alldfn =dir('H*.set'); %change this to the epoched datafile 
alldata = zeros(size(alldfn,1), 3);

for fi =1:size(alldfn,1)
    disp(sprintf('processing %s', alldfn(fi).name));
    %the EEG and par struct are needed for the 
    %showresults_gui function
    EEG = pop_loadset( alldfn(fi).name, ...
        '.');
    par.CRBpar.timeintervals.ref_int=[-400 -100]; 
    par.CRBpar.timeintervals.test_int=[0 800];
    par.CRBpar.timeintervals.t=EEG.times;
    par.savepar.mat=1; 
    par.savepar.matpar.filename= 'tmp'; 
    par.savepar.matpar.includeavespectra= 1; 
    par.CRBpar.singletrialspectra=1;
    par.typeproc=0;
    %EEG_out=pop_CRBanalysis(EEG,1,par);
    %The CRBpar struct are needed for the 
    %CRBanalysis
    CRBpar.timeintervals.ref_int=[-400 -100]; 
    CRBpar.timeintervals.test_int=[0 800];
    CRBpar.timeintervals.t = EEG.times;
    CRBpar.spectraldata=0;
    CRBpar.spectrapar.freq_lim=[1 40];
    CRBpar.typeproc=0;

    disp('applying CRB analysis...');
    [CRB spectra]= CRBanalysis(EEG.data,CRBpar);
    %showresults_gui(CRB, par);%showing the results of the CRB analysis
    meanIAF = mean(CRB.results_num(:,3));
    meanalpha = mean(CRB.results_num(:,5:6));

    disp(sprintf('IAF=%.2f, alpha range=%.2f, %.2f',...
        meanIAF,meanalpha(1),meanalpha(2)));
    alldata(fi,:) = [meanIAF,meanalpha(1),meanalpha(2)];
end