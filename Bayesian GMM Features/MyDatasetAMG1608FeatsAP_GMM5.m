% All in one
% Train UBM, Get Acoustic GMM Posterior for all songs, Check Similarity
clear;clc;

%% This code trains the Universal Background Model
load('AMGCampusSegments42K.mat');
load('AMGCampus_42K_GMMModel.mat');

% Use Netlab's GMM init for good initialization; it internally uses its own
% version of k-means clustering for initialization
% K = 512; % number of mixtures
% % segments_mat = segments_mat(1:20000,:);
% sampleperc = 0.6;
% % Select randomly sampleperc% of frames
% rp = randperm(round(size(segments_mat,1)*sampleperc));
% segments_mat = segments_mat(rp,:); 

K = 16;
mix = gmm(size(segments_mat,2), K, 'full'); 
options = foptions;
options(14) = 200; % how many times to run k-means?
fprintf('Initializing GMM with K-Means...\n');
mix = gmminit(mix, segments_mat, options);

modelInit.w = mix.priors;
modelInit.mu = mix.centres';
modelInit.Sigma = mix.covars;

[z1,model,llh] = mixGaussEm(segments_mat',modelInit); 
ModelAMGCampusGMM = model; % Gives mu, Sigma (full) and weights pi
modelmat = sprintf('AMGCampus_42K_GMMModel_%dKM.mat',K);
save(modelmat,'ModelAMGCampusGMM','ModelAMGCampusStats');

%% Get Acoustic GMM Posterior of all 1608 songs
% fprintf('Loading AMG1608 all segment cells...\n');
load('AMG1608SegmentsCell.mat'); % loads segments_cell

% load(modelmat);
load('AMGCampus_42K_GMMModel_512KM.mat');

fprintf('Normalizing segment-level feature vectors...\n');
[segments_cell] = NormalCell2(segments_cell, ModelAMGCampusStats.nMean, ModelAMGCampusStats.nStd);

AMG1608POST = MyAcousticGMMPosterior(segments_cell, ModelAMGCampusGMM); 
% Final Acoustic Posterior FV 1368 x 32
VisualizePost(AMG1608POST); % visualizing the topic posterior distribution encoded.
posteriorsmat = sprintf('AMG1608GMMTopicPosteriors_%dKM.mat',K);
save(posteriorsmat, 'AMG1608POST');

% %% Check similarity (?)
% tot = 1608; 
% load('AllSongLabelsAMG1608.mat'); % results in allsonglabels of size 1608x665x2
% All_valence = allsonglabels(:,:,1);
% All_arousal = allsonglabels(:,:,2);
% MoodData.Y_Valence_Avg = zeros(tot,1);
% MoodData.Y_Arousal_Avg = zeros(tot,1);
% for i=1:tot
%     kv=All_valence(i,:); 
%     ka=All_arousal(i,:); 
%     % Remove NaNs
%     kv = kv(~isnan(kv));
%     ka = ka(~isnan(ka));
%     MoodData.Y_Valence_Avg(i) = mean(kv);
%     MoodData.Y_Arousal_Avg(i) = mean(ka);
% end
% 
% scatter(MoodData.Y_Valence_Avg,MoodData.Y_Arousal_Avg)
% 
% % 1st quadrant
% % Find all songs in 1st quadrant
% idx = (MoodData.Y_Valence_Avg > 0) & (MoodData.Y_Arousal_Avg > 0);
% songIdx = find(idx==1); % all songs in first quadrant
% % Get their posterior features
% Feats1 = AMG1608POST(songIdx,:);
% 
% % 2nd quadrant
% idx = (MoodData.Y_Valence_Avg < 0) & (MoodData.Y_Arousal_Avg > 0);
% songIdx = find(idx==1); 
% % Get their posterior features
% Feats2 = AMG1608POST(songIdx,:);
% 
% % 3rd quadrant
% idx = (MoodData.Y_Valence_Avg < 0) & (MoodData.Y_Arousal_Avg < 0);
% songIdx = find(idx==1); 
% % Get their posterior features
% Feats3 = AMG1608POST(songIdx,:);
% 
% % 4th quadrant
% idx = (MoodData.Y_Valence_Avg > 0) & (MoodData.Y_Arousal_Avg < 0);
% songIdx = find(idx==1); 
% % Get their posterior features
% Feats4 = AMG1608POST(songIdx,:);
% 
% % Plot these posterior FVs
% figure;
% subplot(2,2,1); imagesc(Feats1);
% subplot(2,2,2); imagesc(Feats2);
% subplot(2,2,3); imagesc(Feats3);
% subplot(2,2,4); imagesc(Feats4);
% 
% % %% Obtain "similar mood" songs
% fCheckSmallSet = 0;
% if fCheckSmallSet
% idx = (MoodData.Y_Valence_Avg > 0.5) & (MoodData.Y_Valence_Avg < 0.9) & (MoodData.Y_Arousal_Avg > 0.5) & (MoodData.Y_Arousal_Avg < 0.9);
% songIdx = find(idx==1); % all songs in first quadrant
% % Get their posterior features
% FeatsSimilar1 = AMG1608POST(songIdx,:);
% figure;imagesc(FeatsSimilar1)
% 
% idx = (MoodData.Y_Valence_Avg < -0.2) & (MoodData.Y_Valence_Avg > -0.4) & (MoodData.Y_Arousal_Avg > 0.4) & (MoodData.Y_Arousal_Avg < 0.6);
% songIdx = find(idx==1); % all songs in first quadrant
% % Get their posterior features
% FeatsSimilar2 = AMG1608POST(songIdx,:);
% figure;imagesc(FeatsSimilar2)
% end
% 
