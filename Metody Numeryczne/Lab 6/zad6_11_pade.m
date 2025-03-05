% Problem 6.11: Przybliżenie funkcji błędu erf(x) za pomocą aproksymacji Padé

syms x;
f = erf(x);  % Definicja funkcji błędu jako funkcji symboliczej

% Obliczanie rozwinięcia Taylora funkcji erf(x) wokół zera do rzędu 10
taylor_approx = taylor(f, x, 'Order', 10);

% Znajdowanie przybliżenia Padé rzędu (3,3) dla rozwinięcia Taylora
[pade_num, pade_den] = pade(taylor_approx, x, [3, 3]);

% Konwersja przybliżenia Padé do postaci numerycznej
pade_approx_func = matlabFunction(pade_num / pade_den);

% Wykres porównawczy funkcji erf(x) i przybliżenia Padé
x_vals = linspace(-2, 2, 1000);
erf_vals = erf(x_vals); % Wartości funkcji wbudowanej erf(x)
pade_vals = pade_approx_func(x_vals);

figure;
plot(x_vals, erf_vals, 'b-', 'DisplayName', 'erf(x) - Funkcja wbudowana');
hold on;
plot(x_vals, pade_vals, 'r--', 'DisplayName', 'Przybliżenie Padé (3,3)');
xlabel('x');
ylabel('erf(x)');
legend;
title('Porównanie funkcji erf(x) i przybliżenia Padé (3,3)');
grid on;
