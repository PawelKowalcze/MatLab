clear all; close all;

[audioData, fs] = audioread('DontWorryBeHappy.wav');

% zamiana sygnału stereo na mono, jeśli to konieczne
if size(audioData, 2) == 2
    audioData = mean(audioData, 2);
end

% sprawdzenie długości pliku audio
audioLength = length(audioData);

% parametry
N1 = 32;
N2 = 128;

% sprawdzenie czy długość sygnału jest wielokrotnością N
if mod(audioLength, N1) ~= 0
    audioData = [audioData; zeros(N1 - mod(audioLength, N1), 1)];
end

if mod(audioLength, N2) ~= 0
    audioData = [audioData; zeros(N2 - mod(audioLength, N2), 1)];
end

% kodowanie i dekodowanie dla N=32
encoded32 = encodeMDCT(audioData, N1);
decoded32 = decodeMDCT(encoded32, N1);

% kodowanie i dekodowanie dla N=128
encoded128 = encodeMDCT(audioData, N2);
decoded128 = decodeMDCT(encoded128, N2);

% zapis dekodowanych plików do porównania
audiowrite('decoded32.wav', decoded32, fs);
audiowrite('decoded128.wav', decoded128, fs);

% porównanie oryginalnego i dekodowanego sygnału dla N=32
error32 = sum((audioData - decoded32(1:length(audioData))).^2);

% porównanie oryginalnego i dekodowanego sygnału dla N=128
error128 = sum((audioData - decoded128(1:length(audioData))).^2);

fprintf('Błąd dla N=32: %f\n', error32);
fprintf('Błąd dla N=128: %f\n', error128);

% ustalanie odpowiedniego Q
Q = 0.01; 

% kwantyzacja i dekwantyzacja dla N=32
quantized32 = quantizeMDCT(encoded32, Q);
dequantized32 = dequantizeMDCT(quantized32, Q);

decoded32_quantized = decodeMDCT(dequantized32, N1);

% sprawdzenie błędu po kwantyzacji dla N=32
error32_quantized = sum((audioData - decoded32_quantized(1:length(audioData))).^2);
fprintf('Błąd po kwantyzacji dla N=32 i Q=%f : %f\n', Q, error32_quantized);

% oszacowanie odpowiedniego Q dla przepływności 64 kbps
bitrate = 64 * 1000;        % 64 kbps
frame_size = N1 / 2;        % zakładając, że frame_size to połowa N
samples_per_frame = frame_size;
total_bits = bitrate * (length(audioData) / fs); % całkowita liczba bitów

% oszacowanie Q
estimated_bits_per_sample = total_bits / (length(audioData) / samples_per_frame);
Q_estimated = max(abs(encoded32)) / (2^(estimated_bits_per_sample - 1));

% kwantyzacja i dekwantyzacja dla oszacowanego Q
quantized32_estimated = quantizeMDCT(encoded32, Q_estimated);
dequantized32_estimated = dequantizeMDCT(quantized32_estimated, Q_estimated);

decoded32_quantized_estimated = decodeMDCT(dequantized32_estimated, N1);

% sprawdzenie błędu po kwantyzacji dla oszacowanego Q
error32_quantized_estimated = sum((audioData - decoded32_quantized_estimated(1:length(audioData))).^2);
fprintf('Błąd po kwantyzacji dla N=32 i Q_estimated=%f : %f\n', Q_estimated, error32_quantized_estimated);

% funkcja do tworzenia okna analizy i syntezy

function h = createWindow(N)
    n = 0:(N-1);
    h = sin(pi * (n + 0.5) / N);
end

% funkcja do tworzenia macierzy analizy dla MDCT
function A = createAnalysisMatrix(N)
    K = N / 2;
    A = zeros(K, N);
    for k = 0:(K-1)
        for n = 0:(N-1)
            A(k+1, n+1) = sqrt(4/N) * cos(pi * (2*n + 1 + N/2) * (2*k + 1) / (2*N));
        end
    end
end

% funkcja do tworzenia macierzy syntezy dla MDCT
function S = createSynthesisMatrix(A)
    S = A';
end

% funkcja do kodowania za pomocą MDCT
function encoded = encodeMDCT(data, N)
    h = createWindow(N);
    A = createAnalysisMatrix(N);
    numFrames = length(data) / N;
    
    encoded = [];
    
    for i = 0:(numFrames-1)
        frame = data((i*N+1):(i+1)*N);
        windowedFrame = frame .* h';
        MDCT = A * windowedFrame;
        encoded = [encoded; MDCT];
    end
end

% funkcja do dekodowania za pomocą MDCT
function decoded = decodeMDCT(encoded, N)
    h = createWindow(N);
    A = createAnalysisMatrix(N);
    S = createSynthesisMatrix(A);
    K = N / 2;
    
    numFrames = length(encoded) / K;
    decoded = zeros(numFrames * N, 1);
    
    for i = 0:(numFrames-1)
        MDCT = encoded((i*K+1):(i+1)*K);
        windowedFrame = S * MDCT;
        frame = windowedFrame .* h';
        decoded((i*N/2+1):(i*N/2+N)) = decoded((i*N/2+1):(i*N/2+N)) + frame;
    end
end

% funkcja do kwantyzacji
function quantized = quantizeMDCT(encoded, Q)
    quantized = round(encoded / Q);
end

% funkcja do dekwantyzacji
function dequantized = dequantizeMDCT(quantized, Q)
    dequantized = quantized * Q;
end
