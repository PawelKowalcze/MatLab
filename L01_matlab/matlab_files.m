% Program matlab_files.m
clear all; close all;

x = 0 : pi/100 : 2*pi;    % argument funkcji: wiele wartosci od-krok-do
y = sin( x );             % funkcja: wiele wartosci
figure; plot(x,y,'bo-'); xlabel('x'); ylabel('y'); title('F1: y=f(x)'); grid;

save( 'myFile.mat' );      % zapisz wartosci wszystkich zmiennych do zbioru myFile.mat
clear all; whos; pause     % wyzeruj pamiec, sprawdz, ze nic nie ma
load( 'myFile.mat' );      % wczytaj wartosci wszystkich zmiennych ze zbiou
figure; plot(x,y,'bo-'); xlabel('x'); ylabel('y'); title('F2: y=f(x)'); grid;

xy = [ x' y'];                                % zbuduj macierz dwukolumnowa xy
save('myFile.dat','xy','-ascii','-double');   % zapisz xy do zbioru myFile.dat
clear all; whos; pause                        % wyzeruj, sprawdz
load( 'myFile.dat' );                         % wczytaj
x=myFile(:,1); y=myFile(:,2);                 % odtworz wektory x, y z macierzy myFile
figure; plot(x,y,'bo-'); xlabel('x'); ylabel('y'); title('F3: y=f(x)'); grid;
