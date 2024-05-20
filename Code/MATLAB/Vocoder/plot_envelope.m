close all;
clear all;

setup_plots();

% This script plots the output of an ideal envelope detector.
% It does not use square-law detector used in the vocoder!

Fs = 44100;
length = 2;
Ts = 1/Fs;    % Sampling Time Period (Interval).
t = 0:Ts:length; % Generate time values.

f0 = 20;
f1 = 2;

s1 = sin(2*pi*f0*t);
s2 = 2 + sin(2*pi*f1*t);
out = s1 .* s2;

[up_env, lo_env] = envelope(out);

f = figure("Name", "Signal Comparison")
f.Position = [823   542   560   219];

hold on;
plot(t,out);
plot(t, up_env);
xlabel('Time t (s)');
ylabel("Amplitude");
ylim([-4,4]);
xlim([0, t(end)]);
title(['Plot of $s(t)$, $f_0=' num2str(f0) '$, $f_1=' num2str(f1) '$']);
legend("Input, $s(t)$","Envelope, $A(t)$")

print("Vocoder Plots/EnvelopeDetectorInput",'-depsc', '-vector');
print("Vocoder Plots/EnvelopeDetectorInput",'-dpdf', '-bestfit');
