clearvars

fd_matData = 'X:\Lab\Zhen\MRStructure\matData2';
fdName_nonVG = 'VG';
failSSFN = [fdName_nonVG, '_failSS.mat'];
load(failSSFN);

fd_VG_nVG = '\\storage1.ris.wustl.edu\taehokim\Active\Lab\VR_VG_Pancreas_Ben\DoseQA\DoseQA_15_VG_nVG';
fd_nonVG = fullfile(fd_VG_nVG, fdName_nonVG);

fd_reanon = 'X:\Lab\VR_VG_Pancreas_Ben\DoseQA\DoseQA_15_VG_nVG\reanon_files';
fd_reanon_nonVG = fullfile(fd_reanon, 'VG');

for n = 1:size(failTT, 1)
    fn{n} = failTT.failFileName{n};
    file_ra = dir(fullfile(fd_reanon_nonVG, '**', [fn{n}, '.dcm']));
    path_ra{n} = file_ra.folder;
    byte_ra{n} = file_ra.bytes/(2^20);
    file_ = dir(fullfile(fd_nonVG, '**', [fn{n}, '.dcm']));
    path_orig{n} = file_.folder;
    byte_orig{n} = file_.bytes/(2^20);
end
fn = fn';
path_ra = path_ra';
size_ra = byte_ra';
path_orig = path_orig';
size_orig = byte_orig';

fileT = table(fn, path_orig, size_orig, path_ra, size_ra);

raSSFN = [fdName_nonVG, '_raSS.mat'];
save(raSSFN, 'fileT')   