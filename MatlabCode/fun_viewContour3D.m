function [CMR] = fun_viewContour3D(matffn, matfd, FractionName, iFig);

[contData] = fun_getContourData(matffn);

% XMin = contData.XMin; XMax = contData.XMax;
% YMin = contData.YMin; YMax = contData.YMax;
% ZMin = contData.ZMin; ZMax = contData.ZMax;
% dz = contData.dz;

%% view
[hF, hA] = fun_addFig(iFig);
hA.Title.String = FractionName;
hA.Title.Color = 'w';
hF.WindowState = 'maximized';

CMR = contData.CMR;
line(hA, CMR.xxAll, CMR.yyAll, CMR.zzAll, 'Color', CMR.Color, 'LineWidth', 1);

sST = contData.sST;
for iST = sST
    line(hA, contData.ST(iST).xxAll, contData.ST(iST).yyAll,...
        contData.ST(iST).zzAll, 'Color', contData.ST(iST).Color, 'LineWidth', 1);
end

LGD = legend(hA, [contData.CMR.sName; {contData.ST(sST).sName}'], 'Interpreter', 'none');
LGD.TextColor = 'w';
LGD.FontSize = 16;
axis(hA, 'equal', 'tight')

figffn = fullfile(matfd, ['Contour3D_', FractionName, '.png']);    
saveas(hF, figffn)    
