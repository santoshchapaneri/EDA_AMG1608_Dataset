function AnalyzeAMG1608Labels(idx, flagAnn)
% Checking for 58, Aqua Barbie Girl
% idx = 58; flagAnn = 0;

load('AllSongInfoAMG1608.mat'); % loads allsonginfo 1608 x 2 cell
% first is artist, second is songtitle

load('AMG1608AnnotatorsConsensus.mat');
% Loads proposed estimates of gold standard
YhatValence = AMG1608AnnotatorsConsensus.YValence;
YhatArousal = AMG1608AnnotatorsConsensus.YArousal;
VarAnn = AMG1608AnnotatorsConsensus.VarAnn;

% load('AMG1608AnnotatorsConsensusMCD.mat');
% % Loads proposed estimates of gold standard
% YhatValenceMCD = AMG1608AnnotatorsConsensusMCD.YValence;
% YhatArousalMCD = AMG1608AnnotatorsConsensusMCD.YArousal;
% VarAnnMCD = AMG1608AnnotatorsConsensusMCD.VarAnn;
% OutliersMCD = AMG1608AnnotatorsConsensusMCD.Outliers;

% load('AMG1608AnnotatorsConsensusMCD_CI.mat');
% % Loads proposed estimates of gold standard
% YhatValenceMCD_CI = AMG1608AnnotatorsConsensusMCD_CI.YValence;
% YhatArousalMCD_CI = AMG1608AnnotatorsConsensusMCD_CI.YArousal;
% VarAnnMCD_CI = AMG1608AnnotatorsConsensusMCD_CI.VarAnn;
% OutliersMCD = AMG1608AnnotatorsConsensusMCD.Outliers;

load('AMG1608AnnotatorsConsensusCIWM.mat');
% Loads proposed estimates of gold standard
YhatValence_CIWM = AMG1608AnnotatorsConsensusCIWM.YValence;
YhatArousal_CIWM = AMG1608AnnotatorsConsensusCIWM.YArousal;
VarAnn_CIWM = AMG1608AnnotatorsConsensusCIWM.VarAnn;


tot = 1; % We want to see results of only particular one song
load('AllSongLabelsAMG1608.mat'); % results in allsonglabels of size 1608x665x2
All_valence = allsonglabels(idx,:,1);
All_arousal = allsonglabels(idx,:,2);
valence = nan(tot,665);
arousal = nan(tot,665);

% NOTE: for loop has no effect as such, we are analyzing only one song here
for i=1:tot
    kv=All_valence(i,:); 
    ka=All_arousal(i,:); 
    
    % Who are the annotators that labeled this song
    Ann = ~isnan(kv);
    AnnID = find(Ann == 1);
    
    % Remove NaNs
    kv = kv(~isnan(kv));
    ka = ka(~isnan(ka));
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

% Display some statistics
numAnnotators = length(AnnID);
outText = sprintf('%d annotators labeled %d.wav', numAnnotators, idx);
disp(outText);

artist = allsonginfo{idx,1};
songtitle = allsonginfo{idx,2};
T = sprintf('SongID %d: %s: %s; %d Annotators',idx,artist, songtitle, numAnnotators);
figure;scatter(val_all,aro_all,'+','LineWidth',2);axis([-1 1 -1 1])
xlabel('Valence','FontSize',12);ylabel('Arousal','FontSize',12);
grid on;
hold on;

% Show the value from proposed estimates
shift = 0.01;
% scatter(YhatValence(idx),YhatArousal(idx),'c*','LineWidth',4);
% text(YhatValence(idx)+shift,YhatArousal(idx)+shift,'MA','FontSize',12);
% Show the value from proposed estimates using MCD
% scatter(YhatValenceMCD_CI(idx),YhatArousalMCD_CI(idx),'rs','LineWidth',4);
% text(YhatValenceMCD_CI(idx)+shift,YhatArousalMCD_CI(idx)+shift,'MCDCI','FontSize',12);
% Show the value from CI_WM
scatter(YhatValence_CIWM(idx),YhatArousal_CIWM(idx),'gd','LineWidth',4);
text(YhatValence_CIWM(idx)+shift,YhatArousal_CIWM(idx)+shift,'CIWM','FontSize',12);
% Show the average value
scatter(mean(val_all),mean(aro_all),'ko','LineWidth',4);
text(mean(val_all)+shift,mean(aro_all)+shift,'Avg','FontSize',12);
set(gcf,'color','white'); box;
screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to screen size
title(T,'FontSize',12);
set(gca,'FontSize',10);

% % Show the median value
% scatter(median(val_all),median(aro_all),'s','LineWidth',4);
% text(median(val_all)+0.03,median(aro_all)+0.03,'Median','FontSize',12);


% Put Annotator labels on each data point
if flagAnn
    shift2 = 0.01;
    for i=1:length(val_all)
%         if find(AnnID(i) == OutliersMCD{idx})
%             text(val_all(i)+5*shift2,aro_all(i)-3*shift2,'Outlier','FontSize',11,'BackgroundColor',[.7 .9 .7]);
%         end
%         strAnn = sprintf('%d(%0.2f)',AnnID(i), VarAnn_CIWM(AnnID(i)));
        strAnn = sprintf('%d(%0.2f,%0.2f)',AnnID(i), VarAnn(AnnID(i)), VarAnn_CIWM(AnnID(i)));
        text(val_all(i)+shift2,aro_all(i)+shift2,strAnn,'FontSize',11);
%         text(val_all(i)+shift2,aro_all(i)+shift2,num2str(AnnID(i)),'FontSize',11);
%         text(val_all(i)+2.5*shift2,aro_all(i)+3*shift2,num2str(VarAnnMCD(AnnID(i))),'FontSize',11);
%         text(val_all(i)-2.5*shift2,aro_all(i)-3*shift2,num2str(VarAnn(AnnID(i))),'FontSize',11);
            
    end
end

% Play the song
filename = sprintf('D:\\Santosh\\MusicPhD\\2016\\Datasets\\AMG1608_release\\amg1608_wav_IDs\\%d.wav',idx);
[y,fs] = audioread(filename);
y = y(1:floor(length(y)/3)); % Edit to change duration of song
player = audioplayer(y, fs);
% play(player);
% pause(length(y)/fs);


hFig = figure;
set(gcf,'color','white'); box;
% figure; 
hold on;
% t=(1:length(y))/fs;
% plot(t, y, 'g'); % plot audio data
plot(y, 'g'); % plot audio data
% title('Audio Data');
ylimits = get(gca, 'YLim'); % get the y-axis limits
set(hFig, 'Position', [50 50 length(y)/fs 100]);
plotdata = ylimits(1):0.1:ylimits(2);
plot(zeros(size(plotdata)), plotdata, 'r'); % plot the marker
% setup the timer for the audioplayer object
player.TimerFcn = {@plotMarker, player, gcf, plotdata}; % timer callback function (defined below)
player.TimerPeriod = 0.01; % period of the timer in seconds
% start playing the audio
% this will move the marker over the audio plot at intervals of 0.01 s
play(player);
pause(length(y)/fs);