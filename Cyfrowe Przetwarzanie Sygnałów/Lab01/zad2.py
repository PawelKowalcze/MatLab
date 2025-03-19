import matplotlib
matplotlib.use('TkAgg')
import numpy as np
import matplotlib.pyplot as plt


def generate_signal(frequency, sampling_rate, duration, amplitude=230):
    t = np.arange(0, duration, 1 / sampling_rate)
    signal = amplitude * np.sin(2 * np.pi * frequency * t)
    return t, signal

def sinc_interp(xn, tn, t_new, T):
    reconstructed = np.zeros_like(t_new)
    for n, x in zip(tn, xn):
        reconstructed += x * np.sinc((t_new - n) / T)  # sinc(x) w numpy to sin(pi*x)/(pi*x)
    return reconstructed

# A. Generowanie sygnału dla różnych częstotliwości próbkowania
f_signal = 50  # Hz
duration = 0.1  # sekundy
sampling_rates = [10000, 500, 200]  # Hz
markers = ['_', 'o', 'x']  # Valid marker styles
colors = ['b', 'r', 'k']  # Colors for each plot

plt.figure(figsize=(10, 5))
for fs, marker, color in zip(sampling_rates, markers, colors):
    t, signal = generate_signal(f_signal, fs, duration)
    plt.plot(t, signal, label=f'f_s={fs} Hz', marker=marker, color=color)

plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.legend()
plt.title('Próbkowanie sygnału sinusoidalnego (50 Hz)')
plt.grid()
plt.show()

# Rekonstrukcja sygnału
fs_reconstruction = 200  # Hz (częstotliwość próbkowania do rekonstrukcji)
T = 1 / fs_reconstruction
t_sampled, x_sampled = generate_signal(f_signal, fs_reconstruction, duration)
t_fine = np.linspace(0, duration, 1000)  # Dokładniejsza siatka czasowa
x_reconstructed = sinc_interp(x_sampled, t_sampled, t_fine, T)

# Generowanie "pseudo analogowego" sygnału
fs_analog = 10000  # Hz (wysoka częstotliwość próbkowania)
t_analog, x_analog = generate_signal(f_signal, fs_analog, duration)

# Porównanie zrekonstruowanego sygnału i "pseudo analogowego"
plt.figure(figsize=(10, 5))
plt.plot(t_fine, x_reconstructed, 'g-', label='Zrekonstruowany sygnał')
plt.plot(t_analog, x_analog, 'b--', label='Pseudo analogowy sygnał')
plt.plot(t_sampled, x_sampled, 'ro', label='Próbkowane punkty')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.legend()
plt.title('Porównanie zrekonstruowanego sygnału i pseudo analogowego')
plt.grid()
plt.show()

# Wyświetlanie błędów rekonstrukcji
reconstruction_errors = np.interp(t_fine, t_analog, x_analog) - x_reconstructed
plt.figure(figsize=(10, 5))
plt.plot(t_fine, reconstruction_errors, 'r-', label='Błędy rekonstrukcji')
plt.xlabel('Czas [s]')
plt.ylabel('Amplituda błędu')
plt.legend()
plt.title('Błędy rekonstrukcji sygnału')
plt.grid()
plt.show()