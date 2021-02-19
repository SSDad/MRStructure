clearvars

folder_nonVG = 'non VG';

% mat folder
folder_matData = '\\storage1.ris.wustl.edu\taehokim\Active\Lab\Zhen\MRStructure\matData';
path_matData_nonVG = fullfile(folder_matData, folder_nonVG);
if ~exist(path_matData_nonVG, 'dir')
    mkdir(path_matData_nonVG);
end

% patient table
fn = ['PatientTable_', folder_nonVG];    
load(fn)

nF = size(T_Patient, 1);
FileName_Struct = cell(nF, 1);
Path_matData = cell(nF, 1);
FileName_matData = cell(nF, 1);
SSS = cell(nF, 1);

% nF = 3;
for n = 1:nF
    display(['Processing ', num2str(n), '/', num2str(nF)]);
    
    Path_matData{n} = fullfile(path_matData_nonVG, T_Patient.folder_Patient{n});
    if ~exist(Path_matData{n}, 'dir')
        mkdir(Path_matData{n});
    end
    
    path_Struct = fullfile(path_nonVG, T_Patient.folder_Patient{n}, T_Patient.folder_Fraction{n});
    junk = dir(fullfile(path_Struct, '*STRUCT*'));
    if ~isempty(junk)     % no struct dcm
    
        junk = junk(1);
        ffn_Struct = fullfile(junk.folder, junk.name);
        FileName_Struct{n} = junk.name;

        SS = [];
        SSS{n} = false;
        try
            di = dicominfo(ffn_Struct, 'UseVRHeuristic', false);
            SS = dicomContours(di);
            SSS{n} = true;
        catch ME
        end
        FileName_matData{n} = ['SS_', T_Patient.folder_Fraction{n}, '.mat'];
        ffn_mat = fullfile(Path_matData{n}, FileName_matData{n});
        save(ffn_mat, 'SS')
    end
end
T_Mat = table(FileName_Struct, FileName_matData, SSS);    
fn = ['MatTable_', folder_nonVG];    
save(fn, 'T_Mat', 'path_matData_nonVG')