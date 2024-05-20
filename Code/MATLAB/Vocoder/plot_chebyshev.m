close all;
clear all;

% This plots the frequency response and pole-zero plot of a chebyshev
% filter.

setup_plots();
set(0,'defaultLineLineWidth',1)

Fs=44100;
lower_freq = 440;
upper_freq= lower_freq * 2^(1/3);

lower_freq = lower_freq / Fs * 2;
upper_freq = upper_freq / Fs * 2;


[b,a]= cheby1(2,3,[lower_freq, upper_freq]);

w = 0:0.0001:pi;
h = freqz(b,a,w);

mag = abs(h);
mag = 20*log10(mag);


% Plot Frequency Response.
freqResponse = figure("Name", "Frequency Response");
freqResponse.Position = [823   542   560   300];

Fs = 44100;
Ts = 1/44100;
hertz = w/pi * (Fs/2);
kHz = hertz / 1000;

plot(kHz,mag);

title(['\textbf{Chebyshev Frequency Response}']);

ylabel("Magnitude");
xlabel("Frequency (kHz)")

% Pole Zero
poleZero= figure("Name", "Pole Zero");
poleZero.Position = [957   193   474   270];
zplane(b,a);
title(['\textbf{Chebyshev Pole-Zero Plot}' ]);
xlabel('Real Part');
ylabel("Imaginary Part")
legend("Pole", "Zero");
