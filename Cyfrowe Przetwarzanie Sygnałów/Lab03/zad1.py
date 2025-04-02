import numpy as np
import matplotlib.pyplot as plt

# Parametry
N = 1000
fs = 1000
t = np.arange(N) / fs
f1, f2 = 100, 200
A1, A2 = 100, 200
phi1, phi2 = np.pi / 7, np.pi / 11

# Sygnał x(t)
x = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)

# Macierz DFT
k = np.arange(N)
n = np.arange(N)
WN = np.exp(-1j * 2 * np.pi / N)
A = np.array([[WN**(-k_i * n_j) for n_j in n] for k_i in k]) / np.sqrt(N)

# Oblicz DFT
X = np.dot(A, x)

# Widmo sygnału
frequencies = np.fft.fftfreq(N, 1/fs)
plt.figure(figsize=(12, 8))

plt.subplot(2, 2, 1)
plt.plot(frequencies, np.real(X))
plt.title('Część rzeczywista')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 2)
plt.plot(frequencies, np.imag(X))
plt.title('Część urojona')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 3)
plt.plot(frequencies, np.abs(X))
plt.title('Moduł')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 4)
plt.plot(frequencies, np.angle(X))
plt.title('Faza')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Faza (radiany)')

plt.tight_layout()
plt.show()

# Macierz rekonstrukcji
B = np.conjugate(A.T)

# Rekonstrukcja sygnału
xr = np.dot(B, X)

print(xr-x)
print(f"Rekonstrukcja poprawna: {np.allclose(xr, x)}")

# Zastąpienie operacji DFT i IDFT funkcjami fft i ifft
X_fft = np.fft.fft(x)
xr_ifft = np.fft.ifft(X_fft)
print(f"Rekonstrukcja z fft/ifft poprawna: {np.allclose(xr_ifft, x)}")

# Zmiana f1 na 100 Hz
f1 = 100
x = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)
X = np.dot(A, x)

# Widmo sygnału z f1 = 100 Hz
plt.figure(figsize=(12, 8))

plt.subplot(2, 2, 1)
plt.plot(frequencies, np.real(X))
plt.title('Część rzeczywista (f1 = 100 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 2)
plt.plot(frequencies, np.imag(X))
plt.title('Część urojona (f1 = 100 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 3)
plt.plot(frequencies, np.abs(X))
plt.title('Moduł (f1 = 100 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 4)
plt.plot(frequencies, np.angle(X))
plt.title('Faza (f1 = 100 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Faza (radiany)')

plt.tight_layout()
plt.show()



# Zmiana f1 na 125 Hz
f1 = 125
x = A1 * np.cos(2 * np.pi * f1 * t + phi1) + A2 * np.cos(2 * np.pi * f2 * t + phi2)
X = np.dot(A, x)

# Widmo sygnału z f1 = 125 Hz
plt.figure(figsize=(12, 8))

plt.subplot(2, 2, 1)
plt.plot(frequencies, np.real(X))
plt.title('Część rzeczywista (f1 = 125 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 2)
plt.plot(frequencies, np.imag(X))
plt.title('Część urojona (f1 = 125 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 3)
plt.plot(frequencies, np.abs(X))
plt.title('Moduł (f1 = 125 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')

plt.subplot(2, 2, 4)
plt.plot(frequencies, np.angle(X))
plt.title('Faza (f1 = 125 Hz)')
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Faza (radiany)')

plt.tight_layout()
plt.show()