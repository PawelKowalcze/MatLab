% equnonlin_ndim.m
clear all; close all;

it = 12;
f1 = @(x1,x2) x1.^2 + 4*x2.^2 -5;         % definicja funkcji 1
f2 = @(x1,x2) 2*x1.^2 - 2*x1 -3*x2 -2.5;  % definicja funkcji 2
fp11 = @(x1,x2) 2*x1;                     % definicja pochodnej f1 wzgl. x1
fp12 = @(x1,x2) 8*x2;                     % definicja pochodnej f1 wzgl. x2
fp21 = @(x1,x2) 4*x1-2;                   % definicja pochodnej f2 wzgl. x1
fp22 = @(x1,x2) -3;                       % definicja pochodnej f2 wzgl. x2

figure; x1=-10:0.1:10; x2=-10:0.1:10;
subplot(121); mesh( x1, x2, feval(f1,x1',x2) ); title('f1(x1,x2)'); xlabel('x1'); ylabel('x2');
subplot(122); mesh( x1, x2, feval(f2,x1',x2) ); title('f2(x1,x2)'); xlabel('x1'); ylabel('x2'); pause

x1=0.8; x2=0.2;                       % punkt startowy [x1=0.8; x2=0.2]
zk = [x1; x2];                        % pierwsza estymata miejsc zerowych        
Kiter = 25; zhist = zeros(2,Kiter);   % liczba iteracji, historia estymat zer 
for k = 1 : Kiter
    k
    fk = [ feval(f1,zk(1),zk(2));   feval(f2,zk(1),zk(2)) ],
    Jk = [ feval(fp11,zk(1),zk(2)), feval(fp12,zk(1),zk(2)); ...
           feval(fp21,zk(1),zk(2)), feval(fp22,zk(1),zk(2)) ],
    d = -Jk\fk,                    % -Jk\fk ALBO -inv(Jk)*fk
    zk = zk + d,                   % modyfikacja estymaty miejsc zerowych
    zhist(:,k) = zk;               % zapamietaj
  % pause
end
zk,                                % pokaz wynik
zero_f1 = feval(f1,zk(1),zk(2)),   % sprawdz zerowanie sie funkcji 1
zero_f2 = feval(f2,zk(1),zk(2)),   % sprawdz zerowanie sie funkcji 2
figure; plot(1:Kiter,zhist(1,:),'bo-',1:Kiter,zhist(2,:),'r*-' ); grid;
xlabel('numer iteracji'); title('z1(iter), z2(iter)');
