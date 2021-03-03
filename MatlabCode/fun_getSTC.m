function [sliceC] = fun_getSTC(cont)
sliceC = [];
z = [];
for iSlice = 1:length(cont)
    z(iSlice) = cont{iSlice}(1,3);
end
if ~isempty(z)
    [z, ind] = sort(z);
    conts = cont(ind);
    [zs, ~, indz] = unique(z);
    for izs = 1:length(zs)
        sliceC(izs).z = zs(izs);
        indS = find(izs == indz);
        for iSubC = 1:length(indS)
             cc = conts{indS(iSubC)};
             sliceC(izs).subC{iSubC} = cc;
             sliceC(izs).subMin(iSubC, :) = min(cc);
             sliceC(izs).subMax(iSubC, :) = max(cc);
             sliceC(izs).subArea(iSubC) = polyarea(cc(:, 1), cc(:, 2));
        end
        sliceC(izs).Min = min(sliceC(izs).subMin, [],  1);
        sliceC(izs).Max = max(sliceC(izs).subMax,[],  1);
        sliceC(izs).Area = sum(sliceC(izs).subArea);
    end
 end