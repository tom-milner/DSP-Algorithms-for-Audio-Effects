close all;
clear all;
setup_plots();
set(0,'defaultLineLineWidth',1)

g = 0.5;
m = 5;

% Filter Coefficients.
b = [zeros(1,m) 1]; 
a = [1 zeros(1, m-1) -g]; 

w = 0:0.0001:pi;
h = freqz(b,a,w);
 
% Plot Frequency Response.
freqResponse = figure("Name", "Frequency Response");
freqResponse.Position = [823   542   560   300];

mag = abs(h);
% mag = 10*log10(mag);

Fs = 44100;
Ts = 1/44100;
hertz = w/pi * (Fs/2);
kHz = hertz / 1000;

% Find the peaks.
[peaks, p_inds] = findpeaks(mag);
peaks_freqs = zeros(1,2);
for i=1:2
    peaks_freqs(i) = w(p_inds(i));
end
peaks_freqs = peaks_freqs/pi * (Fs/2) / 1000;
peaks = peaks(1:2);

% Find the troughs.
[troughs, t_inds] = findpeaks(-mag);
trough_freqs = zeros(1,2);
for i=1:2
    trough_freqs(i) = w(t_inds(i));
end
trough_freqs = trough_freqs/pi * (Fs/2) / 1000;
troughs = -troughs(1:2);

% PLot response.
plot(kHz,mag);
hold on;

% Plot peaks and troughs.
stem(peaks_freqs, peaks, "--red");
stem(trough_freqs, troughs, "--black");
legend("Frequency Response", "Peaks","Troughs")

xlim([0 20]);
ylim([0 2.9]);
title(['\textbf{FBCF Frequency Response}, $m=' num2str(m) '$, $g=' num2str(g) '$' ]);

ylabel("Magnitude");
xlabel("Frequency (kHz)")

print("Reverb Plots/FeedbackCombFrequencyResponse",'-depsc', '-vector');


% Pole Zero Plot
poleZero= figure("Name", "Pole Zero");
poleZero.Position = [957   193   474   270];
zplane(b,a);
title(['\textbf{FBCF Pole-Zero Plot}, $m=' num2str(m) '$, $g=' num2str(g) '$' ]);
legend("Pole", "Zero");

print("Reverb Plots/FeedbackCombPoleZero",'-depsc', '-vector');

% Impulse Response
in = [1 zeros(1,29)];
out = filter(b,a,in);
f = figure;
f.Position = [823   542   560   219];
stem(0:length(out)-1, out, "filled")
title(['\textbf{FBCF Impulse Response}, $m=' num2str(m) '$, $g=' num2str(g) '$' ]);
xlabel('Sample, n');
ylabel("Amplitude")
% ylim([0 1.2])
% xlim([0 19])
print("Reverb Plots/FeedbackCombImpulseResponse",'-depsc', '-vector');