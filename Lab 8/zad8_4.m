function [eigenvalues, eigenvectors] = jacobi_rotation(A, tol, max_iter)
    % Funkcja implementująca metodę rotacji Jacobiego
    % A - symetryczna macierz wejściowa
    % tol - tolerancja zerowania elementów poza przekątną
    % max_iter - maksymalna liczba iteracji
    %
    % eigenvalues - wartości własne (wektor)
    % eigenvectors - macierz kolumnowa wektorów własnych
    
    if ~isequal(A, A')
        error('Macierz wejściowa musi być symetryczna!');
    end
    
    N = size(A, 1);
    eigenvectors = eye(N); % Początkowo macierz jednostkowa
    
    for k = 1:max_iter
        % Znajdź największy element poza przekątną (moduł)
        [p, q, max_offdiag] = find_max_offdiag(A);
        
        % Jeśli największy element jest mniejszy niż tolerancja, zakończ
        if max_offdiag < tol
            break;
        end
        
        % Oblicz kąt obrotu
        xi = (A(q,q) - A(p,p)) / (2 * A(p,q));
        if xi >= 0
            t = -xi + sqrt(1 + xi^2);
        else
            t = -xi - sqrt(1 + xi^2);
        end
        c = 1 / sqrt(1 + t^2);
        s = t * c;
        
        % Zastosuj rotację Jacobiego
        R = eye(N);
        R(p,p) = c; R(q,q) = c;
        R(p,q) = s; R(q,p) = -s;
        
        % Aktualizuj macierz A i macierz wektorów własnych
        A = R' * A * R;
        eigenvectors = eigenvectors * R;
    end
    
    % Wartości własne - elementy na przekątnej
    eigenvalues = diag(A);
end

function [p, q, max_val] = find_max_offdiag(A)
    % Znajduje największy element poza przekątną
    % Zwraca indeksy (p, q) oraz wartość elementu
    N = size(A, 1);
    max_val = 0;
    p = 0; q = 0;
    
    for i = 1:N-1
        for j = i+1:N
            if abs(A(i,j)) > max_val
                max_val = abs(A(i,j));
                p = i;
                q = j;
            end
        end
    end
end

% użycie -----------

A = [4, 1, 2, 3; 
     1, 3, 0, 1; 
     2, 0, 2, 1; 
     3, 1, 1, 5];

tol = 1e-8;      % Tolerancja zerowania
max_iter = 100;  % Maksymalna liczba iteracji

[eigenvalues, eigenvectors] = jacobi_rotation(A, tol, max_iter);

disp('Wartości własne:');
disp(eigenvalues);

disp('Wektory własne:');
disp(eigenvectors);
