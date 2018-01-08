Flow of analysis

1. place the eeg files of open-eye & close eye data (should be already epoched to 2 second segments) from the same participant in the resting/eegdata folder (one for open eye and the other for close eye, with the same prefix indicating the data are from the same participant)

2. run proc_eeg.m to convert all eeg files to set files
3. run proc_mix.m to interleave the close eye and open eye resting data and "fuse" adjacent epochs into a "trial"

4. run crbtest04_resting.m to view the results of CRB analysis on a particular participant (changing the subject ID at the first line of the code to swap the participant's data for viewing)