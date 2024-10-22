function leg=plotps2(xf,sCz,Yo,res,ts)


f1 = loglog(xf, sCz, 'color', 'k', ...
    'linewidth', 2);
hold on;
xp = [5 14 14 5];

if ~isempty(Yo)
    L_invx = loglog(xf, Yo,'color', 'r','linewidth',2);
end

Ry=ylim(gca);
L_TF = line([res.cTF,res.cTF],[Ry(1),Ry(2)],...
    'color', 'k','linewidth',2,...
    'linestyle','-.');

L_IAF = line([res.cIAF,res.cIAF],[Ry(1),Ry(2)], ...
    'color','k', 'linewidth', 2,...
    'linestyle','--');
L_IBF = line([res.cIBF,res.cIBF],[Ry(1),Ry(2)],...
    'color', 'k','linewidth',2,...
    'linestyle',':');


yp=[Ry(1) Ry(1) Ry(2) Ry(2)];
% pe_alpha2 = patch(xp,yp,'b');%extended predefined alpha
% set(pe_alpha2,'FaceAlpha',0.1,'LineStyle','none');
xp_TB=[res.cTB(1) res.cTB(2) res.cTB(2) res.cTB(1)];
p_TB = patch(xp_TB,yp,'r');%extended predefined alpha
set(p_TB,'FaceAlpha',0.2,'LineStyle','none');
xp_AB = [res.cAB(1) res.cAB(2) res.cAB(2) res.cAB(1)];
p_AB = patch(xp_AB,yp,'g');%extended predefined alpha
set(p_AB,'FaceAlpha',0.5,'LineStyle','none');
xp_BB = [res.cBB(1) res.cBB(2) res.cBB(2) res.cBB(1)];
p_BB = patch(xp_BB,yp,'y');%extended predefined alpha
set(p_BB,'FaceAlpha',0.5,'LineStyle','none');
t =title(ts);


set(gca, 'XTick', [5 10 20 30],...
    'XLim', [0 30]);

if ~isempty(Yo)
    legstr ={'signal','1/f','TF','IAF','IBF',...
        'TB','AB','BB',...
        };
    leg = legend(legstr);    
    set(leg, 'Location', 'SouthWest')
end    
    


