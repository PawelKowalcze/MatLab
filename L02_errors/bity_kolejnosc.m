
% Znaczenie kolejnosci operacji

echo on

% double 64b
num2bitstr( 1 + 2^(-53) + 2^(-53) );
num2bitstr( 2^(-53) + 2^(-53) + 1 );

% single 32b
num2bitstr( single( single(1) + single(2^(-24)) + single(2^(-24)) ) );
num2bitstr( single( single(2^(-24)) + single(2^(-24)) + single(1) ) );

echo off