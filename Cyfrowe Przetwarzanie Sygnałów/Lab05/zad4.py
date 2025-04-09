import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, cheby1, cheby2, ellip, freqs, lp2hp, lp2bp, lp2bs

# Parametry filtru
N = 4  # Rząd filtru
rp = 1  # Maksymalne zafalowanie w paśmie przepustowym (dB)
rs = 40  # Minimalne tłumienie w paśmie zaporowym (dB)
w0 = 1  # Częstotliwość środkowa (unormowana)

# Typy filtrów prototypowych
filters = {
    "Butterworth": butter,
    "Chebyshev I": cheby1,
    "Chebyshev II": cheby2,
    "Elliptic": ellip,
}

# Typy filtrów docelowych
transformations = {
    "LP": lambda b, a: (b, a),
    "HP": lp2hp,
    "BP": lp2bp,
    "BS": lp2bs,
}

# Zakres częstotliwości
w = np.logspace(-1, 1, 500)

# Iteracja po filtrach prototypowych
for filter_name, filter_func in filters.items():
    if filter_name == "Butterworth":
        b, a = filter_func(N, w0, btype='low', analog=True)
    else:
        b, a = filter_func(N, rp, rs, w0, btype='low', analog=True)

    # Charakterystyka prototypowa
    w_proto, h_proto = freqs(b, a, worN=w)

    # Iteracja po transformacjach
    for transform_name, transform_func in transformations.items():
        if transform_name == "LP":
            b_trans, a_trans = b, a
        else:
            b_trans, a_trans = transform_func(b, a, wo=w0)

        # Charakterystyka po transformacji
        w_trans, h_trans = freqs(b_trans, a_trans, worN=w)

        # Rysowanie wykresów
        plt.figure(figsize=(10, 6))
        plt.semilogx(w, 20 * np.log10(np.abs(h_proto)), label='Prototypowy')
        plt.semilogx(w, 20 * np.log10(np.abs(h_trans)), label=f'Po transformacji ({transform_name})')
        plt.title(f'{filter_name} - {transform_name}')
        plt.xlabel('Częstotliwość [rad/s]')
        plt.ylabel('Amplituda [dB]')
        plt.legend()
        plt.grid()
        plt.show()