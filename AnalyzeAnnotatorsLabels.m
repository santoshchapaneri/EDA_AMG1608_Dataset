% How many songs were labeled by each annotator?

load('AllSongLabelsAMG1608.mat');
% allsonglabels 1608 x 665 x 2 (numSongs x numAnnotators x (V,A))

numSongs = 1608;
numAnnotators = 665;
All_valence = allsonglabels(:,:,1);
NumSongLabels = zeros(1,numAnnotators);
SongLabels = cell(1,numAnnotators);

for i = 1:numAnnotators
    % check along each column, these are labels of ith annotator
    kv = All_valence(:,i);

    % Which songs have been labeled?
    Ann = ~isnan(kv);
    AnnID = find(Ann == 1);
    SongLabels{i} = AnnID;
    
    % Remove NaNs
    kv = kv(~isnan(kv));
    NumSongLabels(1,i) = length(kv);
end

AMG1608Annotators.NumSongs = NumSongLabels;
AMG1608Annotators.SongLabels = SongLabels;

save('AMG1608Annotators.mat','AMG1608Annotators');