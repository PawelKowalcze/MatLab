%    lab1
close all;
clearvars;
clc;

H = [10;20;30];
V = [3,4,5];

multMat = H * V;
multL = V * H;




%      rysowanie wykresu funkcji

x = -5:0.1:5;   
%y = x.^2 - 4;
%y1 = 2*x.^3 + 3*x.^2 + 7*x + 10;
%plot(x,y),
%hold("on")
%plot(x,y1,'r--'),

%y2 = sin(x);
 %hold("on")
%plot(x,y2),


%     funkcja zewnętrzna

%[y1,y2,y3] = myfunction(x);

%plot(x,y1),
%hold("on")
%plot(x,y2),
%hold("on")
%plot(x,y3),

%wyliczanie wartości funkcji za pomoca pętli



[x_row, x_col] = size(x),
y4 = zeros(x_row,x_col); % tworzę macierz z samych zer o rozmiarze 1x101

for  i=1:size(x,2) %size(zmienna, element rozmiaru)
     y4(i) = x(i)^2 + 4;
end

plot(x,y4),
    
    

