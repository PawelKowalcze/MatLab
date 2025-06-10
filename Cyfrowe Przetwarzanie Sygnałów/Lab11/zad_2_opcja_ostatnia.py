import numpy as np
import matplotlib.pyplot as plt

def mdct_window(N):
    n = np.arange(N)
    return np.sin(np.pi * (n + 0.5) / N)

def transition_window(N_long, N_short, direction='long2short'):
    # Okno przejściowe zgodnie z [TZ2005]
    if direction == 'long2short':
        win = np.zeros(N_long)
        win[:N_short//2] = mdct_window(N_short)[:N_short//2]
        win[N_long//2 - N_short//2:N_long//2 + N_short//2] = mdct_window(N_long)[N_long//2 - N_short//2:N_long//2 + N_short//2]
        win[-N_short//2:] = mdct_window(N_short)[-N_short//2:]
        return win
    elif direction == 'short2long':
        win = np.zeros(N_long)
        win[:N_short//2] = mdct_window(N_short)[:N_short//2]
        win[N_long//2 - N_short//2:N_long//2 + N_short//2] = mdct_window(N_long)[N_long//2 - N_short//2:N_long//2 + N_short//2]
        win[-N_short//2:] = mdct_window(N_short)[-N_short//2:]
        return win
    else:
        raise ValueError("direction must be 'long2short' or 'short2long'")

def mdct_matrix(N):
    k = np.arange(N // 2).reshape(-1,1)
    n = np.arange(N).reshape(1,-1)
    return np.sqrt(4 / N) * np.cos(2 * np.pi / N * (k + 0.5) * (n + 0.5 + N /4))

def frame_signal_dynamic(signal, frame_sizes, positions):
    # Dziel sygnał na ramki o zmiennej długości
    frames = []
    idx = 0
    for N, pos in zip(frame_sizes, positions):
        frame = signal[pos:pos+N]
        if len(frame) < N:
            frame = np.pad(frame, (0, N-len(frame)))
        frames.append(frame)
    return np.array(frames)

def reconstruct_signal_dynamic(frames, frame_sizes, positions, signal_length):
    # Składanie sygnału z nakładających się ramek o zmiennej długości
    signal = np.zeros(signal_length + max(frame_sizes))
    for frame, N, pos in zip(frames, frame_sizes, positions):
        signal[pos:pos+N] += frame
    return signal[:signal_length]

# Przykład użycia:
fs = 44100
t = np.linspace(0, 0.2, int(0.2*fs), endpoint=False)
audio = np.sin(2*np.pi*440*t) + 0.5*np.sin(2*np.pi*880*t)

# Ustal miejsca zmiany długości okna
positions = [0, 4096, 4096+128, 4096+128+32]
frame_sizes = [128, 128, 32, 128]  # long, long2short, short, short2long

# Przygotuj okna
windows = [
    mdct_window(128),
    transition_window(128, 32, 'long2short'),
    mdct_window(32),
    transition_window(128, 32, 'short2long')
]

# Przygotuj macierze MDCT
A_long = mdct_matrix(128)
A_short = mdct_matrix(32)

# Analiza
frames = []
for i, (N, pos, win) in enumerate(zip(frame_sizes, positions, windows)):
    frame = audio[pos:pos+N]
    if len(frame) < N:
        frame = np.pad(frame, (0, N-len(frame)))
    windowed = frame * win
    if N == 128:
        coeffs = windowed @ A_long.T
        rec = coeffs @ A_long
    else:
        coeffs = windowed @ A_short.T
        rec = coeffs @ A_short
    frames.append(rec * win)

# Synteza
reconstructed = reconstruct_signal_dynamic(frames, frame_sizes, positions, len(audio))

# Porównanie
plt.figure(figsize=(10,4))
plt.plot(audio, label='oryginał')
plt.plot(reconstructed[:len(audio)], '--', label='po analizie-syntezie')
plt.legend()
plt.title('Porównanie sygnału przed i po dynamicznej zmianie długości okna MDCT')
plt.show()

print("Maksymalny błąd rekonstrukcji:", np.max(np.abs(audio - reconstructed[:len(audio)])))