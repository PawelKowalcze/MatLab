import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, cheby1, cheby2, ellip, freqs

# Parametry filtru
fs = 256e3  # Częstotliwość próbkowania [Hz]
f3dB = 64e3  # Częstotliwość graniczna [Hz]
f_stop = fs / 2  # Częstotliwość tłumienia [Hz]
g_pass = 3  # Maksymalne zafalowanie w paśmie przenoszenia [dB]
g_stop = 40  # Minimalne tłumienie w paśmie zaporowym [dB]

# Normalizacja częstotliwości
wp = 2 * np.pi * f3dB  # Częstotliwość graniczna w rad/s
ws = 2 * np.pi * f_stop  # Częstotliwość tłumienia w rad/s

# Projektowanie filtrów
filters = {
    "Butterworth": butter,
    "Chebyshev I": cheby1,
    "Chebyshev II": cheby2,
    "Elliptic": ellip,
}

results = {}

for name, func in filters.items():
    if name == "Butterworth":
        N, Wn = func(N=None, Wn=wp, btype='low', analog=True, output='ba', fs=None, gpass=g_pass, gstop=g_stop)