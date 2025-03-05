% equlin_cramer.m
% A*x = b

A = [  1 2; ...
       3 4  ];
  
b = [    5; ...
        11  ];
  
% x = ?

x = inv(A)*b,   % A^(-1)*b

% Metoda Cramera
for k=1:length(b)
    Ak = A; Ak(:,k) = b;
    x(k) = det( Ak ) / det(A); 
end    
x,
