import matplotlib
matplotlib.use('TkAgg')
import numpy as np
import matplotlib.pyplot as plt

# Parameters
N = 100
fs = 1000
t = np.arange(N) / fs
f1, f2, f3 = 50, 100, 150
A1, A2, A3 = 50, 100, 150


# Generate the signal x
x = A1 * np.sin(2 * np.pi * f1 * t) + A2 * np.sin(2 * np.pi * f2 * t) + A3 * np.sin(2 * np.pi * f3 * t)

# Function to generate DCT-II matrix
def generate_dct_matrix(N):
    A = np.zeros((N, N))
    s = np.sqrt(2 / N)
    s0 = np.sqrt(1 / N)
    for k in range(N):
        sk = s0 if k == 0 else s
        for n in range(N):
            A[k, n] = sk * np.cos((np.pi * k / N) * (n + 0.5))
    return A

# Generate the analysis matrix A and synthesis matrix S
A = generate_dct_matrix(N)
S = A.T

# Display rows of A and columns of S
# for i in range(N):
#     plt.figure()
#     plt.plot(A[i], label=f'Row {i} of A')
#     plt.plot(S[:, i], label=f'Column {i} of S')
#     plt.legend()
#     plt.pause(0.5)
#     plt.close()

# Perform analysis y = Ax
y = np.dot(A, x)

# Display the values of y(1:N)
print("Values of y(1:N):")
print(y)

# Compare the non-zero coefficients with the amplitudes of the signal components
non_zero_indices = np.where(y > 1e-10)[0]
print("Non-zero coefficients and their corresponding amplitudes:")
for idx in non_zero_indices:
    print(f"Index: {idx}, Coefficient: {y[idx]}")

# Scale the frequency axis
frequencies = (np.arange(N) * fs) / (2 * N)

# Plot the analysis result
plt.figure()
plt.stem(frequencies, y)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.title('DCT Analysis')
plt.grid()
plt.show()

# Check perfect reconstruction
xr = np.dot(S, y)
is_perfect_reconstruction = np.allclose(xr, x)
print(f"Perfect reconstruction: {is_perfect_reconstruction}")

# Modify the frequency f2 to 105 Hz and analyze again
f2 = 105
x = A1 * np.sin(2 * np.pi * f1 * t) + A2 * np.sin(2 * np.pi * f2 * t) + A3 * np.sin(2 * np.pi * f3 * t)
y = np.dot(A, x)

# Plot the analysis result with modified frequency
plt.figure()
plt.stem(frequencies, y)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.title('DCT Analysis with f2 = 105 Hz')
plt.grid()
plt.show()

# Check perfect reconstruction with modified frequency
xr = np.dot(S, y)
is_perfect_reconstruction = np.allclose(xr, x)
print(f"Perfect reconstruction with f2 = 105 Hz: {is_perfect_reconstruction}")

# Increase all frequencies by 2.5 Hz and analyze
f1, f2, f3 = 52.5, 107.5, 152.5
x = A1 * np.sin(2 * np.pi * f1 * t) + A2 * np.sin(2 * np.pi * f2 * t) + A3 * np.sin(2 * np.pi * f3 * t)
y = np.dot(A, x)

# Plot the analysis result with increased frequencies
plt.figure()
plt.stem(frequencies, y)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.title('DCT Analysis with frequencies increased by 2.5 Hz')
plt.grid()
plt.show()