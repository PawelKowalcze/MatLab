%podstawy Matlaba
%ax^2 + bx + c = 0
clear all;
close all;


a = 1;
b = 10;
c = 3;

delta = b^2 - 4*a*c,
x1 = (-b-sqrt(delta))/2*a,
x2 = (-b+sqrt(delta))/2*a,

wynik1 = a*x1^2 + b*x1 + c,
wynik2 = a*x2^2 + b*x2 + c,




%y = a*x^2 + b*x + c;
%plot(f(x), x),

x = -10:0.1:10;
y = a*x.^2 + b*x + c;

[maxValue, maxIndex] = max(y),
[minValue, minIndex] = min(y),

plot(x,y,'-r','LineWidth',1.5),

hold on;

plot(x(minIndex),minValue,'bo','MarkerSize', 10, 'LineWidth', 2),
plot(x(maxIndex),maxValue,'go','MarkerSize', 10, 'LineWidth', 2),