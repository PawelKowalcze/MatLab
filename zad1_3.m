%zadanie optymalizacyjne - największa objętość dla zadanego pola
%powierzchni całkowitej S
%dane: walec:obj = pp*h = pi*r^2*h
%r,h
%S = 2*pp + pb = 2*pi*r^2 + 2*pi*r*h
%S/(2*pi) = r*(r+h)

syms r;
S = 300;
V = S/2 * r - pi*r^3;
dV = diff(V,r);

zeros_of_dV = solve (dV == 0, r);
zeros_matrix = zeros(1,length(zeros_of_dV));

for i=1:length(zeros_of_dV)
    zeros_matrix(i) = double(zeros_of_dV(i));
end


disp(zeros_matrix),

disp("Radius and Height of an object with the greatest volume are: ")
r_for_max = zeros_matrix(2),
h = S/(2*pi*r_for_max) - r_for_max,
