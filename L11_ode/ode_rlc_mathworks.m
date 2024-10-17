%% PROJECT REPORT: RLC series circuit
% The RLC circuit consists of a resistor, an inductor, and a capacitor:
%
% <<RLC_model.PNG>>
%
% The differential equations governing the RLC circuit are given by:
%
% $\displaystyle LC\frac{d^2 U_c}{dt^2} + RC \frac{U_c}{dt} + U_c\left(1 + \kappa U_c^2\right) = U_{in}$

%% RLC series circuit demo: numerical analysis
% This demo analyzes a RLC series circuit using numerically. From the
% symbolic differential equation a MATLAB function is generated and solved 
% using ode45(). For the sake of completeness, the corresponding MATLAB 
% function block is also generated for use in a Simulink model.
% The system behavior is investigated via the step response in the time
% domain and the bode diagram in the frequency domain.

% Copyright 2014 The MathWorks, Inc.

%% First try to solve the nonlinear equation symbolically...
% Create symbolic objects
clear all; clc;
syms R L C Uc(t) Uin kappa fin
% Define first and second derivatives for Uc
DUcDt   = diff(Uc);
D2UcDt2 = diff(Uc,2);
% Define differential equation for linear RLC circuit
RLC_DE  = L*C*D2UcDt2 + R*C*DUcDt + Uc*(1 + kappa*Uc^2) == Uin;
% Set initial conditions
Uc0     = Uc(0)    == 0;
DUc0    = DUcDt(0) == 0;
% Solve differential equation and display
Uc_sym  = dsolve(RLC_DE, Uc0, DUc0);
disp(Uc_sym)

%% Convert differential equation to set of first order equations
[V,Y] = odeToVectorField(RLC_DE, Uc0, DUc0);
% Convert symbolic expression to MATLAB function (and file)
M = matlabFunction(V,'file','RLC_DEm.m','vars',{'t','Y','R','L','C','Uin','kappa'});
open('RLC_DEm.m')

%% Define system parameters numerically
tspan  = linspace(0,1e-3,1e3);
% Define parameters for RLC
R_val  = 10;
L_val  = 1e-3;
C_val  = 1e-6;
f_val  = 1/(2*pi)*sqrt(1/(L_val*C_val) - (R_val/(2*L_val))^2);
% Input (or RHS): change input to dirac(t), t, etc.
Uin    = 1;
% Add non-linearity to system for kappav neq 0
kappa_val = 0.0;

%% Solve using the standard Runge-Kutta (4,5) and plot
[t_sol,Uc_sol] = ode45(@RLC_DEm,tspan,[0 0],[],R_val,L_val,C_val,Uin,kappa_val);
% Plot results
plot(t_sol,Uc_sol(:,1))
grid
xlabel('Time [sec]')
ylabel('Step response')
title('Step response')

%% Create Simulink block 
new_system('RLC_system');
matlabFunctionBlock('RLC_system/RLC_DE_block',V,...
                    'functionName', 'RLC_DE_block',...
                    'vars',{'Y','Uin','R','L','C','kappa'},...
                    'outputs',{'DYDt'});
save_system('RLC_system');
open_system('RLC_system');

%% Create Bode plot
% Define differential equation for linear RLC circuit: sine input
RLC_DE  = L*C*D2UcDt2 + R*C*DUcDt + Uc == sin(2*pi*fin*t);
[V,Y]   = odeToVectorField(RLC_DE, Uc0, DUc0);
Uc0     = Uc(0)    == 0;
DUc0    = DUcDt(0) == 0;
matlabFunction(V,'file','RLC_DE_sin.m','vars',{'t','Y','R','L','C','fin'});
fin_val = logspace(3,4.5,50)';
t       = linspace(0,1e-2,1e3);
% Solve DE using the standard Runge-Kutta (4,5)
gain_dB   = zeros(numel(fin_val),1);
phase_rad = gain_dB;
options   = odeset('AbsTol',1e-3,'RelTol',1e-2);
% Solve loop using parallel pool, replace by for-loop if necessary
parfor ii = 1:numel(fin_val)
    [~,Uc_sol]    = ode45(@RLC_DE_sin,t,[0 0],options,R_val,L_val,C_val,fin_val(ii));
    gain_dB(ii)   = 20*log10(max(Uc_sol(500:end,1)));
    fft_Uin       = fft(sin(2*pi*fin_val(ii)*t'));
    fft_Uc        = fft(Uc_sol(:,1));
    ind           = find(abs(fft_Uc) == max(abs(fft_Uc)));
    phase_rad(ii) = angle(fft_Uc(ind(1))) - angle(fft_Uin(ind(1)));
end

%% Plot Bode diagram
figure
subplot(2,1,1)
semilogx(fin_val,gain_dB,'linewidth',1)
title('RLC Bode plot')
xlabel('Frequency [Hz]')
ylabel('Gain [dB]')
grid
subplot(2,1,2)
semilogx(fin_val,180/pi*unwrap(phase_rad),'linewidth',1)
xlabel('Frequency [Hz]')
ylabel('Phase [deg]')
grid