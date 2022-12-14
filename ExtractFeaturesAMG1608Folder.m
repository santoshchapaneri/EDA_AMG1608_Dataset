
% Feature extraction of all songs of AMG1608

d = 'D:\Santosh\MusicPhD\Datasets\AMG1608_release\amg1608_wav_IDs\';
names = dir(fullfile(d,'*.wav') );
names = {names(~[names.isdir]).name};
[names,~] = sort_nat(names); % natural sorting order :)
for n = 60:65%1:numel(names)
    filename = [d names{n}];
    namenoextn = names{n}; namenoextn = namenoextn(1:end-4);
    ComputeMIRAMG1608Features(filename, namenoextn);
end
