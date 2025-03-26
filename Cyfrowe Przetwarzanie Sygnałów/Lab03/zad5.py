import numpy as np
import scipy.io
import matplotlib.pyplot as plt

# Wczytaj sygnał z pliku ECG100.mat
data = scipy.io.loadmat('ECG100.mat')
ekg_signal = data['val'].flatten()
fs = 1000  # Zakładana częstotliwość próbkowania 1000 Hz

# Parametry
N = len(ekg_signal)
t = np.arange(N) / fs

# Obliczenie DFT (FFT)
X_dft = np.fft.fft(ekg_signal)
frequencies_dft = np.fft.fftfreq(N, 1/fs)

# Obliczenie DtFT
f = np.linspace(0, fs, N)
X_dtft = np.array([np.sum(ekg_signal * np.exp(-1j * 2 * np.pi * fi * t)) for fi in f])

# Skala decybelowa
X_dft_db = 20 * np.log10(np.abs(X_dft))
X_dtft_db = 20 * np.log10(np.abs(X_dtft))

# Wykres sygnału EKG
plt.figure(figsize=(12, 6))
plt.plot(t, ekg_signal)
plt.xlabel('Czas (s)')
plt.ylabel('Amplituda')
plt.title('Sygnał EKG')
plt.grid()
plt.show()

# Wykres widma DFT w skali liniowej
plt.figure(figsize=(12, 6))
plt.plot(frequencies_dft[:N//2], np.abs(X_dft[:N//2]))
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widmo DFT (skala liniowa)')
plt.grid()
plt.show()

# Wykres widma DFT w skali decybelowej
plt.figure(figsize=(12, 6))
plt.plot(frequencies_dft[:N//2], X_dft_db[:N//2])
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda (dB)')
plt.title('Widmo DFT (skala decybelowa)')
plt.grid()
plt.show()

# Wykres widma DtFT w skali liniowej
plt.figure(figsize=(12, 6))
plt.plot(f, np.abs(X_dtft))
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widmo DtFT (skala liniowa)')
plt.grid()
plt.show()

# Wykres widma DtFT w skali decybelowej
plt.figure(figsize=(12, 6))
plt.plot(f, X_dtft_db)
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda (dB)')
plt.title('Widmo DtFT (skala decybelowa)')
plt.grid()
plt.show()

# Dla DFT (Dyskretna Transformata Fouriera) rysowana jest tylko połowa osi częstotliwości
# , ponieważ DFT jest symetryczna względem połowy częstotliwości próbkowania (fs/2).
# Wynika to z faktu, że DFT przekształca sygnał czasowy w widmo częstotliwościowe,
# które jest okresowe i symetryczne. Dlatego wystarczy narysować tylko połowę widma,
# aby uzyskać pełną informację o częstotliwościach obecnych w sygnale.
#
# Dla DtFT (Dyskretna Transformata Fouriera w Czasie) rysowana jest cała oś częstotliwości,
# ponieważ DtFT jest ciągła i nieokresowa. DtFT przekształca sygnał czasowy w widmo częstotliwościowe,
# które może zawierać informacje o częstotliwościach w całym zakresie od 0 do fs.
# Dlatego, aby uzyskać pełną informację o częstotliwościach obecnych w sygnale,
# rysowana jest cała oś częstotliwości.
#
# Podsumowując:
# DFT: Rysowana jest tylko połowa osi częstotliwości (od 0 do fs/2) ze względu na symetrię widma.
# DtFT: Rysowana jest cała oś częstotliwości (od 0 do fs) ze względu na ciągłość i brak symetrii widma.
#
# Analiza częstotliwościowa sygnału EKG w skali logarytmicznej, co może ułatwić identyfikację mniejszych składowych częstotliwościowych.