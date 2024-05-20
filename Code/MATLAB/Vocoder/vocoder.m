close all;
clear all;

setup_plots();
set(0,'defaultLineLineWidth',.1)


% Get the carrier and modulator signals.
working_dir = "Squarewave/";
[car_signal, mod_signal, Fs, len] = get_signals(working_dir + "Audio/Squarewave.wav", working_dir + "Audio/Voice Input.wav");

% Save the original files.
audiowrite(working_dir +"Audio/Vocoder_Carrier.wav",car_signal,Fs);
audiowrite(working_dir +"Audio/Vocoder_Modulator.wav",mod_signal,Fs);

% Calculate the time values to use for all the plots.
Ts = 1/Fs;
global t_plot;
t_plot = 0:Ts:(len*Ts);
t_plot(end) = [];

% A buffer to store the output samples.
output = zeros(1,len);


% The frequency to start the bandpass filters at, normalized between 0 and 2.
% 1 = Nyquist frequency.
start_freq = 20/Fs * 2; % 20Hz.

% Frequency factor for 1/3 of an octave, 1 octave is 2x the previous frequency.
octave_third = 2^(1/3); 

max_freq = 20000/Fs * 2; % 1 is the normalised Nyquist frequency.

% Work out how many times we can multiply start_freq by
% 2^(1/3) before we hit the max frequency. This is the number of bandpass
% filters we can have.
num_bands = floor(log(max_freq/start_freq) / log(octave_third));

disp("Number of bands: " + num_bands);

% Loop through each band:
lower_freq = start_freq;
f = figure("Name", "Frequency Band");
f.Position = [1   325   774   497];
hold on;
for band=1:num_bands
    fprintf("%d ", band);
    % Get the strength of each of the signals in this band.
    % To start, we need to filter each signal with a bandpass filter.
    upper_freq = lower_freq * octave_third;
    
    % This is a 2nd-order Chebyshev Type I band-pass filter which passes
    % frequencies between lower_freq and upper_freq with 3db of ripple in
    % the passband.
    % b and a are the B/A filter coefficients (FIR or IIR).
    [b,a]= cheby1(2,3,[lower_freq, upper_freq]);

    % Apply the filter to each signal.
    car_filtered = filter(b,a,car_signal);
    mod_filtered = filter(b,a,mod_signal);

    % Get the envelope of the modulator signal.
    mod_envelope = envelope_filter(mod_filtered);

    % Carrier Signal Envelope.
    eps = 0.1; % Epsilon is used to control the signal whitening.
    car_envelope = eps+envelope_filter(car_filtered);

    % Remove the gain added by the LPF by dividing the envelopes by each
    % other.
    gain_adjusted_env = mod_envelope./car_envelope;

    % Apply the modulator envelope to the carrier signal.
    modulated = car_filtered .* gain_adjusted_env;
    
    % Convert to Hz.
    lower_freq_disp = round((lower_freq * Fs)/2);
    upper_freq_disp = round((upper_freq * Fs)/2);

    % Plot the filtered carrier.     
    tiledlayout(3,2, "TileSpacing", "tight", "Padding", "compact");
    nexttile(1,[1,1]);
    title_str = "\textbf{Filtered Carrier Signal}: $x_{c" + band + "}(t)$ (" + lower_freq_disp ...
                + "-" + upper_freq_disp + " Hz, Band " + band + "/" + ...
                num_bands + ")";
    car_plot = pplot(title_str,t_plot, car_filtered, [-1 1]);
    car_plot.Color = "#0072BD";
    
    % Plot the filtered modulator.     
    nexttile(2,[1,1]);
    mod_plot = pplot("\textbf{Filtered Modulation Signal}: $x_{m" + band + "}(t)$", t_plot,mod_filtered, [-1, 1]);
    mod_plot.Color = "#77AC30";

    
    % Plot the envelopes.
    nexttile(3, [1, 1]);
    hold on
    box on   
    plot(t_plot, car_envelope,"Color","#0072BD");
    plot(t_plot, mod_envelope,"Color","#77AC30");
    ylim([-0.5, inf]);
    xlim([0 t_plot(end)]);
    title("\textbf{Signal Envelopes}: $A_{m" + band + "}(t)$ and $A_{c" + band + "}(t)$");
    l = legend("$A_{c" + band + "}(t)$", "$A_{m" + band + "}(t)$");
    l.Position = [0.08 0.4 0.1 0.06];
    xlabel("Time t (s)")
    ylabel("Amplitude")

    % Plot the gain adjusted envelope.
    nexttile(4, [1,1]);
    hold on;
    box on
    plot(t_plot, gain_adjusted_env, "Color", "#7E2F8E");
    xlim([0 t_plot(end)]);
    title("\textbf{Gain Cancelled Envelope}: $A_{m" + band + "}(t) / A_{c" + band + "}(t)$");
    xlabel("Time t (s)")
    ylabel("Amplitude")
    
    % Plot the output signal.
    nexttile(5, [1,2]);
    out_plot = pplot("\textbf{Output}: $y_{" + band + "}(t)$",t_plot,modulated, [-1, 1]);
    out_plot.Color = "#7E2F8E";
    
    % Save the signal plots - be warned, the pdf conversion takes ages.
