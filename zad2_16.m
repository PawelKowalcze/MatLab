clear all; close all;

% Pierwsza część zadania 2.16:
% Sprawdzenie równania 2.26

a= 0.5; b= 1; c = 0.5;
cond = b/(sqrt(b^2-(4*a*c))),


% Druga część zadania
%format long;
a = 0.5; b = 1 + 0.001*randn(1,1000); c = 0.50;
sumx=[];
sumcondx=[];
for i = 1:size(b, 2)
   x1 = (-b(i)-sqrt(b(i)^2-(4*a*c)))/(2*a);
   condx1 = b(i)/(sqrt(b(i)^2-(4*a*c)));
   sumx(end+1) = x1; % end to jest KEYWORD, czyli słowo zarezerwowane
   sumcondx(end+1) = condx1;
end
% Wyswietlanie sredniej i odchylenia standardowego rozwiazan rownania
disp("srednia rozwiazan: " + mean(sumx)),
disp("odchylenie rozwiazan: " + std(sumx)),
% Wyswietlanie sredniej i odchylenia standardowego uwarunkowan
disp("srednia uwarunkowan: " + mean(sumcondx)),
disp("odchylenie uwarunkowan: " + std(sumcondx)),
