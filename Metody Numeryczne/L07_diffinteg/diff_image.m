% diff_image.m
clear all; close all;

[im1,map] = imread('lena512.bmp');    % wczytaj obraz
figure; imshow(im1,map);   title('Wejsciowy obraz');
w = [ 0,  1, 0; ...                   %  
      1, -4, 1; ...                   % 
      0, 1, 0];                       % uzyta maska/filtr
im2 = conv2( im1, w);                 % splot, filtracja, suma wazona
figure; imshow(4*im2,map); title('Przetwarzony obraz');
