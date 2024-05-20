function echo_pole_zero_plot

D = 3;
gain = 0.8;
b = [1 zeros(1, D-1) gain];
a = 1;

setup_plots();
set(0,'defaultLineLineWidth',1)
poleZero= figure("Name", "Pole Zero");
poleZero.Position = [957   193   474   270];
zplane(b,a);
title(['\textbf{FFCF Pole-Zero Plot}, $D=' num2str(D) '$, $a=' num2str(gain) '$' ]);
xlabel('Real Part');
ylabel("Imaginary Part")
legend("Pole", "Zero");
print("Echo Plots/EchoPoleZero",'-depsc', '-vector');
end