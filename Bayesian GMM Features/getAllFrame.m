function  allpoints = getAllFrame(features)

count=0;
for i =1:length(features)
    count=count+size(features{i},1);
end

allpoints = zeros(count,size(features{i},2));

ind=1;
for i =1:length(features)
    allpoints(ind:ind+size(features{i},1)-1,:)=features{i};
    ind=ind+size(features{i},1);
end

