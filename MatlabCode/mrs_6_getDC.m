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
%     TM = T_Mat(ind, :);

    % final
    junk = find(contains(TP.Fraction, 'Final'));
    idx = junk(1);
    matfd = fullfile(path_matData_nonVG, TP.folder_Patient{idx});
    Namesffn= fullfile(matfd, 'Names.mat');    
    load(Namesffn)
    BW3ffn = fullfile(matfd, ['BW3_3CMR_Final.mat']);    
    load(BW3ffn);
%     load(fullfile(matfd, 'param3D.mat'));    
    load(fullfile(matfd, 'Names.mat'));
    
    maskAll_Final = false(size(BW3_3CMR.CMR));
    for iST = 1:length(STNames)
        maskAll_Final = maskAll_Final | BW3_3CMR.ST{iST};
        BW3_Final_3CMR_ST{iST} = BW3_3CMR.ST{iST};
    end

    for iFrac = 1:length(FracNames)
        BW3ffn = fullfile(matfd, ['BW3_3CMR_', FracNames{iFrac}, '.mat']);    
        load(BW3ffn);
        maskAll_Frac = false(size(maskAll_Final));
        for iST = 1:length(STNames)
            maskAll_Frac = maskAll_Frac | BW3_3CMR.ST{iST};
            junkAnd = BW3_3CMR.ST{iST} & BW3_Final_3CMR_ST{iST};
            junkAndSum = sum(junkAnd(:));
            junk1 = sum(BW3_3CMR.ST{iST}(:));
            junk2 = sum(BW3_Final_3CMR_ST{iST}(:));
            DC(iFrac).ST(iST) = 2*junkAndSum/(junk1 + junk2);
        end
        junkAnd = maskAll_Final & maskAll_Frac;
        junkAndSum = sum(junkAnd(:));
        junk1 = sum(maskAll_Final(:));
        junk2 = sum(maskAll_Frac(:));
        DC(iFrac).All = 2*junkAndSum/(junk1 + junk2);
            
            
%         [DC] = fun_Render3D_3CMR(BW3, FractionName{iFig}, iFig, 1,CamView, STNames);
    end
end