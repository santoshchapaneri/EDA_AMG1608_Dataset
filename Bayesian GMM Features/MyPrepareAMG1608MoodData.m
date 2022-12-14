%% Prepare AMG1608 data for TGPs prediction
clc;clear;

%% Features X - All are normalized
load('MyMoodDataAMG1608_X_Y.mat'); % loads AMG1608MoodData
% Store the conventional technique feature stats as well as VQ codebook representation
AMG1608_MoodData.X_FeatStats = zscore(AMG1608MoodData.X_FeatStats,0,2);
AMG1608_MoodData.X_512_KM = zscore(AMG1608MoodData.X_512_KM,0,2);

% Acoustic Bayesian GMM posterior probabilities; normalized mu=0, sigma=1
load('ABGMM_AMG1608_POST_512_Norm.mat'); % loads AMG1608POST_Norm
AMG1608_MoodData.X_512_ABGMM = AMG1608POST_Norm; % 1608 x 512, 1608 songs, each song is feature vector with dimension of 512

%% For regression, output Y values
% Valence and Arousal values (ALL as well as Average and Median)
AMG1608_MoodData.Y_Valence = AMG1608MoodData.Y_Valence;
AMG1608_MoodData.Y_Valence_Avg = AMG1608MoodData.Y_Valence_Avg;
AMG1608_MoodData.Y_Valence_Med = AMG1608MoodData.Y_Valence_Med;
AMG1608_MoodData.Y_Arousal = AMG1608MoodData.Y_Arousal;
AMG1608_MoodData.Y_Arousal_Avg = AMG1608MoodData.Y_Arousal_Avg;
AMG1608_MoodData.Y_Arousal_Med = AMG1608MoodData.Y_Arousal_Med;

% Proposed Estimated Ground Truth:

% This one is using typical EM algorithm (see notebook for details and formulae)
load('AMG1608AnnotatorsConsensus.mat'); % loads AMG1608AnnotatorsConsensus
AMG1608_MoodData.Y_Valence_Consensus = AMG1608AnnotatorsConsensus.YValence; % 1608 x 1
AMG1608_MoodData.Y_Arousal_Consensus = AMG1608AnnotatorsConsensus.YArousal; % 1608 x 1
AMG1608_MoodData.Y_VarAnn_Consensus = AMG1608AnnotatorsConsensus.VarAnn; % 1 x 665 (since 665 annotators)

% This one is final: EM algorithm with weighted median and confidence level
% on variances of annotators with chi-squared distribution
load('AMG1608AnnotatorsConsensusCIWM.mat'); % loads AMG1608AnnotatorsConsensusCIWM
AMG1608_MoodData.Y_Valence_CIWM = AMG1608AnnotatorsConsensusCIWM.YValence; % 1608 x 1
AMG1608_MoodData.Y_Arousal_CIWM = AMG1608AnnotatorsConsensusCIWM.YArousal; % 1608 x 1
AMG1608_MoodData.Y_VarAnn_CIWM = AMG1608AnnotatorsConsensusCIWM.VarAnn; % 1 x 665 (since 665 annotators)
AMG1608_MoodData.Y_VarAnnLB_CIWM = AMG1608AnnotatorsConsensusCIWM.VarAnnLB; % this is lower bound, Do NOT use, FYI only

%% Save it for further usage to TGPs prediction
save('AMG1608_MoodData.mat','AMG1608_MoodData');
