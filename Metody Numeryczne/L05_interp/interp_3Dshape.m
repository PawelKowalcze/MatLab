% interp_3Dshape.m
clear all; close all;

[X,Y] = meshgrid(0 : 0.02 : 1);
Z = X .* Y;
surfl( Z );
xlabel('x'); ylabel('y'); zlabel('z'); title('z=f(x,y)'); 
colormap( gray );
 
