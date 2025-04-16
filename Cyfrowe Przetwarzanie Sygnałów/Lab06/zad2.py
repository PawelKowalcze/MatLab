import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal
import soundfile as sf
from scipy.fft import fft
from collections import defaultdict

# -------------------------------
# Parametry i konfiguracja
# -------------------------------
fs = 8000  # Częstotliwość próbkowania (dla lab06.zip zwykle 8kHz)
frame_len = 0.05  # długość okna analizy w sekundach

# -------------------------------
# 1. Wczytanie sygnału
# -------------------------------
filename = "s0.wav"  # <- zmień na odpowiedni plik!
signal_raw, fs = sf.read(filename)

# -------------------------------
# 2. Spectrogram (ręczne rozkodowanie)
# -------------------------------
plt.figure(figsize=(10, 4))
plt.specgram(signal_raw, NFFT=4096, Fs=fs, noverlap=512)
plt.title("Spectrogram sygnału DTMF")
plt.xlabel("Czas [s]")
plt.ylabel("Częstotliwość [Hz]")
plt.grid()
plt.tight_layout()
plt.show()


# -------------------------------
# 3. Filtracja pasmowo-przepustowa (opcjonalnie – ćwiczenie 1)
# -------------------------------
def bandpass_filter(data, lowcut, highcut, fs, order=4):
    nyq = fs / 2
    sos = signal.butter(order, [lowcut / nyq, highcut / nyq], btype='bandpass', output='sos')
    return signal.sosfilt(sos, data)


filtered_signal = bandpass_filter(signal_raw, 697, 1477, fs)

# Porównanie spektrogramów
plt.figure(figsize=(12, 4))
plt.subplot(1, 2, 1)
plt.specgram(signal_raw, NFFT=1024, Fs=fs, noverlap=256)
plt.title("Przed filtracją")

plt.subplot(1, 2, 2)
plt.specgram(filtered_signal, NFFT=1024, Fs=fs, noverlap=256)
plt.title("Po filtracji")
plt.tight_layout()
plt.show()

# -------------------------------
# 4. Transformata Goertzla
# -------------------------------
dtmf_freqs = {
    (697, 1209): '1', (697, 1336): '2', (697, 1477): '3',
    (770, 1209): '4', (770, 1336): '5', (770, 1477): '6',
    (852, 1209): '7', (852, 1336): '8', (852, 1477): '9',
    (941, 1209): '*', (941, 1336): '0', (941, 1477): '#'
}

row_freqs = [697, 770, 852, 941]
col_freqs = [1209, 1336, 1477]
all_freqs = row_freqs + col_freqs


def goertzel_mag(x, f, fs):
    N = len(x)
    k = int(0.5 + N * f / fs)
    omega = 2 * np.pi * k / N
    coeff = 2 * np.cos(omega)
    s_prev = 0
    s_prev2 = 0
    for n in x:
        s = n + coeff * s_prev - s_prev2
        s_prev2 = s_prev
        s_prev = s
    return s_prev2 ** 2 + s_prev ** 2 - coeff * s_prev * s_prev2


frame_size = int(frame_len * fs)
detected = []

for i in range(0, len(signal_raw), frame_size):
    frame = signal_raw[i:i + frame_size]
    if len(frame) < frame_size: continue
    mags = {f: goertzel_mag(frame, f, fs) for f in all_freqs}

    row = max(row_freqs, key=lambda f: mags[f])
    col = max(col_freqs, key=lambda f: mags[f])

    if mags[row] > 1e4 and mags[col] > 1e4:  # Próg detekcji
        detected.append(dtmf_freqs.get((row, col), '?'))

print("Zdekodowana sekwencja:", ''.join(detected))


# -------------------------------
# 5. Opcjonalne: Bank filtrów IIR (bardziej precyzyjne)
# -------------------------------
def build_dtmf_filterbank(fs, bandwidth=20):
    filters = {}
    for f in all_freqs:
        low = f - bandwidth / 2
        high = f + bandwidth / 2
        sos = signal.butter(4, [low / (fs / 2), high / (fs / 2)], btype='bandpass', output='sos')
        filters[f] = sos
    return filters


filterbank = build_dtmf_filterbank(fs)
detected_iir = []

for i in range(0, len(signal_raw), frame_size):
    frame = signal_raw[i:i + frame_size]
    energies = {}
    for f, sos in filterbank.items():
        filtered = signal.sosfilt(sos, frame)
        energies[f] = np.sum(filtered ** 2)
    row = max(row_freqs, key=lambda f: energies[f])
    col = max(col_freqs, key=lambda f: energies[f])
    if energies[row] > 0.01 and energies[col] > 0.01:
        detected_iir.append(dtmf_freqs.get((row, col), '?'))

print("Sekwencja z banku filtrów IIR:", ''.join(detected_iir))
