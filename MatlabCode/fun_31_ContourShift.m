function [xS, yS, xShift, yShift, zShift] = fun_31_ContourShift(path_matData_nonVG, TP, TM, bPlot)

% final
junk = find(contains(TP.Fraction, 'Final'));
idx = junk(1);
if TM.SSS{idx}
    matfd = fullfile(path_matData_nonVG, TP.folder_Patient{idx});
    iST = 1;
    matffn{iST} = fullfile(matfd, TM.FileName_matData{idx});
    FractionName{iST} = TP.Fraction{idx};

    % fractions
    indFrac = find(~contains(TP.Fraction, 'Final'));
    for m = 1:length(indFrac)
        iFrac = indFrac(m);
        iST = iST+1;
        matffn{iST} = fullfile(matfd, TM.FileName_matData{iFrac});
        FractionName{iST} = TP.Fraction{iFrac};
    end
    if bPlot
        close all        
        for    iFig = 1:3
        [hF(iFig), hA(iFig)] = fun_addFig(iFig);
%         hA(iST).Title.String = '3CMRing';
%         hA(iST).Title.Color = 'w';
%         hF(iST).WindowState = 'maximized';
        end
        CLR = 'rgbcmyw';
    end
    for iST = 1:length(matffn)
        [contData] = fun_getContourData(matffn{iST});
        STC(iST) = contData.CMR;
        z{iST} = [STC(iST).sliceC.z]';
        zShift(iST) = mode(z{1} - z{iST});

        for iSlice = 1:length(STC(iST).sliceC)
                iSubC = 1;  % assume 3CM Ring only 1 closed contour per slice
                xx = STC(iST).sliceC(iSlice).subC{iSubC}(:,1);
                xxm{iST}(iSlice) = mean(xx);
                yy = STC(iST).sliceC(iSlice).subC{iSubC}(:,2);
                yym{iST}(iSlice) = mean(yy);
                zz = STC(iST).sliceC(iSlice).subC{iSubC}(:,3);
                if bPlot
                line(hA(1), xx, yy, zz, 'Color', CLR(iST), 'LineWidth', 1);
                end

                xS{iST}(iSlice) = xxm{1}(iSlice) - xxm{iST}(iSlice);
                yS{iST}(iSlice) = yym{1}(iSlice) - yym{iST}(iSlice);

                zz = zz+zShift(iST);
                if bPlot
                line(hA(2), xx, yy, zz, 'Color', CLR(iST), 'LineWidth', 1);
                end
        end
        xShift(iST) = mode(xS{iST});
        yShift(iST) = mode(yS{iST});

        if bPlot
            for iSlice = 1:length(STC(iST).sliceC)
                    iSubC = 1;
                    xx = STC(iST).sliceC(iSlice).subC{iSubC}(:,1) + xShift(iST);
                    yy = STC(iST).sliceC(iSlice).subC{iSubC}(:,2) + yShift(iST);
                    zz = STC(iST).sliceC(iSlice).subC{iSubC}(:,3) + zShift(iST);
                    line(hA(3), xx, yy, zz, 'Color', CLR(iST), 'LineWidth', 1);
            end
        end
    end
    if bPlot
        axis(hA, 'equal', 'tight')
    end
end