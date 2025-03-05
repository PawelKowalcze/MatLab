clear all; close all;
fpr=44100; Nx=fpr;              % parametry: czestotliwosc probkowania, liczba probek             
dt = 1/fpr;                     % okres probkowania 
n = 0 : Nx-1;                   % numery probek        
t = dt*n;                       % chwile probkowania
A1 = 0.5;
f1 = 1000;
fd = 5000;
f = f1:fpr;

  
p1=0; % sinusoida: amplituda, czestotliwosc, faza
x = A1*sin(2*pi*f.*t+p1);
plot(t,x,'bo-'); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');