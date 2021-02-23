function [BW3] = fun_get3DMask(S, dxyz, xyzLim, MNP)

M = MNP(1); N = MNP(2); P = MNP(3);
BW3 = false(M, N, P);
zz = S.zz;
z1 = xyzLim(5);
z2 = xyzLim(6);
dz = dxyz(3);
zzA = linspace(z1, z2, P);

% P1 = round((zz(1)-z1)/dxyz(3));
% PP = round((zz(end)-zz(1))/dxyz(3))+1;

IPP = xyzLim(1:2:5);
dxdy = dxyz(1:2);

for iP = 1:P
    z = zzA(iP);
    ind = find(abs(z-S.zz) < dz/100);
    if ~isempty(ind)
        bw = zeros(M, N);
        for iSeg = 1:length(ind)
            pt = S.cont{ind(iSeg)}(:,1:2);
            pt = pt-repmat(IPP(1:2), size(pt,1), 1);
            pt = pt./repmat(dxdy, size(pt, 1), 1);

            junk = poly2mask(pt(:, 1), pt(:,2), M, N);
            bw = bw | junk;
        end
    
        BW3(:,:, iP) = bw;
    end
end
    

%     pt = S.cont{iP-P1}(:,1:2);
%     
%     
%         pt = pt-repmat(IPP(1:2), size(pt,1), 1);
%         pt = pt./repmat(dxdy, size(pt, 1), 1);
% 
%         junk = poly2mask(pt(:, 1), pt(:,2), M, N);
%         bw = bw | junk;
%     pt2bw = bwboundaries(bw);
%     
%     for m = 1:size(pt2bw{1}, 1)
%         I(pt2bw{1}(m, 1), pt2bw{1}(m,2)) = iSS;
%     end
%     I3(:,:, n) = I;
%     plot(hA, pt2(:, 1), pt2(:,2), 'g.')
% set(hI, 'CData', I);

