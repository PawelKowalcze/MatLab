% bity_interpretacja.m
clear all; close all;

N=5; K=2; L=2;        % liczba bitow: wszystkich (z bitem znaku), eksponenty, mantysy
denorm = 0;           % 0/1 NIE/TAK denormalizacja mantysy

bias = 2^(K-1)-1;     % przesuniecie w eksponencie
ex = 0 : 2^K-1;       % wszystkie liczby calkowite w eksponencie bez przesuniecia
prec = 2.^(-L);       % precyzja mantysy
mn = 0 : 2^L-1;       % wszystkie liczby calkowite w mantysie bez domyslnego 1

P = length(ex);       % liczba wartosci eksponenty
Q = length(mn);       % liczba wartosci mantysy    
for n = 1 : Q
    for m = 1 : P
        if( denorm==0 | (denorm==1 & ex(n)~=0) )
           x( (n-1)*P + m ) = ( 1 + mn(m)*prec) * 2^(ex(n)-bias);  % domyslne 1
        else
           x( (n-1)*P + m ) =  mn(m)*prec;
        end   
    end
end
x = [ -x, x ];        % dodajemy liczby ujemne
plot( x, zeros(1, length(x)), 'bo'); grid; xlabel('wartosci x'); 
