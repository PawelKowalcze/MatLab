
% LICZBY Z PRZYKŁADÓW Z WYKŁADU

% Integer U2 8 bitów: 01000110
if(1)
  dec2bin(  70, 8) %  70 na 8 bitach
  dec2bin( -70, 8) % -70 na 8 bitach
end

% Fractional U2 8 bitów: 1.546875 oraz -1.546875
if(1)
  hex2bitstr( num2hex( single( 1 + 1/2 + 1/8 ) ) );
  hex2bitstr( num2hex( single(  1.546875 ) ) );
  hex2bitstr( num2hex( single( -1.546875 ) ) );
end

% Single precision 32 bity: -0.009765625
if(1)
  num2hex( single(-0.009765625) ),
  hex2bitstr( num2hex( single( -0.009765625 ) ) );
end

% Double precision 64 bity: -0.009765625
if(1)
  num2hex( -0.009765625 );
  hex2bitstr( num2hex( -0.009765625 ) );
end

% Dokładność obliczeń
if(1)
  disp('1 + 2^(-24)'); hex2bitstr( num2hex( single( 1 + 2^(-24) ))); pause
  disp('1 + 2^(-23)'); hex2bitstr( num2hex( single( 1 + 2^(-23) ))); pause
  disp('1 + 2^(-22)'); hex2bitstr( num2hex( single( 1 + 2^(-22) ))); pause
  disp('1 + 2^(-21)'); hex2bitstr( num2hex( single( 1 + 2^(-21) ))); pause
  disp('1 + 2^(-21) + 2^(-23)'); hex2bitstr( num2hex( single( 1 + 2^(-21) + 2^(-23) ))); pause
end

% Błąd dla 64 bitów +/-0.5*eps
if(1)
  eps_system = eps,
  eps_oblicz = 2^(-52), pause
  disp('1 + 2^(-53) + 2^(-53)    '); hex2bitstr( num2hex( 1 + 2^(-53) + 2^(-53) )); pause
  disp('    2^(-53) + 2^(-53) + 1'); hex2bitstr( num2hex( 2^(-53) + 2^(-53) + 1 )); pause
end  
