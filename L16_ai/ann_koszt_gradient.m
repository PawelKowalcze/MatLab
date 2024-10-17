function [koszt, gradienty] = ann_koszt_gradient(Wagi_wektor, param_warstw, X, y, wsp_reg)

Wagi_macierze = ann_wagi_wektor2macierze( Wagi_wektor, param_warstw );
koszt         = ann_funkcja_kosztu(    Wagi_macierze, param_warstw, X, y, wsp_reg );
gradienty     = ann_propagacja_wstecz( Wagi_macierze, param_warstw, X, y, wsp_reg );

end % funkcji
