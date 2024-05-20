clear all;
close all;
setup_plots();
set(0,'defaultLineLineWidth',1);

% This shows how the sin^2(t) wave table is constructed.

t = 0:0.01:pi;
y  = sin(t).^2;

f = figure;
f.Position = [ 29   201   544   600];
tiledlayout(4,1);

% Plot the continuous sin^2(t) function.
nexttile;
plot(t,y);
title("\textbf{1.} The $\sin^2(t)$ function");
ylim([0 1.1]);
xlim([0 pi]);
yticks(0:0.5:1);
xticks(0:pi/4:pi)
xticklabels({'0','$\pi/4$','$\pi/2$','$3\pi/4$','$\pi$'})
xlabel("t")

% Generate the wavetable points.
resolution = 2^5;
discrete_t = 0:pi/(resolution-1):pi;
discrete_y = sin(discrete_t).^2;

% Plot the sampling process of the wavetable.
nexttile;
stem(discrete_t, discrete_y, "filled","x");
ylim([0 1.1]);
xlim([0 pi]);
xticks(0:pi/4:pi)
xticklabels({'0','$\pi/4$','$\pi/2$','$3\pi/4$','$\pi$'})
xlabel("t")
title(['\textbf{2.} Sampling $N$ discrete points from $\sin^2(t)$, $N=' num2str(resolution) '$']);

% Plot the wavetable.
nexttile;
discrete_t = 0:resolution-1;
stairs(discrete_t, discrete_y);
ylim([0 1.1]);
xlim([0 resolution]);
xticks(0:resolution/4:resolution)
xlabel("n")
title(['\textbf{3.} Wavetable, $N=' num2str(resolution) '$']);

% Plot usage of the getNextValue() function.
nexttile;
cur_index = 8; % Arbitrary start point in the wavetable.
stairs(discrete_t, discrete_y);
ylim([0 1.1]);
xlim([0 resolution]);
xticks(0:resolution/4:resolution)
xlabel("n")
hold on;
title(['\textbf{4.} Using the getNextValue() function, starting position = ' num2str(cur_index)]);

% Plot first call of getNextValue().
stem(cur_index, discrete_y(cur_index+1), "filled", "red--");

% Plot second call of getNextValue().
next_sample = cur_index+1;
stem(next_sample, discrete_y(next_sample+1), "filled", "blue--");
legend("Wavetable values", "First call of getNextValue()", "Second call of getNextValue()");

print("Tremolo Plots/Wavetable",'-depsc', '-vector');