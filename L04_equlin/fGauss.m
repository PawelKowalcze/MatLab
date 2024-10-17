function x = fGauss(A,b)
% Metoda Gaussa

[N,N]=size(A);
A = [ A, b ];   % do³aczamy b jako ostatnia, (N+1)-ta kolumna A
for k=1:N
  % k
  % A(k,:) = A(k,:)/A(k,k); % pause               % OPT #1
    for w = k+1:N
      % w
      % A(w,:) = A(w,:) - A(w,k)* A(k,:);         % OPT #1
        A(w,:) = A(w,:) - A(w,k)* A(k,:)/A(k,k);  % OPT #2
      % A, pause
    end
end
U = A(:,1:N);    % macierz trojkatna gorna
b = A(:,N+1);    % nowe b

% Rozwiazujemy wstecznie od ostatniego elementu x
x(N,1) = b(N)/U(N,N);
for i=N-1:-1:1
    x(i,1) = (1/U(i,i)) * ( b(i) - U(i,i+1:N)*x(i+1:N,1) );
end
