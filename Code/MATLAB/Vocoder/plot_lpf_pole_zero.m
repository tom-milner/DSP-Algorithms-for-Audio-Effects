clear all;
close all;
setup_plots();
set(0,'defaultLineLineWidth',1)

% This script plots the pole zero diagram of the LPF used in the Vocoder.

r = 0.99;
lpf = {};
lpf.a = [1, -2*r, +r*r];
lpf.b = 1;

poleZero= figure("Name", "Pole Zero");
poleZero.Position = [957   193   474   270];
zplane(lpf.b,lpf.a);
title(['\textbf{FFCF Pole-Zero Plot}, $r=' num2str(r) '$']);
xlabel('Real Part');
ylabel("Imaginary Part")
legend("Pole", "Zero");
print("Vocoder Plots/LPFPoleZero",'-depsc', '-vector');
print("Vocoder Plots/LPFPoleZero",'-dpdf', '-bestfit');