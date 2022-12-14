function theta = MyMixBayesianGaussPosterior(X, model)
% Input:
%   X: d x n data matrix
%   model: trained model structure outputed by the EM algirthm
% Output:
%   theta: 1 x k Acoustic Bayesian GMM Posterior probabilities
alpha = model.alpha;   % Dirichlet
kappa = model.kappa;   % Gaussian
m = model.m;           % Gasusian
v = model.v;           % Whishart
U = model.U;           % Whishart 
logW = model.logW;
n = size(X,2);
[d,k] = size(m);

EQ = zeros(n,k);
for i = 1:k
    Q = (U(:,:,i)'\bsxfun(@minus,X,m(:,i)));
    EQ(:,i) = d/kappa(i)+v(i)*dot(Q,Q,1);    % 10.64
end
ElogLambda = sum(psi(0,0.5*bsxfun(@minus,v+1,(1:d)')),1)+d*log(2)+logW; % 10.65
Elogpi = psi(0,alpha)-psi(0,sum(alpha)); % 10.66
logRho = -0.5*bsxfun(@minus,EQ,ElogLambda-d*log(2*pi)); % 10.46
logRho = bsxfun(@plus,logRho,Elogpi);   % 10.46
logR = bsxfun(@minus,logRho,logsumexp(logRho,2)); % 10.49
R = exp(logR);
z = zeros(1,n);
[~,z(:)] = max(R,[],2);
[~,~,z(:)] = unique(z);

% theta: 1 x k Acoustic GMM Posterior probabilities
% theta = zeros(1,k);
% for i = 1:k
%     theta(i) = sum(R(:,i))/n;
% end

% Or, rather:
nk = sum(R,1); % 10.51 
% % idx = find(nk<0.01); 
idx = find(nk<1); % eliminiate irrelevant clusters
% 
% if ~isempty(idx) 
%     R(:,idx) = []; 
%     %Renormalization 
%     tmp = sum(R,2); 
%     R = bsxfun(@times,R,1./tmp); 
%     logR = log(R); 
%     R = exp(logR);
%     [~,z(:)] = max(R,[],2);
%     [~,~,z(:)] = unique(z);
% end
% theta = zeros(1, size(R, 2)); 
% pre-allocate theta
theta = zeros(1,length(nk)-length(idx));
for i=1:size(R, 2) 
    theta(i) = sum(R(:,i) / size(R, 1)); 
end

end

