clear all;
close all;

setup_plots();
set(0,'defaultLineLineWidth',.1)

sine_burst();

function sine_burst()

%  Generate a sinewave burst.
Fs = 44100;
Fc = 800;
a = 0.5;
duration = 200;
in = sin_burst(Fc,Fs,duration,a);
in=in.';

% Make room for the reverb on the input signal.
plot_length = 6; %seconds
padding = zeros(1, plot_length * Fs - length(in));
in = [in.' padding];
filename = ['SineWave_' num2str(Fc) 'Hz'];
plotname =  ['Sine Wave Input ($' num2str(a) '\sin(2\pi f_ct)$, $f_c=' num2str(Fc) '$ Hz)'];

% Plot the output signals.
plot_signals(in, Fs, plot_length,plotname,filename);
end

% in = input signal.
% Fs = sample rate.
% plot_length = length of the matlab plot (in samples).
% header = the title for the output graphs.
% filename = prefix for output files.
function f=plot_signals(in, Fs, plot_length, header, filename)

% Reverb times (Tr).
Trs = [1 2 5 10];
outs = cell(1,length(Trs));
for i=01:length(Trs)
outs{1,i} = schroeder_reverb(in, Fs, Trs(i));
end
colors = [
    "#0072BD"
    "#ff9900",
    "#7E2F8E",
    "#77AC30"
];

in_color = "#A2142F";

f = figure("Name", header);
tiledlayout(length(Trs) + 1,1, "TileSpacing","none");
f.Position = [1     1   735   821];

x_lim = [0 plot_length];
y_lim = [-1.5 1.5];

max_len = max(length(in),length(outs{1,end}));
Ts = 1/Fs;
pt = 0:Ts:((max_len-1)*Ts);

% Plot all reverb outputs.
nexttile
plot(pt, in, "Color", in_color);
title(['\textbf{Multiple Reverberation Times}: ' header ]);
ylabel("Amplitude")
ylim(y_lim)
xlim(x_lim);
legend("Input");
set(gca,'XTickLabel',[]);

% Plot each output.
for i=01:length(Trs)
nexttile
cur_out = outs{1,i};
plot(pt, cur_out,"Color", colors(i));
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
plot(pt, outs{1,i}, "Color", colors(i));
end
title(['\textbf{Overlay - Late Reverb}: ' header ]);
xlabel('Time t (s)');
ylabel("Amplitude")
ylim(y_lim)
xlim(x_lim);

leg_ent = strings(1,length(Trs));
for i=length(Trs):-1:1
leg_ent(length(Trs)+1 - i) = (['(' num2str(i) ') ' '$T_r=' num2str(Trs(i)) '$ s']);
end
legend(leg_ent{:});

% Signal Overlay - Early Response
earlyFig = figure("Name","Early Response");
earlyFig.Position = [737   448   735   374];
hold on;
pt_ms = pt*1000;

% Uncomment if you want to see input
% signal aswell
% plot(pt_ms, in, "Color", in_color); 

for i=1:length(Trs)
plot(pt_ms, outs{1,i}, "Color", colors(i));
end
title(['\textbf{Overlay - Early Reverb}: ' header ]);
xlabel('Time t (ms)');
ylabel("Amplitude")
ylim(y_lim)
xlim([0 400]);

leg_ent = strings(1,length(Trs));
for i=length(Trs):-1:1
leg_ent(i) = (['(' num2str(i) ') ' '$T_r=' num2str(Trs(i)) '$ s']);
end
% leg_ent(length(Trs)+1)= "Input";
legend(leg_ent{:}, "location", "east");



% Output Files.

audiowrite(['Audio/Sinewave/Reverb' filename 'Input.wav'], in, Fs);
for i=1:length(Trs)
audiowrite(['Audio/Sinewave/Reverb' filename 'Output_Tr' num2str(Trs(i)) '.wav'], outs{1,i}, Fs);
end

print(f, ['Reverb Plots/Sinewave/Reverb' filename],'-depsc', '-vector');
print(earlyFig, ['Reverb Plots/Sinewave/Reverb' filename '_Early'],'-depsc', '-vector');
print(lateFig, ['Reverb Plots/Sinewave/Reverb' filename '_Late'],'-depsc', '-vector');
end
