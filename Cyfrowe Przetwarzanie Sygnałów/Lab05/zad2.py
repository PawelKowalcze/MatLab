import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqresp, TransferFunction, impulse, step

# Parametry
omega_3dB = 2 * np.pi * 100
N_values = [2, 4, 6, 8]
frequencies = np.linspace(1, 1000, 1000)
omega = 2 * np.pi * frequencies

# Rysunki
fig_amp, ax_amp = plt.subplots(2, 1, figsize=(10, 8))
fig_phase, ax_phase = plt.subplots(figsize=(10, 4))

for N in N_values:
    k = np.arange(1, N + 1)
    # Bieguny na lewej półpłaszczyźnie zespolonej
    poles = omega_3dB * np.exp(1j * (np.pi / 2 + np.pi / (2 * N) + (k - 1) * np.pi / N))
    poles = poles[np.real(poles) < 0]

    # Filtr Butterwortha: licznik to tylko omega_3dB^N, mianownik z biegunów
    b = [omega_3dB ** N]
    a = np.poly(poles)

    # Transmitancja H(jω)
    _, h = freqresp((b, a), w=omega)
    H_db = 20 * np.log10(np.abs(h))
    H_phase = np.angle(h)

    # Charakterystyki
    ax_amp[0].plot(frequencies, H_db, label=f'N={N}')
    ax_amp[1].semilogx(frequencies, H_db, label=f'N={N}')
    ax_phase.plot(frequencies, H_phase, label=f'N={N}')

# Opisy i legendy
ax_amp[0].set(title='Amplituda (skala liniowa)', xlabel='f [Hz]', ylabel='[dB]', grid=True)
ax_amp[1].set(title='Amplituda (skala log)', xlabel='f [Hz]', ylabel='[dB]', grid=True)
ax_phase.set(title='Faza', xlabel='f [Hz]', ylabel='[rad]', grid=True)
for ax in ax_amp: ax.legend()
ax_phase.legend()
plt.tight_layout()
plt.show()

# Odpowiedź impulsowa i skokowa dla N=4
N = 4
k = np.arange(1, N + 1)
poles = omega_3dB * np.exp(1j * (np.pi / 2 + np.pi / (2 * N) + (k - 1) * np.pi / N))
poles = poles[np.real(poles) < 0]
b = [omega_3dB ** N]
a = np.poly(poles)
H = TransferFunction(b, a)

# Impuls i skok
t_imp, y_imp = impulse(H)
t_step, y_step = step(H)

# Rysowanie
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 6))
ax1.plot(t_imp, y_imp)
ax1.set(title='Odpowiedź impulsowa (N=4)', xlabel='Czas [s]', ylabel='Amplituda', grid=True)
ax2.plot(t_step, y_step)
ax2.set(title='Odpowiedź skokowa (N=4)', xlabel='Czas [s]', ylabel='Amplituda', grid=True)
plt.tight_layout()
plt.show()
