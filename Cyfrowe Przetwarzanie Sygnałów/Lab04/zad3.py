import numpy as np
import time

from matplotlib import pyplot as plt

# Parametry
N = 1024

# Generowanie losowych danych o rozkładzie normalnym
x = np.random.normal(size=N)
# x = np.sin(2 * np.pi * 200 * np.arange(N) / N) + np.sin(2 * np.pi * 800 * np.arange(N) / N)

# Tworzenie sygnału pomocniczego y(n)
y = x[0::2] + 1j * x[1::2]

# Wykonanie N/2-punktowej transformaty Fouriera
start_time_alternate = time.perf_counter_ns()
Y = np.fft.fft(y)
end_time_alternate = time.perf_counter_ns()

# Odtworzenie pełnej transformaty X(k)
X = np.zeros(N, dtype=complex)
N2 = N // 2
for k in range(1, N2):
    W_k = np.exp(-2j * np.pi * k / N)  # Czynnik wagowy
    X[k] = 0.5 * (Y[k] + np.conj(Y[N2 - k])) + 0.5 * W_k * ( np.conj(Y[N2 - k]) - Y[k])
    X[N - k] = np.conj(X[k])  # Wykorzystanie symetrii

# Specjalne przypadki
X[0] = np.real(Y[0]) + np.imag(Y[0])
X[N2-1] = np.real(Y[N2-1]) - 1j * np.imag(Y[N2-1])

# Wykonanie standardowej N-punktowej transformaty FFT dla porównania
start_time_standard = time.perf_counter_ns()
X_standard = np.fft.fft(x)
end_time_standard = time.perf_counter_ns()

# Obliczenie czasu wykonania
time_alternate = end_time_alternate - start_time_alternate
time_standard = end_time_standard - start_time_standard


print(f"Czas wykonania metody alternatywnej: {time_alternate} ns")
print(f"Czas wykonania standardowej FFT: {time_standard} ns")


# Wykresy
plt.figure(figsize=(12, 6))

# Wykres amplitudy X
plt.subplot(2, 1, 1)
plt.plot(np.abs(X), label='Metoda alternatywna')
plt.plot(np.abs(X_standard), label='Standardowa FFT', linestyle='dashed')
plt.title('Amplituda X')
plt.xlabel('Indeks')
plt.ylabel('Amplituda')
plt.legend()
plt.grid()

# Wykres fazy X
plt.subplot(2, 1, 2)
plt.plot(np.angle(X), label='Metoda alternatywna')
plt.plot(np.angle(X_standard), label='Standardowa FFT', linestyle='dashed')
plt.title('Faza X')
plt.xlabel('Indeks')
plt.ylabel('Faza [rad]')
plt.legend()
plt.grid()

plt.tight_layout()
plt.show()