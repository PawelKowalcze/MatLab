    
clear all; close all;

load sygnaly_astma.mat    % macierze 1024 (probki) x 130 (sygnalow): oddechAstma i oddechNorma:  

load widmo1DAstma.mat  % 36x130: 130 kolumn (sygnały) po 36 wsp. widmowych w kolumnie
load widmo1DNorma.mat  % 36x130: 130 kolumn (sygnały) po 36 wsp. widmowych w kolumnie
    
load widmo2DAstma.mat  % 25x25x130: 130 macierzy (sygnaly) 25x25 (x=czestotliwosc, y=czas) 
load widmo2DNorma.mat  % 25x25x130: 130 macierzy (sygnaly) 25x25 (x=czestotliwosc, y=czas)

whos

oddech_Astma  = oddechAstma';              
oddech_Norma  = oddechNorma';            
widmo1D_Astma = widmo1DAstma';             
widmo1D_Norma = widmo1DNorma';             
widmo2D_Astma = reshape( widmo2DAstma(:), 25*25, 130 )';             
widmo2D_Norma = reshape( widmo2DNorma(:), 25*25, 130 )';

whos