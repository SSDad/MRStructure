function fun_viewContour3D(matffn, matfd, FractionName, iFig)

[contData] = fun_getContourData(matffn);

%% view
[hF, hA] = fun_addFig(iFig);
hA.Title.String = FractionName;
hA.Title.Color = 'w';
hF.WindowState = 'maximized';

STC(1) = contData.CMR;

for iST = 1:length(contData.ST)
    STC(iST+1) = contData.ST(iST);
end

for iST = 1:length(contData.ST)+1
    if isempty(STC(iST).sName)
        sNames{iST} = '';
        sColors{iST} = 'k';
    else
        sNames{iST} = STC(iST).sName;
        sColors{iST} = STC(iST).Color;
        for iSlice = 1:length(STC(iST).sliceC)
            for iSubC = 1:length(STC(iST).sliceC(iSlice).subC)
                xx = STC(iST).sliceC(iSlice).subC{iSubC}(:,1);
                yy = STC(iST).sliceC(iSlice).subC{iSubC}(:,2);
                zz = STC(iST).sliceC(iSlice).subC{iSubC}(:,3);
                line(hA, xx, yy, zz, 'Color', sColors{iST}, 'LineWidth', 1);
            end
        end
    end
end
    
[LGD, objh] = legend(hA, sNames, 'Interpreter', 'none');
pos = LGD.Position;
LGD.Position(1:2) = pos(1:2)-pos(3:4);
LGD.Position(3:4) = pos(3:4)*2;

nST = length(contData.ST)+1;
for iST = 1:nST
    objh(iST).Color = sColors{iST};
    objh(iST).FontSize = 16;
end

for n = nST+1:length(objh)
    objh(n).Color = 'k';
end

axis(hA, 'equal', 'tight')

% figffn = fullfile(matfd, ['Contour3D_', FractionName, '.fig']);    
% savefig(hF, figffn, 'compact')    

pngffn = fullfile(matfd, ['Contour3D_', FractionName, '.png']);    
saveas(hF, pngffn)    