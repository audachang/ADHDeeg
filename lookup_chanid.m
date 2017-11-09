function chanid = lookup_chanid(chanstr,chan_names)

     a = mat2cell(char(chan_names), ones(36,1));
     a = replace(a,' ','');
     a = replace(a,char(0),'');
     b = strcmp(a,chanstr);
     chanid = find(b);
     if isempty(chanid) 
         error(sprintf('Cannot find channel label %s',chanstr));
     else
         disp(sprintf('Channel %s has ID %d',chanstr, chanid));
     end
