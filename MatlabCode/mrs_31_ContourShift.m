clearvars

folder_nonVG = 'VG';
fn = ['PatientTable_', folder_nonVG];    
load(fn);
fn = ['MatTable_', folder_nonVG];    
load(fn);

[PatientList, ia, ic] = unique(T_Patient.folder_Patient);

sPatient = [1]; % patient
for iP = 1:length(sPatient)
    iPatient = sPatient(iP);
    ind = find(ic == iPatient);
    
    TP = T_Patient(ind, :);
    TM = T_Mat(ind, :);

    [xS, yS, xShift, yShift, zShift] = fun_31_ContourShift(path_matData_nonVG, TP, TM, 1);
end
    
    

