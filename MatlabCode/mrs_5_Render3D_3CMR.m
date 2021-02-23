clearvars

CamView = [-160 -15];

folder_nonVG = 'VG';
fn = ['PatientTable_', folder_nonVG];    
load(fn);
fn = ['MatTable_', folder_nonVG];    
load(fn);

[PatientList, ia, ic] = unique(T_Patient.folder_Patient);

sPatient = 2; % patient
for iP = 1:length(sPatient)
    iPatient = sPatient(iP);
    ind = find(ic == iPatient);
    
    TP = T_Patient(ind, :);
    TM = T_Mat(ind, :);

    % final
    junk = find(contains(TP.Fraction, 'Final'));
    idx = junk(1);
    matfd = fullfile(path_matData_nonVG, TP.folder_Patient{idx});
    Namesffn= fullfile(matfd, 'Names.mat');    
    load(Namesffn)
    BW3ffn = fullfile(matfd, ['BW3_Final.mat']);    
    load(BW3ffn);
    load(fullfile(matfd, 'param3D.mat'));    
    load(fullfile(matfd, 'Names.mat'));    

    iFig = 1;
    [BW3_3CMR] = fun_Render3D_3CMR(BW3, param3D, CLR, 'Final', iFig, STNames, matfd, CamView);
    save(fullfile(matfd, ['BW3_3CMR_Final.mat']), 'BW3_3CMR')

    for m = 1:length(FracNames)
        BW3ffn = fullfile(matfd, ['BW3_', FracNames{m}, '.mat']);    
        load(BW3ffn);
        iFig = iFig+1;
        [BW3_3CMR] = fun_Render3D_3CMR(BW3, param3D, CLR, FracNames{m}, iFig, STNames, matfd, CamView);
        BW3ffn = fullfile(matfd, ['BW3_3CMR_', FracNames{m}, '.mat']);    
        save(BW3ffn, 'BW3_3CMR')
    end
end