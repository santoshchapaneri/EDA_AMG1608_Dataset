% Analyze ALL songs of AMG1608
% Author: Santosh Chapaneri

%% Analyze specific songs
% % change these parameters to analyze specific songs
start = 58;
NumSongs = 1;
flagAnn = 1;
for i=start:start+NumSongs-1
    AnalyzeAMG1608Labels(i, flagAnn);
    pause; % so that can close running via CTRL+C
    close all;
end

% Which songs to analyze?
% SongIdx = [9, 13, 29, 39, 58, 76, 122, 126, 131, 136, 140, 144, 152, 153, ...
%     178, 180, 183, 184, 190, 191, 192, 221, 277, 300, 302, 363, 393, 399, ...
%     416, 558, 565, 599, 619, 640, 645, 679, 684, 714, 750, 836, 837, 863, ...
%     874, 954, 956, 983, 1000, 1004, 1015, 1025, 1040, 1054, 1133, 1150, ...
%     1196, 1200, 1223, 1269, 1308, 1321, 1386, 1438, 1440, 1467, 1587];
% flagAnn = 1;
% SongIdx = [9, 58, 131, 178, 190, 393, 416, 558, 565, 640, 750, 1004, 1054, 1223, 1308, 1386];
% for k = 1:numel(SongIdx)
%     AnalyzeAMG1608Labels(SongIdx(k), flagAnn);
%     pause;
%     close all;
% end

%% Annotator specific song
% load('AMG1608Annotators.mat'); % loads NumSongs and SongLabels of each annotator
% % Ann = 172; % 647, 172, 
% Ann = 542;% 172, 335, 337, 535, 162, 597];
% flagAnn = 1;
% numSongs = AMG1608Annotators.NumSongs(Ann);
% SongLabels = AMG1608Annotators.SongLabels(Ann); SongLabels = SongLabels{1,1};
% for k = 1:length(SongLabels)
%     AnalyzeAMG1608Labels(SongLabels(k), flagAnn);
%     pause;
%     close all;
% end


%% Ignore - done once for WhoAnnotatedWhat matrix
% load('AMG1608Annotators.mat'); % loads NumSongs and SongLabels of each annotator
% NumSongs = AMG1608Annotators.NumSongs;
% SongLabels = AMG1608Annotators.SongLabels;
% WhoAnnotatedWhat = zeros(1608,665);
% for k = 1:665
%     for j = 1:NumSongs(k)
%         SL = SongLabels(k); SL = SL{1,1};
%         WhoAnnotatedWhat(SL,k) = 1;
%     end
% end
% AMG1608Annotators.WhoAnnotatedWhat = WhoAnnotatedWhat;
% AMG1608Annotators.NumSongs = NumSongs;
% AMG1608Annotators.SongLabels = SongLabels;
% save('AMG1608Annotators.mat','AMG1608Annotators');


