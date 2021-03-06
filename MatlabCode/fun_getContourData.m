function [contData] = fun_getContourData(ffn)

load(ffn);

T = SS.ROIs;

%% 3CM_RING
sNames = T.Name;
idx_3CMR = find(contains(sNames, '3CM', 'IgnoreCase' ,true) & ...
        contains(sNames, 'Ring', 'IgnoreCase' ,true));
iS = idx_3CMR;
cont_3CMR = T.ContourData{iS};
CMR.Color = T.Color{iS}/255;
CMR.sName = sNames{iS};
CMR.name = sNames{iS};

[CMR.sliceC] = fun_getSTC(cont_3CMR);

% CMR.zz = [sliceC_3CMR.z]';
% CMR.Min = min(cell2mat({sliceC_3CMR.Min}'));
% CMR.Max = max(cell2mat({sliceC_3CMR.Max}'));
contData.CMR = CMR;

%%  ST
load('STList')
for iST = 1:3
    indST{iST} = find(strcmp([lower(sNames)], lower(ST(iST).name)));
end
for iST = 4:8
    indST{iST} = find(contains(sNames, ST(iST).name{1}, 'IgnoreCase' ,true) & ...
        contains(sNames, ST(iST).name{2}, 'IgnoreCase' ,true));
    junk2 = find(contains(sNames, ST(iST).name{2}, 'IgnoreCase' ,true));
end

% indNoST = find(cellfun(@isempty, indST));
% indExistST = 1:8;
% indExistST(indNoST) = [];
% 
% sST = indExistST;
for iST = 1:length(ST)
    if ~isempty(indST{iST})
        iS = indST{iST}(1);
        ST(iST).Color = T.Color{iS}/255;
        ST(iST).sName = sNames{iS};
        cont = T.ContourData{iS};
        [ST(iST).sliceC] = fun_getSTC(cont);
    
%     ST(iST).zz = [sliceC.z]';
%     ST(iST).MIn = min(cell2mat({sliceC.Min}'));
%     ST(iST).Max = max(cell2mat({sliceC.Max}'));
    end
end

contData.ST = ST;
% contData.sST = sST;