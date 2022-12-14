%% What's going on here?
% I. X: All types of features collected for AMG1608: a) Stats, b) KM codebook
% based quantized posterior features (varying K), c) Acoustic GMM posterior
% features (varying K)
% II. Y: All labels for V and A; Avg V and Avg A; All labels for Theta and
% Rho; Avg Theta and Avg Rho; As well as Median V, A, Theta, Rho

clear;clc;close all

%% Get multiple annotators labels
load('AllSongLabelsAMG1608.mat'); % results in campus_subset of size 1608x665x2
% 1608 x 665 (users) x 2 (1: v, 2: a)
allsongs_valence = allsonglabels(:,:,1);
allsongs_arousal = allsonglabels(:,:,2);

% Polar coordinate labels for V and A: Val is X axis and Aro is Y axis
[mood_theta, mood_rho] = cart2pol(allsongs_valence, allsongs_arousal);
mood_theta_deg = radtodeg(mood_theta);

% Below all are 1608x665
Y_Valence = allsongs_valence; clear allsongs_valence;
Y_Arousal = allsongs_arousal; clear allsongs_arousal;
Y_Theta = mood_theta;
Y_ThetaDeg = mood_theta_deg;
Y_Rho = mood_rho;

% So far, we got valence and arousal, each 1608x665, i.e. 
% for each of 1608 songs, max 665 people annotated
% for each song, not everyone annotated, so others are NaN
% consider this later when sending to GPR

tot_songs = 1608;
% Avg labels
Y_Valence_Avg = zeros(tot_songs,1); Y_Arousal_Avg = zeros(tot_songs,1);
Y_Theta_Avg = zeros(tot_songs,1); Y_Rho_Avg = zeros(tot_songs,1); Y_ThetaDeg_Avg = zeros(tot_songs,1); 
% Median labels
Y_Valence_Med = zeros(tot_songs,1); Y_Arousal_Med = zeros(tot_songs,1);
Y_Theta_Med = zeros(tot_songs,1); Y_Rho_Med = zeros(tot_songs,1); Y_ThetaDeg_Med = zeros(tot_songs,1); 

% Getting average and median labels (i.e. no multiple annotator)
for i=1:tot_songs
    kv=Y_Valence(i,:); kv = kv(~isnan(kv)); Y_Valence_Avg(i)=mean(kv); Y_Valence_Med(i)=median(kv);
    ka=Y_Arousal(i,:); ka = ka(~isnan(ka)); Y_Arousal_Avg(i)=mean(ka); Y_Arousal_Med(i)=median(ka);
	kT=Y_Theta(i,:); kT = kT(~isnan(kT)); Y_Theta_Avg(i) = mean(kT); Y_Theta_Med(i) = median(kT);
    kR=Y_Rho(i,:); kR = kR(~isnan(kR)); Y_Rho_Avg(i) = mean(kR); Y_Rho_Med(i) = median(kR);
    kTD=Y_ThetaDeg(i,:); kTD = kTD(~isnan(kTD)); Y_ThetaDeg_Avg(i) = mean(kTD); Y_ThetaDeg_Med(i) = median(kTD);
end

%% Load features

% Statistics features
load('AMG1608_FeatStats.mat'); 
AMG1608MoodData.X_FeatStats = AMG1608FeatStatsMat; clear AMG1608FeatStatsMat;

% KM Codebook Posterior features
load('AMG1608_KM_TopicPosteriors_16.mat');
AMG1608MoodData.X_16_KM = AMG1608POSTKM; clear AMG1608POSTKM;
load('AMG1608_KM_TopicPosteriors_32.mat');
AMG1608MoodData.X_32_KM = AMG1608POSTKM; clear AMG1608POSTKM;
load('AMG1608_KM_TopicPosteriors_64.mat');
AMG1608MoodData.X_64_KM = AMG1608POSTKM; clear AMG1608POSTKM;
load('AMG1608_KM_TopicPosteriors_128.mat');
AMG1608MoodData.X_128_KM = AMG1608POSTKM; clear AMG1608POSTKM;
load('AMG1608_KM_TopicPosteriors_256.mat');
AMG1608MoodData.X_256_KM = AMG1608POSTKM; clear AMG1608POSTKM;
load('AMG1608_KM_TopicPosteriors_512.mat');
AMG1608MoodData.X_512_KM = AMG1608POSTKM; clear AMG1608POSTKM;

% Acoustic GMM Posterior features
load('AMG1608GMMTopicPosteriors_16KM.mat');
AMG1608MoodData.X_16_GMM = AMG1608POST; clear AMG1608POST;
load('AMG1608GMMTopicPosteriors_32KM.mat');
AMG1608MoodData.X_32_GMM = AMG1608POST; clear AMG1608POST;
load('AMG1608GMMTopicPosteriors_64KM.mat');
AMG1608MoodData.X_64_GMM = AMG1608POST; clear AMG1608POST;
load('AMG1608GMMTopicPosteriors_128KM.mat');
AMG1608MoodData.X_128_GMM = AMG1608POST; clear AMG1608POST;
load('AMG1608GMMTopicPosteriors_256KM.mat');
AMG1608MoodData.X_256_GMM = AMG1608POST; clear AMG1608POST;

%% Labels seperately for now
% ToDo: Use Dependent GP / Multi-output GP for better perf (?)

% Collect in a structure
AMG1608MoodData.Y_Valence = Y_Valence;
AMG1608MoodData.Y_Valence_Avg = Y_Valence_Avg;
AMG1608MoodData.Y_Valence_Med = Y_Valence_Med;

AMG1608MoodData.Y_Arousal = Y_Arousal;
AMG1608MoodData.Y_Arousal_Avg = Y_Arousal_Avg;
AMG1608MoodData.Y_Arousal_Med = Y_Arousal_Med;

AMG1608MoodData.Y_Theta = Y_Theta;
AMG1608MoodData.Y_Theta_Avg = Y_Theta_Avg;
AMG1608MoodData.Y_Theta_Med = Y_Theta_Med;

AMG1608MoodData.Y_Rho = Y_Rho;
AMG1608MoodData.Y_Rho_Avg = Y_Rho_Avg;
AMG1608MoodData.Y_Rho_Med = Y_Rho_Med;

AMG1608MoodData.Y_ThetaDeg = Y_ThetaDeg;
AMG1608MoodData.Y_ThetaDeg_Avg = Y_ThetaDeg_Avg;
AMG1608MoodData.Y_ThetaDeg_Med = Y_ThetaDeg_Med;

save('MyMoodDataAMG1608_X_Y.mat','AMG1608MoodData');