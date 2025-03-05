% Odbiornik cyfrowy radia FM mono
% Octave: >>pkg load signal[ENTER} 
  clear all; close all;

% IMPORTANT !
% Load dataIQ.zip file from the page:
% http://kt.agh.edu.pl/~tzielin/books/DSPforTelecomm/
% and extract SDRSharp_FMRadio_xxxxxxkHz_IQ.wav files from the ZIP
  
% Wczytaj nagrany sygnal radia FM - Twoj wybor
  FileName = 'SDRSharp_FMRadio_101600kHz_IQ.wav';  T=5;  demod=1; % wiele stacji FM
  inf = audioinfo(FileName), pause                % co zawiera nagranie 
  fs = inf.SampleRate;                            % liczba probek na sekunde
  [x,fs] = audioread(FileName,[1,T*fs]);          % wczytaj tylko T sekund 
  Nx = length(x),                                 % dlugosc sygnalu
  
% Odtworz zespolony sygnal I+j*Q(n), jesli potrzeba dodaj Q=0
  [dummy,M] = size(x);
  if(M==2) x = x(:,1) - j*x(:,2); else x = x(1:Nx,1) + j*zeros(Nx,1); end 

% Zdemoduluj i odtworz jedna, wybrana stacje radia FM - tylko mono
  bwSERV=200e+3; bwAUDIO=25e+3;                      % Parametry: czestotliwosci w Hz 
  D1 = round(fs/bwSERV); D2 = round(bwSERV/bwAUDIO); % Rząd pod-probkowania D1 i D2?
  f0 = -0.59e+6; x = x .* exp(-j*2*pi*f0/fs*(0:Nx-1)');  % Stacja? przesun w Hz: 0? -0.59? 
  x = resample(x,1,D1);                              % Filtracja i redukcja probek D1
  x = real(x(2:end)).*imag(x(1:end-1))-real(x(1:end-1)).*imag(x(2:end)); % demod FM
  x = resample(x,1,D2);                              % Filtracja i redukcja probek D2 
  soundsc(x,bwAUDIO);                                % Odtwarzanie stacji
