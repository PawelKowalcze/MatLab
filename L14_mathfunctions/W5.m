% Odbiornik cyfrowy radia FM mono
% Octave: >>pkg load signal[ENTER} 
  clear all; close all;
  
  m=128; cm_plasma=plasma(m); cm_inferno=inferno(m); % color maps for gray printing
  cm = plasma;
  
% Read recorded IQ signal - choose one

% IMPORTANT !
% Load dataIQ.zip file from the page:
% http://kt.agh.edu.pl/~tzielin/books/DSPforTelecomm/
% and extract SDRSharp_FMRadio_xxxxxxkHz_IQ.wav files from the ZIP

  FileName = 'SDRSharp_FMRadio_101600kHz_IQ.wav';  T=5;  demod=1; % FM Radio signal

  inf = audioinfo(FileName), pause                % what is "inside" 
  fs = inf.SampleRate;                            % sampling rate
  [x,fs] = audioread(FileName,[1,T*fs]);          % read only T seconds 
  whos, pause                                     % what is in the memory
  Nx = length(x),                                 % signal length

% Reconstruct the complex-value IQ data, if necessary add Q=0
  [dummy,M] = size(x);
  if(M==2) x = x(:,1) - j*x(:,2); else x = x(1:Nx,1) + j*zeros(Nx,1); end 
      nd = 1:2500;
      figure(1); plot(nd,real(x(nd)),'bo-',nd,imag(x(nd)),'r*--'); xlabel('n'); grid; 
      title('I(n) = (o) BLUE/solid    |    Q(n)= (*) RED/dashed'); pause

% Parameters - lengths of FFT and STFT, central signal sample
  Nc = floor( Nx/2 ); Nfft = min(2^17,2*Nc); Nstft = 512; 

% Power Spectral Density (PSD) of the signal
  n = Nc-Nfft/2+1 : Nc+Nfft/2;             % indexes of signal samples
  df = fs/Nfft;                            % df - step in frequency
  f = df * (0 : 1 : Nfft-1);               % frequency axis [ 0, fs ]
  fshift = df * (-Nfft/2 : 1 : Nfft/2-1);  % frequency axis [ -fs/2, fs/2 ]
  w = kaiser(Nfft,10);                     % window function used
  X = fft( x(n) .* w );                    % DFT of windowed signal
  P = 2*X.*conj(X) / (fs*sum(w.^2));       % Power Spectral Density (dB/Hz)
  Pshift = fftshift( P );                  % circularly shifted PSD
  
  % Parameters for Short Time Fourier Transform (STFT) of the signal
  N = Nstft; df = fs/N; ff = df*(0:1:N-1);  ffshift = df*(-N/2:1:N/2-1);

      figure(2)
      subplot(211); plot(f,10*log10(abs(P))); xlabel('f (HZ)'); ylabel('(dB/Hz)')
      axis tight; grid; title('PSD for frequencies [0-fs)');
      subplot(212); spectrogram(x(n),kaiser(Nstft,10),Nstft-Nstft/4,ff,fs);
      colormap(cm); pause

      figure(3)
      subplot(211); plot(fshift,10*log10(abs(Pshift))); xlabel('f (HZ)'); ylabel('(dB/Hz)')
      axis tight; grid; title('PSD for frequencies [-fs/2, fs/2)');
      subplot(212); spectrogram(x(n),kaiser(Nstft,10),Nstft-Nstft/4,ffshift,fs);
      colormap(cm); pause
      subplot(111);
  
  if(demod==1) % FM demodulation and mono FM radio decoding
     bwSERV=200e+3; bwAUDIO=25e+3;                                        % Parameters
     D1 = round(fs/bwSERV); D2 = round(bwSERV/bwAUDIO);          % Downsampling ratios
     f0 = 0e+6; x = x .* exp(-j*2*pi*f0/fs*(0:Nx-1)'); % Station? shift in freq 0? -0.59? 
           figure; spectrogram(x(n),kaiser(Nstft,10),Nstft-Nstft/4,ffshift,fs); colormap(cm); pause
     x = resample(x,1,D1);                             % Resample down to service freq
           figure; spectrogram(x,kaiser(Nstft,10),Nstft-Nstft/4,ffshift/D1,bwSERV); colormap(cm); pause
     x = real(x(2:end)).*imag(x(1:end-1))-real(x(1:end-1)).*imag(x(2:end)); % FM demod
           figure; spectrogram(x,kaiser(Nstft,10),Nstft-Nstft/4,ffshift/D1,bwSERV); colormap(cm); pause
     x = resample(x,1,D2);                               % Resample down to audio freq 
           figure; spectrogram(x,kaiser(Nstft,10),Nstft-Nstft/4,ffshift/(D1*D2),bwAUDIO); colormap(cm); pause
     soundsc(x,bwAUDIO);                                                   % Listening
  end
  