%alldfn =dir('setdata/H*_interleaved.set'); %for all subjects
alldfn =dir('resting/setdata/H01_interleaved.set'); %for a single subject
%alldfn =dir('task/setdata/H01LFA.set'); %for a single subject
alldata = zeros(size(alldfn,1), 3);

for fi =1:size(alldfn,1)
    disp(sprintf('processing %s', alldfn(fi).name));
    %the EEG and par struct are needed for the 
    %showresults_gui function
    %EEG = pop_loadset( ['task/setdata/',alldfn(fi).name], '.');
    EEG = pop_loadset( ['resting/setdata/',alldfn(fi).name], '.');
 
    disp('applying pop_CRBanalysis() ...');
%     %%setting the par struct for using pop_CRBanalysis:
    %analysis parameters
%     par.CRBpar.timeintervals.ref_int=[0 1999]; 
%     par.CRBpar.timeintervals.test_int=[2001 3998];
    par.CRBpar.timeintervals.ref_int=[1000 1500]; 
    par.CRBpar.timeintervals.test_int=[2001 2998];
%     par.CRBpar.timeintervals.ref_int=[-500 0]; 
%     par.CRBpar.timeintervals.test_int=[1 1000];

    par.CRBpar.timeintervals.t=EEG.times;
    par.CRBpar.singletrialspectra=1;
    %par.CRBpar.spectraldata =1;
    par.CRBpar.spectrapar.freq_lim=[0,40];
    par.CRBpar.spectrapar.win_type='Hanning';
    %par.CRBpar.algpar.alpha_interval=[8 13];
    par.CRBpar.algpar.w_size=2;
    %par.CRBpar.algpar.w_shift=1/(diff(par.CRBpar.timeintervals.ref_int)/1000);
    par.CRBpar.algpar.w_shift=0.2;
    par.CRBpar.algpar.lambda=0.5;
    par.CRBpar.algpar.lambda_left=0;
    par.CRBpar.algpar.epsilon=0.5;
    par.CRBpar.algpar.epsilon_left=0.2;
    par.CRBpar.algpar.rho_min=0.5;
    par.CRBpar.algpar.CFcomp=1;
    
    
%analysis logistics
    par.CRBfield = 1;
    par.CRBfieldpar.includeavespectra=1;
    par.CRBfieldpar.includestspectra=1;
    par.savepar.mat=1; 
    par.savepar.matpar.filename= 'tmp'; 
    par.savepar.matpar.includeavespectra= 1; 
    par.savepar.matpar.includestspectra = 1;
    par.typeproc =0;
    par.showresults=1;
	par.spectraplots=1;
	%par.plotspar.indexes=[3 4 5 13 14 15 23 24 25]; %F3,F4,Fz, C3,C4,Cz, P3,P4,Pz
    par.plotspar.indexes=[15 ]; %Cz
    %par.plotspar.indexes=1:27; %Cz
	par.plotspar.freq_range=[0,25];
   EEG_out=pop_CRBanalysis(EEG,1,par); %typeproc =1 --> channel data
    
 
    disp('Applying CRBanalysis(EEG.data, CRBpar)...');
    
%%The CRBpar struct are needed for the function CRBanalysis()
load tmp;
%CRBpar = CRB.par.CRBpar;
%        CRBpar.timeintervals.ref_int=[1 1999]; %needed if CRBpar.sepctraldata==0
%        CRBpar.timeintervals.test_int=[2001 3998];%needed if CRBpar.sepctraldata==0
%        CRBpar.timeintervals.t = EEG.times; %needed if CRBpar.sepctraldata==0
%       CRBpar.spectrapar.freq_lim=[8 40];
%     CRBpar.singletrialspectra=1;

%% pop_CRBanalysis will generate CRBpar for CRBanalysis
% and is there for run first
%  [CRB spectra]= CRBanalysis(data,CRBpar), where
% if CRBpar.spectraldata==0 (default)
%data is numerical matrix (Number of channels/ICs x Number of time points x Number of epochs)
%if CRBpar.spectraldata==1;
%data is a cell vector containing the reference average and test PSDs matrices 
%(Number of channels/ICs x Number of frequency points) 
%     [CRB spectra]= CRBanalysis(EEG.data,CRBpar);
%     showresults_gui(CRB, par);%showing the results of the CRB analysis


    
    indx_sel = find(CRB.results_num(:,2)==1);
    
    meanIAF = mean(CRB.results_num(indx_sel,3));
    %average boundaries of the responsiveness intervals 
    %of the channels/ICs participating in the IAF computation
    meanalpha = CRB.ave_alpha_int; 
    
    disp(sprintf('IAF=%.2f, alpha range=%.2f, %.2f',...
        meanIAF,meanalpha(1),meanalpha(2)));
    alldata(fi,:) = [meanIAF,meanalpha(1),meanalpha(2)];
end