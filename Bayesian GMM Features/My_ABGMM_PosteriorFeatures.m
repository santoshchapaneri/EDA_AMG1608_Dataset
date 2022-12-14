%% Getting Acoustic Bayesian GMM posterior probabilities as features of songs
% clc;clear;
% 
% Load the segment cells of all 1608 songs & Normalize the data
fprintf('Loading AMG1608 all segment cells...\n');
load('AMG1608SegmentsCell.mat'); % loads segments_cell
load('ModelAMGStats.mat'); % loads ModelAMGStats struct having nMean and nStd
fprintf('Normalizing segment-level feature vectors...\n');
[segments_cell] = NormalCell2(segments_cell, ModelAMGStats.nMean, ModelAMGStats.nStd);

% VBGMM is already trained, so load the model
fprintf('Loading Acoustic Bayesian GMM model...\n');
% load('ModelAMG_VBUBM_512.mat'); % loads ModelAMG_VBUBM
load('ModelAMG_VBUBM_Reduced.mat'); % loads ModelAMG_VBUBM
ModelAMG_VBUBM = ModelAMG_VBUBM_Reduced;
% Debugging only
% segments_cell = segments_cell{943};

AMG1608POST = MyAcousticBayesianGMMPosterior(segments_cell, ModelAMG_VBUBM); 
% Final Acoustic Posterior FV 1608 x K
VisualizePost(AMG1608POST); % visualizing the topic posterior distribution
% save('ABGMM_AMG1608_POST_512.mat','AMG1608POST');
save('ABGMM_AMG1608_POST_234.mat','AMG1608POST');

% AMG1608POST_Norm = zscore(AMG1608POST');
% AMG1608POST_Norm = AMG1608POST_Norm';
% save('ABGMM_AMG1608_POST_512_Norm.mat','AMG1608POST_Norm');
