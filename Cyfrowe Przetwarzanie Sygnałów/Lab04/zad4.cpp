#include <iostream>
#include <fstream>
#include <complex>
#include <vector>
#include <cmath>

using namespace std;

// Function to perform FFT using radix-2 algorithm (float precision)
void fft_float(vector<complex<float>>& x) {
    const size_t N = x.size();
    if (N <= 1) return;

    vector<complex<float>> even(N / 2);
    vector<complex<float>> odd(N / 2);
    for (size_t i = 0; i < N / 2; ++i) {
        even[i] = x[i * 2];
        odd[i] = x[i * 2 + 1];
    }

    fft_float(even);
    fft_float(odd);

    for (size_t i = 0; i < N / 2; ++i) {
        complex<float> t = polar(1.0f, static_cast<float>(-2 * M_PI * i / N)) * odd[i];
        x[i] = even[i] + t;
        x[i + N / 2] = even[i] - t;
    }
}

// Function to perform FFT using radix-2 algorithm (double precision)
void fft_double(vector<complex<double>>& x) {
    const size_t N = x.size();
    if (N <= 1) return;

    vector<complex<double>> even(N / 2);
    vector<complex<double>> odd(N / 2);
    for (size_t i = 0; i < N / 2; ++i) {
        even[i] = x[i * 2];
        odd[i] = x[i * 2 + 1];
    }

    fft_double(even);
    fft_double(odd);

    for (size_t i = 0; i < N / 2; ++i) {
        complex<double> t = polar(1.0, -2 * M_PI * i / N) * odd[i];
        x[i] = even[i] + t;
        x[i + N / 2] = even[i] - t;
    }
}

// Function to read the signal from xcpp.dat
template <typename T>
vector<complex<T>> read_signal(const string& filename) {
    ifstream file(filename, ios::binary);
    vector<complex<T>> signal;
    T real, imag;
    while (file.read(reinterpret_cast<char*>(&real), sizeof(T)) &&
           file.read(reinterpret_cast<char*>(&imag), sizeof(T))) {
        signal.emplace_back(real, imag);
    }
    return signal;
}

// Function to save the FFT result to a file
template <typename T>
void save_fft_result(const string& filename, const vector<complex<T>>& result) {
    ofstream file(filename, ios::binary);
    for (const auto& value : result) {
        T real = value.real();
        T imag = value.imag();
        file.write(reinterpret_cast<const char*>(&real), sizeof(T));
        file.write(reinterpret_cast<const char*>(&imag), sizeof(T));
    }
}

int main() {
    // Read the signal from xcpp.dat
    auto signal_float = read_signal<float>("xcpp.dat");
    auto signal_double = read_signal<double>("xcpp.dat");

    // Perform FFT in float precision
    fft_float(signal_float);
    save_fft_result("fft_float.dat", signal_float);

    // Perform FFT in double precision
    fft_double(signal_double);
    save_fft_result("fft_double.dat", signal_double);

    cout << "FFT computation completed and results saved." << endl;
    return 0;
}