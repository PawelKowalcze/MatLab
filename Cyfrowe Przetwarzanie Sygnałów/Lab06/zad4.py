import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, lfilter, freqz, spectrogram, tf2zpk
from pydub import AudioSegment
from scipy.fftpack import fft

# Funkcja do wczytania pliku audio
def load_audio(file_path):
    audio = AudioSegment.from_file(file_path)
    samples = np.array(audio.get_array_of_samples())
    fs = audio.frame_rate
    return samples, fs

# Funkcja do obliczenia FFT
def plot_fft(signal, fs, title):
    N = len(signal)
    f = np.fft.fftfreq(N, 1/fs)[:N//2]
    fft_values = np.abs(fft(signal))[:N//2]
    plt.plot(f, fft_values)
    plt.title(f"FFT - {title}")
    plt.xlabel("Częstotliwość [Hz]")
    plt.ylabel("Amplituda")
    plt.grid()

# Funkcja do obliczenia spektrogramu
def plot_spectrogram(signal, fs, title):
    f, t, Sxx = spectrogram(signal, fs)
    plt.pcolormesh(t, f, 10 * np.log10(Sxx), shading='gouraud')
    plt.title(f"Spektrogram - {title}")
    plt.xlabel("Czas [s]")
    plt.ylabel("Częstotliwość [Hz]")
    plt.colorbar(label="Moc [dB]")

# Wczytanie plików audio
wolf, fs_wolf = load_audio("WOLF2.wav")
lion, fs_lion = load_audio("Lion roar animals104.wav")
elephant, fs_elephant = load_audio("Elephant trumpeting animals129.wav")
bird, fs_bird = load_audio("Habicht_Accipiter_gentillis_R_AMPLE-E03521A.mp3")

# Dopasowanie długości i częstotliwości próbkowania
min_length = min(len(wolf), len(lion), len(elephant), len(bird))
wolf, lion, elephant, bird = wolf[:min_length], lion[:min_length], elephant[:min_length], bird[:min_length]

# Sygnał sumy
sum_signal = wolf + lion + elephant + bird

# FFT i spektrogram dla każdego sygnału
plt.figure(figsize=(12, 8))
plt.subplot(2, 2, 1)
plot_fft(wolf, fs_wolf, "Wycie wilka")
plt.subplot(2, 2, 2)
plot_fft(lion, fs_lion, "Ryk lwa")
plt.subplot(2, 2, 3)
plot_fft(elephant, fs_elephant, "Trąbienie słonia")
plt.subplot(2, 2, 4)
plot_fft(bird, fs_bird, "Śpiew ptaka")
plt.tight_layout()
plt.show()

plt.figure(figsize=(12, 8))
plt.subplot(2, 2, 1)
plot_spectrogram(wolf, fs_wolf, "Wycie wilka")
plt.subplot(2, 2, 2)
plot_spectrogram(lion, fs_lion, "Ryk lwa")
plt.subplot(2, 2, 3)
plot_spectrogram(elephant, fs_elephant, "Trąbienie słonia")
plt.subplot(2, 2, 4)
plot_spectrogram(bird, fs_bird, "Śpiew ptaka")
plt.tight_layout()
plt.show()

# FFT i spektrogram dla sygnału sumy
plt.figure(figsize=(12, 6))
plt.subplot(2, 1, 1)
plot_fft(sum_signal, fs_wolf, "Sygnał sumy")
plt.subplot(2, 1, 2)
plot_spectrogram(sum_signal, fs_wolf, "Sygnał sumy")
plt.tight_layout()
plt.show()

# Projektowanie filtru IIR
def butter_bandpass(lowcut, highcut, fs, order=4):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a

# Parametry filtru
lowcut = 300  # Dolna częstotliwość
highcut = 3000  # Górna częstotliwość
b, a = butter_bandpass(lowcut, highcut, fs_wolf)

# Odpowiedź częstotliwościowa filtru
w, h = freqz(b, a, worN=8000)
plt.figure(figsize=(8, 4))
plt.plot(0.5 * fs_wolf * w / np.pi, 20 * np.log10(abs(h)))
plt.title("Odpowiedź częstotliwościowa filtru")
plt.xlabel("Częstotliwość [Hz]")
plt.ylabel("Wzmocnienie [dB]")
plt.grid()
plt.show()

# Zera i bieguny filtru
zeros, poles, _ = tf2zpk(b, a)
plt.figure(figsize=(6, 6))
plt.scatter(np.real(zeros), np.imag(zeros), s=50, label="Zera", color='blue')
plt.scatter(np.real(poles), np.imag(poles), s=50, label="Bieguny", color='red')
plt.title("Zera i bieguny filtru")
plt.xlabel("Re")
plt.ylabel("Im")
plt.axhline(0, color='black', linewidth=0.5)
plt.axvline(0, color='black', linewidth=0.5)
plt.grid()
plt.legend()
plt.show()

# Filtracja sygnału sumy
filtered_signal = lfilter(b, a, sum_signal)

# FFT i spektrogram dla sygnału po filtracji
plt.figure(figsize=(12, 6))
plt.subplot(2, 1, 1)
plot_fft(filtered_signal, fs_wolf, "Sygnał po filtracji")
plt.subplot(2, 1, 2)
plot_spectrogram(filtered_signal, fs_wolf, "Sygnał po filtracji")
plt.tight_layout()
plt.show()