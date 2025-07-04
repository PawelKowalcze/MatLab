function auto_tabdet()
    close all; clc;

    % 1. Wczytaj obraz
    img = imread('car1.jpg'); % lub inny obraz
    img_gray = rgb2gray(img);

    img_gray = adapthisteq(img_gray); % poprawa kontrastu dla car1.jpg. zakomentować dla car2.jpg

    % 2. Binaryzacja – próg jasności
    % Dla car2.jpg
    %bin = img_gray > 120 & img_gray < 255; % dostosuj wartości!
    % Dla car1.jpg
    bin = img_gray > 120 & img_gray < 230;
    figure; imshow(bin); title('Maska binarna jasnych obszarów');

    % 3. Morfologia – usuwanie szumów i wypełnienie
    bin_clean = bwareaopen(bin, 100); % usuń małe obszary
    bin_fill = imfill(bin_clean, 'holes'); % wypełnij dziury
    se = strel('rectangle', [3,7]);
    bin_close = imclose(bin_fill, se);
    figure; imshow(bin_close); title('Po morfologii');

    % 4. Etykietowanie
    [L, num] = bwlabel(bin_close);
    props = regionprops(L, 'BoundingBox', 'Area', 'Eccentricity', 'Extent');

    % 5. Wybór tablicy – na podstawie cech
    best_idx = 0;
    for i = 1:num
        bb = props(i).BoundingBox;
        ratio = bb(3) / bb(4); % szerokość / wysokość
        % Dla car2.jpg
        %if ratio > 2 && ratio < 6 && props(i).Area > 1000 && props(i).Extent > 0.5
        % Dla car1.jpg
        if ratio > 2 && ratio < 6 && props(i).Area > 2000 && props(i).Extent > 0.4 
            best_idx = i;
            break;
        end
    end

    % 6. Wyodrębnienie maski tablicy
    if best_idx > 0
        tablica_maska = (L == best_idx);
        figure; imshow(tablica_maska); title('Maska tablicy');
    else
        error('Nie znaleziono tablicy!');
    end

    % 7. Wymnożenie z oryginałem
    img_tablica = img;
    for c = 1:3
        temp = img(:,:,c);
        temp(~tablica_maska) = 255; % tło na biało
        img_tablica(:,:,c) = temp;
    end
    figure; imshow(img_tablica); title('Wymnożenie z maską');

    % 8. Wycięcie i zapis
    [y, x] = find(tablica_maska);
    x1 = min(x); x2 = max(x);
    y1 = min(y); y2 = max(y);
    tab_crop = img_tablica(y1:y2, x1:x2, :);
    figure; imshow(tab_crop); title('Wycięta tablica');
    imwrite(tab_crop, 'tab_dop.jpg');

    % (opcjonalnie) 9. Usuwanie liter – np. ręcznie: imcontrast() + maskowanie

    % Usuwanie liter z tablicy
    gray_crop = rgb2gray(tab_crop);
    
    % Litery są ciemne – użyj ręcznego progu
    letter_thresh = 100; % eksperymentalnie dobrana wartość
    bin_letters = gray_crop < letter_thresh; % litery to piksele < 100
    
    % Wyznacz tło (piksele nie będące literami) – użyj mediany
    bg_val = mean(gray_crop(~bin_letters)) - 60; % jasność tła, -60 dla car1.jpg
    
    % Stwórz kopię i zamień litery na tło
    gray_no_text = gray_crop;
    gray_no_text(bin_letters) = bg_val;
    
    % Jeśli chcesz zapisać wynik jako kolorowy obraz
    tab_no_text = repmat(uint8(gray_no_text), [1 1 3]);
    figure; imshow(tab_no_text); title('Tablica bez liter (poprawiona)');
    imwrite(tab_no_text, 'tab_bez_liter.jpg');


    % 10. Dopasowanie do wzorca (reg_AT_MI.m)
    % zakładając, że masz: tab_dop.jpg, tab_wz.jpg
end

auto_tabdet,