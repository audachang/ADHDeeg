function eeg2set(eegfile,setfile)
EEG = pop_loadeeg(eegfile);

EEG = pop_saveset(EEG,setfile);