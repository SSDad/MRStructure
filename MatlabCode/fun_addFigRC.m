function [hF, hA] = fun_addFigRC(iFig, nR, nC)

    hF = figure(iFig); clf(hF)
    MP = get(0, 'MonitorPosition');
    
    if size(MP, 1) > 1
        hF.Position(1:2) = hF.Position(1:2) + MP(2, 1:2);
    end
    
    hF.Color = 'k';
    hF.InvertHardcopy = 'off';
    
    for r = 1:nR
        for c = 1:nC
            hA(r, c) = subplot(nR, nC, (r-1)*nC+c, 'parent', hF);
            hA(r, c).Color = 'k';
            hold(hA(r, c), 'on');
            view(3)
            hA(r, c).XTick = [];
            hA(r, c).YTick = [];
            hA(r, c).ZTick = [];
        end
%         axis(hA(n), 'off');
        
%         hA(n).XColor = 'w';
%         hA(n).YColor = 'w';
%         hA(n).ZColor = 'w';
    end