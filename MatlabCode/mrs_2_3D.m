clearvars

b3CMRon = 1;

%% patient info
fdName_nonVG = 'VG';
ptMatInfoFN = ['matInfo_', fdName_nonVG, '.mat'];
load(ptMatInfoFN);

iPatient = 1; % patient
fns = ptMatFile(iPatient).matFN;

%% get contour data
[contData] = fun_getContourData(fns);



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