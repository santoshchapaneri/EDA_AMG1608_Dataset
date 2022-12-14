function songframes = loadfeatures(path, filelist)

songframes = cell(length(filelist), 1);

% matlabpool open 2;

for i=1:length(filelist)
% parfor i=1:length(filelist)
    i
    s = sprintf('%s%s',path, filelist{i});
    load(s);
    % tmp = importdata([path fileName]);
    % song_frames = tmp'; % NumFrames x NumFeatures matrix
    songframes{i} = features';
    clear features;

%     tmp = importdata([path filelist{i}]);
%     songframes{i} = tmp'; % NumFrames x NumFeatures matrix
end
% matlabpool close;    