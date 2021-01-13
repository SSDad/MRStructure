function [contData] = fun_getContourData(fns)

%% sort mat files
[fd, fn] = fun_sortFinalFracitonMatFiles(fns);

%% 
ffn_Final = fullfile(fd, fn.Final);
load(ffn_Final);

T = SS.ROIs;
[nS, ~] = size(T);

% 3d
hF = figure(1); clf(hF)
hF.Color = 'k';
hA(1) = axes('parent', hF);
hA(1).Color = 'k';
hold(hA(1), 'on')
view(3)

hA(1).XColor = 'w';
hA(1).YColor = 'w';
hA(1).ZColor = 'w';

%% 3CM_RING
sNames = T.Name;
% idx_3CMR = find(contains(sNames, '3CM'));
idx_3CMR = find(contains(sNames, '3CM', 'IgnoreCase' ,true) & ...
        contains(sNames, 'Ring', 'IgnoreCase' ,true));
iS = idx_3CMR;
cont_3CMR = T.ContourData{iS};
Color_3CMR = T.Color{iS}/255;
name_3CMR = sNames{iS};
xx1 = [];
yy1 = [];
zz1 = [];
for iC = 1:length(cont_3CMR)
    xx = cont_3CMR{iC}(:,1);
    yy = cont_3CMR{iC}(:,2);
    zz = cont_3CMR{iC}(:,3);
    zz_3CMR(iC) = zz(1);
    
    xx1 = [xx1;xx];
    yy1 = [yy1;yy];
    zz1 = [zz1;zz];
end
hL_3CMR = line(hA(1), xx1, yy1, zz1, 'Color', Color_3CMR, 'LineWidth', 0.1);
XMin = min(xx1);  XMax = max(xx1);
YMin = min(yy1);  YMax = max(zz1);
ZMin = min(zz1);  ZMax = max(zz1);
dz = abs(cont_3CMR{iC-1}(1,3)-cont_3CMR{iC}(1,3));

CMR.cont = cont_3CMR;
CMR.Color = Color_3CMR;
CMR.sName = name_3CMR;
CMR.zz = zz_3CMR;

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

indNoST = find(cellfun(@isempty, indST));
indExistST = 1:8;
indExistST(indNoST) = [];

sST = indExistST;
for iST = sST 
    iS = indST{iST};
    ST(iST).Color = T.Color{iS}/255;
    ST(iST).sName = sNames{iS};
    xx1 = [];
    yy1 = [];
    zz1 = [];
    cont = T.ContourData{iS};
    ST(iST).cont = cont;
    for iC = 1:length(cont)
        xx = cont{iC}(:,1);
        yy = cont{iC}(:,2);
        zz = cont{iC}(:,3);
        ST(iST).zz(iC) = zz(1);
%         line(hA(1), xx, yy, zz, 'Color', 'g', 'LineWidth', 2);

        xx1 = [xx1;xx];
        yy1 = [yy1;yy];
        zz1 = [zz1;zz];
    end
    hL(iST) = line(hA(1), xx1, yy1, zz1, 'Color', ST(iST).Color, 'LineWidth', 0.1);
    
    ST(iST).XLim = [min(xx1) max(xx1)];
    ST(iST).YLim = [min(yy1) max(yy1)];
    ST(iST).ZLim = [min(zz1) max(zz1)];
    
    XMin = min(min(xx1), XMin);  XMax = max(max(xx1), XMax);
    YMin = min(min(yy1), YMin);  YMax = max(max(yy1), YMax);
    ZMin = min(min(zz1), ZMin);  ZMax = max(max(zz1), ZMax);

end