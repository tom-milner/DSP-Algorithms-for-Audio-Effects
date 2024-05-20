
% in = input signal.
% Fs = sample rate.
% Tr = reverberation time (seconds)
function out=schroeder_reverb(in, Fs, Tr)

% This is a reverb implementation based on Gardner's Scroeder Reverb Implementation.
% The filter values were taken from DAFX and the Acoustics Book.

% The delay ratio is recommended to be 1:1.5, between 30 and 45 ms;
delays_ms = [29.7 33.3 35.5 37.1 41.1 43.7]; % ms.
delays = round(delays_ms*(Fs/1000)); % ms to samples.

% Calculate gain values using Gardner's formula.
% Formula: g_i = 10^(-3*m_i*Ts/Tr)
Ts = 1/Fs;
gains = 10.^((-3)*delays*Ts/Tr);

% Feedback Comb Section.
c1 = feedback_comb_filter(in, Fs, delays_ms(1), gains(1));
c2 = feedback_comb_filter(in, Fs, delays_ms(2), gains(2));
c3 = feedback_comb_filter(in, Fs, delays_ms(3), gains(3));
c4 = feedback_comb_filter(in, Fs, delays_ms(4), gains(4));

comb_bank_out = c1 + c2 + c3 + c4;

% Allpass Section.
a1 = allpass_filter(comb_bank_out, Fs, 5, 0.7);
wet = allpass_filter(a1, Fs, 1.7, 0.7);

mix = 1;
out = mix*wet + (1-mix)*in;

% Normalise output.
out = normalise(out);
end
