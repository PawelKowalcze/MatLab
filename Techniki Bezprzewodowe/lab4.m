% jeden router z dwoma antenami
% router wie gdzie w przestrzenie są docelowi clienci -> wie jak kierować sygnał
% scenariusz 1
% router robi TDM i wysyłając do jednego użytkownika manipuluje fazami,
% żeby żeby zysk był jak największy
% scenariusz 2
% router korzysta z orthogonal beamforming i wyśle sygnał do obu
% użytkowniuków jednocześnie. Fazy sygnałów na antenach będą tak
% przygotowane, aby transmisja kierowana do pierwszego użytkownika
% nie docierała do drugiego użytkownika i vice versa.
% router AP coordinates
% r nie trzeba w matlabie deklarować, tylko po prostu jedziemy i dodajemy
% pola z wartościami od tak bezpośrednio
r.x = 60;
r.y = 0;
r.pow = 10; % power anteny pojedynczej, 13dBm == 20mW, połowa to jest -3dB
r.freq = 3 * 10 ^ 9;
r.lambda = 3 * 10^8 / r.freq;

% wspolrzedne anteny 1 AP
r.a1.x = 60;
r.a1.y = -0.025;
% wspolrzedne anteny 2 AP
r.a2.x = 60;
r.a2.y = 0.025;
% users and coordinates
u1.x = 20;
u1.y = -50;
u2.x = 110;
u2.y = 50;
noise = -120; % dBW
% spodziwamy sie tlumienia 20/30 dB
% tłumienie się odbywa jak w przestrzeni swobodnej
% użytkownicy dysponują odbiornikami z pojedynczymi antenami izotropowymi,
% poziom szumów na wejściu odbiorników obu użytkowników wynosi -130 dBW


r.pow = r.pow - 3; % dwa razy mniejsza moc

% user 1
a1u1 = d(r.a1, u1)
a2u1 = d(r.a2, u1)
phi1 = phase(a1u1 - a2u1, r.freq)

% user 2
a1u2 = d(r.a1, u2)
a2u2 = d(r.a2, u2)
phi2 = phase(a1u2 - a2u2, r.freq);

% wyciszenie do U1
H1 = transm(a1u1, r.lambda, 0) + transm(a2u1, r.lambda, phi1 - pi)
P1 = r.pow + 20 * log10(abs(H1))

% wyciszenie do U2
H2 = transm(a1u2, r.lambda, 0) + transm(a2u2, r.lambda, phi2 - pi)
P2 = r.pow + 20 * log10(abs(H2))
snr1w = SNR(P1, -90)
snr2w = SNR(P2, -90)

% transmisja do U1
H2 = transm(a1u1, r.lambda, 0) + transm(a2u1, r.lambda, phi2 - pi)
P2 = r.pow + 20 * log10(abs(H2))

% transmisja do U2
H1 = transm(a1u2, r.lambda, 0) + transm(a2u2, r.lambda, phi1 - pi)
P1 = r.pow + 20 * log10(abs(H1))
snr1 = SNR(P1, -90)
snr2 = SNR(P2, -90)

function [dist] = d(a, b)
   dist = pdist([a.x, a.y; b.x, b.y], 'euclidean');
end
% get phase necesary for constructive interference in radians
function [phi] = phase(dist, freq)
   lambda = 3 * 10^8 / freq;
   phi = rem(dist, lambda) / lambda * 2 * pi;
end
function H = transm(d, lambda, phi)
   H = lambda / 4 / pi / d * exp(-j * 2 * pi * d / lambda) * exp(-j * phi);
end
function [snr] = SNR(signal_dB, noise_dB)
   snr = signal_dB - noise_dB;
end
