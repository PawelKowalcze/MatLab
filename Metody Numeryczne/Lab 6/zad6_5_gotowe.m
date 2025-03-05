close all; clear all;

% Generacja/wczytanie obrazka
N = 512; Nstep = 32;
[img, cmap] = imread('Lena512.bmp'); img = double(img); % Wczytanie obrazu "Lena"

% Opcjonalna biała siatka odniesienia
for i = Nstep:Nstep:N-Nstep, img(i-1:i+1, 1:N) = 255 * ones(3, N); end
for j = Nstep:Nstep:N-Nstep, img(1:N, j-1:j+1) = 255 * ones(N, 3); end

imshow(img, cmap); pause

% Automatyczne znalezienie środka deformacji (punkt symetrii)
[height, width] = size(img);
[rows, cols] = find(img == max(img(:))); % Znalezienie pikseli o największej jasności

% Zakładamy, że środek deformacji jest w przybliżeniu środkiem masy najjaśniejszych pikseli
cx = round(mean(cols));
cy = round(mean(rows));

% Dodawanie zniekształceń beczkowych
a = [1.06, -0.0002, 0.000005];  % Współczynniki wielomianu zniekształceń
x = 1:N; y = 1:N;
[X, Y] = meshgrid(x, y);
r = sqrt((X-cx).^2 + (Y-cy).^2);          % Odległość od automatycznie znalezionego środka
R = a(1) * r.^1 + a(2) * r.^2 + a(3) * r.^3; % Modyfikacja promieni
Rn = R ./ r;
imgR = interp2(img, (X - cx) .* Rn + cx, (Y - cy) .* Rn + cy);

figure;
subplot(1,2,1), imshow(img, cmap); title('Oryginal');
subplot(1,2,2), imshow(imgR, cmap); title('Rybie oko'); pause

% Estymacja zniekształceń beczkowych
i = Nstep : Nstep : N-Nstep;
j = i;
[I, J] = meshgrid(i, j);              % Wszystkie (x,y) punktów przecięć
r = sqrt((I - cx).^2 + (J - cy).^2);  % Promienie od środka
R = a(1) * r + a(2) * r.^2 + a(3) * r.^3;

% Sortowanie i dopasowanie modelu zniekształceń
r = sort(r(:));
R = sort(R(:));
aest1 = pinv([r.^1, r.^2, r.^3]) * R; % Rozwiązanie 1
aest2 = polyfit(r, R, 3)';            % Rozwiązanie 2
%[ aest1, aest2 ], pause               % Porównanie wyników
aest = aest1;                         % Wybór rozwiązania

% Wyznaczenie wielomianu R=f(r) i odwrotnego r=g(R)
r = 0:N/2;
R = polyval(aest, r);                 % R=f(r)
figure; subplot(121); plot(r, R), title('R=f(r)');
ainv = polyfit(R, r, 3);              % Wyznaczenie odwrotności
subplot(122); plot(R, r), title('r=g(R)'); pause

% Korekta zniekształceń beczkowych
[X, Y] = meshgrid(x, y);              % Wszystkie punkty (x,y) zdeformowanego obrazu
R = sqrt((X - cx).^2 + (Y - cy).^2);  % Wyznaczenie promieni dla zdeformowanego obrazu
Rr = polyval(ainv, R);                % Korekcja promieni
Rn = Rr ./ R;
imgRR = interp2(imgR, (X - cx) .* Rn + cx, (Y - cy) .* Rn + cy);

% Wyświetlenie obrazów przed i po korekcie
figure;
subplot(1,2,1), imshow(imgR, cmap); title('Wejście - efekt rybie oko');
subplot(1,2,2), imshow(imgRR, cmap); title('Wyjście - po korekcie');
colormap gray
pause

% Ostateczne porównanie
subplot(111); imshow(imgR, cmap); title('Wejście - efekt rybie oko'); pause
subplot(111); imshow(imgRR, cmap); title('Wyjście - po korekcie'); pause
