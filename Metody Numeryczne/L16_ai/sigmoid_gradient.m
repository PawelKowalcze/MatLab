function g = sigmoid_gradient(z)
% Funkcja gradientu funkcji sigmoidalnej
    g = sigmoid(z) .* (1 - sigmoid(z));
end
