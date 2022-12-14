% Benefit of CIWM

% Weighted Average, no CI
load('AMG1608AnnotatorsConsensus.mat');
VarAnn = AMG1608AnnotatorsConsensus.VarAnn;

% Modified: Weighted Medians with 95% Confidence Interval
load('AMG1608AnnotatorsConsensusCIWM.mat');
VarAnn_CIWM = AMG1608AnnotatorsConsensusCIWM.VarAnn;
VarAnnLB_CIWM = AMG1608AnnotatorsConsensusCIWM.VarAnnLB;

% How many songs were annotated by each annotator?
load('AMG1608Annotators.mat'); % loads NumSongs and SongLabels of each annotator
numSongs = AMG1608Annotators.NumSongs;
SongLabels = AMG1608Annotators.SongLabels; % just in case if needed

% Do we have a long tail problem?
[numSongsSorted, IdxSorted] = sort(numSongs,'descend');
VarAnn_Sorted = VarAnn(IdxSorted);
VarAnn_CIWM_Sorted = VarAnn_CIWM(IdxSorted);
VarAnnLB_CIWM_Sorted = VarAnnLB_CIWM(IdxSorted);

% YES, long tail is seen; so CI should help in penalizing annotators who provided too few responses
bar(numSongsSorted); 
set(gcf,'color','white'); box; grid on;

% See the 95% Confidence Interval of selected annotators
Ann = [159, 479, 193, 664, 38, 115, 71, 216, 499, 35, 13, 647];
for idx = 1:length(Ann)
    AnnIdx = find(IdxSorted==Ann(idx));
    CI_LB(idx) = VarAnnLB_CIWM_Sorted(AnnIdx);
    CI_UB(idx) = VarAnn_CIWM_Sorted(AnnIdx);
end
CI = [CI_LB;CI_UB];
CI'

% Observe how different variances are
figure; set(gcf,'color','white');
plot(VarAnn_CIWM_Sorted,'r-','LineWidth',2);hold on; plot(VarAnn_Sorted,'b--','LineWidth',2); 
legend('CIWM','NoCI'); box; grid on;
% Note these are in descending order of numSongs, so as we move from left
% to right, we have annotators who annotated less number of songs, so
% penalty should increase from left to right
