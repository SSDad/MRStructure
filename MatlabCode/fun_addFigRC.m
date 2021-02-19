function [hF, hA] = fun_addFigRC(iFig, r, c)

    hF = figure(iFig); clf(hF)
    hF.Color = 'k';
    hF.InvertHardcopy = 'off';
    
    for n = 1:r*c
        hA(n) = subplot(r, c, n, 'parent', hF);
        hA(n).Color = 'k';
        hold(hA(n), 'on')
        view(3)
        
        hA(n).XTick = [];
        hA(n).YTick = [];
        hA(n).ZTick = [];

%         axis(hA(n), 'off');
        
%         hA(n).XColor = 'w';
%         hA(n).YColor = 'w';
%         hA(n).ZColor = 'w';
    end