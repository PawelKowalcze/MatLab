clear all;
close all;

N = 256;
h=sin(2*pi/128*(0:N-1));
v=sin(2*pi/64*(0:N-1));
v_vertical = v(:);

plot(v_vertical,0:N-1),
hold on;
plot(0:N-1,h),

mult = v_vertical * h;
mesh(mult),



