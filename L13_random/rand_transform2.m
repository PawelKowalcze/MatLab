% rand_transform2.m
% Przekształcenie Boxa-Millera

disp('Równomierny R[0,1] --> Normalny (0,1)')
N = 10000; 
r1 = rand(1,N);
r2 = rand(1,N);
figure;
subplot(111); plot(r1,r2,'b*'); xlabel('r1'); ylabel('r2'); grid;  pause
figure;
subplot(211); hist(r1,20); title('hist( r1 )'); axis([0,1,0,1000]); grid;
subplot(212); hist(r2,20); title('hist( r2 )'); axis([0,1,0,1000]); grid; pause


n1 = sqrt(-2*log(r1)) .* cos(2*pi*r2);
n2 = sqrt(-2*log(r1)) .* sin(2*pi*r2);
 
figure;
subplot(111); plot(n1,n2,'b*'); xlabel('n1'); ylabel('n2'); grid;  pause
figure;
subplot(211); hist(n1,20); title('hist( n1 )'); axis([-5,5,0,2000]); grid;
subplot(212); hist(n2,20); title('hist( n2 )'); axis([-5,5,0,2000]); grid; pause
