function [fd, matfn] = fun_sortFinalFracitonMatFiles(fns)

for n = 1:length(fns)
    [fd, fn{n}, ~] = fileparts(fns(n).matFN);
end
idx_Final = find(contains(fn, '_final', 'IgnoreCase' ,true));
idx_AF = find(contains(fn, '_f', 'IgnoreCase' ,true));
matfn.Final = fn{idx_AF};

for n = 1:length(idx_AF)
    idx = idx_AF(n);
    if idx~=idx_Final
        k = strfind(lower(fn{idx}), '_f');
        iFraction(n) = str2double(fn{idx}(k+2));
        fn_Fraction{n} = fn{idx};
        str_Fraction{n} = fn{idx}(k+1:k+2);
    end
end
[~, ind] = sort(iFraction);
iFraction = iFraction(ind);
matfn.Fraction = fn_Fraction(ind);
matfn.str_Fraction = str_Fraction(ind);
