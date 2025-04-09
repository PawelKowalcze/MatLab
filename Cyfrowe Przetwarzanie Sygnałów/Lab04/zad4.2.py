import numpy as np
import scipy.io
import matplotlib.pyplot as plt

def read_fft_result(filename, dtype):
    data = np.fromfile(filename, dtype=dtype)
    real_part = data[0::2]
    imag_part = data[1::2]
    return real_part + 1j * imag_part

def compare_signals(x, X2, label):
    difference = np.abs(x - X2)
    if np.any(difference > 1e-10):
        print(f"The signals {label} are significantly different.")
    else:
        print(f"The signals {label} are similar.")

def main():
    # Read the reference FFT result from MATLAB
    x = read_fft_result('xcpp.dat', np.float64)

    # Read the FFT results from C/C++ files
    X_float = read_fft_result('fft_float.dat', np.float32)
    X_double = read_fft_result('fft_double.dat', np.float64)

    # Compare results
    compare_signals(x, X_float, 'float')
    compare_signals(x, X_double, 'double')

    # Plot results for visual comparison
    plt.figure(figsize=(12, 6))
    plt.plot(np.abs(x), label='x (MATLAB)')
    plt.plot(np.abs(X_float), label='X_float (C/C++)', linestyle='--')
    plt.plot(np.abs(X_double), label='X_double (C/C++)', linestyle=':')
    plt.xlabel('Frequency Bin')
    plt.ylabel('Magnitude')
    plt.title('Comparison of FFT Results')
    plt.legend()
    plt.grid()
    plt.show()

if __name__ == "__main__":
    main()