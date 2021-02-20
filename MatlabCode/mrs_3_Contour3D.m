clearvars

folder_nonVG = 'VG';
fn = ['PatientTable_', folder_nonVG];    
load(fn);
fn = ['MatTable_', folder_nonVG];    
load(fn);

[PatientList, ia, ic] = unique(T_Patient.folder_Patient);

sPatient = 2; % patient
for iP = 1:length(sPatient)
    iPatient = sPatient(iP);
    ind = find(ic == iPatient);
    
    TP = T_Patient(ind, :);
    TM = T_Mat(ind, :);

    % final
    junk = find(contains(TP.Fraction, 'Final'));
    idx = junk(1);
    if TM.SSS{idx}
        matfd = fullfile(path_matData_nonVG, TP.folder_Patient{idx});
        matffn = fullfile(matfd, TM.FileName_matData{idx});
        iFig = 1;
        FractionName{iFig} = TP.Fraction{idx};
        [CMR(iFig)] = fun_viewContour3D(matffn, matfd, FractionName{iFig}, iFig);
        
        
        % fractions
        indFrac = find(~contains(TP.Fraction, 'Final'));
        for m = 1:length(indFrac)
            iFrac = indFrac(m);
            matffn = fullfile(matfd, TM.FileName_matData{iFrac});
            iFig = iFig+1;
            FractionName{iFig} = TP.Fraction{iFrac};
            [CMR(iFig)] = fun_viewContour3D(matffn, matfd, FractionName{iFig}, iFig);
        end
        
        % 3CM Ring
        iFig = iFig+1;
        [hF(iFig), hA(iFig)] = fun_addFig(iFig);
        hA(iFig).Title.String = '3CMRing';
        hA(iFig).Title.Color = 'w';
        hF(iFig).WindowState = 'maximized';
        CLR = 'rgbcmyw';
        for iST = 1:length(CMR)
            line(hA(iFig), CMR(iST).xxAll, CMR(iST).yyAll,...
                CMR(iST).zzAll, 'Color', CLR(iST), 'LineWidth', 1);
        end

        LGD = legend(hA(iFig), FractionName, 'Interpreter', 'none');
        LGD.TextColor = 'w';
        LGD.FontSize = 16;
        axis(hA(iFig), 'equal', 'tight')

        figffn = fullfile(matfd, ['Contour3D_3CMRing.png']);    
        saveas(hF(iFig), figffn)    
    end
end
    
    

