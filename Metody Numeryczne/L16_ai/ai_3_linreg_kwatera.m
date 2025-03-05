
% ai_3_linreg_kwatera.m

clear all; close all;

load dane_kwatera.txt
dane = dane_kwatera;  clear dane_kwatera

[N,M] = size(dane),     % N = liczba zestawow danych, M = liczba zmiennych

XX(:,1) = ones(N,1);    % inicjalizacja: c0=1 zawsze
XX(:,2) = dane(:,1);    % kolumna 1 danych = powierzchnia w m^2
XX(:,3) = dane(:,2);    % kolumna 2 danych = liczba pokoi
y       = dane(:,3);    % kolumna 3 danych = koszt wynajmu w zlotych

%% Jeden argument - wplyw tylko powierzchni mieszkania (x1) na koszt (y)
                        % y =  w0 + w1*x1 = [ 1 x1 ] * [ w0;
                        %                                w1 ]
X = XX(:,1:2);          % 1 = jedynka, 2 = powierzchnia (x1)
w1 = inv(X'*X)*X'*y,    % macierzowe obliczenie wspolczynnikow wagowych w0, w1
w2 = train_linear_regress( X, y ),   % adaptacyjne trenowanie
w = w1;                              % wybor

    xi = 10 : 1 : 120;
    yi = w(1) + w(2)*xi;

    figure; plot( X(:,2), y,'bo', xi, yi,'r-'); grid;
    xlabel('Powierzchnia [metry^2]');
    ylabel('Koszt wynajmu [zlote]');
    title('y = funkcja( x )');
    pause

%% Dwa argumenty - wplyw powierzchni mieszkania (x1) i liczby pokoi (x2) na koszt (y)
                        % y = w0 + w1*x1 + w2*x2 = [ 1 x1 x2 ] * [ w0;
                        %                                          w1;
                        %                                          w2 ]
X = XX(:,1:3);          % 1 = jedynka, 2 = powierzchnia (x1), 3 = liczba pokoi (x2)

w1 = inv(X'*X)*X'*y, % macierzowe obliczenie wspolczynnikow wagowych w0, w1
w2 = train_linear_regress( X, y ),    % adaptacyjne trenowanie
w = w1;                               % wybor

    [ X1i, X2i ] = meshgrid( 10:10:120, 1:5 );
    Yi = w(1) + w(2)*X1i + w(3)*X2i;

figure;
surfc( X1i, X2i, Yi, 'FaceAlpha',0.85, 'FaceColor', 'flat' );
hold on;
scatter3( X(:, 2), X(:, 3), y, [], y(:), 'o', 'filled', 'MarkerFaceColor',[0 0 0]);
title('Zbior testowy (punkty) i prognoza ceny (plaszczyzna)');
xlabel('Powierzchnia [m^2]');
ylabel('Liczba pokoi');
zlabel('Koszt [zlote]');
hold off;
