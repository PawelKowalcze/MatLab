import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
from scipy.fftpack import dct

# Load the audio signal
fs, x = wavfile.read('mowa.wav')

# Display the signal
plt.figure()
plt.plot(x)
plt.title('Audio Signal')
plt.xlabel('Sample Number')
plt.ylabel('Amplitude')
plt.show()

# Parameters
N = 256  # Length of each segment
M = 10   # Number of segments

# Generate the DCT-II matrix
def generate_dct_matrix(N):
    A = np.zeros((N, N))
    s = np.sqrt(2 / N)
    s0 = np.sqrt(1 / N)
    for k in range(N):
        sk = s0 if k == 0 else s
        for n in range(N):
            A[k, n] = sk * np.cos((np.pi * k / N) * (n + 0.5))
    return A

A = generate_dct_matrix(N)

# Select 10 different segments
segments = []
dct_results = []
for k in range(M):
    n1 = np.random.randint(0, len(x) - N)
    n2 = n1 + N
    segment = x[n1:n2]
    segments.append(segment)
    dct_result = np.dot(A, segment)
    dct_results.append(dct_result)

# Display the segments and their DCT results
frequencies = (np.arange(N) * fs) / (2 * N)
for k in range(M):
    plt.figure()
    plt.subplot(2, 1, 1)
    plt.plot(segments[k])
    plt.title(f'Segment {k+1}')
    plt.xlabel('Sample Number')
    plt.ylabel('Amplitude')

    plt.subplot(2, 1, 2)
    plt.stem(frequencies, dct_results[k])
    plt.title(f'DCT of Segment {k+1}')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Amplitude')
    plt.grid()
    plt.show()
    plt.pause(0.5)