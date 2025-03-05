%Wartości startowe
clear all; close all;


A=10;
B=250;
C=-115;

%Obliczanie X1 i X2 z standardowego wzoru
x1=(-B-sqrt((B^2)-(4*A*C)))/(2*A);
x2=(-B+sqrt((B^2)-(4*A*C)))/(2*A);


%Wyświetlamy obliczone
disp("x1 = "+x1);
disp("x2 = "+x2);

%Sprawdzamy która zmienna x ma być zmieniona
if(abs(x1)>=abs(x2))
   x2_new=C/(A*x1);
   disp("Lepsze x2 = "+x2_new);
   diff = x2-x2_new; 
   disp("Różnica = "+diff);
else
   x1_new=C/(A*x2);
   disp("Lepsze x1 = "+x1_new);
   diff = x1-x1_new;
   disp("Różnica = "+diff);
end
