function Theta = MyAcousticGMMPosterior(features, modelGMM)

K=size(modelGMM.w,2); % 16
J=length(features);
Theta = zeros(J, K); % J*K matrix whose row represents the distribution over K for song j

% Easy life = VQ
% for j = 1:J,
%    [idx n(j, :)] = vectorquantize(features{j}, c);
% end

% Interesting life = Acoustic GMM Posterior
for j = 1:J
    j
    % process for each features{j} aka jth song
    Theta(j,:) = MyMixGaussPosterior(features{j}', modelGMM);
end
    
    