import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import freqresp

# Zadane zera i bieguny
zeros = [0 + 5j, 0 - 5j, 0 + 15j, 0 - 15j]
poles = [-0.5 + 9.5j, -0.5 - 9.5j, -1 + 10j, -1 - 10j, -0.5 + 10.5j, -0.5 - 10.5j]

# Wyznaczanie wielomianów licznikowego i mianownikowego transmitancji
b = np.poly(zeros)  # wielomian licznikowy
a = np.poly(poles)  # wielomian mianownikowy

# Zakres pulsacji
w = np.linspace(0, 30, 1000)

# Odpowiedź częstotliwościowa
_, h = freqresp((b, a), w)

# Moduł transmitancji (liniowo i w dB)
H_jw = np.abs(h)
H_db = 20 * np.log10(H_jw)

# Rysowanie wykresów
plt.figure(figsize=(12, 8))

# Wykres liniowy |H(jω)|
plt.subplot(2, 1, 1)
plt.plot(w, H_jw, color='orange')
plt.title('|H(jω)| – skala liniowa')
plt.xlabel('ω [rad/s]')
plt.ylabel('|H(jω)|')
plt.grid(True)

# Wykres w skali decybelowej
plt.subplot(2, 1, 2)
plt.plot(w, H_db, color='orange')
plt.title('20log10|H(jω)| – skala decybelowa')
plt.xlabel('ω [rad/s]')
plt.ylabel('Amplituda [dB]')
plt.grid(True)

plt.tight_layout()
plt.show()

# Opcjonalnie: wykres zer i biegunów na płaszczyźnie zespolonej
plt.figure(figsize=(6, 6))
plt.scatter(np.real(zeros), np.imag(zeros), marker='o', color='blue', label='Zera')
plt.scatter(np.real(poles), np.imag(poles), marker='x', color='red', label='Bieguny')
plt.axhline(0, color='black', linewidth=0.5)
plt.axvline(0, color='black', linewidth=0.5)
plt.title('Zera i bieguny na płaszczyźnie zespolonej')
plt.xlabel('Re')
plt.ylabel('Im')
plt.legend()
plt.grid(True)
plt.axis('equal')
plt.show()
