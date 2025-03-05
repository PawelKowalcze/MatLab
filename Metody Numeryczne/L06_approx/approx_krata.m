% approx_krata.m
close all; clear all;

% Generacja/wczyranie obrazka

N = 512; Nstep = 32;
[img, cmap] = imread('Lena512.bmp'); img = double(img); % Lena
%img = zeros(N,N);                                      % czarny kwadrat
if(0) % opcjonalna biala siatka
  for i=Nstep:Nstep:N-Nstep, img(i-1:i+1,1:N) = 255*ones(3,N); end
  for j=Nstep:Nstep:N-Nstep, img(1:N,j-1:j+1) = 255*ones(N,3); end
end  
imshow( img, cmap ); pause

% Dodawanie znieksztalcen beczkowych
a = [ 1.06, -0.0002, 0.000005 ];  % wspolczynniki wielomianu znieksztalcen 
x=1:N; y=1:N; cx = N/2+0.5; cy = N/2+0.5;
[X,Y] = meshgrid( x, y );                 % wszystkie x,y
r = sqrt( (X-cx).^2 + (Y-cy).^2 );        % wszystkie odleglosci od srodka
R = a(1)*r.^1 + a(2)*r.^2 + a(3)*r.^3;    % zmiana odleglosci od srodka
Rn = R ./ r;                              % normowanie 
imgR = interp2( img, (X-cx).*Rn+cx, (Y-cy).*Rn+cy );    % interploacja
    figure;
    subplot(1,2,1),imshow(img,cmap);   title('Oryginal');
    subplot(1,2,2),imshow(imgR, cmap); title('Rybie oko'); pause

% Estymacja znieksztalcen beczkowych    
i = Nstep : Nstep : N-Nstep; j=i;    % polozenie linii w pionie i poziomie
[I,J] = meshgrid( i, j );            % wszystkie (x,y) punktow przeciec 
r = sqrt( (I-cx).^2 + (J-cy).^2 );   % wszystkie promienie od srodka
R = a(1)*r + a(2)*r.^2 + a(3)*r.^3;  % odpowiadajace punkty obrazu znieksztalconego
r = sort( r(:) );                    % sortowanie
R = sort( R(:) );                    % sortowanie
aest1 = pinv([ r.^1, r.^2, r.^3 ])*R; aest1 = [ aest1(end:-1:1); 0]; % rozw.1
aest2 = polyfit( r, R, 3)';                                          % rozw.2
[ aest1, aest2 ], pause              % porownanie
aest = aest1;                        % wybor rozwiazania

% Wielomian R=f(r) i odwrotny r=g(R)
r = 0:N/2;                           % wybrane promienie
R = polyval( aest, r);               % R=f(r) wielomianu znieksztalcen
figure; subplot(121); plot(r,R), title('R=f(r)');
ainv = polyfit( R, r, 3),            % wspolczynniki wielomiany odwrotnego
ainv = polyfit( R, r, 3),            % wspolczynniki wielomiany odwrotnego
subplot(122); plot(R,r), title('r=g(R)'); pause

% Korekta znieksztalcen beczkowych
[X,Y] = meshgrid( x, y );            % wszystkie punkty (x,y) znieksztalconego
R = sqrt( (X-cx).^2 + (Y-cy).^2 );   % wszystkie zle promienie
Rr = polyval( ainv, R );             % wszystkie dobre promienie
Rn = Rr./R;                          % normowanie
imgRR=interp2( imgR, (X-cx).*Rn+cx, (Y-cy).*Rn+cy );   % interpolacja
    figure;
    subplot(1,2,1),imshow(imgR,cmap);  title('Wejscie - efekt rybie oko');
    subplot(1,2,2),imshow(imgRR,cmap); title('Wyjscie - po korekcie');
    colormap gray
    pause

subplot(111); imshow(imgR,cmap);  title('Wejscie - efekt rybie oko');  pause
subplot(111); imshow(imgRR,cmap); title('Wyjscie - po korekcie');  pause

