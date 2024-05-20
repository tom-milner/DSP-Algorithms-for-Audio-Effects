
% Allpass filter implementation.

%        z^{-m} - g
% H(z) = -------------
%        1 - gz^{-m}

% in = input signal.
% Fs = sample rate.
% delay_ms = delay time in milliseconds.
% gain = gain of the delayed signal.
function out=allpass_filter(in, Fs, delay_ms, gain)

% Convert ms to samples.
m = round(delay_ms/1000 * Fs);

b = [-gain zeros(1, m-1) 1]; 
a = [1 zeros(1, m-1) -gain]; 
out = filter(b,a,in);

end