clear
clc
close all

% Reproduce Fig. 2 (histogram of emotion annotations) of paper
tot = 1608;

load('AllSongLabelsAMG1608.mat'); % results in All_subset of size 1608x665x2
All_valence = allsonglabels(:,:,1);
All_arousal = allsonglabels(:,:,2);
valence = nan(tot,665);
arousal = nan(tot,665);

for i=1:tot
    kv=All_valence(i,:); kv = kv(~isnan(kv));
    ka=All_arousal(i,:); ka = ka(~isnan(ka));
    valence(i,1:length(kv))=kv';
    arousal(i,1:length(ka))=ka';
end

% Collect all annotations of each V and A in a single vector
val_all = []; aro_all = [];
for i=1:tot
    vt = valence(i,:);
    val_all = [val_all vt(~isnan(vt))];
    at = arousal(i,:);
    aro_all = [aro_all at(~isnan(at))];
end

my_ndhist(val_all, aro_all);