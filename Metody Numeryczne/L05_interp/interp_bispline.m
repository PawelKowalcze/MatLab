% interp_bispline.m

clear all; close all;

K = 100;
b = ones(1,K+1);
figure; plot(0:1/K:1,b,'b-',[0,1],[1,1],'ro'); pause

for k=1:5
    k,
    b = conv(b,b);
    b = b / sum(b);
    Nb = length(b),
    n = [-(Nb-1)/2 : (Nb-1)/2 ] / K;
    figure; plot(n,b,'b-',n(1:K:end),b(1:K:end),'ro'); pause

end    