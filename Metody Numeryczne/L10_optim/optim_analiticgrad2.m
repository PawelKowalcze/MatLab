% optim_analyticgrad2.m  
  clear all; close all;

% Rysunek funkcji - na poczatek 
  x1var = -10:0.5:10; x2var = -10:0.5:10;
  [X1,X2] = meshgrid( x1var, x2var ); x12 = [ X1(:), X2(:) ];
  [f,fp] = fun_x1x2( x12 );
  f = reshape(f,length(x1var),length(x2var));
  figure; subplot(111); surfc(X1,X2,f);
  xlabel('x_1'); ylabel('x_2'); zlabel('f(x_1,x_2'); title('f()');

% Bez uzycia analitycznego gradientu
  [x,fx,info,output] = fminunc('fun_x1x2',[1 1]), pause

% Z uzyciem analitycznego gradientu
  opt = optimset('GradObj','on');
  [x,fx,info,output] = fminunc('fun_x1x2',[1 1],opt), pause

% ################################
function [f,fp]=fun_x1x2(x)
f  = (x(:,1)-1).^2 + 10*x(:,2).^2;
fp = [ 2*(x(:,1)-1); 20*x(:,2) ];
end
