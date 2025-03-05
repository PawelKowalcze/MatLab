function C = ekstrakcja_cech( X )
% X - macierz majaca w kolumnach kolejne sygnaly
% C - macierz majaca w kolumnach 1,2,... cechy C1, C2, ... dla kolejnych sygnalow (wiersze)
% Patrz Table I w artykule:
% "Joint Application of Audio Spectral Envelope and Tonality Index
% in an E-Asthma Monitoring System", M.Wisniewski, T.Zielinski, 
% IEEE JOURNAL OF BIOMEDICAL AND HEALTH INFORMATICS, VOL. 19, NO. 3, MAY 2015

Nfft=256; Mstep=64; kfft_min=5; kfft_max=40; kfft_frag = kfft_max-kfft_min+1;
[L_probek, L_sygnalow] = size(X);                  % liczba probek sygnalu, liczba sygnalow 
L_widm = floor( (L_probek-Nfft)/Mstep ) + 1;       % liczba widm czestotliwosciowych
shaping = repmat(kaiser(Nfft,8), [1,L_sygnalow]);  % funkcja wygladzajaca powielona wiele razy

% Lacznie dla cech: ASE i TI
P_all = zeros( Nfft/2+1,  L_sygnalow );       % inicjalizacja zmiennej: energia polowy widma
P     = zeros( kfft_frag, L_sygnalow );       % inicjalizacja zmiennej: energia fragmentu widma
for ifragment = 1 : L_widm                    % PETLA: kolejne fragmenty kazdego sygnalu
    nstart = 1 + Mstep*(ifragment-1);         % numer pierwszej probki sygnalu
    nlast = nstart + (Nfft-1);                % numer ostatniej probki sygnalu
    X_frag = X( nstart:nlast, :);             % pobranie kolejnych fragmentow
    X_frag = X_frag - mean( X_frag );         % odjecie wartosci sredniej
  % X_frag = X_frag ./ max(abs( X_frag ));    % unormowanie przez w. maksymalna
    X_frag = shaping .* X_frag;               % wygladzenie sygnalow na koncach
    X_fft_all = fft( X_frag )/Nfft;           % obliczenie widm czestotliwosciowych
    X_fft_all = X_fft_all( 1 : Nfft/2+1, :);  % wyciecie polowy widma
    X_fft = X_fft_all( kfft_min:kfft_max, :); % wyciecie fragmentu widm
  % dla ASE
    P_all = P_all + X_fft_all .* conj( X_fft_all ); % akumulacja calych widm
    P = P + X_fft .* conj( X_fft );                 % akumulacja fragmentow widm
  % dla TI
    r(ifragment,:,:) = abs( X_fft );          % zapamietanie modulu l. zespolonej
    f(ifragment,:,:) = angle( X_fft );        % zapamietanie kata l. zespolonej
end

% Tylko dla ASE (Audio Spectral Envelope) length
  P = P / L_widm;                               % unormowanie #1
  P = (P - min(P)) ./ ( max(P) - min(P) );      % unormowanie #2
  C_1 = sum( abs( diff(P) ) );                  % dlugosc krzywej widma

% Tylko dla dla TI
  r_pred(1:L_widm-2,:,:) = 2*r(2:L_widm-1,:,:) - r(1:L_widm-2,:,:); % prognoza abs()
  f_pred(1:L_widm-2,:,:) = 2*f(2:L_widm-1,:,:) - f(1:L_widm-2,:,:); % prognoza angle()
  r = r(3:L_widm,:,:);                                 
  f = f(3:L_widm,:,:);
  L_widm = L_widm-2;
  A = r.*cos(f) - r_pred.*cos(f_pred);
  B = r.*sin(f) - r_pred.*sin(f_pred);
  c = ((A.^2 + B.^2).^(1/2)) ./ ( r + abs(r_pred) );  % nieprzewidywalnosc widma
  for m = 1:L_widm
      rr = r(m,:,:); cc = c(m,:,:);
      e(m,:) = sum( rr.^2 );
      cw(m,:) = sum( cc.*(rr.^2) );
  end
  e_mean = mean(e);
  cw_mean = mean(cw);
  C_2 = ( log10( cw_mean ./ e_mean ) ).^2;

% #########################################################################
% Dodaj swoja cecha, np. stosunek sumarycznej energii: swistow / calkowita
% #########################################################################
  C_3 = sum(P) ./ sum(P_all);

  C = [ C_1' C_2' C_3' ];

end
