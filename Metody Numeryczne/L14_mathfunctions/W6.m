% Petla cyfrowa PLL - Phase-Locked Loop
clear all; close all;

% PLL parameters
fs = 250000;                    % czestotliwosc probkowania
fc = 19000; phc = pi/4;         % czestotliwosc nosnej
fPLLstart = fc-25; dfreq = 100; % poczatkowa czestotl. petli, szerokosc pracy petli
ipll = 1;                       % 1=real PLL, 2=complex PLL

% Generacja sygnalow
N = 50000; n=0:N-1; A = 0.1;         % licza probkek, indeksy probek
dt=1/fs; t=dt*n;                     % okres probkowania, chwile probkowania 
if(ipll==1) s  = A * cos(2*pi*fc*t + phc);      end    % sygnal WE rzeczywisty
if(ipll==2) s  = A * exp(j*(2*pi*fc*t + phc));  end    % sygnal WE zespolony

% Obliczenie wartosci wspolczynnikow petli
damp = sqrt(2)/2;                                       % standardowe tlumienie
omeg = (dfreq/fs) / (damp+1/(4*damp));                  % zmienna  
mi1   = (4*damp*omeg) / (1 + 2*damp*omeg + omeg*omeg);  % stala adaptacji #1
mi2   = (4*omeg*omeg) / (1 + 2*damp*omeg + omeg*omeg);  % stala adaptacji #2

% PLL
omega = zeros(1,N+1); omega(1) = 2*pi*fPLLstart / fs;
theta = zeros(1,N+1);
smax = max(abs(s));
for n = 1 : N  % PETLA ADAPTACJI
    if( ipll==1 ) delta = -2*sin(theta(n)) * s(n)/smax;
    else          delta = -2*imag( exp(j*theta(n)) * conj(s(n) )/smax );
    end    
    theta(n+1) = theta(n) + omega(n) + mi1*delta;
    omega(n+1) = omega(n) + mi2*delta;
end
c = cos(  theta(1:N) );    % odtworzona nosna
sr = real(s) / smax;       % czesc rzeczywista zaklocenego sygnalu wejsciowego 
n = 1:100;
plot(n,sr(n),'r.-',n,c(n),'b.-'); title('s(n) and c(n)'); grid; pause
figure; plot(1:N,sr-c,'r-'); title('s(n)-c(n)'); grid; pause
figure; plot(theta); title('\theta(n) [rad]');grid; pause
figure; plot(omega*fs/(2*pi),'b-'); xlabel('n'); title('f_{PLL}(n) [Hz]'); grid; pause