% Znajdowanie minimum funkcji "bananowej" Rosenbrocka f(x1,x2) różnymi metodami
% f(x1,x2) = 100*(x2 - x1^2)^2 + (1-x1)^2
% Minimum: f(1,1) = 0
clear all; close all;

set(groot,'DefaultFigureColormap',hsv(64))

fun = @(x)( 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2 );  % funkcja
x0 = [ -1.9, 2 ];                                    % punkt startowy

% fminsearch() - SIMPLEX
figure
options = optimset('OutputFcn',@bananaout,'Display','off');
[x,fval,eflag,output] = fminsearch(fun,x0,options);
title('Rosenbrock - via fminsearch() SIMPLEX'); pause
Fcount = output.funcCount;
disp(['Number of function evaluations for fminsearch() SIMPLEX was ',num2str(Fcount)])
disp(['Number of solver iterations for fminsearch() SIMPLEX was ',num2str(output.iterations)])

% fminunc() - QUASI-NEWTON
figure
options = optimoptions('fminunc','Display','off',...
          'OutputFcn',@bananaout,'Algorithm','quasi-newton');
[x,fval,eflag,output] = fminunc( fun, x0, options );
title('Rosenbrock - fminunc() QUASI-NEWTON'); pause
Fcount = output.funcCount;
disp(['Number of function evaluations for fminunc() QUASI-NEWTON was ',num2str(Fcount)])
disp(['Number of solver iterations for fminunc() QUASI-NEWTON was ',num2str(output.iterations)])

% fminunc() - STEEPEST-DESCENT
figure
options = optimoptions(options,'HessUpdate','steepdesc',...
          'MaxFunctionEvaluations',600);
[x,fval,eflag,output] = fminunc(fun,x0,options);
title('Rosenbrock - fminunc() STEEPEST-DESCENT'); pause
Fcount = output.funcCount;
disp(['Number of function evaluations for fminunc() STEEPEST-DESCENT was ',num2str(Fcount)])
disp(['Number of solver iterations for fminunc() STEEPEST-DESCENT UPDATE was ',num2str(output.iterations)])

% fminunc() - ANALYTIC GRADIENT
figure
grad = @(x)[ -400*(x(2) - x(1)^2)*x(1) - 2*(1 - x(1)); ...   % first variable
             200*(x(2) - x(1)^2)];                           % second variable
fungrad = @(x)deal(fun(x),grad(x));
options = resetoptions(options,{'HessUpdate','MaxFunctionEvaluations'});
options = optimoptions(options,'SpecifyObjectiveGradient',true,...
'Algorithm','trust-region');
[x,fval,eflag,output] = fminunc(fungrad,x0,options);
title('Rosenbrock - fminunc() with ANALYTIC GRADIENT'); pause
Fcount = output.funcCount;
disp(['Number of function evaluations for fminunc() ANALYTIC GRADIENT was ',num2str(Fcount)])
disp(['Number of solver iterations for fminunc() ANALYTIC GRADIENT was ',num2str(output.iterations)])

% fminunc() - ANALYTIC GRADIENT & HESSIAN
figure
hess = @(x)[ 1200*x(1)^2 - 400*x(2) + 2, -400*x(1);
             400*x(1),      200 ];
fungradhess = @(x)deal(fun(x),grad(x),hess(x));
options.HessianFcn = 'objective';
[x,fval,eflag,output] = fminunc(fungradhess,x0,options);
title('Rosenbrock - fminunc() ANALYTIC GRADIENT & HESSIAN'); pause
Fcount = output.funcCount;
disp(['Number of function evaluations for fminunc() ANALYTIC GRAD & HESSIAN was ',num2str(Fcount)])
disp(['Number of solver iterations for ANALYTIC HESSIAN was ',num2str(output.iterations)])

% lsqnonlin() - NON-LINEAR LEAST-SQUARES
figure
options = optimoptions('lsqnonlin','Display','off','OutputFcn',@bananaout);
vfun = @(x)[ 10*(x(2) - x(1)^2), 1 - x(1)];
[x,resnorm,residual,eflag,output] = lsqnonlin(vfun,x0,[],[],options);
title('Rosenbrock - lsqnonlin() NONLINEAR LEAST-SQUARES'); pause
Fcount = output.funcCount;
disp(['Number of function evaluations for lsqnonlin() NONLINEAR LEAST-SQUARES was ',num2str(Fcount)])
disp(['Number of solver iterations for lsqnonlin() NONLINEAR LEAST-SQUARES was ',num2str(output.iterations)])

% lsqnonlin() - NON-LINEAR LEAST-SQUARES + JACOBIAN
figure
jac = @(x)[-20*x(1), 10; ...
                 -1, 0  ];
vfunjac = @(x)deal(vfun(x),jac(x));
options.SpecifyObjectiveGradient = true;
[x,resnorm,residual,eflag,output] = lsqnonlin(vfunjac,x0,[],[],options);
title('Rosenbrock - lsqnonlin() NONLIN-LS with JACOBIAN'); pause
Fcount = output.funcCount;
disp(['Number of function evaluations for lsqnonlin() LS-NONLIN JACOBIAN was ',num2str(Fcount)])
disp(['Number of solver iterations for lsqnonlin() LS-NONLIN JACOBIAN was ',num2str(output.iterations)])

set(groot,'DefaultFigureColormap',parula(64))
