% Demo of Proposed Annotators Strategy for obtaining consensus
clear;clc;close all;
R = 5;  % number of annotators
N = 100; % maximum number of samples
D = 2; % dimension of responses
O = 60; % number of samples per annotator for missing responses case, i.e. N-O responses are missing
noise = log(linspace(0.1,3,R)');
fMA = 1; % 1 means missing annotations, i.e. some will be NaN
fPlot = 0;

% create data
x = linspace(0,1,N)';
y = NaN(N,R,D);
for m=1:R
    if fMA
        r = randperm(length(x)); 
        r = r(1:O);    % select O number of random indices
        [z1(r,m) z2(r,m)] = onevar(x(r,:));
        rndnoise = normrnd(0,exp(noise(m)),O,1);
        y(r,m,1) = z1(r,m) + rndnoise;
        y(r,m,2) = z2(r,m) + rndnoise;
    else
        r = 1:length(x);
        [z1, z2] = onevar(x(r,:)); % ground truth
        rndnoise = normrnd(0,exp(noise(m)),N,1);
        y(r,m,1) = z1 + rndnoise;
        y(r,m,2) = z2 + rndnoise;
    end
end
% Ground Truth of responses
if fMA
    zt(:,:,1) = z1; zt(:,:,2) = z2;
else
	zt = [z1 z2];
end

% Remove unused indices (i.e. all NaNs in single row)
tmp = y(:,:,1);
unusedinds = sum(isnan(tmp),2)==R;
x(unusedinds,:) = [];
y(unusedinds,:,:) = [];
N = size(x,1); % update N

% Determine average annotations 
yavg = zeros(N,D);
for i = 1:N
    for d = 1:D
        T = y(i,:,d);
        idx = ~isnan(T);
        yavg(i,d) = mean(T(idx));
    end
end

% Observe by plotting
if fPlot
    if fMA
        for d = 1:D
            figure;
            set(gcf,'color','white');
            hold on; grid on;
            r = 1:length(x);
            [z1, z2] = onevar(x(r,:)); % ground truth
            ztMA = [z1 z2];
            plot(x,ztMA(:,d),'kd-','LineWidth',2);
            p = y(:,1,d); plot(x(~isnan(p)),p(~isnan(p)),'r+--','LineWidth',1.5);
            p = y(:,2,d); plot(x(~isnan(p)),p(~isnan(p)),'bo--','LineWidth',1.5);
            p = y(:,3,d); plot(x(~isnan(p)),p(~isnan(p)),'gx--','LineWidth',1.5);
            p = y(:,4,d); plot(x(~isnan(p)),p(~isnan(p)),'c*--','LineWidth',1.5);
            p = y(:,5,d); plot(x(~isnan(p)),p(~isnan(p)),'ms--','LineWidth',1.5);
            axis([min(x) max(x) floor(nanmin(nanmin(y(:,:,d)))) ceil(nanmax(nanmax(y(:,:,d))))+1]);
            legend('True','M1','M2','M3','M4','M5');
            legend('Location','Northwest');
            box;
        end
    else
        for d = 1:D
            figure;
            set(gcf,'color','white');
            hold on; grid on;
            plot(x,zt(:,d),'kd-','LineWidth',2);
            plot(x,y(:,1,d),'r+--','LineWidth',1.5);
            plot(x,y(:,2,d),'bo--','LineWidth',1.5);
            plot(x,y(:,3,d),'gx--','LineWidth',1.5);
            plot(x,y(:,4,d),'c*--','LineWidth',1.5);
            plot(x,y(:,5,d),'ms--','LineWidth',1.5);
            axis([min(x) max(x) floor(nanmin(nanmin(y(:,:,d)))) ceil(nanmax(nanmax(y(:,:,d))))+1]);
            legend('True','M1','M2','M3','M4','M5');
            legend('Location','Northwest');
            box;
        end
    end
end

% [Yhat,VarAnn] = AnnotatorsConsensus(y,1000);
[Yhat,VarAnn] = AnnotatorsConsensusCI(y,0.05,1000);

r = 1:length(x);
[z1, z2] = onevar(x(r,:)); % ground truth
zt = [z1 z2];
% Compute MSE
sumnorm = 0;
for i = 1:size(zt,1)
    sumnorm = sumnorm + norm(zt(i,:)-yavg(i,:));
end
MSEAvg = sumnorm/size(zt,1)
sumnorm = 0;
for i = 1:size(zt,1)
    sumnorm = sumnorm + norm(zt(i,:)-Yhat(i,:));
end
MSEProp = sumnorm/size(zt,1)

% figure;
for d = 1:D
    figure;
%     subplot(2,1,d);
    set(gcf,'color','white');
    hold on; grid on;
    plot(x,zt(:,d),'kd-','LineWidth',2);
    plot(x,Yhat(:,d),'r+--','LineWidth',1.5);
    plot(x,yavg(:,d),'bd--','LineWidth',1.5);
    axis([min(x) max(x) floor(nanmin(nanmin(y(:,:,d)))) ceil(nanmax(nanmax(y(:,:,d))))+1]);
    strTitle = sprintf('MSE Average = %0.4f, MSE Proposed = %0.4f',MSEAvg,MSEProp);
    strVar = sprintf('Variance: ');
    strTrueVar = sprintf('TrueVar: ');
    for m = 1:R
        strVar = strcat(strVar,32,32,sprintf('%0.4f',VarAnn(m)));
        strTrueVar = strcat(strTrueVar,32,32,sprintf('%0.4f',exp(noise(m))));
    end

    if d==1
        title(char(strTitle,char(strVar,strTrueVar)),'FontSize',12);
    end
    legend('True','Proposed','Avg');
    legend('Location','Northwest')
    box;
end

