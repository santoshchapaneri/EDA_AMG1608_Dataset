
% Rename all wav files of AMG1608 as per IDs.mat
% This file should be run in amg1608_wav\ folder


K = csvread('AMG1608IDs2.csv'); % 1608 x 1 double: filenames

% SongPath = 'amg1608_wav\';
% path(path, [pwd, filesep, SongPath]); % add to path
% 
% names = dir(fullfile(SongPath,'*.wav') );
% names = {names(~[names.isdir]).name};
% for n = 1:numel(names)
%     filename = [SongPath names{n}];
% end

% Directory of the files
d = 'D:\Santosh\MusicPhD\Datasets\AMG1608_release\AMG1608AcousticPosterior\amg1608_wav\';
% Retrieve the name of the files only
names = dir(d);
names = {names(~[names.isdir]).name};

% Rename in a LOOP
for n = 1:numel(names)
    oldname = [names{n}];
    namenoextn = names{n}; namenoextn = namenoextn(1:end-4);
    tmp = str2double(namenoextn);
    % Find tmp in K and get corresponding index in K
    p = find(K == tmp);
    newname = sprintf('%d_%s',p,names{n});
    dos(['rename "' oldname '" "' newname '"']);
end
