% Problem 6.10: Przybliżenie Padé dla funkcji f(x) = 1 / (1 + x^2)

syms x;
f = 1 / (1 + x^2);

% Wyznaczanie przybliżenia Padé rzędu (1,1)
[pade_num, pade_den] = pade(f, x, [1, 1]);

% Konwersja funkcji Padé do postaci numerycznej
pade_approx = matlabFunction(pade_num / pade_den);

% Wykres porównawczy funkcji i jej przybliżenia Padé
x_vals = linspace(-5, 5, 1000);
f_vals = double(subs(f, x, x_vals));
pade_vals = pade_approx(x_vals);

figure;
plot(x_vals, f_vals, 'b-', 'DisplayName', 'f(x) = 1 / (1 + x^2)');
hold on;
plot(x_vals, pade_vals, 'r--', 'DisplayName', 'Przybliżenie Padé (1,1)');
xlabel('x');
ylabel('f(x)');
legend;
title('Porównanie funkcji f(x) i przybliżenia Padé');
grid on;
