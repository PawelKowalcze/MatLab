function x = fGaussJordan(A,b)

[N,N]=size(A);
A = [ A, b ];    % dolaczamy b jako ostatnia, (N+1)-sza kolumne A 
for k=1:N
  % k
    A(k,:) = A(k,:)/A(k,k);
    for w = 1:N
      % w
        if (w~=k)
           A(w,:) = A(w,:) - A(w,k)* A(k,:);
         % A, pause
        end    
    end
end
x = A(:,N+1);    % odczytujemy wynik