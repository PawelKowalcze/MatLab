import numpy as np
import scipy.io
import matplotlib.pyplot as plt

def read_mat_file(filename):
    data = scipy.io.loadmat(filename)
    return data['x'].flatten()

def read_cpp_file(filename):
    data = np.fromfile(filename, dtype=np.float64)
    real_part = data[0::2]
    imag_part = data[1::2]
    return real_part + 1j * imag_part

def perform_fft(signal):
    return np.fft.fft(signal)

def compare_signals(X1, X2):
    difference = np.abs(X1 - X2)
    if np.any(difference > 1e-10):
        print("The signals are significantly different.")
    else:
        print("The signals are similar.")

def main():
    # Read signals from files
    x1 = read_mat_file('x.mat')
    x2 = read_cpp_file('xcpp.dat')

    # Perform FFT
    X1 = perform_fft(x1)
    X2 = perform_fft(x2)

    # Compare results
    compare_signals(X1, X2)

    # Plot results for visual comparison
    plt.figure(figsize=(12, 6))
    plt.plot(np.abs(X1), label='X1 (MATLAB)')
    plt.plot(np.abs(X2), label='X2 (C/C++)', linestyle='--')
    plt.xlabel('Frequency Bin')
    plt.ylabel('Magnitude')
    plt.title('Comparison of FFT Results')
    plt.legend()
    plt.grid()
    plt.show()

if __name__ == "__main__":
    main()