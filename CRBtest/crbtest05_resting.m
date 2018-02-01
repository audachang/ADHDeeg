alldfn =dir('resting/setdata/H*_interleaved.set'); %for all subjects
%alldfn =dir('resting/setdata/H01_interleaved.set'); %for a single subject
alldata = zeros(size(alldfn,1), 9);

for fi =1:size(alldfn,1)
%for fi =1:2 %for debugging with only two dataset
    disp(sprintf('processing %s', alldfn(fi).name));
    %the EEG and par struct are needed for the 
    %showresults_gui function
    EEG = pop_loadset( ['resting/setdata/',alldfn(fi).name], '.');
 
    disp('applying pop_CRBanalysis() ...');
    %%setting the par struct for using pop_CRBanalysis:
    %analysis parameters
    readparam;
    sID =  cell2mat(regexp(alldfn(fi).name, '\w\d{2}','match'));
    par.savepar.matpar.filename = sprintf('tmp_%s',sID);
   EEG_out=pop_CRBanalysis(EEG,1,par); %typeproc =1 --> channel data
    
 eval(sprintf('load %s',par.savepar.matpar.filename));
%     
     indx_sel = find(CRB.results_num(:,2)==1);
     alldata(fi,:) = mean(CRB.results_num(indx_sel,:));
    
end
%creating a column of subject ID
tmp = regexp({alldfn.name}, 'H\d{2}', 'match');
sIDs =[tmp{:}]';
sIDs = table(sIDs, 'VariableNames', {'subject'});

vns = matlab.lang.makeValidName(CRB.colnames);
datatab = array2table(alldata, 'VariableNames', vns);

datatab=[sIDs datatab];

writetable(datatab, 'meanresults.txt');
