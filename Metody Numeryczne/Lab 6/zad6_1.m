clear all;
close all;

A = [5,7;4,3;7,6;10,1];

x = zeros(1,2);

b = [1;2;3;4];

x = inv(transpose(A)*A)*transpose(A) * b,
