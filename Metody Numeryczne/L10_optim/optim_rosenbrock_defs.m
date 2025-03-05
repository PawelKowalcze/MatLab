% optim_rosenrock_def.m
% funkcja "bananowa" Rosenbrocka i jej pochodne

fun = @(x)(100*(x(2) - x(1)^2)^2 + (1 - x(1))^2);     % funkcja bananowa
x0 = [-1.9,2];                                        % argumenty je minimum

grad = @(x)[-400*(x(2) - x(1)^2)*x(1) - 2*(1 - x(1)); % # jej gradient
             200*(x(2) - x(1)^2)];                    % #
fungrad = @(x)deal(fun(x),grad(x));                   % fun + grad 

hess = @(x)[1200*x(1)^2 - 400*x(2) + 2, -400*x(1);    % # jej hesjan
                             -400*x(1),      200];    % #
fungradhess = @(x)deal(fun(x),grad(x),hess(x));       % fun + grad + hes                         

vfun = @(x)[10*(x(2)-x(1)^2), 1-x(1)]; % f1(x1,x2) = 10*(x2 - x1^2), f2(x1,x2)=1-x1
jac = @(x)[-20*x(1),10;                % banan = f(x1,x2) = f1^2 + f2^2; 
                -1,  0];               % jacobian [f1; f2]
vfunjac = @(x)deal(vfun(x),jac(x));

% Przykład szukania minimum z użyciem tylko rownania funkcji i metody SIMPLEX
options = optimset('OutputFcn',@bananaout,'Display','off');
[x,fval,eflag,output] = fminsearch(fun,x0,options);
title('Rosenbrock solution via fminsearch() Simplex');
