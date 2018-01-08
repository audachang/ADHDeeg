% EEGLAB history file generated on the 06-Jan-2018
% ------------------------------------------------

EEG.etc.eeglabvers = '14.1.1'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = eeg_checkset( EEG );
EEG = pop_loadset('filename','H01_interleaved.set','filepath','C:\\mytools\\CRBtest\\setdata\\');
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG=pop_CRBanalysis(EEG,1,par);
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
