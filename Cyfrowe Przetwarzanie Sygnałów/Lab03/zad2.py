import numpy as np
import matplotlib.pyplot as plt

# Parametry
N = 100
M = 100
fs = 1000
t = np.arange(N) / fs
f1, f2 = 125, 200
A1, A2 = 100, 200
phi1, phi2 = np.pi / 7, np.pi / 11

# Sygnał x(t)
x = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

# DFT sygnału x (X1)
X1 = np.fft.fft(x) / N
fx1 = fs * np.arange(N) / (2 * N)

# Zwiększenie rozdzielczości częstotliwości poprzez dołączenie zer
xz = np.concatenate([x, np.zeros(M)])
X2 = np.fft.fft(xz) / (N + M)
fx2 = fs * np.arange(N + M) / (2 * (N + M))

# Obliczenie DtFT sygnału x (X3)
f = np.arange(0, 1000.25, 0.25)
X3 = np.array([np.sum(x * np.exp(-1j * 2 * np.pi * fi * t)) / N for fi in f])
fx3 = f

# Rysowanie widm
plt.figure()
plt.plot(fx1, np.abs(X1), 'o', label='X1')
plt.plot(fx2, np.abs(X2), 'bx', label='X2')
plt.plot(fx3, np.abs(X3), 'k-', label='X3')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.title('Widma X1, X2, X3')
plt.legend()
plt.grid()
plt.show()

# Obliczenie X3 dla f = -2000:0.25:2000 Hz
f_extended = np.arange(-2000, 2000.25, 0.25)
X1_extended = np.fft.fft(x, len(f_extended)) / N
X2_extended = np.fft.fft(xz, len(f_extended)) / (N + M)
X3_extended = np.array([np.sum(x * np.exp(-1j * 2 * np.pi * fi * t)) / N for fi in f_extended])



# Rysowanie rozszerzonych widm
plt.figure()
plt.plot(f_extended, np.abs(X1_extended), 'o', label='X1')
plt.plot(f_extended, np.abs(X2_extended), 'bx', label='X2')
plt.plot(f_extended, np.abs(X3_extended), 'k-', label='X3')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.title('Rozszerzone widma X1, X2, X3')
plt.legend()
plt.grid()
plt.show()