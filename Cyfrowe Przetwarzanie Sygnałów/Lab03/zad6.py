import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
from scipy.fft import fft, ifft
from sounddevice import playrec

# Wczytaj pliki dźwiękowe
fs1, bird_signal = wavfile.read('bird_01.wav')
fs2, son_signal = wavfile.read('son_993_echappement_sport.wav')

# Sprawdź, czy częstotliwości próbkowania są takie same
assert fs1 == fs2, "Częstotliwości próbkowania muszą być takie same"

# Oblicz DFT obu sygnałów
bird_dft = fft(bird_signal)
son_dft = fft(son_signal)

# Wyświetl widma DFT
frequencies_bird = np.fft.fftfreq(len(bird_signal), 1/fs1)
frequencies_son = np.fft.fftfreq(len(son_signal), 1/fs2)

plt.figure(figsize=(12, 6))
plt.plot(frequencies_bird[1:len(bird_signal)//2], np.abs(bird_dft)[1:len(bird_signal)//2])
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widmo DFT bird_01.wav')
plt.grid()
plt.show()

plt.figure(figsize=(12, 6))
plt.plot(frequencies_son[1:len(son_signal)//2], np.abs(son_dft)[1:len(son_signal)//2])
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widmo DFT  son_993_echappement_sport.wav')
plt.grid()
plt.show()

# Dodaj sygnały, dopełniając krótszy zerami
max_len = max(len(bird_signal), len(son_signal))
bird_signal_padded = np.pad(bird_signal, (0, max_len - len(bird_signal)), 'constant')
son_signal_padded = np.pad(son_signal, (0, max_len - len(son_signal)), 'constant')

sum_signal = bird_signal_padded + son_signal_padded

# Oblicz DFT sumy sygnałów
sum_dft = fft(sum_signal)

# Wyświetl widmo DFT sumy
frequencies_sum = np.fft.fftfreq(len(sum_signal), 1/fs1)

plt.figure(figsize=(12, 6))
plt.plot(frequencies_sum[1:len(sum_signal)//2], np.abs(sum_dft)[1:len(sum_signal)//2])
plt.xlabel('Częstotliwość (Hz)')
plt.ylabel('Amplituda')
plt.title('Widmo DFT sumy sygnałów')
plt.grid()
plt.show()

# Wyzeruj współczynniki DFT związane z jednym sygnałem
# Przykład: usuń składowe związane z  son_993_echappement_sport.wav
threshold = 0.2 * np.max(np.abs(son_dft))
sum_dft[np.abs(son_dft) > threshold] = 0

# Wykonaj IDFT
filtered_signal = ifft(sum_dft)

# Sprawdź, czy sygnał jest rzeczywisty
if np.iscomplexobj(filtered_signal):
    filtered_signal = np.real(filtered_signal)

# Wyświetl wynik
plt.figure(figsize=(12, 6))
plt.plot(np.arange(len(filtered_signal)) / fs1, filtered_signal)
plt.xlabel('Czas (s)')
plt.ylabel('Amplituda')
plt.title('Przefiltrowany sygnał')
plt.grid()
plt.show()

# Zapisz przefiltrowany sygnał do pliku
wavfile.write('filtered_signal.wav', fs1, filtered_signal.astype(np.int16))

# Odsłuchaj sygnał (można użyć zewnętrznego odtwarzacza)

