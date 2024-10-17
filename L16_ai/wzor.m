
([ 1 1; 1 1; 1 1] * [-0.0537; 0.9463]) .* [ 1; sigmoid_gradient(2.6614); sigmoid_gradient(2.6614) ], pause

W_przed = [ 1 1;  1 1; 1 1; 1 1];
delta_po = [ -0.0218; 0.9782 ];
wektor = [ 1; sigmoid_gradient( [ 2.6614; 2.6616; 2.6614 ] )];
(W_przed * delta_po) .* wektor
pause
