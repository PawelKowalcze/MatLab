import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy.ndimage import gaussian_filter
from skimage.morphology import remove_small_objects, binary_dilation, binary_erosion
from skimage.measure import label
from skimage.morphology import disk
from skimage.segmentation import clear_border

#reading the image ant converting it to grayscale
img = cv2.imread('car1.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
plt.figure()
plt.imshow(gray, cmap='gray')
plt.title('Image 1 in grayscale')
plt.axis('off')

#low-pass filtering
blurred = gaussian_filter(gray, sigma=2)    #counterpar of matlab's fspecial('gaussian,...)
plt.figure()
plt.imshow(blurred, cmap='gray')
plt.title('Blurred Image -> afeter low-pass filtering')
plt.axis('off')

#quantization
quantized = np.round(blurred).astype(np.uint8)

#adjusting binary threshold
lt = 100
ut = 200

#binarization
binary = np.where((quantized >= lt) & (quantized <= ut), 1, 0).astype(np.uint8)
plt.figure()
plt.imshow(binary, cmap='gray')
plt.title('Binarized Image')
plt.axis('off')

#morfological operations
binary = binary_dilation(binary, footprint=disk(1))
plt.figure()
plt.imshow(binary, cmap='gray')
plt.title('Dilated Image')
plt.axis('off')

binary = binary_erosion(binary, footprint=disk(1))
plt.figure()
plt.imshow(binary, cmap='gray')
plt.title('Eroded Image')
plt.axis('off')

binary_filled = cv2.morphologyEx(binary.astype(np.uint8), cv2.MORPH_CLOSE, np.ones((3,3),np.uint8))
binary_filled = cv2.morphologyEx(binary_filled, cv2.MORPH_OPEN, np.ones((3,3),np.uint8))
binary_filled = cv2.morphologyEx(binary_filled, cv2.MORPH_CLOSE, np.ones((3,3),np.uint8))
binary_filled = cv2.morphologyEx(binary_filled, cv2.MORPH_DILATE, np.ones((3,3),np.uint8))
binary_filled = cv2.morphologyEx(binary_filled, cv2.MORPH_ERODE, np.ones((3,3),np.uint8))

#wypełnianie dziur
binary_filled = cv2.morphologyEx(binary_filled, cv2.MORPH_CLOSE, np.ones((5,5),np.uint8))
binary_filled = cv2.morphologyEx(binary_filled, cv2.MORPH_OPEN, np.ones((5,5),np.uint8))
plt.figure()
plt.imshow(binary_filled, cmap='gray')
plt.title('Binary Image after Morphological Operations')
plt.axis('off')

#usuwanie małych obiektów
label_image = label(binary_filled)
cleaned = remove_small_objects(label_image, min_size=500)
binary_cleaned = (cleaned > 0).astype(np.uint8)
plt.figure()
plt.imshow(binary_cleaned, cmap='gray')
plt.title('Cleaned Binary Image')
plt.axis('off')

#curve detection -> Sobel
sobel_edges = cv2.Sobel(binary_cleaned, cv2.CV_64F, 1, 1, ksize=3)
plt.figure()
plt.imshow(np.abs(sobel_edges), cmap='gray')
plt.title('Sobel Edge Detection')
plt.axis('off')

#curve detection -> Prewitt (manual mask)
kernel_x = np.array([[1, 0, -1], [1, 0, -1], [1, 0, -1]], dtype=int)
kernel_y = np.array([[1, 1, 1], [0, 0, 0], [-1, -1, -1]], dtype=int)
prewitt_x = cv2.filter2D(binary_cleaned, -1, kernel_x)
prewitt_y = cv2.filter2D(binary_cleaned, -1, kernel_y)
prewitt_edges = cv2.magnitude(prewitt_x.astype(np.float32), prewitt_y.astype(np.float32))
plt.figure()
plt.imshow(prewitt_edges, cmap='gray')
plt.title('Prewitt Edge Detection')
plt.axis('off')

#curve detection -> Canny
canny_edges = cv2.Canny((binary_cleaned*255).astype(np.uint8), 50, 150)
plt.figure()
plt.imshow(canny_edges, cmap='gray')
plt.title('Canny Edge Detection')
plt.axis('off')

plt.show()