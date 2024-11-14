% Problem 6.11: Przybliżenie funkcji błędu erf(x)

syms x t;
f = 2 / sqrt(pi) * int(exp(-t^2), t, 0, x);

% Aproksymacja Taylora dla erf(x) wokół zera do rzędu 10
taylor_approx = taylor(f, x, 'Order', 10);

% Konwersja przybliżenia Taylora do funkcji numerycznej
taylor_approx_func = matlabFunction(taylor_approx);

% Wykres porównawczy funkcji erf(x) i przybliżenia Taylora
x_vals = linspace(-2, 2, 1000);
erf_vals = erf(x_vals); % Wartości funkcji wbudowanej erf(x)
taylor_vals = taylor_approx_func(x_vals);

figure;
plot(x_vals, erf_vals, 'b-', 'DisplayName', 'erf(x) - Funkcja wbudowana');
hold on;
plot(x_vals, taylor_vals, 'r--', 'DisplayName', 'Przybliżenie Taylora (rzędu 10)');
xlabel('x');
ylabel('erf(x)');
legend;
title('Porównanie funkcji erf(x) i przybliżenia Taylora');
grid on;
