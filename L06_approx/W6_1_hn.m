
load sndb_prbs;

figure;
subplot(211); stem(u(1:200)); title('We');
subplot(212); stem(y(1:200)); title('Wy'); pause

M=30;           % dlugosc licznika
L=length(u);
% model FIR o dlugosci M
U=[];
for i=1:M
    U=[U, u(M-i+1:L-i+1)];
end
Y = y(M:L);
b = U \ Y;

figure; stem(b); title('b = h(n)'); grid; pause

if(rem(L,2)==1) L = L-1; end
Hls=freqz(b(1:M),[1], L/2);
ids=1:L/2;
Freqs=(ids-1)*fs/L;
figure; semilogy(Freqs, abs(Hls), 'b-'); grid;
xlabel('f [Hz]'); title('|H(f)|'); pause