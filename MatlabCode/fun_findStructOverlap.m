function [OL] = fun_findStructOverlap(cont1, cont2, color1, color2)

OL = [];
bPlot = 1;

for iC = 1:length(cont1)
    zz1(iC) = cont1{iC}(1,3);
end

for iC = 1:length(cont2)
    zz2(iC) = cont2{iC}(1,3);
end

[~, ind1, ind2] = intersect(zz1, zz2);

if ~isempty(ind1)
    cc1 = cont1(ind1);
    cc2 = cont2(ind2);
end

if bPlot
    hF = figure(11); clf(hF)
    hF.Color = 'k';
    hA = axes('parent', hF);
    hA.Color = 'k';
    hold(hA, 'on')
    hL(1) = line(hA, 'XData', [], 'YData', [], 'Color', color1, 'LineWidth', 0.1);
    hL(2) = line(hA, 'XData', [], 'YData', [], 'Color', color2, 'LineWidth', 0.1);
    hL(3) = line(hA, 'XData', [], 'YData', [], 'Color', 'g', 'LineWidth', 2);
    
    TT = title(hA, 'Overlap', 'Color', 'w');
end

iOL = 0;
for n = 1:length(cc1)
    C1 = cc1{n};
    C2 = cc2{n};
    
    pgon1 = polyshape(C1(:, 1), C1(:, 2));
    pgon2 = polyshape(C2(:, 1), C2(:, 2));
    polyout = intersect(pgon1, pgon2);
    
    CC = polyout.Vertices;
    if bPlot
        set(hL(1), 'XData', C1(:, 1), 'YData', C1(:, 2));
        set(hL(2), 'XData', C2(:, 1), 'YData', C2(:, 2));
        set(hL(3), 'XData', [], 'YData', []);
        TT.String = ['z = ', num2str(C1(1,3)), ' mm'];
        axis(hA, 'equal', 'tight')
    end
    if ~isempty(CC)
        iOL = iOL+1;
        OL{iOL} = [CC repmat(C1(1, 3), size(CC, 1), 1)];
        if bPlot
            set(hL(3), 'XData', CC(:, 1), 'YData', CC(:, 2));
        end
    end
end