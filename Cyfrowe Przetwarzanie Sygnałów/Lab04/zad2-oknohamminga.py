import numpy as np
import matplotlib.pyplot as plt


# Rozmycie widma sygnału o częstotliwości ( f_0 = 125 ) Hz wynika z efektu zwanego "wyciekiem spektralnym"
# (ang. spectral leakage). Efekt ten pojawia się, gdy sygnał nie jest idealnie okresowy w oknie analizy,
# co prowadzi do rozmycia energii sygnału na sąsiednie częstotliwości w widmie.
#
# W praktyce, gdy obliczamy DFT sygnału, zakładamy, że sygnał jest okresowy w analizowanym
# oknie czasowym. Jeśli sygnał nie jest dokładnie okresowy, jego widmo będzie miało komponenty
# na częstotliwościach innych niż rzeczywista częstotliwość sygnału, co prowadzi do rozmycia widma.
#
# Funkcje okienkowe są stosowane, aby zminimalizować ten efekt.
# Okno prostokątne (ang. rectangular window), które jest domyślnie używane,
# nie tłumi wystarczająco składowych sygnału na brzegach okna, co prowadzi do wycieku spektralnego.
#
# Aby zredukować rozmycie widma, można zastosować inne funkcje okienkowe,
# takie jak okno Hanninga, Hamming, Blackmana czy inne, które mają lepsze właściwości
# tłumienia składowych sygnału na brzegach okna.
#
# Przykład zastosowania okna Hanninga w Pythonie:


# Parametry
fpr = 1000  # częstotliwość próbkowania (Hz)
N = 100  # liczba próbek sygnału
dt = 1 / fpr
t = dt * np.arange(N)  # chwile próbkowania sygnału, oś czasu

# Sygnał
f0 = 125
x = 10 * np.sin(2 * np.pi * f0 * t)  # sygnał o częstotliwości f0 = 125 Hz

# Zastosowanie okna Hanninga
window = np.hamming(N)
x_windowed = x * window

# Wykres sygnału z oknem
plt.figure()
plt.plot(t, x_windowed, 'bo-')
plt.xlabel('t [s]')
plt.title('x(t) z oknem Hanninga')
plt.grid()
plt.show()

# FFT spektrum
X = np.fft.fft(x_windowed)  # FFT
f = fpr / N * np.arange(N)  # oś częstotliwości

# Wykres FFT
plt.figure()
plt.plot(f, 1 / N * np.abs(X), 'bo-')
plt.xlabel('f [Hz]')
plt.title('|X(k)| z oknem Hanninga')
plt.grid()
plt.show()