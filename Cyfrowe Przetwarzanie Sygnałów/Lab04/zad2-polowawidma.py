import numpy as np
import matplotlib.pyplot as plt

def plot_fft(f0, N):
    # Parametry
    fpr = 1000  # częstotliwość próbkowania (Hz)
    dt = 1 / fpr
    t = dt * np.arange(N)  # chwile próbkowania sygnału, oś czasu

    # Sygnał
    x = 10 * np.sin(2 * np.pi * f0 * t)  # sygnał o częstotliwości f0

    # FFT spektrum
    X = np.fft.fft(x)  # FFT
    f = fpr / N * np.arange(N // 2 + 1)  # oś częstotliwości

    # Wykres FFT
    plt.figure()
    plt.plot(f, 2 / N * np.abs(X[:N // 2 + 1]), 'bo-')
    plt.xlabel('f [Hz]')
    plt.ylabel('Amplituda')
    plt.title(f'|X(k)| dla f0 = {f0} Hz i N = {N}')
    plt.grid()
    plt.show()

    # Wykres FFT w decybelach
    X_db = 20 * np.log10(2 / N * np.abs(X[:N // 2 + 1]))
    plt.figure()
    plt.plot(f, X_db, 'bo-')
    plt.xlabel('f [Hz]')
    plt.ylabel('Amplituda [dB]')
    plt.title(f'|X(k)| w decybelach dla f0 = {f0} Hz i N = {N}')
    plt.grid()
    plt.show()

# Obejrzyj widma FFT dla różnych wartości f0 i N
for f0 in [50, 100, 125, 200]:
    for N in [100, 1000]:
        plot_fft(f0, N)