function y = fun_zero(x)
% funkcja, w ktorej miejsc zerowych poszukujemy miejsc zerowych, wykorzystywana przez cw_6.m

y = 1 ./ ((x-.3).^2 + .01) + 1 ./ ((x-.9).^2 + .04) - 6;
