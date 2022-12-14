clc;clear;close all;

% Check similarity of POST for 1608 songs
load('MyMoodDataAMG1608AP.mat');
% MoodDataAMG1608APAMG1608AP.Y_Valence_Avg (1608 x 1) and .Y_Arousal_Avg (1608 x 1)
% MoodDataAMG1608APAMG1608AP.X: 1608 x 32 double, 1608 songs, each has 32 audio topic posterior
% probability

figure; scatter(MoodDataAMG1608AP.Y_Valence_Avg,MoodDataAMG1608AP.Y_Arousal_Avg)

%% 1st quadrant
% Find all songs in 1st quadrant
idx = (MoodDataAMG1608AP.Y_Valence_Avg > 0) & (MoodDataAMG1608AP.Y_Arousal_Avg > 0);
songIdx = find(idx==1); % all songs in first quadrant
% Get their posterior features
Feats1 = MoodDataAMG1608AP.X(songIdx,:);

%% 2nd quadrant
idx = (MoodDataAMG1608AP.Y_Valence_Avg < 0) & (MoodDataAMG1608AP.Y_Arousal_Avg > 0);
songIdx = find(idx==1); 
% Get their posterior features
Feats2 = MoodDataAMG1608AP.X(songIdx,:);

%% 3rd quadrant
idx = (MoodDataAMG1608AP.Y_Valence_Avg < 0) & (MoodDataAMG1608AP.Y_Arousal_Avg < 0);
songIdx = find(idx==1); 
% Get their posterior features
Feats3 = MoodDataAMG1608AP.X(songIdx,:);

%% 4th quadrant
idx = (MoodDataAMG1608AP.Y_Valence_Avg > 0) & (MoodDataAMG1608AP.Y_Arousal_Avg < 0);
songIdx = find(idx==1); 
% Get their posterior features
Feats4 = MoodDataAMG1608AP.X(songIdx,:);

%% Plot these posterior FVs
figure;
subplot(2,2,1); imagesc(Feats1);
subplot(2,2,2); imagesc(Feats2);
subplot(2,2,3); imagesc(Feats3);
subplot(2,2,4); imagesc(Feats4);
% Notice that for each quadrant, different audio topics are dominant
% Thus, the acoustic posterior FV can easily discriminate between the four
% quadrants. Similarly, GPR can learn properly from Acoustic Posterior FVs
% compared to directly feeding raw features.

% %% Obtain "similar mood" songs
idx = (MoodDataAMG1608AP.Y_Valence_Avg > 0.5) & (MoodDataAMG1608AP.Y_Valence_Avg < 0.9) & (MoodDataAMG1608AP.Y_Arousal_Avg > 0.5) & (MoodDataAMG1608AP.Y_Arousal_Avg < 0.9);
songIdx = find(idx==1); % all songs in first quadrant
% Get their posterior features
FeatsSimilar1 = MoodDataAMG1608AP.X(songIdx,:);
figure;imagesc(FeatsSimilar1)
% 
idx = (MoodDataAMG1608AP.Y_Valence_Avg < -0.2) & (MoodDataAMG1608AP.Y_Valence_Avg > -0.4) & (MoodDataAMG1608AP.Y_Arousal_Avg > 0.4) & (MoodDataAMG1608AP.Y_Arousal_Avg < 0.6);
songIdx = find(idx==1); % all songs in first quadrant
% Get their posterior features
FeatsSimilar2 = MoodDataAMG1608AP.X(songIdx,:);
figure;imagesc(FeatsSimilar2)
% 



