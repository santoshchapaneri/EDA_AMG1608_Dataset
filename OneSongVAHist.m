% clear
% clc
% close all

% Checking for 58, Aqua Barbie Girl
idx = 58; tot = 1;

load('AllSongLabelsAMG1608.mat'); % results in All_subset of size 1608x665x2
All_valence = allsonglabels(idx,:,1);
All_arousal = allsonglabels(idx,:,2);
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
figure;scatter(val_all,aro_all);axis([-1 1 -1 1])