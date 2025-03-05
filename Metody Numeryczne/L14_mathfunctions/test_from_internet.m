% Filter test program in matlab
% https://www.dsprelated.com/freebooks/pasp/Digital_Waveguide_Oscillator.html

%N = 300;   % Number of samples to generate
N = 3000;   % Number of samples to generate
f = 100;    % Desired oscillation frequency (Hz)
fs = 8192;  % Audio sampling rate (Hz)
%R = .99;   % Decay factor (1=never, 0=instant)
R = 1;      % Decay factor (1=never, 0=instant)
b1 = 1;     % Input gain to state variable x(n)
b2 = 0;     % Input gain to state variable y(n)

%nd = 16;   % Number of significant digits to use
nd = 4;     % Number of significant digits to use
base = 2;   % Mantissa base (two significant figures)
            % (see 'help chop' in Matlab)

u = [1,zeros(1,N-1)]; % driving input test signal
theta = 2*pi*f/fs;    % resonance frequency, rad/sample

% ================================================
% 2D PLANAR ROTATION (COMPLEX MULTIPLY)

x1 = zeros(1,N); % Predeclare saved-state arrays
y1 = zeros(1,N);

x1(1) = 0;      % Initial condition
y1(1) = 0;      % Initial condition

c = chop(R*cos(theta),nd,base); % coefficient 1
s = chop(R*sin(theta),nd,base); % coefficient 2

for n=1:N-1,
  x1(n+1) = chop(   c*x1(n) - s*y1(n) + b1*u(n), nd,base);
  y1(n+1) = chop(   s*x1(n) + c*y1(n) + b2*u(n), nd,base);
end

% ================================================
% MODIFIED COUPLED FORM ("MAGIC CIRCLE")
% (ref: http://ccrma.stanford.edu/~jos/wgo/ )

x2 = zeros(1,N); % Predeclare saved-state arrays
y2 = zeros(1,N);

x2(1) = 0.0;     % Initial condition
y2(1) = 0.0;     % Initial condition

e = chop(2*sin(theta/2),nd,base); % tuning coefficient

for n=1:N-1,
  x2(n+1) = chop(R*(x2(n)-e*y2(n))+b1*u(n),nd,base);
  y2(n+1) = chop(R*(e*x2(n+1)+y2(n))+b2*u(n),nd,base);
end

% ================================================
% DIGITAL WAVEGUIDE RESONATOR (DWR)

x3 = zeros(1,N); % Predeclare saved-state arrays
y3 = zeros(1,N);

x3(1) = 0;      % Initial condition
y3(1) = 0;      % Initial condition

g = R*R;        % decay coefficient
t = tan(theta); % toward tuning coefficient
cp = sqrt(g/(g + t^2*(1+g)^2/4 + (1-g)^2/4)); % exact
%cp = 1 - (t^2*(1+g)^2 + (1-g)^2)/(8*g); % good approx
b1n = b1*sqrt((1-cp)/(1+cp)); % input scaling

% Quantize coefficients:
cp = chop(cp,nd,base);
g = chop(g,nd,base);
b1n = chop(b1n,nd,base);

for n=1:N-1,
  gx3 = chop(g*x3(n), nd,base); % mpy 1
  y3n = y3(n);
  temp = chop(cp*(gx3 + y3n), nd,base); % mpy 2
  x3(n+1) = temp - y3n + b1n*u(n);
  y3(n+1) = gx3 + temp + b2*u(n);
end

% ================================================
% playandplot.m

figure(4);
title('Impulse Response Overlay');
ylabel('Amplitude');
xlabel('Time (samples)');
alt=1;%alt = (-1).^(0:N-1); % for visibility
plot([y1',y2',(alt.*y3)']); grid('on');
legend('2DR','MCF','WGR');
title('Impulse Response Overlay');
ylabel('Amplitude');
xlabel('Time (samples)');
