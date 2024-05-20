
%  Utility function for plotting time domain graphs.
function time_plot(title_str, x, y, x_lim, y_lim)
    
    plot(x, y);
    ylim(y_lim);
    xlim(x_lim);
    title(title_str);
   
    xlabel("Time t (ms)");
    ylabel("Amplitude");
end