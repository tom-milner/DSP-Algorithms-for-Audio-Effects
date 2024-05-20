function echo_impulse_plot()
close all;
in = [1 zeros(1,19)];
out = filter([1 zeros(1,9) 0.8],1,in);

set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(0, 'defaulttextInterpreter','latex')
set(groot,'defaultAxesFontSize',15)

f = figure;
f.Position = [823   542   560   219];
stem([0:19], out, "filled")
title('\textbf{Echo Filter Impulse Response}');
xlabel('n (sample number)');
ylabel("Amplitude")
xlabel('Sample, n');
ylabel("Amplitude")
ylim([0 1.2])
xlim([0 19])
grid on
print("Echo Plots/ImpulseResponse",'-depsc', '-vector');
end