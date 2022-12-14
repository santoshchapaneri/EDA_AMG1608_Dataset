
% Rename all wav files of AMG1608 from 1.wav to 1608.wav
% This file should be run in amg1608_wav_IDs\ folder
% Directory of the files
d = 'D:\Santosh\MusicPhD\Datasets\AMG1608_release\AMG1608AcousticPosterior\amg1608_wav_IDs\';
% Retrieve the name of the files only
SongPath = 'amg1608_wav_IDs\';
path(path, [pwd, filesep, SongPath]); % add to path
names = dir(fullfile(d,'*.wav') );
names = {names(~[names.isdir]).name};
[namesSorted,idx] = sort_nat(names);
% Rename in a LOOP
for n = 1:numel(names)
    n
    oldname = [namesSorted{n}];
    newname = sprintf('%d.wav',n);
    dos(['rename "' oldname '" "' newname '"']);
end
