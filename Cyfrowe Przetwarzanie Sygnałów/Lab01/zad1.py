import matplotlib
matplotlib.use('TkAgg')
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import welch

def generate_signal(frequency, sampling_rate, duration, amplitude=230):
    t = np.arange(0, duration, 1 / sampling_rate)
    signal = amplitude * np.sin(2 * np.pi * frequency * t)
    return t, signal

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

# B. Próbkowanie dla różnych częstotliwości bliskich 50 Hz
sampling_rates_B = [10000, 26, 25, 24]  # Hz
markers = ['_', 'o', 'o', 'o']  # Valid marker styles
colors = ['b', 'g', 'r', 'k']  # Colors for each plot

duration_B = 1  # sekunda
plt.figure(figsize=(10, 5))
for fs, marker, color in zip(sampling_rates_B, markers, colors):
    t, signal = generate_signal(f_signal, fs, duration_B)
    plt.plot(t, signal, label=f'f_s={fs} Hz', marker=marker, color = color)

plt.xlabel('Czas [s]')
plt.ylabel('Amplituda')
plt.legend()
plt.title('Próbkowanie sygnału 50 Hz dla różnych częstotliwości próbkowania')
plt.grid()
plt.show()
#
# # C. Zmiana częstotliwości sygnału od 0 Hz do 300 Hz co 5 Hz
# f_sweep = np.arange(0, 305, 5)  # wartości od 0 Hz do 300 Hz co 5 Hz
# sampling_rate_C = 100  # Hz
# duration_C = 1  # sekunda
#
# plt.figure(figsize=(10, 5))
# for i, f in enumerate(f_sweep):
#     t, signal = generate_signal(f, sampling_rate_C, duration_C)
#     plt.plot(t, signal, alpha=0.5)
#     print(f'Obieg: {i+1}, Częstotliwość: {f} Hz')
#     plt.xlabel('Czas [s]')
#     plt.ylabel('Amplituda')
#     plt.title('Zmiana częstotliwości od 0 do 300 Hz co 5 Hz')
#     plt.grid()
#     plt.show()
#
# # Porównanie wybranych częstotliwości sinusoidy
# frequencies_to_compare = [(5, 105, 205), (95, 195, 295), (95, 105)]
# for group in frequencies_to_compare:
#     plt.figure(figsize=(10, 5))
#     for f in group:
#         t, signal = generate_signal(f, sampling_rate_C, duration_C)
#         plt.plot(t, signal, label=f'{f} Hz')
#     plt.xlabel('Czas [s]')
#     plt.ylabel('Amplituda')
#     plt.legend()
#     plt.title(f'Porównanie częstotliwości: {group}')
#     plt.grid()
#     plt.show()
#
# # Powtórzenie eksperymentu dla kosinusoidy
# def generate_cosine_signal(frequency, sampling_rate, duration, amplitude=230):
#     t = np.arange(0, duration, 1 / sampling_rate)
#     signal = amplitude * np.cos(2 * np.pi * frequency * t)
#     return t, signal
#
# plt.figure(figsize=(10, 5))
# for i, f in enumerate(f_sweep):
#     t, signal = generate_cosine_signal(f, sampling_rate_C, duration_C)
#     plt.plot(t, signal, alpha=0.5)
#     print(f'Obieg: {i+1}, Częstotliwość: {f} Hz')
#     plt.xlabel('Czas [s]')
#     plt.ylabel('Amplituda')
#     plt.title('Zmiana częstotliwości od 0 do 300 Hz co 5 Hz (kosinus)')
#     plt.grid()
#     plt.show()
#
# # Porównanie wybranych częstotliwości kosinusoidy
# for group in frequencies_to_compare:
#     plt.figure(figsize=(10, 5))
#     for f in group:
#         t, signal = generate_cosine_signal(f, sampling_rate_C, duration_C)
#         plt.plot(t, signal, label=f'{f} Hz')
#     plt.xlabel('Czas [s]')
#     plt.ylabel('Amplituda')
#     plt.legend()
#     plt.title(f'Porównanie częstotliwości (kosinus): {group}')
#     plt.grid()
#     plt.show()


#D. SFM




def generate_sfm_signal(carrier_freq, modulating_freq, modulation_depth, sampling_rate, duration, amplitude=230):
    t = np.arange(0, duration, 1 / sampling_rate)
    modulating_signal = np.sin(2 * np.pi * modulating_freq * t)
    instantaneous_freq = carrier_freq + modulation_depth * modulating_signal
    signal = amplitude * np.sin(2 * np.pi * instantaneous_freq * t)
    return t, signal, modulating_signal

# Parameters
fs = 10000  # Hz
fn = 50  # Hz
fm = 1  # Hz
df = 5  # Hz
duration = 1  # second

# Generate SFM signal
t, sfm_signal, modulating_signal = generate_sfm_signal(fn, fm, df, fs, duration)

# 1. Plot modulated and modulating signals
plt.figure(figsize=(10, 5))
plt.plot(t, sfm_signal, label='SFM Signal')
plt.plot(t, modulating_signal * df, label='Modulating Signal (scaled)')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.legend()
plt.title('SFM Signal and Modulating Signal')
plt.grid()
plt.show()

# 2. Sample the modulated signal at 25 Hz
fs_sampled = 25  # Hz
t_sampled = np.arange(0, duration, 1 / fs_sampled)
sfm_signal_sampled = np.interp(t_sampled, t, sfm_signal)

# Plot the original and sampled signals
plt.figure(figsize=(10, 5))
plt.plot(t, sfm_signal, label='Original SFM Signal', alpha=0.5)
plt.stem(t_sampled, sfm_signal_sampled, linefmt='r-', markerfmt='ro', basefmt='r-', label='Sampled SFM Signal')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.legend()
plt.title('Original and Sampled SFM Signal')
plt.grid()
plt.show()

# Plot sampling errors
sampling_errors = np.interp(t, t_sampled, sfm_signal_sampled) - sfm_signal
plt.figure(figsize=(10, 5))
plt.plot(t, sampling_errors, label='Sampling Errors')
plt.xlabel('Time [s]')
plt.ylabel('Error Amplitude')
plt.legend()
plt.title('Sampling Errors Over Time')
plt.grid()
plt.show()

# 3. Generate and display power spectral density (PSD)
nperseg = min(len(sfm_signal), len(sfm_signal_sampled))  # Ensure nperseg is not greater than the input length
frequencies, psd_original = welch(sfm_signal, fs, nperseg=nperseg)
frequencies_sampled, psd_sampled = welch(sfm_signal_sampled, fs_sampled, nperseg=nperseg)

plt.figure(figsize=(10, 5))
plt.semilogy(frequencies, psd_original, label='Original SFM Signal PSD')
plt.semilogy(frequencies_sampled, psd_sampled, label='Sampled SFM Signal PSD')
plt.xlabel('Frequency [Hz]')
plt.ylabel('Power Spectral Density [V^2/Hz]')
plt.legend()
plt.title('Power Spectral Density of SFM Signal')
plt.grid()
plt.show()