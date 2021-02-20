function [CMR] = fun_viewContour3D(matffn, matfd, FractionName, iFig);

[contData] = fun_getContourData(matffn);

% XMin = contData.XMin; XMax = contData.XMax;
% YMin = contData.YMin; YMax = contData.YMax;
% ZMin = contData.ZMin; ZMax = contData.ZMax;
% dz = contData.dz;

%% view
[hF(iFig), hA(iFig)] = fun_addFig(iFig);
hA(iFig).Title.String = FractionName;
hA(iFig).Title.Color = 'w';
hF(iFig).WindowState = 'maximized';

CMR = contData.CMR;
line(hA(iFig), CMR.xxAll, CMR.yyAll, CMR.zzAll, 'Color', CMR.Color, 'LineWidth', 1);

sST = contData.sST;
for iST = sST
    line(hA(iFig), contData.ST(iST).xxAll, contData.ST(iST).yyAll,...
        contData.ST(iST).zzAll, 'Color', contData.ST(iST).Color, 'LineWidth', 1);
end

LGD = legend(hA(iFig), [contData.CMR.sName; {contData.ST(sST).sName}'], 'Interpreter', 'none');
LGD.TextColor = 'w';
LGD.FontSize = 16;
axis(hA(iFig), 'equal', 'tight')

figffn = fullfile(matfd, ['Contour3D_', FractionName, '.png']);    
saveas(hF(iFig), figffn)    
