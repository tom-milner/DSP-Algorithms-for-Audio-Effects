
% Envelope Detector for the Vocoder.
% in_signal = input signal.
function out_signal=envelope_filter(in_signal)

% We need a low pass filter for the square law envelope detector.
% We're using a second order low pass IIR filter. The coefficients below
% are thus for the 'a' section of the B/A Matlab LTI filter structure (as it's an IIR).
% It forms an IIR of the structure:
% y(n) = x(n) + 2ry(n-1) - r^2*y(n-2)
% The coefficients are negated because Matlab implements an LTI
% filter using Direct Form 2 Transposed, which negates 'a' coeffients after
% a(1):
%
%    a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
r = 0.99;
lpf = {};
lpf.a = [1, -2*r, +r*r];
lpf.b = [1];

% Get the envelope of the modulator signal using the square law envelope detector.
in_squared = in_signal.*in_signal;
out_signal = sqrt(filter(lpf.b, lpf.a, in_squared));

end