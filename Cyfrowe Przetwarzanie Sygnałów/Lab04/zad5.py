import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import get_window

# Parametry
fpr = 8000  # częstotliwość próbkowania (Hz)
T = 3  # czas trwania sygnału w sekundach
N = round(T * fpr)  # liczba próbek
dt = 1 / fpr
t = dt * np.arange(N)  # oś czasu
n = np.arange(1000)  # indeksy próbek sygnału dla rysunków

# Sygnał
x1 = np.sin(2 * np.pi * 200 * t) + np.sin(2 * np.pi * 800 * t)  # 2xSIN
x2 = np.sin(2 * np.pi * (0 * t + 0.5 * ((1 / T) * fpr / 4) * t**2))  # LFM
fm = 0.5
x3 = np.sin(2 * np.pi * ((fpr / 4) * t - (fpr / 8) / (2 * np.pi * fm) * np.cos(2 * np.pi * fm * t)))  # SFM
x = x3  # wybór

# Rysunek sygnału
plt.figure()
plt.plot(t[n], x[n], 'b-')
plt.xlabel('t [s]')
plt.title('x(t)')
plt.grid()
plt.show()

# Widmo FFT
Mwind = 512
Mstep = 16
Mfft = 2 * Mwind
Many = (N - Mwind) // Mstep + 1
t = (Mwind / 2 + 1 / 2) * dt + Mstep * dt * np.arange(Many)  # czas
f = fpr / Mfft * np.arange(Mfft)  # częstotliwość
w = np.hamming(Mwind)  # wybór okna
X1 = np.zeros((Mfft, Many))  # inicjalizacja STFT
X2 = np.zeros(Mfft)  # inicjalizacja PSD

# Pętla analizy
for m in range(Many):
    bx = x[m * Mstep : Mwind + m * Mstep]  # kolejny fragment sygnału
    bx = bx * w  # okienkowanie
    X = np.fft.fft(bx, Mfft) / sum(w)  # FFT ze skalowaniem
    X1[:, m] = X  # STFT
    X2 += np.abs(X)**2  # Welch PSD

X1 = 20 * np.log10(np.abs(X1))  # przeliczenie na decybele
X2 = (1 / Many) * X2 / fpr  # normalizacja PSD

# STFT
plt.figure()
plt.imshow(X1, aspect='auto', extent=[t[0], t[-1], f[0], f[-1]], origin='lower')
c = plt.colorbar()
c.set_label('V (dB)')
plt.xlabel('t (s)')
plt.ylabel('f (Hz)')
plt.title('STFT |X(t,f)|')
plt.show()

# PSD Welcha
plt.figure()
plt.semilogy(f, X2)
plt.grid()
plt.title('PSD Welcha')
plt.xlabel('f [Hz]')
plt.ylabel('V^2 / Hz')
plt.show()


def myspectrogram(x, fs=1.0, window='hann', nperseg=256, noverlap=None, nfft=None, mode='psd'):
    if noverlap is None:
        noverlap = nperseg // 2
    if nfft is None:
        nfft = nperseg

    step = nperseg - noverlap
    shape = (nfft, (len(x) - noverlap) // step)
    result = np.zeros(shape, dtype=np.complex64)

    window = get_window(window, nperseg)
    for i in range(shape[1]):
        segment = x[i * step : i * step + nperseg]
        segment = segment * window
        result[:, i] = np.fft.fft(segment, nfft)

    if mode == 'psd':
        result = np.abs(result)**2
    elif mode == 'magnitude':
        result = np.abs(result)
    elif mode == 'angle':
        result = np.angle(result)
    elif mode == 'complex':
        pass
    else:
        raise ValueError("Invalid mode")

    t = np.arange(nperseg / 2, len(x) - nperseg / 2 + 1, step) / fs
    f = np.fft.fftfreq(nfft, 1 / fs)
    f = f[:nfft // 2 + 1]

    return f, t, result[:nfft // 2 + 1]

# Przykład użycia
f, t, Sxx = myspectrogram(x, fs=fpr, window='hamming', nperseg=Mwind, noverlap=Mwind-Mstep, nfft=Mfft, mode='magnitude')

# plt.figure()
# plt.pcolormesh(t, f, 20 * np.log10(Sxx), shading='gouraud')
# plt.colorbar(label='V (dB)')
# plt.xlabel('t (s)')
# plt.ylabel('f (Hz)')
# plt.title('STFT |X(t,f)|')
# plt.show()