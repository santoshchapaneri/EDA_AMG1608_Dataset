function feat_cell = loadStatsfeatures2(path, filelist, len, hop)

feat_cell = cell(length(filelist),1);

for i=1:length(filelist)
    i
    s = sprintf('%s%s',path, filelist{i});
    load(s);
    
    FeatMat = zscore(FeatMat');
    % FeatMat = FeatMat';

    D = size(FeatMat,2);
    L = floor((size(FeatMat,1)-len)/hop)+1;
    F = zeros(L, D*2);
    ind=1;
    for j=1:L
        M = FeatMat(ind:ind+len-1,:);
        F(j,:) = [mean(M) std(M)];
        ind = ind+hop;
        if ind+len > size(FeatMat,1)
            F=F(1:end-1,:); % to avoid last row of all zeros
            break;
        end
    end
    feat_cell{i} = F;
    clear FeatMat;
end
