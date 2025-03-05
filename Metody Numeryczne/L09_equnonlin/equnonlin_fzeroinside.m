function [b,fval,exitflag,output] = fzero(FunFcnIn,x,varargin)
%FZERO  Scalar nonlinear zero finding.
%   Copyright 1984-2002 The MathWorks, Inc.
...
fc = fb;
% Main loop, exit from middle of the loop
while fb ~= 0
   % Insure that b is the best result so far, a is the previous
   % value of b, and c is on the opposite of the zero from b.
...
% Convergence test and possible exit
   m = 0.5*(c - b);
   toler = 2.0*tol*max(abs(b),1.0);
   if (abs(m) <= toler) | (fb == 0.0), 
      break, 
   end
% Choose bisection or interpolation
   if (abs(e) < toler) | (abs(fa) <= abs(fb))
      % Bisection
      d = m;  e = m;
      step='       bisection';
   else
      % Interpolation
      s = fb/fa;
      if (a == c)
         % Linear interpolation
         p = 2.0*m*s;
         q = 1.0 - s;
      else
         % Inverse quadratic interpolation
         q = fa/fc;
         r = fb/fc;
         p = s*(2.0*m*q*(q - r) - (b - a)*(r - 1.0));
         q = (q - 1.0)*(r - 1.0)*(s - 1.0);
      end;
      if p > 0, q = -q; else p = -p; end;
      % Is interpolated point acceptable
      if (2.0*p < 3.0*m*q - abs(toler*q)) & (p < abs(0.5*e*q))
         e = d;  d = p/q;
         step='       interpolation';
      else
         d = m;  e = m;
         step='       bisection';
      end;
   end % Interpolation
% Next point
...
end % Main loop