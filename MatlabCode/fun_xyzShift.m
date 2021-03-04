function [S] = fun_xyzShift(S, xyzShift)

for iSlice = 1:length(S.sliceC)
    for iSubC = 1:length(S.sliceC(iSlice).subC)
        S.sliceC(iSlice).subC{iSubC}(:,1) = S.sliceC(iSlice).subC{iSubC}(:,1) + xyzShift(1);
        S.sliceC(iSlice).subC{iSubC}(:,2) = S.sliceC(iSlice).subC{iSubC}(:,2) + xyzShift(2);
        S.sliceC(iSlice).subC{iSubC}(:,3) = S.sliceC(iSlice).subC{iSubC}(:,1) + xyzShift(3);
        S.sliceC(iSlice).subMin(iSubC, :) = S.sliceC(iSlice).subMin(iSubC, :) + xyzShift;
        S.sliceC(iSlice).subMax(iSubC, :) = S.sliceC(iSlice).subMax(iSubC, :) + xyzShift;
    end
    S.sliceC(iSlice).z = S.sliceC(iSlice).z + xyzShift(3);
    S.sliceC(iSlice).Min = S.sliceC(iSlice).Min + xyzShift;
    S.sliceC(iSlice).Max = S.sliceC(iSlice).Max + xyzShift;   
end
