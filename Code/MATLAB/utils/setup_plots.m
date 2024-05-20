
% Apply some default formatting to MATLAB plots to make them look nicer.

function setup_plots()

set(0, 'defaultAxesTickLabelInterpreter','latex'); 
set(0, 'defaultLegendInterpreter','latex');
set(0, 'defaulttextInterpreter','latex');
set(0,'defaultAxesFontSize',15)
set(0,'defaultAxesXGrid','on')
set(0,'defaultAxesYGrid','on')
set(0,'defaultAxesXMinorGrid','on','defaultAxesXMinorGridMode','manual');
set(0,'defaultAxesYMinorGrid','on','defaultAxesYMinorGridMode','manual');

end