function Theta = MyAcousticBayesianGMMPosterior(features, modelABGMM)

K = size(modelABGMM.weights,2); 
J = length(features);
Theta = zeros(J, K); % J*K matrix whose row represents the distribution over K for jth song

% % Easy life = VQ
% for j = 1:J
%    [~, Theta(j, :)] = vectorquantize(features{j}, modelABGMM.m');
% end

% Interesting life = Acoustic Bayesian GMM Posterior
for j = 1:J
% for j = 942:943
    fprintf('%d \n',j);
    % process for each features{j} aka jth song
    tmp = MyMixBayesianGaussPosterior(features{j}', modelABGMM);
    tmpL = length(tmp);
    if tmpL < K
        tmp2 = [tmp zeros(1,K-tmpL)];
    else
        tmp2 = tmp;
    end
    Theta(j,:) = tmp2;
end
    
    