function w = train_logistic_regress( X, y, lambda, Niter )
% adaptacyjne obliczenie wag "w" dla y = w0 + w1*x1 + w2*x2 + w3*x1^2 + w4*x2^2 +... 
% X - macierz NxM z cechami wielomianowymi, pierwsza kolumna jedynek dla w0 
% y - wektor Nx1 
% tak jak w przykladzie ai_1_kwatera.m 
 
  [N,M] = size(X);

%% Normalizacja wartosci kazdej cechy - bez jedynek zwiazanych ze wspolczynnikiem w0
  Xmean = mean( X(:,1:M) );           % oblicz srednia   kazdej cechy (kolumny)
  Xstd  =  std( X(:,1:M) );           % oblicz odch.std. kazdej cechy (kolumny)
  X(:,2:M) = X(:,2:M) -  Xmean(2:M);  % odejmij srednie w kolumnach
  X(:,2:M) = X(:,2:M) ./ Xstd(2:M);   % podziel przez odchylenia standardowe w kolumnach

%% Adapatacja wartosci wag "w"
  w_init = zeros(M,1);                % wartosci poczatkowe - same zera
  options = optimset('GradObj', 'on', 'MaxIter', Niter);
  [w, cost, exit_flag] = fminunc( @(w)(optim_callback(X, y, w, lambda)), w_init, options);
%  w = fmincg( @(w)( optim_callback(X, y, w, lambda)), w_init, options);  % do testowania

%% Denormalizacja wspolczynnikow, kolejno w0, w1, w2
  Xmean = Xmean'; Xstd = Xstd';       % transpozycja wektorow
  w(1) = w(1) - sum( w(2:M) .* Xmean(2:M) ./ Xstd(2:M) ); 
  w(2:end) = w(2:M) ./ Xstd(2:M);


end

% #########################################################################
% #########################################################################
% #########################################################################
function [cost, gradients] = optim_callback( X, y, w, lambda )
  N = length( y );                                       % liczba przykladow
  y_pred = sigmoid(X * w);                               % predykcja/prognoza/hipoteza y
  cost = cost_function(X, y, y_pred, w, lambda, N);      % obliczenie funkcji kosztu
  gradients = gradient_step(X, y, y_pred, w, lambda, N); % obliczenie gradientow dla "w"
end
% #########################################################################
function [cost] = cost_function( X, y, y_pred, w, lambda, N )
  regular = lambda/(2*N) * sum( w(2:end,1).^2 );                     % p. regularyzacji
  cost = -(1/N) * (y'*log(y_pred) + (1-y)'*log(1-y_pred)) + regular; % funkcja kosztu
end
% #########################################################################
function [gradients] = gradient_step( X, y, y_pred, w, lambda, N )
  regular = (lambda/N) * w;                                   % parametr regularyzacji 
  gradients    = (1/N) * (X'      * (y_pred - y)) + regular;  % regularyzacja dla   
  gradients(1) = (1/N) * (X(:,1)' * (y_pred - y));            % wszystkich w bez w0
end  
% #########################################################################
function y = sigmoid( x )
  y = 1 ./ (1 + exp(-x));
end
