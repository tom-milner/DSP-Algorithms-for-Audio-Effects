close all;
clear all;
setup_plots();
set(0,'defaultLineLineWidth',1)

gain = 0.5;
m = 5;

% Filter Coefficients.
b = [-gain zeros(1, m-1) 1]; 
a = [1 zeros(1, m-1) -gain]; 

w = 0:0.01:pi;
h = freqz(b,a,w); 
 
% Plot Frequency Response.
freqResponse = figure("Name", "Frequency Response");
freqResponse.Position = [823   542   560   219];

mag = abs(h);
mag = 10*log10(mag); % Convert to dB.

Fs = 44100;
hertz = w/pi * (Fs/2);
kHz = hertz / 1000;

plot(kHz,mag);

xlim([0 20]);
ylim([-1 1]);

title(['\textbf{Allpass Frequency Response}, $m=' num2str(m) '$, $g=' num2str(gain) '$' ]);

ylabel("Magnitude (dB)");
xlabel("Frequency (samples)")

print("Reverb Plots/AllpassFrequencyResponse",'-depsc', '-vector');


% Pole Zero Plot
poleZero= figure("Name", "Pole Zero");
poleZero.Position = [957   193   474   270];
zplane(b,a);
title(['\textbf{Allpass Pole-Zero Plot}, $m=' num2str(m) '$, $g=' num2str(gain) '$' ]);
legend("Pole", "Zero");

print("Reverb Plots/AllpassPoleZero",'-depsc', '-vector');

% Impulse Response
in = [1 zeros(1,49)];
out = filter(b,a,in);
f = figure("Name", "Impulse Response");
f.Position = [823   542   560   219];
stem(0:length(out)-1, out, "filled")
title(['\textbf{Allpass Impulse Response}, $m=' num2str(m) '$, $g=' num2str(gain) '$' ]);
xlabel('Sample, n');
ylabel("Amplitude")
ylim([-.6 1])
xlim([0 35])
print("Reverb Plots/AllpassImpulseResponse",'-depsc', '-vector');