function ModelAMG_VBUBM = MyTrain_ABGMM_UBM()

K = 256; % number of GMM clusters

% Obtain 100K training feature vectors
% getTrainFeatureVectors(); % already done, dont do it again!
addpath(genpath('netlab'));
addpath(genpath('VbGm'));

load('AMGSegments100K.mat'); % returns segments_mat 100K samples, each of D = 140
% trim data ?
% sampleperc = 0.01;
% rp = randperm(round(size(segments_mat,1)*sampleperc));
% segments_mat = segments_mat(rp,:);
% 
% segments_mat = segments_mat(:,1:4);

% Initialize with EM algorithm
mix = gmm(size(segments_mat,2), K, 'full'); 
options = foptions;
options(14) = 200; % how many times to run k-means?
fprintf('Initializing GMM with K-Means...\n');
mix = gmminit(mix, segments_mat, options);
% maxIter = 30; options(3) = 0.1; options(14) = maxIter;
% [mix, ~, ~] =  gmmem(mix, segments_mat, options);

% Finite GMM part
addpath(genpath('EmGm'));
modelInit.w = mix.priors;
modelInit.mu = mix.centres';
modelInit.Sigma = mix.covars;
[~,ModelAMG_UBM,~] = mixGaussEm(segments_mat',modelInit); 
save('ModelAMG_UBM_256.mat','ModelAMG_UBM');
% llh

% Variational part
[d, N] = size(segments_mat');
prior.alpha = 0.001;
prior.kappa = 1;
prior.m = mean(mix.centres',2); % initialized with K-means of netlab
prior.v = d+1;
prior.M = eye(d);   % M = inv(W)
% prior.logW = -2*sum(log(diag(chol(prior.M)))); % this is done inside
[~, ModelAMG_VBUBM, ~] = mixGaussVb(segments_mat', K, prior);
save('ModelAMG_VBUBM_256.mat','ModelAMG_VBUBM');
% K

% %% Remove irrelevant clusters
% load('ModelAMG_VBUBM_512.mat');
% model = ModelAMG_VBUBM;
% nk = sum(model.R,1); % 10.51 
% idx = find(nk<1);
% 
% if ~isempty(idx) 
%     model.R(:,idx) = []; 
%     model.alpha(idx) = [];
%     model.kappa(idx) = [];
%     model.m(:,idx) = [];
%     model.v(idx) = [];
%     model.U(:,:,idx) = [];
%     model.logW(idx) = [];
%     model.logR(:,idx) = [];
%     %Renormalization 
%     tmp = sum(model.R,2); 
%     model.R = bsxfun(@times,model.R,1./tmp); 
%     model.logR = log(model.R); 
%     model.R = exp(model.logR);
% end
% model.weights = zeros(1, size(model.R, 2)); 
% for i=1:size(R, 2) 
%     model.weights(i) = sum(model.R(:,i) / size(model.R, 1)); 
% end
% ModelAMG_VBUBM_Reduced = model;
% save('ModelAMG_VBUBM_Reduced.mat','ModelAMG_VBUBM_Reduced');
%% Testing
% addpath(genpath('netlab'));
% % addpath(genpath('VBEMGMM'));
% addpath(genpath('VbGm'));
% % addpath(genpath('EmGm'));
% 
% load('AMGCampusSegments100K.mat'); % returns segments_mat
% sampleperc = 0.1;
% rp = randperm(round(size(segments_mat,1)*sampleperc));
% segments_mat = segments_mat(rp,:);
% 
% [z, R, theta] = mixGaussVbPred(ModelAMG_VBUBM, segments_mat');
% theta
