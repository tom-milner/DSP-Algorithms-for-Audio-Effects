close all;
clear all;

setup_plots();


% This file implements the echo effect on sin burst signal and outputs the
% result.

F1 = 500; % Frequency (Hz) (A)

% Take 10 samples per period.
Fs = 44100; % Sampling Frequency.
Ts = 1/Fs;    % Sampling Time Period (Interval).

% Generate sampled sine wave.
D = .1; % Duration of sine wave (100ms)
N = (D/Ts) + 1; % Number of samples.
t = 0:Ts:D; % Generate time values.
input_sig = sin(2*pi*F1*t); % Generate sine samples.
save_input(F1, input_sig, Fs);

z = zeros(1,4*N); % Zeros to append to end of sine wave.
input_sig = [input_sig z]; % Pad the array so there's room for the echos.

pt = 0:Ts:(max(size(input_sig)-1)*Ts); % Used to plot the sine + zeros.


delay_time = 0.3; % Time till echo.
delay_samples = delay_time * Fs;

gain = 0.5;

b = [1 zeros(1, delay_samples-1) gain];
a = [1];

filtered = filter(b,a,input_sig);
filtered = normalise(filtered);

save_output(delay_time, gain, filtered, Fs);

% Plot Signal.
signalComparison = figure("Name", "Signal Comparison");

tiledlayout(2,1)

nexttile
plot(pt,input_sig);
title('\textbf{Input Signal}');
xlabel('Time t (s)');
ylabel("Amplitude")
ylim([-1.5,1.5])
xlim([0 0.5])
grid minor;

nexttile
plot(pt, filtered);
title('\textbf{Output Signal}');
xlabel('Time t (s)');
ylabel("Amplitude")
ylim([-1.5,1.5])
xlim([0 0.5])
grid minor;
print("Echo Plots/SignalComparison",'-depsc');

% Frequency Response.
w = 0:0.00001:pi;
h = freqz(b,a,w);
freq = abs(h);

% Plot Frequency Response.
freqResponse = figure("Name", "Frequency Response");
freqResponse.Position = [859   491   560   270];

% Decibel conversion
% freq = 10*log10(freq);

% Find the peaks.
[peaks, p_inds] = findpeaks(freq);
peaks_freqs = zeros(1,5);
for i=1:5
    peaks_freqs(i) = w(p_inds(i));
end
peaks_freqs = peaks_freqs/pi * (Fs/2);
peaks = peaks(1:5);

% Find the troughs.
[troughs, t_inds] = findpeaks(-freq);
trough_freqs = zeros(1,5);
for i=1:5
    trough_freqs(i) = w(t_inds(i));
end
trough_freqs = trough_freqs/pi * (Fs/2);
troughs = -troughs(1:5);


hertz = w/pi * (Fs/2);
plot(hertz,freq);
hold on;

stem(peaks_freqs, peaks, "--red");
stem(trough_freqs, troughs, "--black");
legend("Frequency Response", "Peaks","Troughs")

grid minor;

xlabel("Frequency (hz)");
ylabel("Magnitude")
title("\textbf{Frequency Response}")
ylim([0,2])
xlim([0, 11])
print("Echo Plots/FrequencyResponse",'-depsc');

saveas(freqResponse, "Echo Plots/Frequency Response");
saveas(signalComparison, "Echo Plots/Signal Comparison");

function save_output(d,g,sig,Fs)
audiowrite(['Audio/Echo Output (d=' num2str(d) 'ms, g=' num2str(g) ').wav' ], sig, Fs);
end

function save_input(f,sig,Fs)
audiowrite(['Audio/Echo Input (' num2str(f) ' Hz sine).wav' ], sig, Fs);
end
