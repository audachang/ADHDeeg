%searching IAF, TF, & IBF as well as the associated bands
%over corrected frequency spectrum average exported from
%neuroscan; require the freq spectrum avg files be placed 
% in the fspec folder.
%2017-11-10 EC
% tidy up the codes and folder structures
%  *.avg of frequency spectrum in fspec/data folder
%  plots of the markers in fspec/figures 
%  scripts in ADHDeeg main folder
%2017-11-07 created by Erik Chang


%%



droot='fspec/data';
fns = dir('fspec/data/*.avg');
%define channel name
chanstr = 'FP1';


close all;
for f = 1:length(fns)
%for f=3:3
    fn = sprintf('%s/%s',droot,fns(f).name);
    [cTF,cIAF,cIBF,cTB,cAB,cBB] =...
        findmarkers_fspec(fn, chanstr,true,'fspec/figures');
    %findmarkers;
    if f==1
        tab=table(cTF,cIAF,cIBF,cTB,cAB,cBB);
    else
        tab=[tab; table(cTF,cIAF,cIBF,cTB,cAB,cBB)];
    end
end

tab.Properties.RowNames={fns.name}';
tab.Properties.VariableNames=...
    {'TF','IAF','IBF','TB','AB','BB'};
tab.Properties.Description = ['1/f corrected '...
    'by fitting least square linear function through '...
    '2-5 & 30-40 Hz'];
writetable(tab, 'fspec/summary.fspec.txt',...
    'Delimiter',',','WriteRowNames',true);

