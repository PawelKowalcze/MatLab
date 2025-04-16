import scipy.io
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# 1. Wczytaj dane z butter.mat
mat_data = scipy.io.loadmat("butter.mat")
z = mat_data['z']
p = mat_data['p']
k = mat_data['k']

# Sprawdzenie i poprawa formatu danych
z = np.ravel(z)  # Upewnij się, że zera są jednowymiarowe
p = np.ravel(p)  # Upewnij się, że bieguny są jednowymiarowe
k = np.isscalar(k) if np.size(k) == 1 else k  # Upewnij się, że wzmocnienie jest skalarem

# Parametry
fs = 16000  # Hz
f_low = 1189
f_high = 1229

# 2. Utwórz filtr analogowy H(s)
H_s = signal.ZerosPolesGain(z, p, k)

# 3. Konwersja biliniowa do postaci cyfrowej H(z)
H_z = H_s.to_tf().to_discrete(dt=1/fs, method='bilinear')

# 3a. Prewarp częstotliwości graniczne
T = 1 / fs
omega1 = 2 / T * np.tan(np.pi * f_low / fs)
omega2 = 2 / T * np.tan(np.pi * f_high / fs)

# 3b. Wyznacz środkową i szerokość pasma (do konwersji z LP -> BP)
omega0 = np.sqrt(omega1 * omega2)      # środkowa częstotliwość
B = omega2 - omega1                    # szerokość pasma

# 3c. Filtr prototypowy LP: przeniesienie LP -> BP -> biliniowa
z_bp, p_bp, k_bp = signal.lp2bp_zpk(z, p, k, wo=omega0, bw=B)
b_s, a_s = signal.zpk2tf(z_bp, p_bp, k_bp)
b_z, a_z = signal.bilinear(b_s, a_s, fs=fs)
H_z_corrected = signal.TransferFunction(b_z, a_z, dt=1/fs)


# 4. Wygeneruj charakterystyki częstotliwościowe
w_analog, h_analog = signal.freqs_zpk(z, p, k, worN=1024)
w_digital, h_digital = signal.freqz(H_z.num, H_z.den, worN=1024, fs=fs)

# 5. Narysuj porównanie charakterystyk
plt.figure(figsize=(10, 5))
plt.plot(w_analog / (2*np.pi), 20 * np.log10(abs(h_analog)), label="Analogowy H(s)")
plt.plot(w_digital, 20 * np.log10(abs(h_digital)), label="Cyfrowy H(z)")
plt.axvline(f_low, color='r', linestyle='--', label='Częstotliwości graniczne')
plt.axvline(f_high, color='r', linestyle='--')
plt.title("Charakterystyki H(s) vs H(z)")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Wzmocnienie [dB]")
plt.grid()
plt.legend()
plt.tight_layout()
plt.show()

# 6. Sygnał testowy (suma sinusów 1209 i 1272 Hz)
t = np.arange(0, 1, 1/fs)
x = np.sin(2*np.pi*1209*t) + np.sin(2*np.pi*1272*t)

# 7. Filtracja sygnału
y_filter = signal.lfilter(H_z.num, H_z.den, x)

# 8. Porównanie w dziedzinie czasu
plt.figure(figsize=(10, 4))
plt.plot(t, x, label="Sygnał oryginalny", alpha=0.6)
plt.plot(t, y_filter, label="Po filtracji (lfilter)", alpha=0.8)
plt.xlim(0, 0.01)  # tylko początek dla przejrzystości
plt.legend()
plt.title("Sygnał przed i po filtracji")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda")
plt.grid()
plt.tight_layout()
plt.show()

# Charakterystyki nowego filtra
w_digital_corrected, h_digital_corrected = signal.freqz(H_z_corrected.num, H_z_corrected.den, worN=1024, fs=fs)

plt.figure(figsize=(10, 5))
plt.plot(w_digital, 20 * np.log10(abs(h_digital)), label="Bez korekty prototypu")
plt.plot(w_digital_corrected, 20 * np.log10(abs(h_digital_corrected)), label="Z korektą prototypu")
plt.axvline(f_low, color='r', linestyle='--', label='1189 Hz')
plt.axvline(f_high, color='r', linestyle='--', label='1229 Hz')
plt.title("Porównanie H(z) z i bez korekty prototypu")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Wzmocnienie [dB]")
plt.grid()
plt.legend()
plt.tight_layout()
plt.show()

# Filtracja sygnału poprawionym filtrem
y_corrected = signal.lfilter(H_z_corrected.num, H_z_corrected.den, x)

plt.figure(figsize=(10, 4))
plt.plot(t, x, label="Oryginalny sygnał", alpha=0.5)
plt.plot(t, y_corrected, label="Po filtracji (z korektą)", alpha=0.8)
plt.xlim(0, 0.01)
plt.title("Sygnał po filtracji filtrem z korektą prototypu")
plt.xlabel("Czas [s]")
plt.ylabel("Amplituda")
plt.grid()
plt.legend()
plt.tight_layout()
plt.show()
