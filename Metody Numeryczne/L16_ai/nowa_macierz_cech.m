function X = nowa_macierz_cech( X1, X2, poly_degree)
% Utworzenie macierzy cech, uzupelnionej o cechy wielomianowe. W kolejnych kolumnach: 
% 1, X1, X2, X1.^2, X2.^2, X1*X2, X1*X2.^2, itd.
  X = ones( size(X1(:, 1)) );
  for i = 1 : poly_degree
      for j = 0 : i
          X(:, end + 1) = (X1.^(i - j)) .* (X2.^j);
      end
  end
end
