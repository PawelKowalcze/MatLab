function [x,fx]=quadsearch(f,x1,x2,x3,tol,maxiter,ifigs,x)

iter = maxiter;
while( iter > 0 )
  % iter
  fx1 = feval(f,x1);
  fx2 = feval(f,x2);
  fx3 = feval(f,x3);
  x4 = x2 - ((x2-x1)^2*(fx2-fx3)-(x2-x3)^2*(fx2-fx1)) / ...
            ((x2-x1)  *(fx2-fx3)-(x2-x3)  *(fx2-fx1));
  fx4 = feval(f,x4);
  
  if(ifigs==1) plot(x,feval(f,x),'b-',x1,fx1,'b*',x2,fx2,'ro',x3,fx3,'ks',x4,fx4,'gp'); grid; pause(0.25)
  end
  
  if( (x4>x2) & (x4<x3) )
      x1 = x2; x2 = x4;
  elseif ( (x4>x1) & (x4<x2) )
      x3 = x2; x2 = x4;;
  elseif ( x4<x1 )
      x3=x2; x2=x1; x1=x4;
  elseif ( (x4>x3) )
      x1=x2; x2=x3; x3=x4;
  else    
  end
  if     ( abs(x1-x2) < tol ) x2 = (x1+x3)/2;
  elseif ( abs(x2-x3) < tol ) x2 = (x2+x3)/2;
  end
  
  iter = iter-1;
end      
x=x4; fx=feval(f,x4);

