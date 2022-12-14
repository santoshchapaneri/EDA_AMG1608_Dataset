function feat_cell = getTrainSegmentVectors2(feat1, feat2, len, hop)
% feat: feature cell with time-by-feature_dim matrix in each cell
% len: # of local consecutive frames that is considered in a chunk
% hop: the hop size in frame
% feat_cell: feature cell where each matrix is with [mean std] vector in each row (time-by-feat_dim matrix) 

feat = [feat1; feat2];
feat_cell = cell(length(feat),1);
D = size(feat{1},2);

matlabpool open 2;
parfor i=1: length(feat)
%  for i=1: length(feat)
%      i
    L = floor((size(feat{i},1)-len)/hop)+1;
    F = zeros(L, D*2);
    ind=1;
    for j=1:L
        M = feat{i}(ind:ind+len-1,:);
        F(j,:) = [mean(M) std(M)];
        ind = ind+hop;
        if ind+len > size(feat{i},1)
            break;
        end
    end
    feat_cell{i} = F;
end
matlabpool close;