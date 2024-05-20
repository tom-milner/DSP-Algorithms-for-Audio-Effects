clear all;
close all;

setup_plots();
set(0,'defaultLineLineWidth',.1)

guitar_sample();


function guitar_sample()

% Guitar Sample
[in, Fs] = audioread("Audio/Guitar/Guitar Input.wav");
plot_length = round(length(in) / Fs) + 5;
padding = zeros(1, (plot_length * Fs) - length(in));
in = [in.' padding]; % Make room for reverb samples.

plot_signals(in, Fs, plot_length, 'Guitar Sample', 'GuitarSample');
end

% in = input signal.
% Fs = sample rate.
% plot_length = length of the matlab plot (in samples).
% header = the title for the output graphs.
% filename = prefix for output files.
function f=plot_signals(in, Fs, plot_length, header, filename)

% Reverberation times - feel free to play about with these!
Trs = [0.5 1 2 4];

% Generate output signals for each reverb time.
out_signals = cell(1,length(Trs));
for i=1:length(Trs)
out_signals{1,i} = schroeder_reverb(in, Fs, Trs(i));
end

out_colors = [
    "#0072BD"
    "#ff9900"
    "#7E2F8E"
    "#77AC30"
];

in_color = "#A2142F";

% Plot output signals.
f = figure("Name", header);
tiledlayout(length(Trs) + 1,1, "TileSpacing","none")
f.Position = [1     1   735   821];

x_lim = [0 plot_length];
y_lim = [-1.5 1.5];

max_len = max(length(in),length(out_signals{1,end}));
Ts = 1/Fs;
pt = 0:Ts:((max_len-1)*Ts);

nexttile
plot(pt, in, "Color", in_color);
title(['\textbf{Multiple Reverberation Times}: ' header ]);
ylabel("Amplitude")
ylim(y_lim)
xlim(x_lim);
legend("Input");
set(gca,'XTickLabel',[]);

% Plot each signal.
for i=01:length(Trs)
nexttile
cur_out = out_signals{1,i};
plot(pt, cur_out,"Color", out_colors(i));
xlim(x_lim);
ylim(y_lim)

% Turn off X Labels for all but last plot.
if i ~= length(Trs)
set(gca,'XTickLabel',[]);
end

% Put X Labels on last plot.
if i == length(Trs)
xlabel('Time t (s)');
end

legend(['(' num2str(i) ') ' '$T_r=' num2str(Trs(i)) '$ s']);

end


% Signal Overlay - Late Response
lateFig = figure("Name","Late Response");
lateFig.Position = [737     1   735   368];
hold on;

for i=length(Trs):-1:1
plot(pt, out_signals{1,i}, "Color", out_colors(i));
end

title(['\textbf{Overlay - Late Reverb}: ' header ]);
xlabel('Time t (s)');
ylabel("Amplitude")
ylim(y_lim)
xlim(x_lim);

legend_entry = strings(1,length(Trs));
for i=length(Trs):-1:1
% Generate legend keys for each signal.
legend_entry(length(Trs)+1 - i) = (['(' num2str(i) ') ' '$T_r=' num2str(Trs(i)) '$ s']);
end
legend(legend_entry{:});

% Signal Overlay - Early Response
earlyFig = figure("Name","Early Response");
earlyFig.Position = [737   448   735   374];
hold on;
pt_ms = pt*1000;
for i=1:length(Trs)
plot(pt_ms, out_signals{1,i}, "Color", out_colors(i));
end
title(['\textbf{Overlay - Early Reverb}: ' header ]);
xlabel('Time t (ms)');
ylabel("Amplitude")
ylim(y_lim)
xlim([0 1000]);

legend_entry = strings(1,length(Trs));
for i=length(Trs):-1:1
legend_entry(i) = (['(' num2str(i) ') ' '$T_r=' num2str(Trs(i)) '$ s']);
end
legend(legend_entry{:});

% Output the files.
audiowrite(['Audio/Guitar/Reverb' filename 'Input.wav'], in, Fs);
for i=1:length(Trs)
audiowrite(['Audio/Guitar/Reverb' filename 'Output_Tr' num2str(Trs(i)) '.wav'], out_signals{1,i}, Fs);
end

print(f, ['Reverb Plots/Guitar/Reverb' filename],'-depsc', '-vector');
print(earlyFig, ['Reverb Plots/Guitar/Reverb' filename '_Early'],'-depsc', '-vector');
print(lateFig, ['Reverb Plots/Guitar/Reverb' filename '_Late'],'-depsc', '-vector');
end
