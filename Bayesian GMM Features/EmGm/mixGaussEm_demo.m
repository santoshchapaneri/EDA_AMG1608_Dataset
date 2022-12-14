close all; clear;
d = 2;
k = 3;
n = 500;
[X,label, truemodel] = mixGaussRnd(d,k,n);
plotClass(X,label);

m = floor(n/2);
X1 = X(:,1:m);
X2 = X(:,(m+1):end);
% train
[z1,model,llh] = mixGaussEm(X1,k);
figure;
plot(llh);
figure;
plotClass(X1,z1);
% predict
z2 = mixGaussPred(X2,model);
label2 = label(m+1:end);

plot(1:250,label2, 1:250,z2);
legend('true','predicted');
figure;
plotClass(X2,z2);
