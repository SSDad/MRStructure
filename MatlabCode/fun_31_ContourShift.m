function [shft] = fun_31_ContourShift(path_matData_nonVG, TP, TM, bPlot)

% final
junk = find(contains(TP.Fraction, 'Final'));
idx = junk(1);
if TM.SSS{idx}
    matfd = fullfile(path_matData_nonVG, TP.folder_Patient{idx});
    iSec = 1;
    matffn{iSec} = fullfile(matfd, TM.FileName_matData{idx});
    FractionName{iSec} = TP.Fraction{idx};

    % fractions
    indFrac = find(~contains(TP.Fraction, 'Final'));
    for m = 1:length(indFrac)
        iFrac = indFrac(m);
        iSec = iSec+1;
        matffn{iSec} = fullfile(matfd, TM.FileName_matData{iFrac});
        FractionName{iSec} = TP.Fraction{iFrac};
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
    for iSec = 1:length(matffn)
        [contData] = fun_getContourData(matffn{iSec});
        STC(iSec) = contData.CMR;
        z{iSec} = [STC(iSec).sliceC.z]';
        zShift(iSec) = mode(z{1} - z{iSec});

        for iSlice = 1:length(STC(iSec).sliceC)
                iSubC = 1;  % assume 3CM Ring only 1 closed contour per slice
                xx = STC(iSec).sliceC(iSlice).subC{iSubC}(:,1);
                xxm{iSec}(iSlice) = mean(xx);
                yy = STC(iSec).sliceC(iSlice).subC{iSubC}(:,2);
                yym{iSec}(iSlice) = mean(yy);
                zz = STC(iSec).sliceC(iSlice).subC{iSubC}(:,3);
                if bPlot
                line(hA(1), xx, yy, zz, 'Color', CLR(iSec), 'LineWidth', 1);
                end

                xSS{iSec}(iSlice) = xxm{1}(iSlice) - xxm{iSec}(iSlice);
                ySS{iSec}(iSlice) = yym{1}(iSlice) - yym{iSec}(iSlice);

                zz = zz+zShift(iSec);
                if bPlot
                line(hA(2), xx, yy, zz, 'Color', CLR(iSec), 'LineWidth', 1);
                end
        end
        xShift(iSec) = mode(xSS{iSec});
        yShift(iSec) = mode(ySS{iSec});

        if bPlot
            for iSlice = 1:length(STC(iSec).sliceC)
                    iSubC = 1;
                    xx = STC(iSec).sliceC(iSlice).subC{iSubC}(:,1) + xShift(iSec);
                    yy = STC(iSec).sliceC(iSlice).subC{iSubC}(:,2) + yShift(iSec);
                    zz = STC(iSec).sliceC(iSlice).subC{iSubC}(:,3) + zShift(iSec);
                    line(hA(3), xx, yy, zz, 'Color', CLR(iSec), 'LineWidth', 1);
            end
        end
    end
    shft.x = xShift;
    shft.y = yShift;
    shft.z = zShift;
    shft.xSS = xSS;
    shft.ySS = ySS;
    
    if bPlot
        axis(hA, 'equal', 'tight')
    end
end