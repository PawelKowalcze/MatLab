% ai_0_demo.m
  clear all; close all;
  rng(1);                 % inicjalizacja generatora liczb losowych
% Generacja cech (normalnie obliczanie/ekstrakcja cech na podstawie danych) 
  N = 2000;               % liczba przykladow/wzorcow: 200, 2000, 20000
  C = 2*(rand(N,2)-0.5);  % N wierszy, 2 cechy/przyklad (2 kolumny) - liczby [-1...1]
  figure; plot(C(:,1),C(:,2),'.'); xlabel('C1'); ylabel('C2'); title('Rozklad cech'); 
% Definicja klas danych
  klasa = zeros(N,1);                            % 0 = norma
  x = C(:,1); y = C(:,2);                        % 1 = patologia
  if(0)
     klasa( y > myfun(x) ) = 1;                  % nasza funkcja
     xg = -1 : 0.01 : 1;  yg = myfun( xg );      % graniczna krzywa (xg,yg)
  else
     R = 0.5; x0 = 0; y0 = 0;                         % kolo o prom. R o srodku (x0,y0)
     klasa( sqrt( (x-x0).^2 + (y-y0).^2 ) < R ) = 1;  % wnetrze kola to klasa 1
     fi = 0:pi/100:2*pi; xg = x0+R*sin(fi); yg = y0+R*cos(fi);
  end
% Uczenie 
  nr = 1:2:N; svmStruct = fitcsvm( C(nr,:), klasa(nr), 'KernelFunction','RBF');
% Testowanie
  nr = 2:2:N; decyzja = predict( svmStruct, C(nr,:) );
% Bledy
  ind = find( decyzja~=klasa(nr) );              % indeksy blednych decyzji
  bledy = length( ind ),                         % liczba  blednych decyzji
  procent = bledy / length( nr ) * 100,          % procent blednych decyzji             
% Rysunek  
  figure;
  ind1 = find( decyzja==1 ); ind0 = find( decyzja==0 );
  plot(C(nr(ind1),1),C(nr(ind1),2),'r*',C(nr(ind0),1),C(nr(ind0),2),'g*');
  grid; axis([-1,1,-1,1]); axis square; hold on;
  xlabel('C1'); ylabel('C2'); title('Wynik rozpoznawania (*)');
  pause
  plot(xg,yg,'k-', C(nr(ind),1), C(nr(ind),2), 'bo','LineWidth',1);
  title('Wynik rozpoznawania (*) i bledne decyzje (o)');

% #######################
  function [y] = myfun(x)
     y = x.^2 + 0.5*x - 0.5;         % parabola
   % P=0.75; y = cos(P*2*pi*x);  % cosinus: P=0.25, 0.5, 0.75, 1, 1.5, 2  
  end
