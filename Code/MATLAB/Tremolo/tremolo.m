clear all;
close all;

setup_plots();
set(0,'defaultLineLineWidth',.1)


F = 500; % Frequency (Hz)

% Generate sine wave input.
Fs = 44100; % Sampling Frequency.
Ts = 1/Fs;    % Sampling Time Period (Interval).
D = 1; % Duration of sine wave (1000ms)
N = (D/Ts) + 1; % Number of samples.
t = 0:Ts:D; % Generate time values.
input_signal = 0.8 * sin(2*pi*F*t); % Generate sine samples.
save_input(F,input_signal, Fs);

% LFO Modulation Signal.
trem_speed = 5; % How fast the tremolo acts (frequency or speed).
trem_depth = .8; % 0 - 1. How deep the tremolo goes (amplitude).
mod_signal = (1-trem_depth) + trem_depth * sin(pi * t * trem_speed).^2;

% Generate the outpu.
output = input_signal .* mod_signal;
save_output(trem_depth, trem_speed, output, Fs);


% Plot all the signals.
trem_fig = figure("Name", "Tremolo");
trem_fig.Position = [1     1   735   821];

% Plot the input.
tiledlayout(5,1);
nexttile
plot(t,input_signal);
title(['\textbf{Input Signal}: $\sin(2\pi f_ct)$, $f_c=' num2str(F) '$ Hz'] );
xlabel('Time t (s)');
ylabel('Amplitude');
ylim([-1.5,1.5])
xlim([0 0.5])
grid minor;

% Plot the modulation signal.
nexttile
plot(t, mod_signal);
title(['\textbf{Modulation Signal}: $f_m=' num2str(trem_speed) '$ Hz, $D= ' num2str(trem_depth) '$']);
xlabel('Time t (s)');
ylabel('Amplitude');
ylim([-1.5,1.5])
xlim([0 0.5])
grid minor;
yline(1-trem_depth, "red--");
legend("Signal", ['$1-D=' num2str(1-trem_depth) '$'])

% Plot the output signal.
nexttile
plot(t, output);
title('\textbf{Output Signal}: input $\times$ modulation');
xlabel('Time t (s)');
ylabel('Amplitude');
ylim([-1.5,1.5])
xlim([0 0.5])
grid minor;


% Make a new modulation signal.
trem_speed = 15;
trem_depth = 0.4;
mod_signal = (1-trem_depth) + trem_depth * sin(pi * t * trem_speed).^2;
output = input_signal .* mod_signal;
save_output(trem_depth, trem_speed, output, Fs);

% Plot second modulation signal.
nexttile
plot(t, mod_signal);
title(['\textbf{Modulation Signal}: $f_m=' num2str(trem_speed) '$ Hz, $D= ' num2str(trem_depth) '$']);
xlabel('Time t (s)');
ylabel('Amplitude');
ylim([-1.5,1.5])
xlim([0 0.5])
grid minor;
yline(1-trem_depth, "red--");
legend("Signal", ['$1-D=' num2str(1-trem_depth) '$'])

% Plot second output.
nexttile
plot(t, output);
title('\textbf{Output Signal}: input $\times$ modulation');
xlabel('Time t (s)');
ylabel('Amplitude');
ylim([-1.5,1.5])
xlim([0 0.5])
grid minor;

print("Tremolo Plots/Signals",'-depsc', '-vector');

function save_output(trem_depth, trem_speed, output, Fs)
audiowrite(['Audio/Tremolo Output (D=' num2str(trem_depth) ', f_m=' num2str(trem_speed) ').wav'], output, Fs);
end

function save_input(f, input_signal, Fs)
audiowrite(['Audio/Tremolo Input (' num2str(f) ' Hz sine).wav'], input_signal, Fs);
end
