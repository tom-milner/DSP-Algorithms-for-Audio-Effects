% Feedback Comb Filter (FBCF) implementation.

%           z^{-m}
% H(z) = -------------
%        1 - gz^{-m}

% in = input signal.
% Fs = sample rate.
% delay_ms = delay time in milliseconds.
% gain = gain of the delayed signal.
function out=feedback_comb_filter(input, Fs, delay_ms, gain)

% LDE: y(n) = x(n) + gx(n-m)
m = round(delay_ms/1000 * Fs) ;

b = [zeros(1, m-1) 1];
a = [1 zeros(1, m-1) gain];
out = filter(b,a,input);
end