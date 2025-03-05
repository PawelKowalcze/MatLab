% interp_lagrange.m
clear all; close all;;

if(1)
  x  = [-3, -1, 1, 3]; y = [1, 1, 1, 1];  % zadane punkty = wezly
  xi = [-4: 0.05 : 4];                    % gdzie obliczyc nowe wartosci funkcji
else
  x = [ 5, 6, 8, 11 ]; y = [ -2, 3, 7, 10 ];  % temperatura w Krakowie
  xi = [4: 1/12 : 12];
end

[yi,a] = funTZ_lagrange(x,y,xi);  % nasza funkcja interpolujaca
%[yi,a,p] = funTZ_newton(x,y,xi);   % nasza funkcja interpolujaca
yii = polyval(a,xi);               % oblicz wartosci wielomianu "a" w punktach "xi" 
a,                                 % obliczone wsp. wielomianu: aN,...,a1,a0
figure; plot(x,y,'ro',xi,yi,'b-',xi,yii,'k-'); title('y=f(x)');   % rysunek
