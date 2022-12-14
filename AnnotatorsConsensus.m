function [Yhat,VarAnn] = AnnotatorsConsensus(Y, maxIter)
% Obtain consensus to estimate gold standard (no dependency on features)
% Can also handle missing annotations
% Input Y is Tensor : N x M x D, where N is number of instances, M is
% number of annotators, D is dimension of annotation responses, here D = 2,
% i.e. (valence, arousal) values for each instance

N = size(Y,1); % number of instances
M = size(Y,2); % number of annotators
D = size(Y,3); % dimension of responses, here D = 2 (V, A)

% Initialize EM algorithm with average data
Yhat = zeros(N,D);
for i = 1:N
    for d = 1:D
        T = Y(i,:,d);
        idx = ~isnan(T);
        Yhat(i,d) = mean(T(idx));
    end
end
% a=-1; b=1; Yhat = a + (b-a).*rand(N,D);
% VarAnn = rand(1,M); % initialize randomly

stopCr = 1e-8; % stopping criterion
oldYhat = zeros(N,D); oldVar = 0;

for iter=1:maxIter
    
    % Compute Variance of each Annotator
    for m=1:M
        T = Y(:,m,1); % same indices in both dimensions i.e. V and A together given by a single annotator
        idx = find(~isnan(T));
        Z(:,1) = Y(idx,m,1); Z(:,2) = Y(idx,m,2);
        sumnorm = 0;
        for k = 1:numel(idx)
            sumnorm = sumnorm + norm(Z(k,:) - Yhat(idx(k),:));
        end
        VarAnn(m) = sumnorm/numel(idx);
        clear Z;
    end
    % Avoid VarAnn = 0 to avoid division by zero in Yhat computation
    VarAnn = VarAnn + eps;

    % Compute Yhat (estimated gold standard)
    for i = 1:N
        for d=1:D
            T = Y(i,:,d);
            idx = find(~isnan(T));
            Yhat(i,d) = sum((1./VarAnn(idx)*Y(i,idx,d)'))/sum(1./VarAnn(idx));
        end
    end
    
	delta_Yhat = 0;
    for i = 1:size(Yhat,1)
        delta_Yhat = delta_Yhat + norm(Yhat(i,:)-oldYhat(i,:),1); % sum of element magnitudes
    end
    delta_VarAnn = sum(abs(VarAnn-oldVar));
    
    oldVar = VarAnn; oldYhat = Yhat;
   
    if delta_Yhat<stopCr && delta_VarAnn<stopCr
        fprintf('converged after %d iters\n',iter);
        break;
    end
    
    fprintf('iter:%d\t delta_Yhat:%.6f\t delta_var:%.12f\n',iter,delta_Yhat,delta_VarAnn);
end
end

