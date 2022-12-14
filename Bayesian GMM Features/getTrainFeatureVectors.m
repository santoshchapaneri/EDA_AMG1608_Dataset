function getTrainFeatureVectors()

featurepath = 'D:\Santosh\MusicPhD\2016\Datasets\AMG1608_release\AMG1608FeatureExtract\AMG1608Features\';
path(path, [featurepath]); % add to path
for i=1:1608 
    filelist{i} = sprintf('Feats_%d.mat',i);
end

frames_cell = loadStatsfeatures2(featurepath, filelist, 16, 4); % segment level texture window

% Is this needed? Zscore already done in above function...
fprintf('Normalizing segment-level feature vectors...\n');
[segments_cell, ModelAMGStats.nMean, ModelAMGStats.nStd, samplesegments] = NormalCell(frames_cell);

segments_mat = [];
sampleperc = 0.22; % so as to get 100K frames for training UBM
for i =1:1608
    i
    % Select randomly sampleperc% of frames
    A = segments_cell{i};
    rp = randperm(round(size(A,1)*sampleperc));
    segments_mat = [segments_mat; A(rp,:)]; 
end
save('AMGCampusSegments100K.mat','segments_mat','ModelAMGStats');