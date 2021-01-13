clearvars

% addpath(fullfile(pwd, 'getStructure'));

fd_matData = 'X:\Lab\Zhen\MRStructure\matData2';
fdName_nonVG = 'nonVG';

ptMatInfoFN = ['matInfo_', fdName_nonVG, '.mat'];
if exist(ptMatInfoFN, 'file')
    load(ptMatInfoFN);
end

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

for n = 1:length(fd_pt)
    ffd = fullfile(fd_pt(n).folder, fd_pt(n).name);
    junk = dir(ffd);
    fd_P =junk(~ismember({junk(:).name},{'.','..'}));
    
    % Final
    matDataPath = fullfile(fd_matData_nonVG, fd_pt(n).name);
    if ~exist(matDataPath, 'dir')
        mkdir(matDataPath);
    end
    
    ind = find(contains({fd_P.name}, '_f', 'IgnoreCase',true));
    for nn = 1:length(ind)
        
        m = ind(nn);
        matFN = fullfile(matDataPath, ['SS_', fd_P(m).name, '.mat']);
        
        if exist(matFN, 'file')
            display(['Patient ', num2str(n), '/', num2str(length(fd_pt)),...
                ',  Fraction ', num2str(nn), '/', num2str(length(ind)), ' was already done...']);
        else
        
            display(['Processing Patient ', num2str(n), '/', num2str(length(fd_pt)),...
                ',  Fraction ', num2str(nn), '/', num2str(length(ind)), '...']);

            ffd = fullfile(fd_P(m).folder, fd_P(m).name);

            % RTStruct file
            junk = dir(fullfile(ffd, '*STRUCT*'));
            junk = junk(1);
            ffn = fullfile(junk.folder, junk.name);
            SS = [];

            % size
            junk = dir(ffn);
            filesize = junk.bytes;
            
            if filesize > 2^20*100
                display('......Structure file might be corrupted since its size is larger than 100MB');
            else
                di = dicominfo(ffn);
       %         plan = load_structure_from_dicom(ffn);
        % 
        %         SS.Names = plan.structureData.names;
        %         SS.structures = plan.structureData.structures;
                try
                    SS = dicomContours(di);
                catch ME
        %             rethrow(ME);
        %             warning('Problem using function.  Assigning a value of 0.');
                end
            end
            save(matFN, 'SS')
            ptMatFile(n).matFN(nn).matFN = matFN;
            ptMatFile(n).matFN(nn).bSSEmpty = isempty(SS);
        end
    end
end

save(ptMatInfoFN, 'ptMatFile');