function [x, y] = sum(a,b,c)
    x = a+b;
    y = a+c;
end

we1 = 10;
we2 = 20;
we3 = 30;


[X,Y] = sum(we1,we2,we3);

disp(X);
disp(Y);

