% Aproksymacja funkcji log2()
format long

x = 71,            % wartosc wejsciowa: 70 = 64 + 7 = 2^6 + 7 = 2^6 * (1 + 7/2^6)
                   % log2(70) = log2(2^6) + log2(1+7/2^6) = 6 + log2(1+7/2^6)
% OGOLNY TEST
disp('log10() ###################')
y = log10(x),            % besposrednio
y = log(x)/log(10),      % z uzyciem logarytmu naturalnego: ln()     
y = log2(x)/log2(10),    % z uzyciem logarytmy przy podstawie 2: log2()
pause
disp('log2() ####################')
% log2
y = log2(x),             % bezposrednio
y = log(x)/log(2),       % z uzyciem logarytmu naturalnego: ln()
pause

% Czesc calkowita wyniku log2(x)
xc = x; power = 0;
while( xc > 1 )
    xc = xc/2;
    power = power+1;
end
power = power-1, pause   % znaleziona potega liczby 2   np. 6

% Czesc ulamkowa wyniku log2(x)
x = x - 2^power, pause   % pozostalosc                  np. 71 - 2^6  = 7
x = x / 2^power;         % pozostalosc ulamkowo         np. 7/2^6 
y = x/(2+x);             % uzyte podstawienie 
lnxplus1 = 2*y.*(15-4*y.^2) ./ (15-9*y.^2);  % ln(1+x)
y = lnxplus1 / 0.693147181;                  % ln() --> log2(): dzielenie przez ln(2)
y = power + y,                               % koncowy wynik 
