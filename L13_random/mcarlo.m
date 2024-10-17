NFCN = 0; AMID = x; AMIN = eval(evalstr); 
rand('seed',sum(100*clock));
% Monte Carlo Search over entire variable parameter space
for INUM = 1:MAXFUN	  % Main Loop
  for i = 1:nvars	  % Loop over variables
    IsInBounds = 0;
    while ~IsInBounds	                  % Choose new parameter's value in bounds
      XPLS = 2.0*(rand-0.5);	          % Random value in (-1,1)
      XPLS = XPLS * (MAXFUN-NFCN)/MAXFUN; % Resize random interval
      if ~isinf(VUB(i)) & ~isinf(VLB(i)), range = VUB(i)-VLB(i);
      else range = 1; end 
      x(i) = AMID(i) + XPLS * WERR(i) * range;
      if x(i) <= VUB(i) & x(i) >= VLB(i), IsInBounds = 1; end
    end
  end
  F = eval(evalstr);	NFCN = NFCN + 1;
  if F < AMIN,	AMIN = F;	AMID = x;	end
end 
x = AMID; % Search finished. Set x to best values

