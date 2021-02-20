clearvars

folder_nonVG = 'nonVG';
path_VG_nVG = '\\storage1.ris.wustl.edu\taehokim\Active\Lab\VR_VG_Pancreas_Ben\DoseQA\DoseQA_15_VG_nVG';
path_nonVG = fullfile(path_VG_nVG, folder_nonVG);

junk = dir(path_nonVG);
fd_Patient =junk(~ismember({junk(:).name},{'.','..'}));

folder_Patient = [];
folder_Fraction = [];
for n = 1:length(fd_Patient)
    ffd = fullfile(fd_Patient(n).folder, fd_Patient(n).name);
    junk = dir(ffd);
    fd_Frac =junk(~ismember({junk(:).name},{'.','..'}));
    
    ind = find(contains({fd_Frac.name}, '_f', 'IgnoreCase',true));
    if length(ind) < 2
        ind = find(contains({fd_Frac.name}, '_', 'IgnoreCase',true));
    end
    for nn = 1:length(ind)
        m = ind(nn);
        folder_Patient = [folder_Patient; {fd_Patient(n).name}];
        folder_Fraction = [folder_Fraction; {fd_Frac(m).name}];
        
    end
end

Fraction = cell(size(folder_Fraction));
ind = find(contains(folder_Fraction, 'final', 'IgnoreCase', true));
Fraction(ind) = {'Final'};

for n = 1:10
    frac = ['F', num2str(n)];
    ind = find(contains(folder_Fraction, frac, 'IgnoreCase', true));
    if ~isempty(ind)
        Fraction(ind) = {frac};
    end
    junk = ['_', num2str(n)];
    ind = find(contains(folder_Fraction, junk, 'IgnoreCase', true));
    if ~isempty(ind)
        Fraction(ind) = {frac};
    end
end

T_Patient = table(folder_Patient, folder_Fraction, Fraction);

fn = ['PatientTable_', folder_nonVG];    
save(fn, 'T_Patient', 'path_nonVG')