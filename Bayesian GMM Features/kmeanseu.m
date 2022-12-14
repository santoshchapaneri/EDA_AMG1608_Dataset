function [idx c] = kmeanseu(x, K, its, c)
% function [idx c] = kmeanseu(x, K, its, c)

M = size(x, 1);
N = size(x, 2);

if (nargin < 4)
    % % rows of c are the centroids.
    % % initialize them with random points
    rp = randperm(M);
    c = x(rp(1:K), :);
end

% % idx(m) = the cluster with which point m is associated
idx = zeros(M, 1);

lastscore = inf;
for it = 1:its,
    % % first, assign each point to its closest centroid
    % % this involves first calculating the distance matrix of all points
    % % to all centroids.
    distmat = zeros(M, K);
    for k = 1:K,
%         diffs = submean(x, c(k, :));
        diffs = x - repmat(c(k, :), size(x, 1), 1);
        distmat(:, k) = sum(diffs .* diffs, 2);
    end
    score = 0;
    
    [temp idx] = min(distmat, [], 2);
    for m = 1:M
        score = score + distmat(m, idx(m));
    end
    disp(sprintf('score = %f', score))
    
    % % now recompute the centroids
    for k = 1:K,
        c(k, :) = mean(x(idx == k, :));
    end
    
    if (score / lastscore > 0.9999)
        break;
    end
    lastscore = score;
end
