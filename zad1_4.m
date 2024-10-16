h = [1,2,3,4],
v = [4;5;6;8],  
a=h*v,  
A=v*h,  
a=A*v,
b=h*A,  
B=A*A,

% h*h, wymiary nie są zgodne
% v*v, wymiary nie są zgodne
%v*A,
%A*h, żadne wymiary się nie zgadzają - matlab sie denerwuje

length(h),
length(v),
