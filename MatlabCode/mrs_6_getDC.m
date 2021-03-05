clearvars

bView = 1;
CamView = [-160 -15];

folder_nonVG = 'VG';
fn = ['PatientTable_', folder_nonVG];    
load(fn);
fn = ['MatTable_', folder_nonVG];    
load(fn);

[PatientList, ia, ic] = unique(T_Patient.folder_Patient);

sPatient = 1; % patient
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
    BW3_Final_3CMR_CMR = BW3_3CMR.CMR;
%     load(fullfile(matfd, 'param3D.mat'));    
    load(fullfile(matfd, 'Names.mat'));
    
    maskAll_Final = false(size(BW3_3CMR.CMR));
    for iST = 1:length(STNames)
        maskAll_Final = maskAll_Final | BW3_3CMR.ST{iST};
        BW3_Final_3CMR_ST{iST} = BW3_3CMR.ST{iST};
    end

    nFrac = length(FracNames);
    nST = length(STNames);
    if bView
        [hF, hA] = fun_addFigRC(100, nFrac, nST);
        % hA.Title.String = FractionName;
%         hA.Title.Color = 'w';
        hF.WindowState = 'maximized';
        
        load(fullfile(matfd, 'param3D.mat'));    
    end
    
    for iFrac = 1:nFrac
        BW3ffn = fullfile(matfd, ['BW3_3CMR_', FracNames{iFrac}, '.mat']);    
        load(BW3ffn);
        [DC(iFrac).CMR] = fun_calDC(BW3_3CMR.CMR, BW3_Final_3CMR_CMR);
        
        maskAll_Frac = false(size(maskAll_Final));
        for iST = 1:nST
            maskAll_Frac = maskAll_Frac | BW3_3CMR.ST{iST};
            [DC(iFrac).ST(iST)] = fun_calDC(BW3_3CMR.ST{iST}, BW3_Final_3CMR_ST{iST});
            if bView
                jBW{1} = BW3_3CMR.CMR;
                jBW{2} = BW3_3CMR.ST{iST};
                jBW{3} = BW3_Final_3CMR_ST{iST};
                fun_3DComp(hA(iFrac, iST), jBW, param3D); 
            end
        end
        [DC(iFrac).All] = fun_calDC(maskAll_Final, maskAll_Frac);
            
            
%         [DC] = fun_Render3D_3CMR(BW3, FractionName{iFig}, iFig, 1,CamView, STNames);
    end
    TDC = array2table(cell2mat({DC.ST}'));
    TDC.Properties.VariableNames = STNames
    
end