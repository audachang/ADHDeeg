%%
setpns = 'resting/setdata/'; %set the directory containing the .set files to be interleaved
setfns = dir([setpns sprintf('H*s.set')]); %get all file names
setfns = {setfns.name}; %reduce the returned struct to only name
m=regexp(setfns, 'H\d{2}','match'); %extracting the IDs
sIDs = unique([m{:}]); %extracting unique IDs

%%
for si = 1:length(sIDs)
        tfns = dir([setpns sprintf('%s*s.set',sIDs{si})]); %set file associated with the current sID
        tfns = {tfns.name};
        tfns = strcat(setpns, tfns);
        EEG=pop_loadset('filename',tfns);%read closed and open eye EEG

        event_n = min(EEG.trials);
        %%To make the O & C set of equal number of epoch
        for ei=1:length(EEG)
          EEG(ei) = pop_selectevent( EEG(ei), ...
             'event',1:event_n,...
             'type',{'TLE'});
         EEG(ei) = eeg_checkset( EEG(ei) );
        end
        %%
        %merge the C and O sets (1st and 2nd halfs, respectively)
        EEG2= pop_mergeset(EEG, [1:length(EEG)]);
        %for interleaving the epoch from EEG(1) and EEG(2)
        mixseq= reshape(reshape(1:event_n*2, event_n, 2)',event_n*2,1);
        mixedeventtype= repmat({'C','O'},1, event_n);
        EEG2.data = EEG2.data(:,:,mixseq);%reorder the epochs data to interleave sets
        %effectively "glue" adjacent epochs
        EEG2.data = reshape(EEG2.data, size(EEG2.data).*[1,2,0.5]); 
        %keep the equivalent length of epochs
        EEG2.epoch = EEG2.epoch(1:event_n*2);
        %rearrange the order of the epochs. 
        [EEG2.epoch]=EEG2.epoch(mixseq);

        EEG2.event = EEG2.event(2:2:event_n*2);
        %force the event.type to the new label ('O')
        [EEG2.event.type]=deal(mixedeventtype{2:2:event_n*2});
        EEG2.epoch = EEG2.epoch(2:2:event_n*2);
        EEG3 = eeg_checkset(EEG2);
        EEG3= pop_saveset(EEG3,...
            sprintf('%s/%s_interleaved.set',setpns,sIDs{si}));
        %pop_eegplot( EEG3, 1, 1, 1);
end