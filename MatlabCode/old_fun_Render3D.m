function [DC] = fun_Render3D(ptMatFile, iPatient, CamView)

fns = ptMatFile(iPatient).matFN;
[fd, fn] = fun_sortFinalFracitonMatFiles(fns);
DC = [];


if isfield(fn, 'Final')
if fn.bFinalSSEmpty
    display([fd, ' - Final Structure file is empty...']);
else

%% Final
ffn_Final = fullfile(fd, fn.Final);

[contData_Final] = fun_getContourData(ffn_Final);
zzF = contData_Final.CMR.zz';

XMin = contData_Final.XMin; XMax = contData_Final.XMax;
YMin = contData_Final.YMin; YMax = contData_Final.YMax;
ZMin = contData_Final.ZMin; ZMax = contData_Final.ZMax;
dz = contData_Final.dz;

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

% 3CMR
CMR = contData_Final.CMR;
[CMR.BW3] = fun_get3DMask(CMR, dxyz, xyzLim, MNP);
[f, v] = isosurface(xg, yg, zg, CMR.BW3, 0.99);
contData_Final.CMR = CMR;

iFig = 1;
[hF(iFig), hAF(1)] = fun_addFigRC(iFig, 1, 1);
hF(iFig).Name = 'Final';
patch(hAF(1), 'Faces', f, 'Vertices', v, 'Facecolor', contData_Final.CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.2);
hF(iFig).WindowState = 'maximized';

iFig = iFig+1;
[hF(iFig), hAF(2)] = fun_addFigRC(iFig, 1, 1);
hF(iFig).Name = 'Final 3CM Ring';
patch(hAF(2), 'Faces', f, 'Vertices', v, 'Facecolor', contData_Final.CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.2);
hF(iFig).WindowState = 'maximized';

ST = contData_Final.ST;
sST = contData_Final.sST;
iOL3 = 0;

maskAll_Final = zeros(size(CMR.BW3));
for iST = sST
    [ST(iST).BW3] = fun_get3DMask(ST(iST), dxyz, xyzLim, MNP);
    [f, v] = isosurface(xg, yg, zg, ST(iST).BW3, 0.99);
    pch(iST) = patch(hAF(1), 'Faces', f, 'Vertices', v, 'Facecolor',ST(iST).Color, 'Edgecolor', 'none', 'FaceAlpha', 0.5);
    
    % overlap
    ST(iST).OL3 = ST(iST).BW3 & CMR.BW3;
    if (sum(ST(iST).OL3(:)) > 0)
        maskAll_Final = maskAll_Final | ST(iST).OL3;
        
        iOL3 = iOL3+1;
        sST_OL3(iOL3) = iST;
        [f, v] = isosurface(xg, yg, zg, ST(iST).OL3, 0.99);
        pchOL3(iST) = patch(hAF(2), 'Faces', f, 'Vertices', v, 'Facecolor',ST(iST).Color, 'Edgecolor', 'none', 'FaceAlpha', 0.5);
    end    
    contData_Final.ST = ST;
    contData_Final.sST_OL3 = sST_OL3;
end

