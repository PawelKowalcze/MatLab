import matplotlib
matplotlib.use('TkAgg')
import numpy as np
import matplotlib.pyplot as plt

# Parameters
t = 10  # time duration in seconds
fs = 44100  # sampling frequency in Hz
f1 = 1000  # starting frequency in Hz
fd = 5000  # frequency change per second in Hz

# Time array
time = np.linspace(0, t, int(fs * t))

# Frequency array
frequency = f1 + fd * time

# Sinusoidal signal
signal = np.sin(2 * np.pi * frequency * time)

# Plotting the signal
plt.plot(time, signal)
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.title('Sinusoidal Signal')
plt.grid(True)
plt.show()