import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, lfilter, welch, find_peaks, freqz

# Parametry
fs = 256e3  # Częstotliwość próbkowania (Hz)
t = np.linspace(0, 1, int(fs), endpoint=False)  # Oś czasu
wideband_signal = np.sin(2 * np.pi * 50e3 * t) + np.sin(2 * np.pi * 100e3 * t)  # Sygnał szerokopasmowy

# 1. Charakterystyki czasowo-częstotliwościowe i widma gęstości mocy
def plot_psd(signal, fs, title):
    f, Pxx = welch(signal, fs, window='hamming', nperseg=1024)
    plt.semilogy(f, Pxx)
    plt.title(title)
    plt.xlabel('Częstotliwość [Hz]')
    plt.ylabel('Gęstość mocy [V^2/Hz]')
    plt.grid()

plt.figure(figsize=(10, 6))
plt.subplot(2, 1, 1)
plt.plot(t, wideband_signal)
plt.title("Sygnał szerokopasmowy w dziedzinie czasu")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda")
plt.grid()

plt.subplot(2, 1, 2)
plot_psd(wideband_signal, fs, "Widmo gęstości mocy sygnału szerokopasmowego")
plt.tight_layout()
plt.show()

# 2. Wyszukiwanie stacji radiowych
f, Pxx = welch(wideband_signal, fs, window='hamming', nperseg=1024)
peaks, _ = find_peaks(Pxx, height=np.max(Pxx) * 0.1)  # Wykrywanie "górek"
station_freqs = f[peaks]
print("Częstotliwości stacji radiowych:", station_freqs)

# 3. Filtr cyfrowy Butterworth LP (80 kHz)
def butter_lowpass(cutoff, fs, order=4):
    nyq = fs / 2
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return b, a

b, a = butter_lowpass(80e3, fs)
filtered_signal = lfilter(b, a, wideband_signal)

plt.figure(figsize=(10, 6))
plt.subplot(2, 1, 1)
plot_psd(filtered_signal, fs, "Widmo gęstości mocy po filtrze LP (80 kHz)")
plt.subplot(2, 1, 2)
w, h = freqz(b, a, worN=8000)
plt.plot(0.5 * fs * w / np.pi, 20 * np.log10(abs(h)))
plt.title("Charakterystyka amplitudowo-częstotliwościowa filtru LP (80 kHz)")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Wzmocnienie [dB]")
plt.grid()
plt.tight_layout()
plt.show()

# 4. Filtr antyaliasingowy (16 kHz)
b_aa, a_aa = butter_lowpass(16e3, fs)
anti_aliased_signal = lfilter(b_aa, a_aa, filtered_signal)

plt.figure(figsize=(10, 6))
plot_psd(anti_aliased_signal, fs, "Widmo gęstości mocy po filtrze antyaliasingowym (16 kHz)")
plt.tight_layout()
plt.show()

# 5. Filtr de-emfazy i pre-emfazy
def design_deemphasis(fs):
    cutoff = 2.1e3
    b, a = butter(1, cutoff / (fs / 2), btype='low')
    return b, a

b_de, a_de = design_deemphasis(fs)
deemphasized_signal = lfilter(b_de, a_de, anti_aliased_signal)

plt.figure(figsize=(10, 6))
w, h = freqz(b_de, a_de, worN=8000)
plt.plot(0.5 * fs * w / np.pi, 20 * np.log10(abs(h)))
plt.title("Charakterystyka amplitudowo-częstotliwościowa filtru de-emfazy")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Wzmocnienie [dB]")
plt.grid()
plt.tight_layout()
plt.show()

# Filtr pre-emfazy (odwrotny do de-emfazy)
b_pre, a_pre = design_deemphasis(fs)
preemphasized_signal = lfilter(b_pre, a_pre, deemphasized_signal)

plt.figure(figsize=(10, 6))
plt.plot(t, deemphasized_signal, label="Po de-emfazie")
plt.plot(t, preemphasized_signal, label="Po pre-emfazie")
plt.title("Porównanie sygnałów po de-emfazie i pre-emfazie")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda")
plt.legend()
plt.grid()
plt.tight_layout()
plt.show()