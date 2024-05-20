close all;
clear all;

setup_plots();

% This file implements the distortion effect.

% First, generate the input signal (a sine wave).
F = 500; % Hz, A
F2 = 3/2 * F ; % Fifth.
L = 1; % Note length (s).
Fs = 44100; % Sample Rate.
Ts = 1/Fs; % Sampling Interval
t=0:Ts:L;

in_amp = 0.75;
input = in_amp*sin(2*pi*F*t);
save_input(F, input, Fs);

% Plot the input sin signal.
time_domain_x_lim = [0 20];
t_ms = t * 1000;
time_domain = figure("Name", "Time Domain");
time_domain.Position = [1     1   735   821];
tiledlayout(5,1)
nexttile;
time_plot('\textbf{Input Signal}: $0.75\sin(2\pi f_c t)$, $f_c = 500$ Hz', t_ms,input,time_domain_x_lim, [-1.5 1.5]);
hold on;

% Plot the amplitude of the original input signal.
yline(in_amp,"red--");
yline(-in_amp,"red--");
legend("Signal", "Amplitude of input signal");

% Run the distortion effect on the input signal at various levels of rg.
r = 1;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp,Fs);


r = 5;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp,Fs);


r = 15;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp,Fs);


r = 50;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp,Fs);


print("Distortion Plots/SquareWaveApproximation",'-depsc');


% Frequency Analysis.
freq_domain = figure("Name", "Frequency Domain");
freq_domain.Position = [1     1   735   821];
tiledlayout(5,1)

num_bins = 8192*2;
f = Fs/num_bins*(0:(num_bins-1));
f_kHz = f/1000;

% Plot the input signal FFT.
freq_input = fft(input,num_bins);
nexttile
y = freq_input;
fft_plot("\textbf{Input Frequencies}: $0.75\sin(2\pi f_c t)$, $f_c = 500$ Hz",f_kHz,y,F,Fs);
xlabel("Frequency (kHz)");
ylabel("Amplitude (dB)");

% Plot odd harmonics.
for i=1:2:40
xline(i*F/1000, "--");
end
legend("Signal", "$f_c$ odd harmonics");

% Plot the output signal FFTs.
r = 1;
g = 1;
nexttile;
freq_graph(input,r,g, F, Fs);

r = 5;
g = 1;
nexttile;
freq_graph(input,r,g, F, Fs);

r = 15;
g = 1;
nexttile;
freq_graph(input,r,g, F, Fs);

r = 50;
g = 1;
nexttile;
freq_graph(input,r,g, F, Fs);

print("Distortion Plots/SignalFrequencies",'-depsc');


% Distort a signal and plots its FFT.
function freq_graph(input,r,g, F, Fs)

header = ['\textbf{Output Frequencies, $rg = ', num2str(r*g), '$}'];

num_bins = 8192*2;
fuzz = exp_dist(input,g,r,1);
f_out = fft(fuzz,num_bins);

f = Fs/num_bins*(0:(num_bins-1));
f_kHz = f / 1000;

F_kHz = F/1000;
Fs_kHz = Fs/1000;

fft_plot(header, f_kHz, f_out, F_kHz, Fs_kHz);

% Plot odd harmonics.
for i=1:2:40
xline(i*F_kHz, "--");
end
end

% Distort a signal and plot the output in the time domain.
function rg_graph(t, input, r,g, in_amp,Fs)

fuzz = exp_dist(input,g,r,1);
title_str= ['\textbf{Output Signal, $rg = ', num2str(r*g), '$}'];
plot(t, fuzz);
xlim([0 20]);
ylim([-1.5 1.5]);
title(title_str);
    
xlabel("Time t (ms)");
ylabel("Amplitude");

hold on;
% Plot the original amplitude.
yline(in_amp,"red--");
yline(-in_amp,"red--");
save_output(r,g,fuzz,Fs);
end

% Apply the distortion effect to a signal.
function y=exp_dist(x,gain,range,mix)

% Apply gain.
q = gain*x*range;

% Distort Signal
z=sign(q).*(1-exp(-abs(q))); 

% Scale the dry signal.
dry=(1-mix)*x; 

% Scale the wet signal.
wet=mix*z;

% Mix.
y=dry+wet;

end

function save_output(r,g,fuzz,Fs)
audiowrite(['Audio/Distortion Output (r=' num2str(r) ', g=' num2str(g) ').wav' ], fuzz, Fs);
end

function save_input(f,sig,Fs)
audiowrite(['Audio/Distortion Input (' num2str(f) ' Hz sine).wav' ], sig, Fs);
end
