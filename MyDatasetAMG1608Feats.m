% Features as per Access 2014 for AMG1608 full dataset
% Also, get V and A as polar coordinates

clear;clc;close all
% 1608 x 665 (users) x 2 (1: v, 2: a)

%% Get multiple annotators labels
load('AllSongLabelsAMG1608.mat'); % results in campus_subset of size 1608x665x2
allsongs_valence = allsonglabels(:,:,1);
allsongs_arousal = allsonglabels(:,:,2);
valence = nan(1608,665); arousal = nan(1608,665);
mood_theta = nan(1608,665); mood_rho = nan(1608,665); mood_theta_deg = nan(1608,665);

for i=1:1608
    kv=allsongs_valence(i,:); kv = kv(~isnan(kv));
    ka=allsongs_arousal(i,:); ka = ka(~isnan(ka));
    valence(i,1:length(kv))=kv';
    arousal(i,1:length(ka))=ka';
    % polar coordinates for V and A: Val is X axis and Aro is Y axis
    [theta, rho] = cart2pol(kv, ka); 
    mood_theta(i,1:length(theta))=theta';
    theta_deg = radtodeg(theta);
    mood_theta_deg(i,1:length(theta))=theta_deg';
    mood_rho(i,1:length(rho))=rho';
end

% Below all are 1608x665
Y_Valence = valence; 
Y_Arousal = arousal; 
Y_Theta = mood_theta;
Y_ThetaDeg = mood_theta_deg;
Y_Rho = mood_rho;

% So far, we got valence and arousal, each 1608x665, i.e. 
% for each of 1608 songs, max 665 people annotated
% for each song, not everyone annotated, so others are left as NaN
% consider this later when sending to GPR

% Getting average label (i.e. no multiple annotator)
Y_Valence_Avg = zeros(1608,1); Y_Arousal_Avg = zeros(1608,1);
Y_Theta_Avg = zeros(1608,1); Y_Rho_Avg = zeros(1608,1); Y_ThetaDeg_Avg = zeros(1608,1); 
for i=1:1608
    kv=Y_Valence(i,:); kv = kv(~isnan(kv)); Y_Valence_Avg(i)=mean(kv);
    ka=Y_Arousal(i,:); ka = ka(~isnan(ka)); Y_Arousal_Avg(i)=mean(ka);
	kT=Y_Theta(i,:); kT = kT(~isnan(kT)); Y_Theta_Avg(i) = mean(kT);
    kR=Y_Rho(i,:); kR = kR(~isnan(kR)); Y_Rho_Avg(i) = mean(kR);
    kTD=Y_ThetaDeg(i,:); kTD = kTD(~isnan(kTD)); Y_ThetaDeg_Avg(i) = mean(kTD);
end

%% Get features
% Feat1.mat to Feat1608.mat
% Each is 72 x 1199, 72 features along 1199 frames
% Normalize each dimension to [-1, 1]
% Temporal aggregation of features 
% 20 frames combine -> mean and std of each feature dimension
% again merge, mean mean, mean std, std mean and std std
% stack all into one vector -> final feature vector of the clip
% All above is done by function CreateFeatureVector

X = zeros(1608,72*4); % size of feature matrix for GPR
for i=1:1608
    i
    featureMatFilename = sprintf('Feats%d.mat',i);
    FeatVec = CreateFeatureVector(featureMatFilename);
    X(i,:) = FeatVec;
end

%% Summary till now
% X is 1608x288 features

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
MoodData.Y_Theta = Y_Theta;
MoodData.Y_Rho = Y_Rho;
MoodData.Y_ThetaDeg = Y_ThetaDeg;
MoodData.Y_Theta_Avg = Y_Theta_Avg;
MoodData.Y_Rho_Avg = Y_Rho_Avg;
MoodData.Y_ThetaDeg_Avg = Y_ThetaDeg_Avg;
save('MyMoodDataAMG1608Feats.mat','MoodData');