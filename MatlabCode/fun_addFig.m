function [hF, hA] = fun_addFig(iFig)

    hF = figure(iFig); clf(hF)
    hF.Color = 'k';
    hF.InvertHardcopy = 'off';
    
    hA = axes( 'parent', hF);
    hA.Color = 'k';
    hold(hA, 'on')
    view(3)
        
        hA.XTick = [];
        hA.YTick = [];
        hA.ZTick = [];

%         axis(hA(n), 'off');
        
%         hA(n).XColor = 'w';
%         hA(n).YColor = 'w';
%         hA(n).ZColor = 'w';
