% Prepare AMG1608 dataset for GPR-MA

clear;clc;close all
%% Get multiple annotators labels
load('AllSongLabelsAMG1608.mat'); % results in campus_subset of size 1608x665x2
Y_Valence = allsonglabels(:,:,1);
Y_Arousal = allsonglabels(:,:,2);

tot = 1608;
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
% Load Posterior features
load('AMG1608TopicPosteriorsCampus.mat'); % AMG1608POST 240 x 32
load('AMG1368TopicPosteriors.mat'); % AMG1368POST 1368 x 32
% combine them
X = [AMG1608POST; AMG1368POST]; % 1608 x 32 APFV (acoustic posterior feature vector)

%% Summary till now
% X is 1608x72 features

% Labels seperately for now
% ToDo: Use Dependent GP / Multi-output GP for better perf (?)
% Y_Valence is 1608x665
% Y_Arousal is 1608x665
% Y_Valence_Avg is 1608x1
% Y_Arousal_Avg is 1608x1

% Collect in a structure
MoodDataAMG1608AP.X = X;
MoodDataAMG1608AP.Y_Valence = Y_Valence;
MoodDataAMG1608AP.Y_Arousal = Y_Arousal;
MoodDataAMG1608AP.Y_Valence_Avg = Y_Valence_Avg;
MoodDataAMG1608AP.Y_Arousal_Avg = Y_Arousal_Avg;
save('MyMoodDataAMG1608AP.mat','MoodDataAMG1608AP');