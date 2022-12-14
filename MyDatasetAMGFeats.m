% Features as per Access 2014

clear;clc;close all
% Campus is 240 (1:240), x 22 (users) x 2 (1: v, 2: a)

%% Get multiple annotators labels
load('CampusSongLabelsAMG1608.mat'); % results in campus_subset of size 240x22x2
campus_valence = campus_subset(:,:,1);
campus_arousal = campus_subset(:,:,2);
valence = nan(240,22);
arousal = nan(240,22);

for i=1:240
    kv=campus_valence(i,:); kv = kv(~isnan(kv));
    ka=campus_arousal(i,:); ka = ka(~isnan(ka));
    valence(i,1:length(kv))=kv';
    arousal(i,1:length(ka))=ka';
end
Y_Valence = valence; % is 240x22
Y_Arousal = arousal; % is 240x22

% So far, we got valence and arousal, each 240 x 22, i.e. 
% for each of 240 songs, max 22 people annotated
% for each song, not everyone annotated, so others are left as NaN
% eg. for 1st song, instead of 1x22, we have 1x17, 5 are NaN, need to
% consider this later when sending to GPR

% Getting average label (i.e. no multiple annotator)
Y_Valence_Avg = zeros(240,1); Y_Arousal_Avg = zeros(240,1);
for i=1:240
    kv=Y_Valence(i,:); kv = kv(~isnan(kv));
    ka=Y_Arousal(i,:); ka = ka(~isnan(ka));
    Y_Valence_Avg(i)=mean(kv);
    Y_Arousal_Avg(i)=mean(ka);
end

%% Get features
% Feat1.mat to Feat240.mat
% Each is 72 x 1199, 72 features along 1199 frames
% Normalize each dimension to [-1, 1]
% Temporal aggregation of features 
% 20 frames combine -> mean and std of each feature dimension
% again merge, mean mean, mean std, std mean and std std
% stack all into one vector -> final feature vector of the clip

X = zeros(240,72*4); % size of feature matrix for GPR
for i=1:240
    featureMatFilename = sprintf('Feats%d.mat',i);
    FeatVec = CreateFeatureVector(featureMatFilename);
    X(i,:) = FeatVec;
end

%% Summary till now
% X is 240x288 features

% Labels seperately for now
% ToDo: Use Dependent GP / Multi-output GP for better perf (?)
% Y_Valence is 240x22
% Y_Arousal is 240x22
% Y_Valence_Avg is 240x1
% Y_Arousal_Avg is 240x1

% Collect in a structure
MoodData.X = X;
MoodData.Y_Valence = Y_Valence;
MoodData.Y_Arousal = Y_Arousal;
MoodData.Y_Valence_Avg = Y_Valence_Avg;
MoodData.Y_Arousal_Avg = Y_Arousal_Avg;
save('MyMoodDataAMGFeats.mat','MoodData');