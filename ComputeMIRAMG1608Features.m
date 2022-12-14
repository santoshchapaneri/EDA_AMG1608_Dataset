function ComputeMIRAMG1608Features(filename, output)

mirwaitbar(0);
f = miraudio(filename,'Frame');

fd = mirgetdata(f);
[~,numFrames] = size(fd); clear fd;
numFeatures = 70;
FeatMat = zeros(numFeatures,numFrames);

feats = mirfeatures(f);
featsdata = mirgetdata(feats);

%% Dynamics features
FeatMat(1,:) = featsdata.dynamics.rms;
%% Spectral features
FeatMat(2,:) = featsdata.spectral.centroid;
FeatMat(3,:) = featsdata.spectral.spread;
FeatMat(4,:) = featsdata.spectral.skewness;
FeatMat(5,:) = featsdata.spectral.kurtosis;
FeatMat(6,:) = featsdata.spectral.spectentropy;
FeatMat(7,:) = featsdata.spectral.flatness;
FeatMat(8,:) = featsdata.spectral.rolloff85;
FeatMat(9,:) = featsdata.spectral.rolloff95;
FeatMat(10,:) = featsdata.spectral.brightness;
FeatMat(11,:) = featsdata.spectral.roughness;
FeatMat(12,:) = featsdata.spectral.irregularity;
%% Timbre features
FeatMat(13,:) = featsdata.timbre.zerocross;
FeatMat(14,:) = [0 featsdata.timbre.spectralflux];
FeatMat(15:27,:) = featsdata.spectral.mfcc;
FeatMat(28:40,:) = [zeros(13,2) featsdata.spectral.dmfcc zeros(13,2)];
FeatMat(41:53,:) = [zeros(13,4) featsdata.spectral.ddmfcc zeros(13,4)];
%% Tonal features
FeatMat(54,:) = featsdata.tonal.keyclarity;
FeatMat(55,:) = featsdata.tonal.mode;
FeatMat(56,:) = [0 featsdata.tonal.hcdf];
feat_tonal_chromagram = mirchromagram(f,'Wrap','yes');
feat_tonal_chromagram_data = mirgetdata(feat_tonal_chromagram);
FeatMat(57:68,:) = feat_tonal_chromagram_data;
FeatMat(69,:) = featsdata.tonal.chromagram.peak;
FeatMat(70,:) = featsdata.tonal.chromagram.centroid;

FeatMat(isnan(FeatMat))=0; % 70 x 1199 FV matrix
% 1199 frames, 70 features per frame
% NOTE: Should do zscore(FeatMat') to obtain zero mean, unit std for further
% prcoessing
save(sprintf('AMG1608Features\\Feats_%s.mat',output),'FeatMat');
clear f; clear featsdata; clear FeatMat;
mirwaitbar(1);
end