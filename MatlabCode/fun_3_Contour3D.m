function fun_3_Contour3D(path_matData_nonVG, TP, TM)

    close all;
    
    % final
    junk = find(contains(TP.Fraction, 'Final'));
    idx = junk(1);
    if TM.SSS{idx}
        matfd = fullfile(path_matData_nonVG, TP.folder_Patient{idx});
        matffn = fullfile(matfd, TM.FileName_matData{idx});
        iST = 1;
        FractionName{iST} = TP.Fraction{idx};
        fun_viewContour3D(matffn, matfd, FractionName{iST}, iST);
        
        % fractions
        indFrac = find(~contains(TP.Fraction, 'Final'));
        for m = 1:length(indFrac)
            iFrac = indFrac(m);
            matffn = fullfile(matfd, TM.FileName_matData{iFrac});
            iST = iST+1;
            FractionName{iST} = TP.Fraction{iFrac};
             fun_viewContour3D(matffn, matfd, FractionName{iST}, iST);
        end
        
%         % 3CM Ring
%         iST = iST+1;
%         [hF(iST), hA(iST)] = fun_addFig(iST);
%         hA(iST).Title.String = '3CMRing';
%         hA(iST).Title.Color = 'w';
%         hF(iST).WindowState = 'maximized';
%         CLR = 'rgbcmyw';
%         for iST = 1:length(CMR)
%             line(hA(iST), CMR(iST).xxAll, CMR(iST).yyAll,...
%                 CMR(iST).zzAll, 'Color', CLR(iST), 'LineWidth', 1);
%         end
% 
%         LGD = legend(hA(iST), FractionName, 'Interpreter', 'none');
%         LGD.TextColor = 'w';
%         LGD.FontSize = 16;
%         axis(hA(iST), 'equal', 'tight')

%         figffn = fullfile(matfd, ['Contour3D_3CMRing.png']);    
%         saveas(hF(iST), figffn)    
    end
    

