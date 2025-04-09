import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, cheby1, cheby2, ellip, freqs, buttord

# Filter specifications
fs = 256e3  # Sampling frequency [Hz]
f3dB = 64e3  # Passband frequency [Hz]
f_stop = fs / 2  # Stopband frequency [Hz]
g_pass = 3  # Maximum ripple in passband [dB]
g_stop = 40  # Minimum attenuation in stopband [dB]

# Normalize frequencies to rad/s
wp = 2 * np.pi * f3dB  # Passband frequency in rad/s
ws = 2 * np.pi * f_stop  # Stopband frequency in rad/s

# Design filters
filters = {
    "Butterworth": butter,
    "Chebyshev I": cheby1,
    "Chebyshev II": cheby2,
    "Elliptic": ellip,
}
results = {}
N, Wn = buttord(wp, ws, g_pass, g_stop, analog=True)  # Filter order and cutoff

for name, func in filters.items():
    if name == "Butterworth":
        b, a = func(N=N, Wn=Wn, btype='low', analog=True, output='ba')
    elif name == "Chebyshev I":
        b, a = func(N=N, rp=g_pass, Wn=Wn, btype='low', analog=True, output='ba')
    elif name == "Chebyshev II":
        b, a = func(N=N, rs=g_stop, Wn=Wn, btype='low', analog=True, output='ba')
    elif name == "Elliptic":
        b, a = func(N=N, rp=g_pass, rs=g_stop, Wn=Wn, btype='low', analog=True, output='ba')
    results[name] = (b, a)

# Plot pole-zero diagrams and frequency responses
fig, axes = plt.subplots(2, len(filters), figsize=(18, 8))

for i, (name, (b, a)) in enumerate(results.items()):
    # Pole-zero plot
    poles = np.roots(a)
    zeros = np.roots(b)
    axes[0, i].scatter(np.real(zeros), np.imag(zeros), marker='o', label='Zeros')
    axes[0, i].scatter(np.real(poles), np.imag(poles), marker='x', label='Poles')
    axes[0, i].axhline(0, color='black', linewidth=0.5)
    axes[0, i].axvline(0, color='black', linewidth=0.5)
    axes[0, i].set_title(f'{name} Poles and Zeros')
    axes[0, i].set_xlabel('Re')
    axes[0, i].set_ylabel('Im')
    axes[0, i].grid(True)
    axes[0, i].legend()
    axes[0, i].axis('equal')

    # Frequency response
    w, h = freqs(b, a, worN=np.logspace(3, 6, 1000))  # Frequency range in rad/s
    axes[1, i].semilogx(w / (2 * np.pi), 20 * np.log10(np.abs(h)), label='Magnitude [dB]')
    axes[1, i].set_title(f'{name} Frequency Response')
    axes[1, i].set_xlabel('Frequency [Hz]')
    axes[1, i].set_ylabel('Magnitude [dB]')
    axes[1, i].grid(True)
    axes[1, i].axvline(f3dB, color='green', linestyle='--', label='f3dB')
    axes[1, i].axvline(f_stop, color='red', linestyle='--', label='f_stop')
    axes[1, i].legend()

plt.tight_layout()
plt.show()