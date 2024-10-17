function um = zar_model(a,i)
% model zrowki: u=f(i) - wielomian 3 stopnia, szukamy wspolczynnikow a 
um = a(3)*i.^3 + a(2)*i.^2 + a(1)*i;  % napiecie zarowki jako funkcja pradu 