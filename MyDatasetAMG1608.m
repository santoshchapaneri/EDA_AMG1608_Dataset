% Prepare AMG1608 dataset for GPR-MA

clear;clc;close all
% Campus is 240 (1:240), x 22 (users) x 2 (1: v, 2: a)

%% Get multiple annotators labels
load('AllSongLabelsAMG1608.mat'); % results in campus_subset of size 1608x665x2
All_valence = allsonglabels(:,:,1);
All_arousal = allsonglabels(:,:,2);

tot = 1608;

valence = nan(tot,665);
arousal = nan(tot,665);

for i=1:tot
    kv=All_valence(i,:); kv = kv(~isnan(kv));
    ka=All_arousal(i,:); ka = ka(~isnan(ka));
    valence(i,1:length(kv))=kv';
    arousal(i,1:length(ka))=ka';
end
Y_Valence = valence; % is 1608 x 665
Y_Arousal = arousal; % is 1608 x 665

% So far, we got valence and arousal, each 1608 x 665, i.e. 
% for each of 1608 songs, max 665 people annotated
% for each song, not everyone annotated, so others are left as NaN

% Getting average label (i.e. no multiple annotator)
Y_Valence_Avg = zeros(tot,1); Y_Arousal_Avg = zeros(tot,1);
for i=1:tot
    kv=Y_Valence(i,:); kv = kv(~isnan(kv));
    ka=Y_Arousal(i,:); ka = ka(~isnan(ka));
    Y_Valence_Avg(i)=mean(kv);
    Y_Arousal_Avg(i)=mean(ka);
end

%% Get features
% Feat1.mat to Feat240.mat
% Each is 72 x 1199, 72 features along 1199 frames
% For now, we will just average out the features along each dimension;
% ToDo: temporal aggregation of features for better performance
% Normalize each dimension to [-1, 1]
% Resulting in 1x72 for each song
% So we need 240x72 matrix as features X

X = zeros(tot,72); % size of feature matrix for GPR
for i=1:tot
    str = sprintf('Feats%d.mat',i);
    load(str); % get features which is 72x1199 matrix
    F_norm = normalize_var(features, -1, 1);
    F_norm_avg = mean(F_norm, 2);
    X(i,:) = F_norm_avg';
end

%% Summary till now
% X is 1608x72 features

% Labels seperately for now
% ToDo: Use Dependent GP / Multi-output GP for better perf (?)
% Y_Valence is 1608x665
% Y_Arousal is 1608x665
% Y_Valence_Avg is 1608x1
% Y_Arousal_Avg is 1608x1

% Collect in a structure
MoodDataAMG1608.X = X;
MoodDataAMG1608.Y_Valence = Y_Valence;
MoodDataAMG1608.Y_Arousal = Y_Arousal;
MoodDataAMG1608.Y_Valence_Avg = Y_Valence_Avg;
MoodDataAMG1608.Y_Arousal_Avg = Y_Arousal_Avg;
save('MyMoodDataAMG1608.mat','MoodDataAMG1608');