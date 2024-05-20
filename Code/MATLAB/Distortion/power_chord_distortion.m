close all;
clear all;
setup_plots();

% Generate Power Chord input.
F = 500; % Hz, A
F2 = 3/2 * F ; % Fifth.
L = 1; % Note length (s).
Fs = 44100; % Sample Rate.
Ts = 1/Fs; % Sampling Interval
t=0:Ts:L;

in_amp = 0.75;
input = in_amp*sin(2*pi*F*t)/2 + in_amp*sin(2*pi*F2*t)/2;
save_input(F, F2, input, Fs);


% Plot input.
time_domain_x_lim = [0 20];
t_ms = t * 1000;
time_domain = figure("Name", "Time Domain");
time_domain.Position = [1     1   735   821];
tiledlayout(5,1)
nexttile;
time_plot('\textbf{Input Signal}: $f_r = 500$, $f_5 = 3/2f_r$ Hz', t_ms,input,time_domain_x_lim, [-1.5 1.5]);
hold on;

% Plot the original amplitude.
yline(in_amp,"red--");
yline(-in_amp,"red--");
legend("Signal", "Amplitude of input signal");


%  Plot distortion.
r = 1;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp);

r = 5;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp);

r = 15;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp);

r = 50;
g = 1;
nexttile;
rg_graph(t_ms,input,r,g,in_amp);

print("Distortion Plots/PowerChordSquareWaveApproximation",'-depsc', '-vector');

% Frequency Analysis.
freq_domain = figure("Name", "Frequency Domain");
freq_domain.Position = [1     1   735   821];
tiledlayout(5,1)

num_bins = 8192*2;
f = Fs/num_bins*(0:(num_bins-1));
f_kHz = f/1000;
F_kHz = F/1000;
Fs_kHz = Fs/1000;

% Input FFT.
freq_input = fft(input,num_bins);
nexttile
y = freq_input;
header = "\textbf{Input Frequencies}: $f_r = 500$ Hz, $f_5 = 3/2f_r$ Hz";
legend_key(1) = fft_plot(header,f_kHz,y,F,Fs);
xlabel("Frequency (kHz)");
ylabel("Amplitude (dB)");
xlim([0 10]);

%  Plot power chord harmonics.
for i=1:2:Fs/F
if i ==1
    % Save handles to the first two lines for the legend.
    legend_key(2) = xline(i*F_kHz, "--black");
    legend_key(3) = xline(i*F_kHz*3/2, "--red");
else 
    xline(i*F_kHz, "--black");
    xline(i*F_kHz*3/2, "--red");
end

end
for i=1:Fs_kHz/F_kHz;
if i==1
    % Keep a handle to this for the legend.
    legend_key(4)=xline(i*F_kHz/2, ":blue");
else
xline(i*F_kHz/2, ":blue");
end
end

legend(legend_key,"Signal", "$f_r$ odd harmonics","$f_5$ odd harmonics","$f_r/2$ odd harmonics")


% Distortion outputs.
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

print("Distortion Plots/PowerChordSignalFrequencies",'-depsc','-vector');


% Distort signal, plot FFT, and save it.
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
xlim([0 10]);

% Plot Harmonics.
for i=1:2:Fs/F
xline(i*F, "--black");
xline(i*F*3/2, "--red");
end
for i=0:120
xline(i*F_kHz/2, "blue:")
end


save_output(r,g,fuzz,Fs);
end


% Distort signal and plot in time domain.
function rg_graph(t, input, r,g, in_amp)

fuzz = exp_dist(input,g,r,1);
time_plot(['\textbf{Output Signal, $rg = ', num2str(r*g), '$}'],t,fuzz, [0 20], [-1.5 1.5]);
hold on;

% Plot the original amplitude.
yline(in_amp,"red--");
yline(-in_amp,"red--");

end



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
audiowrite(['Audio/Power Chord Distortion Output (r=' num2str(r) ', g=' num2str(g) ').wav' ], fuzz, Fs);
end

function save_input(f1, f2,sig,Fs)
audiowrite(['Audio/Power Chord Distortion Input (' num2str(f1) '&' num2str(f2) ' Hz sine).wav' ], sig, Fs);
end