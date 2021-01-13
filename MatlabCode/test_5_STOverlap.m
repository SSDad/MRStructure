clearvars

b3CMRon = 1;

fd_matData = 'X:\Lab\Zhen\MRStructure\matData';
fdName_nonVG = 'VG';
fd_matData_nonVG = fullfile(fd_matData, fdName_nonVG);

junk = dir(fd_matData_nonVG);
fd_pt =junk(~ismember({junk(:).name},{'.','..'}));

for iPt = 1:length(fd_pt)
    ffd = fullfile(fd_pt(iPt).folder, fd_pt(iPt).name);
    junk = dir(ffd);
    fnSS =junk(~ismember({junk(:).name},{'.','..'}));

    % Final
    indFile = find(contains({fnSS.name}, '_final', 'IgnoreCase' ,true));
    if ~isempty(indFile)
        idx_3CMR = indFile(end);
        ffn_Final{iPt} = fullfile(fnSS(idx_3CMR).folder, fnSS(idx_3CMR).name);
    end
end

iPatient = 1; % patient
load(ffn_Final{iPatient});
T = SS.ROIs;
[nS, ~] = size(T);

% 3d
hF = figure(1); clf(hF)
hF.Color = 'k';
hA(1) = axes('parent', hF);
hA(1).Color = 'k';
hold(hA(1), 'on')
view(3)

hA(1).XColor = 'w';
hA(1).YColor = 'w';
hA(1).ZColor = 'w';

%% 3CM_RING
sNames = T.Name;
% idx_3CMR = find(contains(sNames, '3CM'));
idx_3CMR = find(contains(sNames, '3CM', 'IgnoreCase' ,true) & ...
        contains(sNames, 'Ring', 'IgnoreCase' ,true));
iS = idx_3CMR;
cont_3CMR = T.ContourData{iS};
Color_3CMR = T.Color{iS}/255;
name_3CMR = sNames{iS};
xx1 = [];
yy1 = [];
zz1 = [];
for iC = 1:length(cont_3CMR)
    xx = cont_3CMR{iC}(:,1);
    yy = cont_3CMR{iC}(:,2);
    zz = cont_3CMR{iC}(:,3);
    zz_3CMR(iC) = zz(1);
    
    xx1 = [xx1;xx];
    yy1 = [yy1;yy];
    zz1 = [zz1;zz];
end
hL_3CMR = line(hA(1), xx1, yy1, zz1, 'Color', Color_3CMR, 'LineWidth', 0.1);
XMin = min(xx1);  XMax = max(xx1);
YMin = min(yy1);  YMax = max(zz1);
ZMin = min(zz1);  ZMax = max(zz1);
dz = abs(cont_3CMR{iC-1}(1,3)-cont_3CMR{iC}(1,3));

CMR.cont = cont_3CMR;
CMR.Color = Color_3CMR;
CMR.sName = name_3CMR;
CMR.zz = zz_3CMR;

%%  ST
load('STList')
for iST = 1:3
    indST{iST} = find(strcmp([lower(sNames)], lower(ST(iST).name)));
end
for iST = 4:8
    indST{iST} = find(contains(sNames, ST(iST).name{1}, 'IgnoreCase' ,true) & ...
        contains(sNames, ST(iST).name{2}, 'IgnoreCase' ,true));
    junk2 = find(contains(sNames, ST(iST).name{2}, 'IgnoreCase' ,true));
end

indNoST = find(cellfun(@isempty, indST));
indExistST = 1:8;
indExistST(indNoST) = [];

sST = indExistST;
for iST = sST 
    iS = indST{iST};
    ST(iST).Color = T.Color{iS}/255;
    ST(iST).sName = sNames{iS};
    xx1 = [];
    yy1 = [];
    zz1 = [];
    cont = T.ContourData{iS};
    ST(iST).cont = cont;
    for iC = 1:length(cont)
        xx = cont{iC}(:,1);
        yy = cont{iC}(:,2);
        zz = cont{iC}(:,3);
        ST(iST).zz(iC) = zz(1);
