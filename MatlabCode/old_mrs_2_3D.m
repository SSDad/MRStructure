clearvars

b3CMRon = 1;

%% patient info
fdName_nonVG = 'VG';
ptMatInfoFN = ['matInfo_', fdName_nonVG, '.mat'];
load(ptMatInfoFN);

iPatient = 1; % patient
fns = ptMatFile(iPatient).matFN;
[fd, fn] = fun_sortFinalFracitonMatFiles(fns);

%% Final
ffn_Final = fullfile(fd, fn.Final);

[contData_Final] = fun_getContourData(ffn_Final);
zzF = contData_Final.CMR.zz';

XMin = contData_Final.XMin; XMax = contData_Final.XMax;
YMin = contData_Final.YMin; YMax = contData_Final.YMax;
ZMin = contData_Final.ZMin; ZMax = contData_Final.ZMax;
dz = contData_Final.dz;

%% Fractions    
for n = 1:length(fn.Fraction)
    if ~fn.bFSSEmpty(n)
        ffn_F{n} = fullfile(fd, fn.Fraction{n});
        [contData_F{n}] = fun_getContourData(ffn_F{n});

        % sort z
        zzFR = contData_F{n}.CMR.zz';
        zzFRm = zzFR(round(length(zzFR)/2));
        [~, idx] = min(abs(zzFRm-zzF));
        shft = zzF(idx) - zzFRm;
        
        % shift z
        contData_F{n}.CMR.zz = contData_F{n}.CMR.zz + shft;
        for iST = 1:length(contData_F{n}.ST)
            contData_F{n}.ST(iST).zz = contData_F{n}.ST(iST).zz + shft;
        end
        contData_F{n}.ZMin = contData_F{n}.ZMin + shft;
        contData_F{n}.ZMax = contData_F{n}.ZMax + shft;
%         contData_F{n}.ZLim = contData_F{n}.ZLim + shft;
        
        XMin = min(XMin, contData_F{n}.XMin); XMax = max(XMax, contData_F{n}.XMax);
        YMin = min(YMin, contData_F{n}.YMin); YMax = max(YMax, contData_F{n}.YMax);
        ZMin = min(ZMin, contData_F{n}.ZMin); ZMax = max(ZMax, contData_F{n}.ZMax);
        
    end
end



%% isosurface
% grid
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

[xg, yg, zg] = meshgrid(x1:dx:x2, y1:dy:y2, linspace(z1, z2, P));

% Final
% 3CMR
[BW3] = fun_get3DMask(contData_Final.CMR, dxyz, xyzLim, MNP);
[f, v] = isosurface(xg, yg, zg, BW3, 0.99);

% figure
iFig = 1;
[hF(iFig), hA(iFig)] = fun_addFig(iFig);
hA(iFig).Title.String = 'Final';
hA(iFig).Title.Color = 'w';
patch(hA(iFig), 'Faces', f, 'Vertices', v, 'Facecolor', contData_Final.CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.2);





        iFig = iFig+1;
        [hF(iFig), hA(iFig)] = fun_addFig(iFig);
        hA(iFig).Title.String = fn.str_Fraction{n};
        hA(iFig).Title.Color = 'w';

        hL.Final.CMR = line(hA(iFig), contData_F{n}.CMR.xxAll, contData_F{n}.CMR.yyAll, contData_F{n}.CMR.zzAll,...
            'Color', contData_F{n}.CMR.Color, 'LineWidth', 0.1);
        line(hA_3CMR, contData_F{n}.CMR.xxAll, contData_F{n}.CMR.yyAll, contData_F{n}.CMR.zzAll,...
            'Color', rand(1,3), 'LineWidth', 0.1);

        sST = contData_F{n}.sST;
        for iST = sST
            hL.F(n).ST(iST) = line(hA(iFig), contData_F{n}.ST(iST).xxAll, contData_F{n}.ST(iST).yyAll,...
                contData_F{n}.ST(iST).zzAll, 'Color', contData_F{n}.ST(iST).Color, 'LineWidth', 0.1);
        end

        LGD.F(n) = legend(hA(iFig), [contData_F{n}.CMR.sName; {contData_F{n}.ST(sST).sName}'], 'Interpreter', 'none');
        LGD.F(n).TextColor = 'w';
        LGD.F(n).FontSize = 16;
        axis(hA(iFig), 'equal', 'tight')
        
        figffn = fullfile(fd, ['Contour3D_', fn.str_Fraction{n}, '.png']);    
        saveas(hF(iFig), figffn)    

    
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

%% view
iFig = 1;
[hF(iFig), hA(iFig)] = fun_addFig(iFig);
hA(iFig).Title.String = 'Final';
hA(iFig).Title.Color = 'w';

sST = contData_Final.sST;
for iST = sST
    hL.Final.ST(iST) = line(hA(iFig), contData_Final.ST(iST).xxAll, contData_Final.ST(iST).yyAll,...
        contData_Final.ST(iST).zzAll, 'Color', contData_Final.ST(iST).Color, 'LineWidth', 0.1);
end

LGD.Final = legend(hA(iFig), [contData_Final.CMR.sName; {contData_Final.ST(sST).sName}'], 'Interpreter', 'none');
    LGD.Final.TextColor = 'w';
    LGD.Final.FontSize = 16;
    axis(hA(1), 'equal', 'tight')

figffn = fullfile(fd, 'Contour3D_Final.png');    
saveas(hF(iFig), figffn)    