LText{1} = [CMR.sName; {ST(sST).sName}'];
LText{2} = [CMR.sName; {ST(sST_OL3).sName}'];
for iFR = 1:2
    L = legend(hAF(iFR), LText{iFR}, 'Interpreter', 'none');
    L.TextColor = 'w';
    L.FontSize = 16;
    hAF(iFR).View = CamView;
    axis(hAF(iFR), 'equal', 'tight')
end

figffn = fullfile(fd, ['Render3D_Final.png']);
saveas(hF(1), figffn)    

figffn = fullfile(fd, ['Render3D_Final3CMRing.png']);
saveas(hF(2), figffn)    


%% Fractions
if isfield(fn, 'Fraction')

for iFR = 1:length(fn.Fraction)
    if ~fn.bFSSEmpty(iFR)
        ffn_F{iFR} = fullfile(fd, fn.Fraction{iFR});
        [contData_F{iFR}] = fun_getContourData(ffn_F{iFR});

        % sort z
        zzFR = contData_F{iFR}.CMR.zz';
        zzFRm = zzFR(round(length(zzFR)/2));
        [~, idx] = min(abs(zzFRm-zzF));
        shft = zzF(idx) - zzFRm;
        
        % shift z
        contData_F{iFR}.CMR.zz = contData_F{iFR}.CMR.zz + shft;
        for iST = 1:length(contData_F{iFR}.ST)
            contData_F{iFR}.ST(iST).zz = contData_F{iFR}.ST(iST).zz + shft;
        end
        contData_F{iFR}.ZMin = contData_F{iFR}.ZMin + shft;
        contData_F{iFR}.ZMax = contData_F{iFR}.ZMax + shft;
%         contData_F{n}.ZLim = contData_F{n}.ZLim + shft;
        
%         XMin = min(XMin, contData_F{n}.XMin); XMax = max(XMax, contData_F{n}.XMax);
%         YMin = min(YMin, contData_F{n}.YMin); YMax = max(YMax, contData_F{n}.YMax);
%         ZMin = min(ZMin, contData_F{n}.ZMin); ZMax = max(ZMax, contData_F{n}.ZMax);
        
        % isosurface
        CMR = contData_F{iFR}.CMR;
        [CMR.BW3] = fun_get3DMask(CMR, dxyz, xyzLim, MNP);
        [f, v] = isosurface(xg, yg, zg, CMR.BW3, 0.99);
        contData_F{iFR}.CMR = CMR;

        iFig = iFig+1;
        [hF(iFig), hA] = fun_addFigRC(iFig, 1, 1);
        hF(iFig).Name = ['Fraction - ', num2str(iFR)];
        patch(hA(1), 'Faces', f, 'Vertices', v, 'Facecolor', CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.2);
%         patch(hA(2), 'Faces', f, 'Vertices', v, 'Facecolor', CMR.Color, 'Edgecolor', 'none', 'FaceAlpha', 0.2);

        ST = contData_F{iFR}.ST;
        sST = contData_F{iFR}.sST;
        iOL3 = 0;
        maskAll_FR = zeros(size(CMR.BW3));
        for iST = sST
            [ST(iST).BW3] = fun_get3DMask(ST(iST), dxyz, xyzLim, MNP);
            [f, v] = isosurface(xg, yg, zg, ST(iST).BW3, 0.99);
%             pch(iST) = patch(hA(1), 'Faces', f, 'Vertices', v, 'Facecolor',ST(iST).Color, 'Edgecolor', 'none', 'FaceAlpha', 0.5);

            % overlap
            ST(iST).OL3 = ST(iST).BW3 & CMR.BW3;
            if (sum(ST(iST).OL3(:)) > 0)
                maskAll_FR = maskAll_FR | ST(iST).OL3;
                
                iOL3 = iOL3+1;
                sST_OL3(iOL3) = iST;
                [f, v] = isosurface(xg, yg, zg, ST(iST).OL3, 0.99);
                pchOL3(iST) = patch(hA(1), 'Faces', f, 'Vertices', v, 'Facecolor',ST(iST).Color, 'Edgecolor', 'none', 'FaceAlpha', 0.5);
            end    
            contData_F{iFR}.ST = ST;
            contData_F{iFR}.sST_OL3 = sST_OL3;
        end

        junkAnd = maskAll_Final & maskAll_FR;
        junkAndS = sum(junkAnd(:));
        junk1 = sum(maskAll_Final(:));
        junk2 = sum(maskAll_FR(:));
        DC(iFR) = 2*junkAndS/(junk1 + junk2);
        
%         LText{1} = [CMR.sName; {ST(sST).sName}'];
        LText{1} = [CMR.sName; {ST(sST_OL3).sName}'];
        for m = 1:1
            L = legend(hA(m), LText{m}, 'Interpreter', 'none');
            L.TextColor = 'w';
            L.FontSize = 16;
            hA(m).View = CamView;
            axis(hA(m), 'equal', 'tight')
        end
        
        hF(iFig).WindowState = 'maximized';
        figffn = fullfile(fd, ['Render3D_', fn.str_Fraction{iFR}, '.png']);
        saveas(hF(iFig), figffn)    

        DCffn = fullfile(fd, 'DC.mat');
        save(DCffn, 'DC')    
    end
end

end % isfield(fn, Fraction)

end % bFinalSSEmpty
else
    display([fd, ' - No Structure file for Final...']);
end % isfiled - Final