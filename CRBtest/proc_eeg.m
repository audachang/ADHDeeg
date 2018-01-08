eegpath = 'eegdata/';
setpath = 'setdata/';
eegfns = dir([eegpath '*.eeg']);

for i = 1:length({eegfns.name})
   eegfn = eegfns(i).name;
   setfn = eegfn2setfn(eegfn);
   eeg2set([eegpath eegfn],[setpath setfn]);
end