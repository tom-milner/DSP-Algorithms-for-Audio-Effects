
% Nicely plot the output of an fft.

% header = title of plot.
% f = frequency axis data.
% y = fft output.
% Fs = sample rate.
function h=fft_plot(header,f,y, Fs)

y = 10*log10(abs(y)); % dB

h = plot(f,y);

xlim([0 20]);
ylim([-25 45]);

ticks = 0:1:Fs/2;

xticks(ticks);

xlabel("Frequency (kHz)");
ylabel("Amplitude (dB)");

title(header);
end