%     saveas(f, working_dir +"Plots/" + lower_freq_disp ...
%                  + "-" + upper_freq_disp + "Hz, Band " + band);
%     
%     f.PaperOrientation = "landscape";
%     print(working_dir + "Plots/" +  lower_freq_disp ...
%                 + "-" + upper_freq_disp + "Hz, Band " + band, "-dpdf", "-bestfit");
% 
%     if band == 8 || band == 18
%     % We like plots 8 and 18.
%     print(working_dir+ "Plots/" +"VocoderBand" + band ,'-depsc', '-vector');
%     end

    % Add this band to the final output signal.
    output = output + modulated;

    % Move to the next frequency band
    lower_freq = upper_freq;
end



% Graph the signals.
f = figure("Name", "Input + Output Signals");
f.Position = [80   280   735   498];
tiledlayout(3,1,"TileSpacing","tight");

% mod_heading = "``Harder Better Faster Stronger'' Voice";
% car_heading = "``Harder Better Faster Stronger'' Synth";
mod_heading = "Voice Input";
car_heading = "Squarewave";

nexttile;
pplot("\textbf{Modulation Signal}: " + mod_heading, t_plot,mod_signal, [-1 1]);

nexttile;
pplot("\textbf{Carrier Signal}: "+ car_heading, t_plot,car_signal, [-1 1]);

nexttile;
pplot('\textbf{Vocoder Output Signal}',t_plot, output, [-1 1]);

f.PaperOrientation = "landscape";
print(working_dir +"Plots/VocoderInOut",'-depsc', '-vector');
print(working_dir +"Plots/VocoderInOut","-dpdf", "-bestfit");

audiowrite(working_dir +"Audio/Vocoder_Output.wav", output, Fs);


% Get the specified carrier and modulation signals, and process them to
% work with the vocoder.
% car_file = carrier signal file.
% modulation_file = modulation signal file.
% car_signal = carrier signal.
% mod_signal = modulation signal.
% Fs = sample rate.
% len = the length of the signals.
function [car_signal, mod_signal, Fs, len]=get_signals(car_file, mod_file)


    % Get input signals from audio files.
    [car_signal,Fs_car]= audioread(car_file);
    [mod_signal,Fs_mod] = audioread(mod_file);
    
    
    % If sample rates aren't equal, resample to make them so.
    if Fs_car ~= Fs_mod
        disp("Sample rates are different! Resampling...");
        car_signal = resample(car_signal, Fs_mod, Fs_car);
    end
    Fs = Fs_car;
    
    % If there is more than one track for each signal, take the first track.
    car_signal = car_signal(:,1);
    mod_signal = mod_signal(:,1);
    
    % Make both signals the same size.
    min_len = min(length(car_signal), length(mod_signal));
    car_signal = car_signal(1:min_len);
    mod_signal = mod_signal(1:min_len);
    len = min_len;
    
    % Turn row vector into column vector.
    car_signal = car_signal.';
    mod_signal = mod_signal.';

end

% Utility function for plotting signals.
% p = the made plot.
% title_str = the title of the plot.
% t_plot = the values of t to plot y against.
% y = the signal to plot.
% y_lim = the y limits to use for plotting the signal.
function p=pplot(title_str,t_plot, y, y_lim)

 
    p = plot(t_plot, y);
    ylim(y_lim);
    xlim([0 t_plot(end)]);
    title(title_str);
    
    xlabel("Time t (s)")
    ylabel("Amplitude")

end