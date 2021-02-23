function [BW3, param3D, STNames, CLR] = fun_Render3D(matffn, matfd, FractionName, iFig, bFinal, param3D, CamView)

[contData] = fun_getContourData(matffn);
CMR = contData.CMR;
ST = contData.ST;
sST = contData.sST;

if bFinal
    zzF = contData.CMR.zz';

    XMin = contData.XMin; XMax = contData.XMax;
    YMin = contData.YMin; YMax = contData.YMax;
    ZMin = contData.ZMin; ZMax = contData.ZMax;
    dz = contData.dz;

    % grid
    dx = 1;
    dy = 1;
    dxyz = [dx dy dz];

    junk = dz;
    x1 = floor(XMin-junk);
    x2 = ceil(XMax+junk);
    y1 = floor(YMin-junk);
    y2 = ceil(YMax+junk);
    z1 = ZMin-junk;
    z2 = ZMax+junk;
    xyzLim = [x1 x2 y1 y2 z1 z2];

    N = round((x2-x1)/dx)+1;
    M = round((y2-y1)/dy)+1;
    P = round((z2-z1)/dz)+1;
    MNP = [M N P];

    [xg, yg, zg] = meshgrid(x1:dx:x2, y1:dy:y2, linspace(z1, z2, P));
    
    param3D.zzF = zzF;
    param3D.dxyz = dxyz;
    param3D.xyzLim = xyzLim;
    param3D.MNP = MNP;
    param3D.xg = xg;
    param3D.yg = yg;
    param3D.zg = zg;
else
    zzF = param3D.zzF;
    dxyz = param3D.dxyz;
    xyzLim = param3D.xyzLim;
    MNP = param3D.MNP;
    xg = param3D.xg;
    yg = param3D.yg;
    zg = param3D.zg;
    
    % shift z
    zzFR = CMR.zz';
    zzFRm = zzFR(round(length(zzFR)/2));
    [~, idx] = min(abs(zzFRm-zzF));
    shft = zzF(idx) - zzFRm;

    CMR.zz = CMR.zz + shft;
    for iST = 1:length(ST)
        ST(iST).zz = ST(iST).zz + shft;
    end
end
% 3CMR
[BW3.CMR] = fun_get3DMask(CMR, dxyz, xyzLim, MNP);
[f, v] = isosurface(xg, yg, zg, BW3.CMR, 0.99);

[hF, hA] = fun_addFig(iFig);
patch(hA, 'Faces', f, 'Vertices', v, 'Facecolor', CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.2);
hA.Title.String = FractionName;
hA.Title.Color = 'w';
hF.WindowState = 'maximized';
CLR.CMR = CMR.Color;

for iST = sST
    [BW3.ST{iST}] = fun_get3DMask(ST(iST), dxyz, xyzLim, MNP);
    [f, v] = isosurface(xg, yg, zg, BW3.ST{iST}, 0.99);
    patch(hA, 'Faces', f, 'Vertices', v, 'Facecolor', ST(iST).Color, 'Edgecolor', 'none', 'FaceAlpha', 0.5);
    CLR.ST{iST} = ST(iST).Color;
end
STNames = {ST(sST).sName}';
LText = [CMR.sName; STNames];
L = legend(hA, LText, 'Interpreter', 'none');
L.TextColor = 'w';
L.FontSize = 16;
hA.View = CamView;
axis(hA, 'equal', 'tight')
figffn = fullfile(matfd, ['Render3D_', FractionName, '.png']);
saveas(hF, figffn)