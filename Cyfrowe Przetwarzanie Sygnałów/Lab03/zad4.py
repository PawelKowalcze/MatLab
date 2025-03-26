import numpy as np
import scipy.io
import matplotlib.pyplot as plt

print(np.mod(420588, 16) + 1)


# Wczytaj sygnał z pliku lab_03.mat
data = scipy.io.loadmat('lab_03.mat')
x_13 = data['x_13'].flatten()

# Parametry
K = 8
N = 512
M = 32
frame_length = N + M

# Usuń prefiksy i wykonaj FFT dla każdej ramki
fft_results = []
for m in range(K):
    start_idx = m * frame_length + M
    frame = x_13[start_idx:start_idx + N]
    fft_result = np.fft.fft(frame)
    fft_results.append(fft_result)

# Wyznacz harmoniczne
harmonics = np.fft.fftfreq(N)
print(harmonics)
# Wyświetl wyniki
plt.figure(figsize=(12, 8))
for i, fft_result in enumerate(fft_results):
    plt.subplot(4, 2, i + 1)
    plt.stem(harmonics, np.abs(fft_result))
    plt.title(f'Ramka {i + 1}')
    plt.xlabel('Częstotliwość (Hz)')
    plt.ylabel('Amplituda')

plt.tight_layout()
plt.show()