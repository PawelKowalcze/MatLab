% evd_qr.
clear all; close all;

if(1)  A = [ 4 0.5; 0.5 1 ];   % analizowana macierz
else   A = magic(4);
end
[N,N]=size(A);                 % jej wymiary
x = ones(N,1);                 % inicjalizacja

[Q,R] = qr(A);                 % pierwsza dekompozycja QR
for i=1:30                     % petla - start
    [Q,R] = qr(R*Q);           % kolejne iteracje
end                            % petla -stop
A1 = R*Q,                      % ostatni wynik
lambda = diag(A1),             % elementy na przekatnej
ref = eig(A),                  % porownanie z Matlabem
pause
