clear; clc; close all;

% Wczytaj fragment sygnału
[x, fs] = audioread('DontWorryBeHappy.wav');
x = x(:,1);                % tylko 1 kanał
x = x(fs*1 : fs*3);        % fragment: 1s do 3s

warianty = {
    struct('ch', 8, 'q', 6, 'opis', '8 podpasma, 6 bitów'),
    struct('ch', 32, 'q', 6, 'opis', '32 podpasma, 6 bitów'),
    struct('ch', 32, 'q', [8 8 7 7 6 6 4], 'opis', '32 podpasma, zmienna liczba bitów')
};

for i = 1:length(warianty)
    fprintf('\n--- Wariant: %s ---\n', warianty{i}.opis);
    ch = warianty{i}.ch;
    q = warianty{i}.q;

    % Uruchom kodowanie
    [y, bps] = kodowanie_podpasmowe(x, ch, q);

    % Współczynnik kompresji
    fprintf('Kompresja: %.2f bity/probke\n', bps);

    % Porównanie spektrogramów
    figure('Name', warianty{i}.opis);
    subplot(2,1,1);
    spectrogram(x, 256, 200, 512, fs, 'yaxis');
    title('Oryginalny sygnał');

    subplot(2,1,2);
    spectrogram(y, 256, 200, 512, fs, 'yaxis');
    title('Sygnał po kompresji/dekompresji');

    % Porównanie przebiegów
    figure('Name', ['PCM - ' warianty{i}.opis]);
    plot(x(1:1000)); hold on;
    plot(y(1:1000));
    legend('oryginalny','po rekonstrukcji');
    title(['Porównanie PCM: ' warianty{i}.opis]);
end
