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

XMin = contData_Final.XMin; XMax = contData_Final.XMax;
YMin = contData_Final.YMin; YMax = contData_Final.YMax;
ZMin = contData_Final.ZMin; ZMax = contData_Final.ZMax;
dz = contData_Final.dz;

%% view
iFig = 1;
[hF(iFig), hA(iFig)] = fun_addFig(iFig);
hA(iFig).Title.String = 'Final';
hA(iFig).Title.Color = 'w';

[hF_3CMR, hA_3CMR] = fun_addFig(101);

hL.Final.CMR = line(hA(iFig), contData_Final.CMR.xxAll, contData_Final.CMR.yyAll, contData_Final.CMR.zzAll,...
    'Color', contData_Final.CMR.Color, 'LineWidth', 0.1);

line(hA_3CMR, contData_Final.CMR.xxAll, contData_Final.CMR.yyAll, contData_Final.CMR.zzAll,...
    'Color', 'g', 'LineWidth', 0.1);

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

%% Fractions    
for n = 1:length(fn.Fraction)
    if ~fn.bFSSEmpty(n)
        ffn_F{n} = fullfile(fd, fn.Fraction{n});
        [contData_F{n}] = fun_getContourData(ffn_F{n});

        XMin = min(XMin, contData_F{n}.XMin); XMax = max(XMax, contData_F{n}.XMax);
        YMin = min(YMin, contData_F{n}.YMin); YMax = max(YMax, contData_F{n}.YMax);
        ZMin = min(ZMin, contData_F{n}.ZMin); ZMax = max(ZMax, contData_F{n}.ZMax);
        
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

    end
    
end