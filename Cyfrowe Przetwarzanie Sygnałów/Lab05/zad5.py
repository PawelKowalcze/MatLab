import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import cheby1, freqz

# Parametry filtru
fs = 10e6  # Częstotliwość próbkowania, 10 MHz
f_pass = [95.9e6, 96.1e6]  # pasmo przepustowe
f_stop = [95.8e6, 96.2e6]  # pasmo zaporowe

# Przeskalowanie do częstotliwości znormalizowanej (fs/2 -> 1.0)
wp = [2 * f / fs for f in f_pass]
ws = [2 * f / fs for f in f_stop]

# Maksymalne zafalowanie w paśmie przepustowym i minimalne tłumienie w zaporowym
gpass = 3  # dB
gstop = 40  # dB

# Projektowanie filtru Chebysheva typu I
N, wn = cheby1(N=4, rp=gpass, Wn=wp, btype='bandpass', analog=False, output='ba')
w, h = freqz(wn, worN=2048, fs=fs)

# Rysowanie charakterystyki częstotliwościowej
plt.figure(figsize=(10, 6))
plt.plot(w, 20 * np.log10(abs(h)), label='Filtr 96MHz ±100kHz')
plt.axvline(95.8e6, color='r', linestyle='--', label='Granice pasma zaporowego')
plt.axvline(96.2e6, color='r', linestyle='--')
plt.axvline(95.9e6, color='g', linestyle='--', label='Granice pasma przepustowego')
plt.axvline(96.1e6, color='g', linestyle='--')
plt.title('Charakterystyka częstotliwościowa filtru pasmowo-przepustowego')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Amplituda [dB]')
plt.ylim([-100, 5])
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
