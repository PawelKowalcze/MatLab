import matplotlib
matplotlib.use('TkAgg')
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
from scipy.fftpack import dct, idct
import sounddevice as sd

# Load the audio file
fs, x = wavfile.read("Nagrywanie.wav")

# Plot the audio signal
plt.figure()
plt.plot(x)
plt.title('Audio Signal')
plt.xlabel('Sample Number')
plt.ylabel('Amplitude')
plt.show()

# Play the audio signal
sd.play(x, fs)
sd.wait()

# Perform DCT on the entire signal
c = dct(x, norm='ortho')

# Display the DCT coefficients
plt.figure()
plt.stem(c)
plt.title('DCT Coefficients')
plt.xlabel('Index')
plt.ylabel('Amplitude')
plt.show()

# Synthesize speech using 25% of the DCT coefficients
num_coeffs_25 = len(c) // 4
y_25 = dct(np.concatenate([c[:num_coeffs_25], np.zeros(len(c) - num_coeffs_25)]), norm='ortho')

# Play the synthesized signal with 25% coefficients
sd.play(y_25, fs)
sd.wait()

# Synthesize speech using 75% of the DCT coefficients
num_coeffs_75 = len(c) * 3 // 4
y_75 = dct(np.concatenate([np.zeros(len(c) - num_coeffs_75), c[-num_coeffs_75:]]), norm='ortho')

# Play the synthesized signal with 75% coefficients
sd.play(y_75, fs)
sd.wait()

# Zero out coefficients less than 50
c_mod = np.copy(c)
c_mod[c_mod < 50] = 0

# Perform inverse DCT
y_mod = idct(c_mod, norm='ortho')

# Play the modified signal
sd.play(y_mod, fs)
sd.wait()

# Zero out coefficients with indices from 100 to 200
c_mod2 = np.copy(c)
c_mod2[100:200] = 0

# Perform inverse DCT
y_mod2 = idct(c_mod2, norm='ortho')

# Play the modified signal
sd.play(y_mod2, fs)
sd.wait()

# Add sinusoidal noise to the signal
noise = 0.5 * np.sin(2 * np.pi * 250 / fs * np.arange(len(x)))
x_noisy = x + noise

# Plot the noisy signal
plt.figure()
plt.plot(x_noisy)
plt.title('Noisy Audio Signal')
plt.xlabel('Sample Number')
plt.ylabel('Amplitude')
plt.show()

# Play the noisy signal
sd.play(x_noisy, fs)
sd.wait()

# Perform DCT on the noisy signal
c_noisy = dct(x_noisy, norm='ortho')

# Zero out the noise coefficients
c_noisy[240:260] = 0

# Perform inverse DCT to remove noise
y_denoised = idct(c_noisy, norm='ortho')

# Plot the denoised signal
plt.figure()
plt.plot(y_denoised)
plt.title('Denoised Audio Signal')
plt.xlabel('Sample Number')
plt.ylabel('Amplitude')
plt.show()

# Play the denoised signal
sd.play(y_denoised, fs)
sd.wait()