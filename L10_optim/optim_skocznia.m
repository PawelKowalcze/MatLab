% optim_skocznia.m
% przyklad skoczni narciarskiej

x = 0 : 0.001 : 1;
figure
for a = 1 : 0.5 : 5
  % f = (a*x-1).*(x-1);         % parabola: ax^2 + (a+1)*x + 1
    f = a*x.^2 - (a+1)*x + 1;
    plot(x,f); hold on;
end    
grid; title('a = 0 : 0.5 : 5'); xlabel('x'); ylabel('f(x)');