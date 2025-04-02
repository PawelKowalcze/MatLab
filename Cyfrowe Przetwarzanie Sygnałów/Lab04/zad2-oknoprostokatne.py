import numpy as np
import matplotlib.pyplot as plt

# Parametry
fpr = 1000  # częstotliwość próbkowania (Hz)
N = 100  # liczba próbek sygnału
dt = 1 / fpr
t = dt * np.arange(N)  # chwile próbkowania sygnału, oś czasu

# Sygnał
f0 = 125
x = 10 * np.sin(2 * np.pi * f0 * t)  # sygnał o częstotliwości f0 = 50 Hz

# Wykres sygnału
plt.figure()
plt.plot(t, x, 'bo-')
plt.xlabel('t [s]')
plt.title('x(t)')
plt.grid()
plt.show()

# FFT spektrum
X = np.fft.fft(x)  # FFT
f = fpr / N * np.arange(N)  # oś częstotliwości

# Wykres FFT
plt.figure()
plt.plot(f, 1 / N * np.abs(X), 'bo-')
plt.xlabel('f [Hz]')
plt.title('|X(k)|')
plt.grid()
plt.show()

# Symetria hermitowska widma wynika z właściwości transformaty Fouriera sygnałów rzeczywistych.
# Gdy sygnał w dziedzinie czasu jest rzeczywisty, jego transformata Fouriera ma pewne symetryczne właściwości
# w dziedzinie częstotliwości.
#
# Dla sygnału rzeczywistego ( x(n) ), jego dyskretna transformata Fouriera (DFT) ( X(k) ) spełnia następujące warunki:
# [ X(N-k) = X^*(k) ]
# gdzie:
# ( X(k) ) to wartość DFT dla indeksu ( k ),
# ( X^*(k) ) to sprzężenie zespolone ( X(k) ),
# ( N ) to liczba próbek sygnału.
# Oznacza to, że widmo DFT sygnału rzeczywistego jest symetryczne względem środka,
# a wartości po jednej stronie osi częstotliwości są sprzężone zespolone z wartościami po drugiej stronie.
# Przykład:
# Jeśli ( X(1) = a + jb ), to ( X(N-1) = a - jb ).

# Symetria hermitowska jest kluczowa w analizie sygnałów, ponieważ pozwala na redukcję ilości danych
# potrzebnych do reprezentacji widma sygnału rzeczywistego. W praktyce oznacza to,
# że wystarczy znać tylko połowę widma, aby odtworzyć pełne widmo sygnału rzeczywistego.

# Wartości maksimów widma są dwa razy niższe niż spodziewane, ponieważ w analizie Fouriera
# sygnałów sinusoidalnych i cosinusoidalnych, amplituda sygnału jest rozdzielana na dwie części
# w widmie częstotliwości. Dla sygnału sinusoidalnego ( \sin(\alpha) ) mamy:
#
# sin(alpha) = (e^j*alpha - e^j*alpha)/2j
#
# Podobnie jak w przypadku cosinusa, gdzie:
#
# cos(alpha) = (e^j*alpha + e^j*alpha)/2
#
# W wyniku tego rozdzielenia, każda część widma (dla dodatnich i ujemnych częstotliwości)
# zawiera połowę amplitudy sygnału. Dlatego wartości maksimów widma są dwa razy niższe niż spodziewane,
# ponieważ każda część widma reprezentuje tylko połowę całkowitej amplitudy sygnału.
