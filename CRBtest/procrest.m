EEG_open = pop_loadcnt('resting/E01VAO1.cnt');
EEG_close = pop_loadcnt('resting/E01VAC1.cnt');
EEG_open = pop_saveset(EEG_open,'resting/E01VAO1.set');
EEG_close = pop_saveset(EEG_close,'resting/E01VAC1.set');