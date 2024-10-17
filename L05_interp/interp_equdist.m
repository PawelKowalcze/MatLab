% interp_equdist.m
clear all; close all;

T = [ 25 55 75 81 84 86 87 87 88 88 88 ]; % temperatura odczytywana co 1 minute
N = length(T);                            % liczba punktow
t = 0 : 1 : N-1;                          % chwile pomiarow, kolejne minuty
d(:,1)=T(1:N);                            % pierwsza kolumna macierzy roznic w przod
for k=1:N-1                               % nastepne kolumny (w petli jest +1)  
  for w=k:N-1                             % kolejne wiersze na i ponizej diagonali
     d(w+1,k+1)=( d(w+1,k)- d(w,k) );  % roznica w przod w nastepnej kolumnie
  end                                     %
end                                       %
for i = 1 : 100                           % liczy wartosci ze wzoru na T(i)
    ti(i) = 0.1 * (i-1);                  % interpolowane minuty                
    coef = 1; for k = 0:N-2, coef = [ coef, (ti(i)-k)/(k+1) ]; end
    Ti(i) = cumprod( coef ) * diag(d);    % sum( (i;j) * delta^j(T) ) 
end    
figure; plot(t,T,'ro',ti,Ti,'b-'); xlabel('t [min]'); title('T(t) [^{o} C]'); grid; 