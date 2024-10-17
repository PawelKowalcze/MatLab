% Rozwiązanie równania:
% a*x^2 + b*x + c = 0

format long;

a=1.2, c = 3.4, b = -1e+6*(4*a*c), pause

x1 = (-b+sqrt(b^2-4*a*c))/(2*a),
x2 = (-b-sqrt(b^2-4*a*c))/(2*a), pause

if( abs(x1) > abs(x2) )
    x2new = 2*c /(-b+sqrt(b^2-4*a*c)),
end    
if( abs(x1) < abs(x2) )
    x1new = 2*c /(-b-sqrt(b^2-4*a*c)),
end    