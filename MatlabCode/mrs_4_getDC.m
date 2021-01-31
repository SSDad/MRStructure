clearvars

CamView = [-160 -15];

%% patient info
fdName_nonVG = 'VG';
ptMatInfoFN = ['matInfo_', fdName_nonVG, '.mat'];
load(ptMatInfoFN);

fn_DC = ['DC_', fdName_nonVG];
nPatient = length(ptMatFile);
for iPatient = 15:nPatient
    close all;
    display(['Working on ', num2str(iPatient), '/', num2str(nPatient), '...']);
    [DC{iPatient}] = fun_Render3D(ptMatFile, iPatient, CamView);
end

save(fn_DC, 'DC')