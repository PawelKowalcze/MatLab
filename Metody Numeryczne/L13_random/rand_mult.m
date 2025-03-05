function s=rand_mult( N, seed )
a = 69069;
p = 2^12;
s = zeros(N,1);
for i=1:N
    s(i) = mod(seed*a,p);
    seed = s(i);
end

% TEST  
figure; w=s-mean(s); plot(-9999:9999,xcorr(w,w),'o-');
z = 1:4096;  [ s(z), s(z+2*1024)], pause

s = s/p;