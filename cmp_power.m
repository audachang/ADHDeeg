function res=cmp_power(band,res,raweeg)
%area under curve
    tmp = getfield(res,band);%retrive the beginning/end of the band frequency
    xfseg = tmp(1):tmp(end);
    
    res=setfield(res,sprintf('area_%s',band),...
        strtrim(trapz(xfseg,raweeg.s2ana(xfseg))));
    
    res=setfield(res,sprintf('avg_%s',band),...
        strtrim(mean(raweeg.s2ana(xfseg))));

    
    ixf1 = find(raweeg.nxf==xfseg(1));
    ixf2 = find(raweeg.nxf==xfseg(end));
    smxfseg = ixf1:ixf2; %the interpolated version of xfseg
    res=setfield(res,sprintf('sm_area_%s',band),...
        strtrim(trapz(raweeg.nxf(smxfseg),...
        raweeg.spd2ana(smxfseg))));
    
    res=setfield(res,sprintf('sm_avg_%s',band),...
        strtrim(mean(raweeg.spd2ana(smxfseg))));
    
function newdata = strtrim(data)    
    newdata = cellstr(num2str(data,'%.3f'));
    

