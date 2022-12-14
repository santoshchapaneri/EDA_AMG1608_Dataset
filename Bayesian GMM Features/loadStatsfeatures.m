function feat_cell = loadStatsfeatures(path, filelist, len, hop)

feat_cell = cell(length(filelist),1);

for i=1:length(filelist)
    i
    s = sprintf('%s%s',path, filelist{i});
    load(s);
    
    % See if this has any effect ; 13 Sep 2016
    features = zscore(features');
%     features = features';

    D = size(features,2);
    L = floor((size(features,1)-len)/hop)+1;
    F = zeros(L, D*2);
    ind=1;
    for j=1:L
        M = features(ind:ind+len-1,:);
        F(j,:) = [mean(M) std(M)];
        ind = ind+hop;
        if ind+len > size(features,1)
            F=F(1:end-1,:); % to avoid last row of all zeros
            break;
        end
    end
    feat_cell{i} = F;
    clear features;
end
