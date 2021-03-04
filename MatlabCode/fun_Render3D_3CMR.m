function [BW3_3CMR] = fun_Render3D_3CMR(BW3, param3D, CLR, FractionName, iFig, STNames, matfd, CamView)

    xg = param3D.xg;
    yg = param3D.yg;
    zg = param3D.zg;

% 3CMR
BW3_3CMR.CMR = BW3.CMR;
[f, v] = isosurface(xg, yg, zg, BW3.CMR, 0.99);

[hF, hA] = fun_addFig(iFig);
patch(hA, 'Faces', f, 'Vertices', v, 'Facecolor', CLR.CMR, 'Edgecolor', 'none', 'FaceAlpha', 0.2);
hA.Title.String = FractionName;
hA.Title.Color = 'w';
hF.WindowState = 'maximized';

for iST = 1:length(STNames)
    BW3_3CMR.ST{iST} = BW3.ST{iST} & BW3.CMR;
    [f, v] = isosurface(xg, yg, zg, BW3_3CMR.ST{iST}, 0.99);
    patch(hA, 'Faces', f, 'Vertices', v, 'Facecolor', CLR.ST{iST}, 'Edgecolor', 'none', 'FaceAlpha', 0.5);
end
LText = [{'3CM_Ring'}; STNames'];
L = legend(hA, LText, 'Interpreter', 'none');
L.TextColor = 'w';
L.FontSize = 16;
hA.View = CamView;
axis(hA, 'equal', 'tight')

figffn = fullfile(matfd, ['Render3D_3CMR_', FractionName, '.fig']);
savefig(hF, figffn)
pngffn = fullfile(matfd, ['Render3D_3CMR_', FractionName, '.png']);
saveas(hF, pngffn)