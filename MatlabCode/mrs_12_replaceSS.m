clearvars

fdName_nonVG = 'VG';
raSSFN = [fdName_nonVG, '_raSS.mat'];
load(raSSFN)   

failSSFN = [fdName_nonVG, '_failSS.mat'];
load(failSSFN);

for n = 6:size(fileT, 1)
    ffn = fullfile(fileT.path_ra{n}, fileT.fn{n});
    matFN = failTT.failMatFileName{n};

    di = dicominfo(ffn, 'UseVRHeuristic', false);
    SS = dicomContours(di);
    save(matFN, 'SS')

end