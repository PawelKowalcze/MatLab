%ai_0_roc.m
clear all; close all;

% Ekstrakcja/generacja cech
N = 2000;        % liczba przykladow/wzorcow
C = rand(N,2);   % 2 cechy na przyklad w dwoch osobnych kolumnach

N = 2000; bias = 2;                                        % bias = 3, 2.5, 2, 1.5, 1, 0.5, 0.25
x1 = randn(1,N) - bias;  [ h1, x1_arg ] = hist( x1, 50 );  % zdrowy
x2 = randn(1,N) + bias;  [ h2, x2_arg ] = hist( x2, 50 );  % chory
figure
plot(x1_arg, h1, 'b.-', x2_arg, h2, 'r.-' ); grid;
xlabel('Wartosc cechy'); ylabel('Liczba przypadkow'); title('Histogramy dla cechy #1')
legend('Zdrowy','Chory'); pause

lim = 1.5*(3+bias);
iter = 1;
for prog = -lim : 0.1 : lim
    TN(iter) = numel( x1( x1 < prog ) );   % zdrowy zdiagnozowany jako zdrowy (nizszy od progu)
    FP(iter) = N - TN(iter);               % zdrowy zdiagnozowany jako chory  (wyzszy od progu)
    TP(iter)  = numel( x2( x2 > prog ) );  % chory  zdiagnozowany jako chory  (wyzszy od progu)
    FN(iter) = N - TP(iter);               % chory  zdiagnozowany jako zdrowy (nizszy od progu)
    iter = iter + 1;
end
TPR = TP ./ ( TP+FN);  % czulosc   (True Positive Rate)
TNR = TN ./ ( TN+FP);  % swoistosc (True Negative Rate)

figure
prog = -lim : 0.1 : lim;
plot( prog, TNR, 'b.-', prog, TPR, 'r.-'); grid; title('Ksztalt krzywych jakosci');
xlabel('Wartosc progu'); ylabel('Wartosc miary jakosci');
legend('Swoistosc','Czulosc'); pause

figure
plot( 1-TNR, TPR, 'b.-'); grid; title('Krzywa ROC dla cechy #1');
xlabel('1-Swoistosc (1-Specificity)'); ylabel('Czulosc / Sensitivity'); pause
