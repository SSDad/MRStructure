clearvars

% addpath(fullfile(pwd, 'getStructure'));

% fd = 'X:\Lab\VR_VG_Pancreas_Ben\DoseQA\DoseQA_15_VG_nVG\VG\14VG\Pancreas_Final';
% junk = dir(fullfile(fd, 'RTSTRUCT*'));
% junk = junk(1);
% ffn = fullfile(junk.folder, junk.name);
% di = dicominfo(ffn);

ffn = 'X:\Lab\Zhen\MRStructure\matData\VG\11VG\SS_Pancreas_F1.mat';
load(ffn);
T = SS.ROIs;

nS = size(T, 1);
for iST = 1:nS
    cont = T.ContourData{iST};
    [STC(iST).sliceC] = fun_getSTC(cont);
    
%     z = [];
%     sliceC = [];
%     for iSlice = 1:length(cont)
%         z(iSlice) = cont{iSlice}(1,3);
%     end
%     [z, ind] = sort(z);
%     conts = cont(ind);
%     [zs, ~, indz] = unique(z);
%     for izs = 1:length(zs)
%         indS = find(izs == indz);
%         for iSubC = 1:length(indS)
%             sliceC(izs).subC{iSubC} = conts{indS(iSubC)};
%         end        
%     end
end

figure(1), clf
hold on
for iST = 2:9
    for iSlice = 1:length(STC(iST).sliceC)
        for iSubC = 1:length(STC(iST).sliceC(iSlice).subC)
            xx = STC(iST).sliceC(iSlice).subC{iSubC}(:,1);
            yy = STC(iST).sliceC(iSlice).subC{iSubC}(:,2);
            zz = STC(iST).sliceC(iSlice).subC{iSubC}(:,3);
            plot3(xx, yy, zz, 'Color', T.Color{iST}/255)
        end
    end
end