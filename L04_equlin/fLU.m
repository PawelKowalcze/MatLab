function [x,L,U] = fLU(A,b)

[N,N] = size(A);
%A,
if(0) % teoretyczna idea --------------------------------------------
   MM=eye(N);
   for k=1:N-1
       Lk=eye(N);
       Mk(k+1:N,k) = -A(k+1:N,k)/A(k,k), pause
       MM=Mk*MM;
   end
   U = MM*A;
   L = inv(MM); % pause
   
else  % alg. Doolittle'a
    
   if(0) % proœciej, wolniej -----------------------------------------
      L = eye(N); U = zeros(N,N);
      for i = 1:N
          for j=i:N
              U(i,j) = A(i,j) - L(i,1:i-1)*U(1:i-1,j);
          end
          for j=i+1:N
              L(j,i) = 1/U(i,i) * ( A(j,i) - L(j,1:i-1)*U(1:i-1,i) );
          end    
      end
   else % trudniej, szybciej ----------------------------------------
      U=A; L=eye(N);
      for i=1:N-1
          for j=i+1:N
              L(j,i)  = U(j,i) / U(i,i);
              U(j,i:N) = U(j,i:N) - L(j,i)*U(i,i:N);
          end
      end
   end    
end

% liczymy x --------------------------------------------------------
% A*x=b,  (L*U)*x = b, L*(U*x) = b, L*y=b --> y=? 
% Pierwsze równanie: L*y=b --> y=?
y(1,1)=b(1);
for i=2:N
    y(i,1) = b(i)- L(i,1:i-1)*y(1:i-1,1);
end
% Drugie równanie: U*x = y --> x=?
x(N,1)=y(N)/U(N,N);
for i=N-1:-1:1
    x(i,1) = (1/U(i,i)) * ( y(i) - U(i,i+1:N)*x(i+1:N,1) );
end
  