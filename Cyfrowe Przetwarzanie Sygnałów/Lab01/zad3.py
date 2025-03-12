import numpy as np
import scipy.io
import matplotlib.pyplot as plt

# Load the .mat file
mat = scipy.io.loadmat('adsl_x.mat')
# print(mat.keys())
signal = mat['x'].flatten()

# Define the parameters
M = 32
N = 512
K = 4


# Custom cross-correlation function
def cross_correlation(x, y):
    n = len(x)
    corr = np.zeros(n)
    for lag in range(n):
        for i in range(n - lag):
            corr[lag] += x[i] * y[i + lag]
    return corr


# Find the start of each prefix
prefix_starts = []
for k in range(K):
    block_start = k * (M + N)
    block_end = block_start + M + N
    block = signal[block_start:block_end]

    prefix = block[:M]
    suffix = block[-M:]

    corr = cross_correlation(prefix, suffix)
    max_corr_index = np.argmax(corr)

    prefix_start = block_start + max_corr_index
    prefix_starts.append(prefix_start)

# Print the start of each prefix
for i, start in enumerate(prefix_starts):
    print(f'Start of prefix {i + 1}: {start}')

# Optional: Plot the signal and mark the prefix starts
plt.figure(figsize=(10, 5))
plt.plot(signal, label='ADSL Signal')
for start in prefix_starts:
    plt.axvline(x=start, color='r', linestyle='--', label=f'Prefix start at {start}')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.title('ADSL Signal with Prefix Starts')
plt.legend()
plt.grid()
plt.show()