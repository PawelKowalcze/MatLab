function s=rand_multadd( N, seed )
a = 69069;
m = 5;
p = 2^32;
s = zeros(N,1);
for i=1:N
    s(i) = mod(seed*a+m,p);
    seed = s(i);
end
s = s/p;