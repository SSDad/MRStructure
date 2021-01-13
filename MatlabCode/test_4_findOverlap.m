clearvars

fd_matData = 'X:\Lab\Zhen\MRStructure\matData';
fdName_nonVG = 'VG';
fd_matData_nonVG = fullfile(fd_matData, fdName_nonVG);

junk = dir(fd_matData_nonVG);
fd_pt =junk(~ismember({junk(:).name},{'.','..'}));

for n = 1:length(fd_pt)
    ffd = fullfile(fd_pt(n).folder, fd_pt(n).name);
    junk = dir(ffd);
    fnSS =junk(~ismember({junk(:).name},{'.','..'}));

    % Final
    ind = find(contains({fnSS.name}, 'final', 'IgnoreCase',true));
    if ~isempty(ind)
        idx_3CM = ind(end);
        ffn_Final{n} = fullfile(fnSS(idx_3CM).folder, fnSS(idx_3CM).name);
    end
end

iP = 1; % patient
load(ffn_Final{iP});
T = SS.ROIs;
[nS, ~] = size(T);

% 3d
hF = figure(1); clf(hF)
hF.Color = 'k';
hA = axes('parent', hF);
hA.Color = 'k';
hold(hA, 'on')
view(3)

hA.XColor = 'w';
hA.YColor = 'w';
hA.ZColor = 'w';

% 3CM_RING
sNames = T.Name;
idx_3CM = find(contains(sNames, '3CM'));
iS = idx_3CM;
cont = T.ContourData{iS};
sColor{iS} = T.Color{iS}/255;
xx1 = [];
yy1 = [];
zz1 = [];
for iC = 1:length(cont)
    xx = cont{iC}(:,1);
    yy = cont{iC}(:,2);
    zz = cont{iC}(:,3);
    
    xx1 = [xx1;xx];
    yy1 = [yy1;yy];
    zz1 = [zz1;zz];
end
hL(1) = line(hA, xx1, yy1, zz1, 'Color', sColor{iS}, 'LineWidth', 0.1);
color1 = sColor{iS};

% 
idx = 8;
iS = idx;

cont = T.ContourData{iS};
sColor{iS} = T.Color{iS}/255;
xx1 = [];
yy1 = [];
zz1 = [];
for iC = 1:length(cont)
    xx = cont{iC}(:,1);
    yy = cont{iC}(:,2);
    zz = cont{iC}(:,3);
    
    xx1 = [xx1;xx];
    yy1 = [yy1;yy];
    zz1 = [zz1;zz];
end
hL(1) = line(hA, xx1, yy1, zz1, 'Color', sColor{iS}, 'LineWidth', 0.1);
color2 = sColor{iS};

L = legend(sNames{idx_3CM}, sNames{idx});
L.TextColor = 'w';
L.FontSize = 16;
axis(hA, 'equal', 'tight')

%% find overlap
cont1 = T.ContourData{idx_3CM};
cont2 = T.ContourData{idx};
[OL] = fun_findStructOverlap(cont1, cont2, color1, color2);

% 3d
% hF = figure(2); clf(hF)
% hF.Color = 'k';
% hA = axes('parent', hF);
% hA.Color = 'k';
% hold(hA, 'on')
% view(3)
% 
% hA.XColor = 'w';
% hA.YColor = 'w';
% hA.ZColor = 'w';

cont = OL;
for iC = 1:length(cont)
    xx = cont{iC}(:,1);
    yy = cont{iC}(:,2);
    zz = cont{iC}(:,3);
    line(hA, xx, yy, zz, 'Color', 'g', 'LineWidth', 2);
end
% axis(hA, 'equal', 'tight')
