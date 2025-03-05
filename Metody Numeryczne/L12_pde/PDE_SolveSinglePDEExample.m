% PDE_SolveSinglePDEExample.m
% Solving partial differential example in Matlab using pdepe()
% task:                 u(x,t) = ? 
% equation              pi^2 * du(x,t)/dt = d^2 u(x,t)/dt^2
% initial condition:    t=0, x=var: u0 = u(x,0)=sin(pi*x)
% boundary condition:   x=0, t=var: u(0,t)=0
%                       x=1, t=var: u(1,t) = pi*exp(-t) + du(1,t)/dx = 0
clear all; close all;

% Required (x,t) grid
x = linspace(0,1,20);     % a  <= x <= b
t = linspace(0,2,5);      % t1 <= t <= t2

% Solving                    init. condition   boundary conditions
m = 0;           % function    u0 for t(1)     u(x=a,t), u(x=b,t)
sol = pdepe( m,   @pdex1pde,   @pdex1ic,       @pdex1bc, x, t);
u = sol(:,:,1);

% Results
figure;
subplot(121); surf(x,t,u);                  title('Num  solution'); xlabel('odl. x'); ylabel('czas t');
subplot(122); surf(x,t,exp(-t)'*sin(pi*x)); title('True solution'); xlabel('odl. x'); ylabel('czas t');
