clearvars

CamView = [-160 -15];

%% patient info
fdName_nonVG = 'VG';
ptMatInfoFN = ['matInfo_', fdName_nonVG, '.mat'];
load(ptMatInfoFN);

nPatient = length(ptMatFile);
for iPatient = 1:nPatient
    fn_DC = ['DC_', fdName_nonVG, '_', num2str(iPatient), '.mat'];
    if ~exist(fn_DC, 'file')
        close all;
        display(['Working on ', num2str(iPatient), '/', num2str(nPatient), '...']);
        [DC] = fun_Render3D(ptMatFile, iPatient, CamView);
        save(fn_DC, 'DC')
    end
end