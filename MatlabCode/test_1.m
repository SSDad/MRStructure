clearvars

addpath(fullfile(pwd, 'getStructure'));

fd_matData = 'X:\Lab\Zhen\MRStructure\matData';
fdName_nonVG = 'nonVG';

fd_matData_nonVG = fullfile(fd_matData, fdName_nonVG);
if ~exist(fd_matData_nonVG, 'dir')
    mkdir(fd_matData_nonVG);
end

fd_VG_nVG = '\\storage1.ris.wustl.edu\taehokim\Active\Lab\VR_VG_Pancreas_Ben\DoseQA\DoseQA_15_VG_nVG';
fd_nonVG = fullfile(fd_VG_nVG, fdName_nonVG);
% fd_VG = fullfile(fd_VG_nVG, 'VG');

% nonVG
junk = dir(fd_nonVG);
fd_pt =junk(~ismember({junk(:).name},{'.','..'}));

for n = 1%:length(fd_pt)
    ffd = fullfile(fd_pt(n).folder, fd_pt(n).name);
    junk = dir(ffd);
    fd_P =junk(~ismember({junk(:).name},{'.','..'}));
    
    % Final
    matDataPath = fullfile(fd_matData_nonVG, fd_pt(n).name);
    if ~exist(matDataPath, 'dir')
        mkdir(matDataPath);

        ind = find(contains({fd_P.name}, 'final', 'IgnoreCase',true));
        if length(ind) > 1
            for m = 1:length(ind)
                 junk = fd_P(ind(m)).name;
                 dt{m} = datetime(junk(end-7:end), 'InputFormat', 'MMddyyyy');
                 dn(m) = datenum(dt{m});
            end
            [~, ind_dn] = sort(dn);
            idx_Final = ind(ind_dn(end));
        else
            idx_Final = ind;
        end
        ffd_Final{n} = fullfile(fd_P(idx_Final).folder, fd_P(idx_Final).name);

        % RTStruct
        junk = dir(fullfile(ffd_Final{n}, '*STRUCT*'));
        junk = junk(1);
        ffn = fullfile(junk.folder, junk.name);
        di = dicominfo(ffn);
        plan = load_structure_from_dicom(ffn);

        SS.Names = plan.structureData.names;
        SS.structures = plan.structureData.structures;

        matFN = fullfile(matDataPath, ['SS_', fd_P(idx_Final).name]);
        save(matFN, 'SS')
        
    end
end
