%% Get Standard Statistics of features of AMG1608 dataset
clear;clc;
% Feats_1.mat to Feats_1608.mat
% Each is 70 x 1199, 70 features along 1199 frames

% featurepath = 'AMG1608Features\';
featurepath = 'D:\Santosh\MusicPhD\Datasets\AMG1608_release\AMG1608FeatureExtract\AMG1608Features\';
% path(path, [pwd, filesep, featurepath]); % add to path

for i=1:1608
    filelist{i} = sprintf('Feats_%d.mat',i);
end

AMG1608FeatStatsMat = CreateFeatureVectorStats(featurepath, filelist, 20);
VisualizePost(AMG1608FeatStatsMat); 
save('AMG1608_FeatStats.mat', 'AMG1608FeatStatsMat');


