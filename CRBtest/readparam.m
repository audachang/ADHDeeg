par = ini2struct('par.ini');
par.CRBpar = ini2struct('CRBpar.ini');
par.CRBpar.timeintervals.t = EEG.times;
par.savepar = ini2struct('savepar.ini');
par.plotspar = ini2struct('plotspar.ini');
