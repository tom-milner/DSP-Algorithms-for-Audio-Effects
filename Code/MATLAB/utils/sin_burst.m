
% Generate a sinewave burst signal.
% sin_f = target frequency.
% Fs = sample rate.
% length_ms = duration of burst.
% amplitude = amplitude of burst.
function out=sin_burst(sin_f, Fs, length_ms, amplitude)

Ts = 1/Fs;    % Sampling Time Period (Interval).
D = length_ms/1000; % Duration of sine wave.
t = 0:Ts:D; % Generate time values.
out = amplitude * sin(2*pi*sin_f*t); % Generate sine samples.

end