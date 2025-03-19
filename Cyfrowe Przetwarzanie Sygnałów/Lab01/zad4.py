import matplotlib
matplotlib.use('TkAgg')
import numpy as np
import matplotlib.pyplot as plt
from scipy.io.wavfile import write

# Parameters
name = "Pawel"
fpr = 16000  # Hz
T = 0.1  # seconds
fc0 = 500  # Hz for bit '0'
fc1 = 500  # Hz for bit '1' (negative sinusoid)

# Convert name to binary
binary_string = ''.join(format(ord(char), '08b') for char in name)
print(binary_string)

# Generate signal
t = np.arange(0, T, 1 / fpr)
signal = np.array([])

for bit in binary_string:
    if bit == '0':
        signal = np.concatenate((signal, np.sin(2 * np.pi * fc0 * t)))
    else:
        signal = np.concatenate((signal, -np.sin(2 * np.pi * fc1 * t)))

# Plot the signal
plt.figure(figsize=(10, 5))
plt.plot(np.arange(len(signal)) / fpr, signal)
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.title('Transmitted Signal')
plt.grid()
plt.show()

# Save the signal to a WAV file
write('transmitted_signal.wav', fpr, signal.astype(np.float32))

# Play the signal at different sampling rates
sampling_rates = [8000, 16000, 24000, 32000, 48000]
for rate in sampling_rates:
    write(f'transmitted_signal_{rate}.wav', rate, signal.astype(np.float32))
#
# To answer the questions:
# Faster Transmission: To transmit the same bits faster, you can reduce the duration ( T ) of each bit. Alternatively, you can transmit multiple bits simultaneously by using different amplitudes and phases for the sinusoidal signals. This method is known as Quadrature Amplitude Modulation (QAM).
# Program to Decode the Signal: Yes, you can write a program to decode the signal by analyzing the frequency and phase of each segment of the signal.

from scipy.signal import find_peaks

def decode_signal(signal, fpr, T, fc0, fc1):
    bit_duration = int(T * fpr)
    num_bits = len(signal) // bit_duration
    decoded_bits = []

    for i in range(num_bits):
        segment = signal[i * bit_duration:(i + 1) * bit_duration]
        avg_amplitude = np.mean(segment)
        if avg_amplitude > 0:
            decoded_bits.append('1')
        else:
            decoded_bits.append('0')

    return ''.join(decoded_bits)

# Decode the signal
decoded_binary = decode_signal(signal, fpr, T, fc0, fc1)
print(decoded_binary)
decoded_name = ''.join(chr(int(decoded_binary[i:i+8], 2)) for i in range(0, len(decoded_binary), 8))
print(f'Decoded Name: {decoded_name}')

# To transmit bits faster, you can use techniques like QAM, where you modulate both the amplitude and phase of the carrier signal. Here is an example of how to implement QAM:
def generate_qam_signal(binary_string, fpr, T, fc):
    t = np.arange(0, T, 1 / fpr)
    signal = np.array([])

    for i in range(0, len(binary_string), 2):
        bit_pair = binary_string[i:i+2]
        if bit_pair == '00':
            signal = np.concatenate((signal, np.sin(2 * np.pi * fc * t)))
        elif bit_pair == '01':
            signal = np.concatenate((signal, np.sin(2 * np.pi * fc * t + np.pi / 2)))
        elif bit_pair == '10':
            signal = np.concatenate((signal, np.sin(2 * np.pi * fc * t + np.pi)))
        else:
            signal = np.concatenate((signal, np.sin(2 * np.pi * fc * t + 3 * np.pi / 2)))

    return signal

# Generate QAM signal
qam_signal = generate_qam_signal(binary_string, fpr, T, fc0)

# Plot the QAM signal
plt.figure(figsize=(10, 5))
plt.plot(np.arange(len(qam_signal)) / fpr, qam_signal)
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.title('QAM Transmitted Signal')
plt.grid()
plt.show()

# Save the QAM signal to a WAV file
write('qam_transmitted_signal.wav', fpr, qam_signal.astype(np.float32))
# This code generates a QAM signal by modulating both the amplitude and phase of the carrier signal. You can decode this signal by analyzing the amplitude and phase of each segment.
