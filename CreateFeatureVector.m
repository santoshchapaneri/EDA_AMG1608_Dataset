function FeatVec = CreateFeatureVector(featureMatFilename)

load(featureMatFilename); % gives features as 72 x 1199 double
% Normalize between -1 to 1 for each feature dimension
F_norm = normalize_var(features, -1, 1);
[r, c] = size(F_norm); % r is 72, c is 1199
% Take 20 frames at a time
win = 20;
numWin = fix(c/win); % 59
WinStat_Mean = zeros(numWin+1, r); % 60 x 72
WinStat_Std = zeros(numWin+1, r); % 60 x 72
for i = 1:numWin
    tmp = F_norm(:,20*(i-1)+1:i*win);
    WinStat_Mean(i,:) = mean(tmp,2); % 1 x 72
    WinStat_Std(i,:) = std(tmp,0,2); % 1 x 72
end
% Do this only if extra window remains!
% Handle the last window here (19 frames)
% At this point, i = 59, so i+1 = 60
if (numWin ~= (c/win))
    tmp = F_norm(:,20*(i+1-1)+1:end);
    WinStat_Mean(i+1,:) = mean(tmp,2); 
    WinStat_Std(i+1,:) = std(tmp,0,2); 
end

% Now window level statistics
FVec = zeros(4,r); % Final feature vector
FVec(1,:) = mean(WinStat_Mean,1);
FVec(2,:) = std(WinStat_Mean,0,1);
FVec(3,:) = mean(WinStat_Std,1);
FVec(4,:) = std(WinStat_Std,0,1);

% Stack all together to make one vector
FeatVec = [FVec(1,:) FVec(2,:) FVec(3,:) FVec(4,:)];
clear features;
end







