close all;
clear all;
setup_plots();
set(0,'defaultLineLineWidth',1)

% This script plots the frequency response of the LPF used in the Vocoder.

r = 0.99;
lpf = {};
lpf.a = [1, -2*r, +r*r];
lpf.b = [1];

w = 0:0.0001:pi;
h = freqz(lpf.b,lpf.a,w);
 
% Plot Frequency Response.
freqResponse = figure("Name", "Frequency Response");
freqResponse.Position = [823   542   560   219];

mag = abs(h);
mag = 20*log10(mag);

norm_w = w/pi;
plot(norm_w,mag);

xlim([0 1]);
xticks(0:0.1:1);
title(['\textbf{LPF Frequency Response}, $\left|H\left(e^{j \omega}\right)\right|$, $r=' num2str(r) '$']);

ylabel("Magnitude (dB)");
xlabel("Normalised Frequency ($\times \pi$ rad/sample)")

print("Vocoder Plots/LPFResponse",'-depsc', '-vector');
print("Vocoder Plots/LPFResponse",'-dpdf', '-bestfit');