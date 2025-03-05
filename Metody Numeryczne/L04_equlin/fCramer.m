function x = fCramer(A,b)
% Funkcja metody Cramera. M=N.

[M,N] = size(A); x = zeros(M,1);
for k=1:N
    Ak = A; Ak(:,k) = b;
    x(k) = det( Ak ) / det(A); 
end
