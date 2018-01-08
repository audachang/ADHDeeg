function cnt2set(cntfile,setfile)
EEG = pop_loadcnt(cntfile);

EEG = pop_saveset(EEG,setfile);