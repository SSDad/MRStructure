function [fd, matfn] = fun_sortFinalFracitonMatFiles(fns)
matfn = [];

for n = 1:length(fns)
    [fd, fn{n}, ~] = fileparts(fns(n).matFN);
end
idx_Final = find(contains(fn, '_final', 'IgnoreCase' ,true));
idx_AF = find(contains(fn, '_f', 'IgnoreCase' ,true));
if ~isempty(idx_Final)
    matfn.Final = fn{idx_Final(1)};
    matfn.bFinalSSEmpty = fns(idx_Final(1)).bSSEmpty;
end

iFR = 0;
for n = 1:length(idx_AF)
    idx = idx_AF(n);
    if idx~=idx_Final
        k = strfind(lower(fn{idx}), '_f');
        iFR = iFR+1;
        iFraction(iFR) = str2double(fn{idx}(k+2));
        fn_Fraction{iFR} = fn{idx};
        str_Fraction{iFR} = fn{idx}(k+1:k+2);
        
        bSSEmpty(iFR) = fns(idx).bSSEmpty;
        
    end
end

if iFR > 0
    [~, ind] = sort(iFraction);
    matfn.bFSSEmpty = bSSEmpty(ind);
    matfn.Fraction = fn_Fraction(ind);
    matfn.str_Fraction = str_Fraction(ind);
end