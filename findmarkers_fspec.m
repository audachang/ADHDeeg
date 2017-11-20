function res = ...
    findmarkers_fspec(fn, chanstr, plotflag,pfolder)
%2017-11-19 EC
% added area and mean power to output
% store input/output EEG parameter in the res struct
%2017-11-09 added IBF and Beta band (peak 14-30, IBF+-2) detection
% also modularize each of the major steps
% using built-in findpeaks to locate IAF and IBF
% correcting line and patch labels as well as returned value labels
%2017-11-07 created by Erik Chang

%plotflag=false;
%read in the *.avg file
%fn = 'H11LaC.avg';
[signal,variance, chan_names,...
    pnts,srate,xmin,xmax]=loadavg(fn);
%chanstr = 'CZ';
chanid = lookup_chanid(chanstr,chan_names);
%determine freq range to analyze
freq_range = 1:40;
%only use 1 to 40Hz
signal2ana = signal(:,freq_range);

s2ana = signal2ana(chanid,:); %signal of 2ana channel

%splined dataset
xf = 1:length(s2ana); %original frequencies
inv_xf = 1./xf;%inversed frequencies
log_xf = log(xf); %log raw frequency
log_s2ana = log(s2ana);

%applying least suqre linear fit to compute the 1/f line 
lm_log_xf =log_xf([2:5,30:40])';
lm_X = [ones(size(lm_log_xf)) lm_log_xf];
lm_log_s2ana = log_s2ana([2:5,30:40])';

b = lm_X\lm_log_s2ana;

%the 1/f correction line (both inv_X & inv_Y in log space)
inv_X = [ones(size(log_xf')) log_xf'];
inv_Y = inv_X*b; %1/f in log unit

%1/f X Y in original space
Xo = exp(inv_X(:,2));
Yo = exp(inv_Y);


log_inv_xf = log(inv_xf)+abs(min(log(inv_xf))); %log inversed raw frequency
log_cs2ana = log_s2ana'-inv_Y; %log corrected raw  data
cs2ana = exp(log_cs2ana);
cinv_xf = exp(log_inv_xf);


nxf = 1:0.005:length(s2ana); %splined space frequecies

spd2ana = spline(1:length(s2ana),s2ana , nxf);

raweeg.s2ana=s2ana;
raweeg.nxf =nxf;
raweeg.spd2ana=spd2ana;


log_nxf = log(nxf);
inv_nX = [ones(size(log_nxf')) log_nxf'];
inv_nY = inv_nX*b; %1/f in log unit

log_spd2ana = log(spd2ana);
log_cspd2ana = log_spd2ana - inv_nY; %1/f correction 

%raw IAF
alpha_s2ana = s2ana(5:14);
beta_s2ana = s2ana(14:30);
[IAFvalue,rawIAF] = max(alpha_s2ana);
[IBFvalue,rawIBF] = max(beta_s2ana);
rawIAF = rawIAF+5-1;
rawIBF = rawIBF+14-1;

%corrected IAF
alpha_log_cs2ana = log_cs2ana(5:14);
beta_log_cs2ana = log_cs2ana(14:30);
[pcIAF, tmp1, wIAF,pIAF]=findpeaks(alpha_log_cs2ana);
if length(pcIAF)>1
    [pcIAF,tmp11] = max(pcIAF);
    tmp1 = tmp1(tmp11);
end
[pcIBF, tmp2, wIBF,pIBF]=findpeaks(beta_log_cs2ana);
if length(pcIBF)>1
    [pcIBF,tmp21] = max(pcIBF);
    tmp2 = tmp2(tmp21);
end
%[pcIBF,tmp2] = max(beta_log_cs2ana);
res.cIAF = tmp1+5-1;
res.cIBF = tmp2+14-1;
%limit the searching range of TF within alpha
[mAB,mABi] = min(alpha_log_cs2ana(1:tmp1));

%TF was computed as the minimum power
%in the extended alpha frequency range (5-14Hz)
res.cTF = mABi+5-1;
res.cAB = [res.cIAF-2, res.cIAF+2];
res.cTB = [res.cTF-2 res.cTF];
res.cBB = [res.cIBF-2, res.cIBF+2];

%area under curve
%alpha band
res=cmp_power('cAB',res,raweeg);
%theta band
res=cmp_power('cTB',res,raweeg);
%beta band
res=cmp_power('cBB',res,raweeg);

if plotflag
    
    figure;
    subplot(1,2,1);
    [a,fn,ext] = fileparts(fn);
    %ploting the frequency powerspectrum with IAF marked
    ts =sprintf('%s|original',fn);
    leg = plotps2(xf,s2ana,Yo,res,ts);

    subplot(1,2,2);
    ts =sprintf('%s|corrected for 1/f',fn);
    plotps2(xf,cs2ana,[],res,ts)
    
    set(gcf, 'Position', [0 0 1024 512],...
        'color','w');
    shg;
    
    fign = sprintf('%s/%s.jpg',pfolder,fn);
    saveas(gcf, fign);
end
