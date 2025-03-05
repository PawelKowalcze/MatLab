
% Rotacja - test kierunku

phi = pi/4;                                       % kąt rotacji lewoskrętnej
R = [ cos(phi), -sin(phi); sin(phi), cos(phi) ];  % macierz rotacji
v = [ 1; 0];                                      % wektor przed rotacją
vr = R * v,                                       % wektor po rotacji