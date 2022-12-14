clear
clc

% Reproduce Fig. 2 (histogram of emotion annotations) of paper

load('CampusSongLabelsAMG1608.mat'); % results in campus_subset of size 240x22x2
campus_valence = campus_subset(:,:,1);
campus_arousal = campus_subset(:,:,2);
valence = nan(240,22);
arousal = nan(240,22);

for i=1:240
    kv=campus_valence(i,:); kv = kv(~isnan(kv));
    ka=campus_arousal(i,:); ka = ka(~isnan(ka));
    valence(i,1:length(kv))=kv';
    arousal(i,1:length(ka))=ka';
end

% Collect all annotations of each V and A in a single vector
val_all = []; aro_all = [];
for i=1:240
    vt = valence(i,:);
    val_all = [val_all vt(~isnan(vt))];
    at = arousal(i,:);
    aro_all = [aro_all at(~isnan(at))];
end

ndhist(val_all, aro_all);

% Note; also see
% hist3([val_all' aro_all'],[20 20]);

 
% val_all = val_all'; aro_all = aro_all';
% vXEdge = linspace(-1,1,20);
% vYEdge = linspace(-1,1,20);
% mHist2d = hist2d([val_all aro_all],vYEdge,vXEdge);
% nXBins = length(vXEdge);
% nYBins = length(vYEdge);
% vXLabel = 0.5*(vXEdge(1:(nXBins-1))+vXEdge(2:nXBins));
% vYLabel = 0.5*(vYEdge(1:(nYBins-1))+vYEdge(2:nYBins));
% pcolor(vXLabel, vYLabel,mHist2d); colorbar;

% %% Take average to view the histogram
% for i=1:240
%     vt = valence(i,:);
%     val_avg(i) = mean(vt(~isnan(vt)));
%     at = arousal(i,:);
%     aro_avg(i) = mean(at(~isnan(at)));
% end
% 
% val_avg = val_avg'; aro_avg = aro_avg';
% vXEdge = linspace(-1,1,20);
% vYEdge = linspace(-1,1,20);
% mHist2d = hist2d([val_avg aro_avg],vYEdge,vXEdge);
% nXBins = length(vXEdge);
% nYBins = length(vYEdge);
% vXLabel = 0.5*(vXEdge(1:(nXBins-1))+vXEdge(2:nXBins));
% vYLabel = 0.5*(vYEdge(1:(nYBins-1))+vYEdge(2:nYBins));
% pcolor(vXLabel, vYLabel,mHist2d); colorbar;
% % figure; Plot2dHist(mHist2d, vXEdge, vYEdge, 'Valence', 'Arousal', 'Histogram');