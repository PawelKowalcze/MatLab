#include <iostream>
#include <fstream>
#include <vector>
#include <complex>
#include <cmath>

using namespace std;

constexpr double PI = 3.14159265358979323846;

// FFT radix-2 dla wektorów zespolonych (szablon dla float i double)
template <typename T>
void fft(vector<complex<T>>& a) {
    size_t n = a.size();
    if (n <= 1) return;

    vector<complex<T>> even(n / 2), odd(n / 2);
    for (size_t i = 0; i < n / 2; i++) {
        even[i] = a[i * 2];
        odd[i] = a[i * 2 + 1];
    }

    fft(even);
    fft(odd);

    for (size_t i = 0; i < n / 2; i++) {
        complex<T> t = polar<T>(1.0, -2 * PI * i / n) * odd[i];
        a[i] = even[i] + t;
        a[i + n / 2] = even[i] - t;
    }
}

// Funkcja do wczytania danych binarnych
template <typename T>
vector<complex<T>> load_data(const string& filename) {
    ifstream file(filename, ios::binary);
    vector<complex<T>> data;
    if (!file) {
        cerr << "Nie można otworzyć pliku: " << filename << endl;
        return data;
    }

    while (file) {
        T real, imag;
        file.read(reinterpret_cast<char*>(&real), sizeof(T));
        file.read(reinterpret_cast<char*>(&imag), sizeof(T));
        if (file) data.emplace_back(real, imag);
    }

    return data;
}

// Funkcja do zapisu wyników FFT
template <typename T>
void save_data(const string& filename, const vector<complex<T>>& data) {
    ofstream file(filename, ios::binary);
    for (const auto& c : data) {
        T real = c.real();
        T imag = c.imag();
        file.write(reinterpret_cast<const char*>(&real), sizeof(T));
        file.write(reinterpret_cast<const char*>(&imag), sizeof(T));
    }
}

int main() {
    // Wczytanie sygnału w precyzji double
    vector<complex<double>> signal_double = load_data<double>("xcpp.dat");
    vector<complex<float>> signal_float(signal_double.begin(), signal_double.end());

    // Wykonanie FFT dla double
    fft(signal_double);
    save_data("fft_double.dat", signal_double);

    // Wykonanie FFT dla float
    fft(signal_float);
    save_data("fft_float.dat", signal_float);

    cout << "Transformacja FFT zakończona. Wyniki zapisane w fft_double.dat i fft_float.dat." << endl;
    return 0;
}
