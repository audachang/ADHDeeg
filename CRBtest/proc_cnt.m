cntpath = 'resting/cnt/';
setpath = 'resting/set/';
cntfns = dir([cntpath '*.cnt']);

for i = 1:length({cntfns.name})
   cntfn = cntfns(i).name;
   setfn = cntfn2setfn(cntfn);
   cnt2set([cntpath cntfn],[setpath setfn]);
end