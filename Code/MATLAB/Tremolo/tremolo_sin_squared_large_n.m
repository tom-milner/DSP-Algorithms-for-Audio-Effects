close all;
clear all;
setup_plots();

% This plots a comparison of the sin^2(t) wavetable to the real sin^2(t)
% function.

t = 0:0.01:pi;
y  = sin(t).^2;

f = figure;
f.Position = [1     1   735   200];
tiledlayout(1,2,"TileSpacing", "compact");

% Plot continuous sin^2(t).
nexttile;
plot(t,y);
title("$\sin^2(t)$");
ylim([0 1.1]);
xlim([0 pi]);
yticks(0:0.5:1);
xticks(0:pi/4:pi)
xticklabels({'0','$\pi/4$','$\pi/2$','$3\pi/4$','$\pi$'})
xlabel("t")

% Simulate wavetable points.
resolution = 2^7;
discrete_t = 0:pi/(resolution-1):pi;
discrete_y = sin(discrete_t).^2;

% Plot wavetable approximation.
nexttile;
discrete_t = 0:resolution-1;
stairs(discrete_t, discrete_y);
ylim([0 1.1]);
xlim([0 resolution]);
xticks(0:resolution/4:resolution)
xlabel("n")
title(['Wavetable Approximation, $N=' num2str(resolution) '$']);

print("Tremolo Plots/WavetableLargeN",'-depsc', '-vector');
