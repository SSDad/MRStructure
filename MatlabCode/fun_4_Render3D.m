function fun_4_Render3D(path_matData_nonVG, TP, TM)

close all;

CamView = [-160 -15];

    % final
    junk = find(contains(TP.Fraction, 'Final'));
    idx = junk(1);
    if TM.SSS{idx}
        matfd = fullfile(path_matData_nonVG, TP.folder_Patient{idx});
        matffn = fullfile(matfd, TM.FileName_matData{idx});
        iFig = 1;
%         FracNames{iFig} = TP.Fraction{idx};
        [BW3, param3D, STNames, CLR] = fun_Render3D(matffn, matfd, 'Final', iFig, 1, [], CamView);
        save(fullfile(matfd, 'param3D'), 'param3D', 'CLR')
        save(fullfile(matfd, ['BW3_Final.mat']), 'BW3')

        % fractions
        indFrac = find(~contains(TP.Fraction, 'Final'));
        for m = 1:length(indFrac)
            iFrac = indFrac(m);
            matffn = fullfile(matfd, TM.FileName_matData{iFrac});
            iFig = iFig+1;
            FracNames{m} = TP.Fraction{iFrac};
            [BW3, ~, ~, ~] = fun_Render3D(matffn, matfd, FracNames{m}, iFig, 0, param3D, CamView);
            BW3ffn = fullfile(matfd, ['BW3_', FracNames{m}, '.mat']);    
            save(BW3ffn, 'BW3')
        end
        Namesffn= fullfile(matfd, 'Names.mat');    
        save(Namesffn, 'STNames', 'FracNames');
    end