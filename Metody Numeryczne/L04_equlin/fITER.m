function x = fITER(A,b)
% Metoda Jacobiego

% Sprawdzenie warunku: |A(i,i)| >= SUM(|A(i,j)|) for j=1:N and j!=i.
[N,N] = size(A);
for i = 1:N
    if abs( 2*A(i,i)) < sum(abs(A(i,:)) )
        disp("MACIERZ A NIE JEST DIAGONALNIE ZDOMINOWANA!");
        x = zeros(N,1);
        return;
    end
end

% Zbuduj macierze: D oraz A z wyzerowna przekatna (L+U)
D = zeros(N,N);
for k=1:N
    D(k,k)=A(k,k);
    A(k,k)=0;
end
U = triu(A); 
L = tril(A); 
LU = L+U;

% Iterowanie
Dinv = inv(D);
x1=rand(N,1)
x2= Dinv * (b - LU*x1); 
while( max(abs(x1-x2)) > 100*eps )  
   x1 = x2;
   x2 = Dinv * (b - LU*x1);
end
x = x2;


