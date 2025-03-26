import numpy as np
import matplotlib.pyplot as plt
from scipy.signal.windows import chebwin

# Parametry
N = 100
fs = 1000
t = np.arange(N) / fs
f1, f2 = 100, 125
A1, A2 = 1, 0.0001
f = np.arange(0, 500.1, 0.1)

# Sygnał x(t)
x = A1 * np.cos(2 * np.pi * f1 * t) + A2 * np.cos(2 * np.pi * f2 * t)

# Obliczenie DtFT sygnału x
X3 = np.array([np.sum(x * np.exp(-1j * 2 * np.pi * fi * t)) / N for fi in f])

# Wyświetlenie widma
plt.figure()
plt.plot(f, np.abs(X3), 'k-', label='Bez okna')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widmo sygnału x(t)')
plt.legend()
plt.grid()
plt.show()

# Okna
windows = {
    'Prostokątne': np.ones(N),
    'Hamminga': np.hamming(N),
    'Blackmana': np.blackman(N),
    'Czebyszewa 100 dB': chebwin(N, at=100),
    'Czebyszewa 120 dB': chebwin(N, at=120)
}

# Obliczenie DtFT dla różnych okien
plt.figure()
for name, window in windows.items():
    x_windowed = x * window
    X3_windowed = np.array([np.sum(x_windowed * np.exp(-1j * 2 * np.pi * fi * t)) / N for fi in f])
    plt.plot(f, np.abs(X3_windowed), label=name)

plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widma sygnału x(t) z różnymi oknami')
plt.legend()
plt.grid()
plt.show()

# Powtórzenie zadania dla N=1000 i różnych wartości tłumienia okna Czebyszewa
N = 1000
t = np.arange(N) / fs
x = A1 * np.cos(2 * np.pi * f1 * t) + A2 * np.cos(2 * np.pi * f2 * t)
windows_cheb = {
    'Czebyszewa 60 dB': chebwin(N, at=60),
    'Czebyszewa 80 dB': chebwin(N, at=80),
    'Czebyszewa 100 dB': chebwin(N, at=100),
    'Czebyszewa 120 dB': chebwin(N, at=120)
}

plt.figure()
for name, window in windows_cheb.items():
    x_windowed = x * window
    X3_windowed = np.array([np.sum(x_windowed * np.exp(-1j * 2 * np.pi * fi * t)) / N for fi in f])
    plt.plot(f, np.abs(X3_windowed), label=name)

plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widma sygnału x(t) z oknami Czebyszewa (N=1000)')
plt.legend()
plt.grid()
plt.show()