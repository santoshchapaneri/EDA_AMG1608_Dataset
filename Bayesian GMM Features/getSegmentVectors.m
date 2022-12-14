% Get Segment Vectors of each Song's feature vector
function song_frames_stats = getSegmentVectors(path, fileName, len, hop)

s = sprintf('%s%s',path, fileName);
load(s);
% tmp = importdata([path fileName]);
% song_frames = tmp'; % NumFrames x NumFeatures matrix
song_frames = features';

L = floor((size(song_frames,1)-len)/hop)+1;
D = size(song_frames,2);
F = zeros(L, D*2);
ind=1;
for j=1:L
    if j==293
        j=293;
    end
    M = song_frames(ind:ind+len-1,:);
    F(j,:) = [mean(M) std(M)];
    ind = ind+hop;
    if ind+len > size(song_frames,1)
        F=F(1:end-1,:);
        break;
    end
end
song_frames_stats = F;
