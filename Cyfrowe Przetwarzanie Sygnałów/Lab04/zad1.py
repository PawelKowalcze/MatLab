import numpy as np
from matplotlib import pyplot as plt

# Krok 1: Wygeneruj losowy sygnał x o długości 1024 próbek
N = 1024
x = np.random.rand(N)

# Krok 2: Oblicz DFT sygnału x
X = np.fft.fft(x)

# Krok 3: Podziel sygnał na próbki parzyste i nieparzyste
x_even = x[::2]
x_odd = x[1::2]

# Krok 4: Oblicz DFT próbek parzystych i nieparzystych
X1 = np.fft.fft(x_even)
X2 = np.fft.fft(x_odd)

# Krok 5: Wyznacz Xfft zgodnie z podanym wzorem (6)
k = np.arange(N // 2)
Wn = np.exp(-2j * np.pi * k / N)
Xfft = np.concatenate([X1 + Wn * X2, X1 - Wn * X2])

# Krok 6: Podziel próbki parzyste i nieparzyste na kolejne parzyste i nieparzyste
x_even_even = x_even[::2]
x_even_odd = x_even[1::2]
x_odd_even = x_odd[::2]
x_odd_odd = x_odd[1::2]

# Krok 7: Oblicz DFT dla tych podziałów i wyznacz X1 oraz X2 zgodnie z podanym wzorem (2)
X11 = np.fft.fft(x_even_even)
X12 = np.fft.fft(x_even_odd)
X21 = np.fft.fft(x_odd_even)
X22 = np.fft.fft(x_odd_odd)

k_half = np.arange(N // 4)
Wn_half = np.exp(-2j * np.pi * k_half / (N // 2))
X1_new = np.concatenate([X11 + Wn_half * X12, X11 - Wn_half * X12])
X2_new = np.concatenate([X21 + Wn_half * X22, X21 - Wn_half * X22])
Xnew = np.concatenate([X1_new + Wn * X2_new, X1_new - Wn * X2_new])

# Wyniki
print("len(X):", len(X))
print("len(Xfft):", len(Xfft))
print("len(X1):", len(X1))
print("len(X2):", len(X2))
print("len(X11):", len(X11))
print("len(X12):", len(X12))
print("len(X21):", len(X21))
print("len(X22):", len(X22))
X[0] = 0
Xfft[0] = 0
Xnew[0] = 0
# Krok 8: Narysuj wykresy dla X, Xfft oraz X1_new + X2_new
plt.figure(figsize=(12, 6))
plt.plot(np.abs(X))
plt.xlabel('Próbka')
plt.ylabel('Amplituda')
plt.title('Widmo DFT (X)')
plt.grid()
plt.show()

plt.figure(figsize=(12, 6))
plt.plot(np.abs(Xfft))
plt.xlabel('Próbka')
plt.ylabel('Amplituda')
plt.title('Widmo DFT (Xfft)')
plt.grid()
plt.show()

plt.figure(figsize=(12, 6))
plt.plot(np.abs(Xnew))
plt.xlabel('Próbka')
plt.ylabel('Amplituda')
plt.title('Widmo DFT (Xnew)')
plt.grid()
plt.show()