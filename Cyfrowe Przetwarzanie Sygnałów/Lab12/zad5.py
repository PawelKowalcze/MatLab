import cv2
import numpy as np
import matplotlib.pyplot as plt
from skimage.measure import label, regionprops
from skimage.morphology import remove_small_objects, closing, footprint_rectangle
from scipy.ndimage import binary_fill_holes
from skimage.transform import AffineTransform, warp, resize
from skimage.metrics import normalized_mutual_information as mutual_information


# === KROK 1: Wczytanie obrazu ===
image = cv2.imread("car1.jpg")
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Binaryzacja jasnych obszarów (zakładamy że tablica jest jasna)
_, binary = cv2.threshold(gray, 200, 255, cv2.THRESH_BINARY)

# === KROK 2: Operacje morfologiczne i filtracja ===
binary_cleaned = closing(binary, footprint_rectangle((3, 3)))
binary_filled = binary_fill_holes(binary_cleaned)
binary_filtered = remove_small_objects(binary_filled.astype(bool), min_size=1000)

# Etykietowanie komponentów
label_image = label(binary_filtered)

# === KROK 3: Wybór najlepszego regionu ===
regions = regionprops(label_image)
candidate = None
max_aspect = 0

for region in regions:
    minr, minc, maxr, maxc = region.bbox
    width = maxc - minc
    height = maxr - minr
    aspect_ratio = width / height

    if 2 < aspect_ratio < 6:
        if aspect_ratio > max_aspect:
            max_aspect = aspect_ratio
            candidate = region

mask = np.zeros_like(label_image, dtype=np.uint8)
if candidate:
    mask[label_image == candidate.label] = 255
else:
    print("Tablica nie znaleziona, użyj tab_dop.jpg")

# === KROK 4: Wyodrębnienie tablicy z oryginalnego obrazu ===
mask_bool = mask.astype(bool)
output_plate = image.copy()
output_plate[~mask_bool] = [255, 255, 255]

# === KROK 5: Wycięcie tablicy ===
ys, xs = np.nonzero(mask)
min_x, max_x = xs.min(), xs.max()
min_y, max_y = ys.min(), ys.max()
pad = 5
min_x, max_x = max(min_x - pad, 0), min(max_x + pad, image.shape[1])
min_y, max_y = max(min_y - pad, 0), min(max_y + pad, image.shape[0])
cropped_plate = output_plate[min_y:max_y, min_x:max_x]

# === KROK 6: Dopasowanie do wzorca ===
ref_img = cv2.imread("tab_wz.jpg", cv2.IMREAD_GRAYSCALE)
target_img = cv2.cvtColor(cropped_plate, cv2.COLOR_BGR2GRAY)
target_img_resized = resize(target_img, ref_img.shape, anti_aliasing=True)

best_mi = -np.inf
best_transform = None

for angle in np.linspace(-10, 10, 20):
    for tx in range(-10, 11, 2):
        for ty in range(-10, 11, 2):
            tform = AffineTransform(scale=(1, 1), rotation=np.deg2rad(angle),
                                    translation=(tx, ty))
            warped = warp(target_img_resized, tform.inverse, output_shape=ref_img.shape)
            mi = mutual_information(ref_img.ravel(), warped.ravel())

            if mi > best_mi:
                best_mi = mi
                best_transform = tform
                best_warped = warped

# === WIZUALIZACJA ===
plt.figure(figsize=(10, 4))
plt.subplot(1, 2, 1)
plt.imshow(ref_img, cmap='gray')
plt.title("Obraz wzorcowy")

plt.subplot(1, 2, 2)
plt.imshow(best_warped, cmap='gray')
plt.title(f"Dopasowany obraz (MI={best_mi:.2f})")
plt.tight_layout()
plt.show()
