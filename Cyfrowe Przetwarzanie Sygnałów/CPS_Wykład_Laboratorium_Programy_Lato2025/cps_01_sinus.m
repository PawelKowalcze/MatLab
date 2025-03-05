% cps_01_sinus.m
  clear all; close all;

  fpr=8000; Nx=3*fpr;              % parametry: czestotliwosc probkowania, liczba probek             
  dt = 1/fpr;                     % okres probkowania 
  n = 0 : Nx-1;                   % numery probek        
  t = dt*n;                       % chwile probkowania
  A1=0.5; A2 = 0.75; A3=0.2; 
  f1=200; f2 = fpr + f1; f3 = 2*fpr + f1;
  
  p1=pi/2; p2=pi/4; p3=pi/6;         % sinusoida: amplituda, czestotliwosc, faza
  x1 = A1*cos(2*pi*f1    *t+p1);  % pierwszy skladnik sygnalu
  %x1 = A1*sin(2*pi*f1/fpr*n+p1);  % pierwszy składnik inaczej zapisany
  x2 = A2*cos(2*pi*f1*t+p2);  % drugi skladnik
  x3 = A3*cos(2*pi*f1*t+p3);  % trzeci skladnik
  x = x1 + x2 + x3;                         % wybor skladowych: x = x1, x1 + 0.123*x2 + 0.456*x3   
  plot(t,x,'bo-'); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');