%         line(hA(1), xx, yy, zz, 'Color', 'g', 'LineWidth', 2);

        xx1 = [xx1;xx];
        yy1 = [yy1;yy];
        zz1 = [zz1;zz];
    end
    hL(iST) = line(hA(1), xx1, yy1, zz1, 'Color', ST(iST).Color, 'LineWidth', 0.1);
    
    ST(iST).XLim = [min(xx1) max(xx1)];
    ST(iST).YLim = [min(yy1) max(yy1)];
    ST(iST).ZLim = [min(zz1) max(zz1)];
    
    XMin = min(min(xx1), XMin);  XMax = max(max(xx1), XMax);
    YMin = min(min(yy1), YMin);  YMax = max(max(yy1), YMax);
    ZMin = min(min(zz1), ZMin);  ZMax = max(max(zz1), ZMax);

end

% contour overlap
% for iST = 1:nST
%     [OL] = fun_findStructOverlap(cont_3CMR, ST(iST).cont, Color_3CMR, ST(iST).Color);
% 
%     for iC = 1:length(cont_3CMR)
%         xx = OL{iC}(:,1);
%         yy = OL{iC}(:,2);
%         zz = OL{iC}(:,3);
%         line(hA, xx, yy, zz, 'Color', 'g', 'LineWidth', 2);
%     end
% end

%% isosurface
dx = 1;
dy = 1;
dxyz = [dx dy dz];

junk = dz*10;
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

% figure
hF2 = figure(2); clf(hF2)
hF2.Color = 'k';
hA(2) = axes('parent', hF2);
hA(2).Color = 'k';
hold(hA(2), 'on')
view(3)

hF3 = figure(3); clf(hF3)
hF3.Color = 'k';
hA(3) = axes('parent', hF3);
hA(3).Color = 'k';
hold(hA(3), 'on')
view(3)

[xg, yg, zg] = meshgrid(x1:dx:x2, y1:dy:y2, linspace(z1, z2, P));

% 3CMR
[CMR.BW3] = fun_get3DMask(CMR, dxyz, xyzLim, MNP);
[f, v] = isosurface(xg, yg, zg, CMR.BW3, 0.99);
if b3CMRon
    pch_3CMR = patch(hA(2), 'Faces', f, 'Vertices', v, 'Facecolor',CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.2);
    pch_3CMR = patch(hA(3), 'Faces', f, 'Vertices', v, 'Facecolor',CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.1);
end

% ST
iOL3 = 0;
for iST = sST
    [ST(iST).BW3] = fun_get3DMask(ST(iST), dxyz, xyzLim, MNP);
    [f, v] = isosurface(xg, yg, zg, ST(iST).BW3, 0.99);
    pch(iST) = patch(hA(2), 'Faces', f, 'Vertices', v, 'Facecolor',ST(iST).Color, 'Edgecolor', 'none', 'FaceAlpha', 0.5);
    
    % overlap
    ST(iST).OL3 = ST(iST).BW3 & CMR.BW3;
    if (sum(ST(iST).OL3(:)) > 0)
        iOL3 = iOL3+1;
        sST_OL3(iOL3) = iST;
        [f, v] = isosurface(xg, yg, zg, ST(iST).OL3, 0.99);
        pchOL3(iST) = patch(hA(3), 'Faces', f, 'Vertices', v, 'Facecolor',ST(iST).Color, 'Edgecolor', 'none', 'FaceAlpha', 0.5);
    end    

end

for n = 1:3
    if n == 3
        sST = sST_OL3;
    end
    if b3CMRon
        L = legend(hA(n), [name_3CMR; {ST(sST).sName}'], 'Interpreter', 'none');
    else
        L = legend(hA(n), [{ST(sST).sName}'], 'Interpreter', 'none');
    end
    L.TextColor = 'w';
    L.FontSize = 16;
    axis(hA(n), 'equal', 'tight')
end