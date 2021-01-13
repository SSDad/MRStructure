clearvars

addpath(fullfile(pwd, 'getStructure'));

fd = 'Y:\Varian MRA\Lung\Data\Patient List_CT_RTDOSE_RTSS\11102389';
junk = dir(fullfile(fd, 'RS*'));
junk = junk(1);
ffn = fullfile(junk.folder, junk.name);
di = dicominfo(ffn);
% plan = load_structure_from_dicom(ffn);

contour = dicomContours(di);