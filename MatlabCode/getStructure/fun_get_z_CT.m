function        [infoIS, nCTslice, z_CT, M, PixelSpacing,...
                    ImagePositionPatient, ImageOrientationPatient...
                     Manufacturer] = fun_get_z_CT(Folder, FrameOfReferenceUID)

dcmFiles_CT=dir(fullfile(Folder, 'CT*.*'));
dcmFiles_MR=dir(fullfile(Folder, 'MR*.*'));
% dcmFiles_other=dir(fullfile(Folder, '*.*'));
% dcmFiles = [dcmFiles_CT;dcmFiles_MR;dcmFiles_other];
dcmFiles = [dcmFiles_CT;dcmFiles_MR];
dcmFiles = dcmFiles(~ismember({dcmFiles.name}, {'.','..'}));

dcmFileNames = {dcmFiles.name}';
nF = length(dcmFileNames);

iSlice = 0;

for iF = 1:nF
    ffn = fullfile(Folder, dcmFileNames{iF});
    dcmInfo = dicominfo(ffn);
    FoRUID = dcmInfo.FrameOfReferenceUID;
    
    if strcmp(FoRUID, FrameOfReferenceUID);
        iSlice = iSlice+1;
        dicomInfo(iSlice) = dcmInfo;
        z_CT(iSlice) = dicomInfo(iSlice).ImagePositionPatient(3);
        dicomFileNames{iSlice} = dcmFileNames{iF};
    end
end

nCTslice = iSlice;
[z_CT idx] = sort(z_CT);
dicomFileNames = {dicomFileNames{idx}};
dicomInfo = dicomInfo(idx);

% waiting bar
progLim = nCTslice;
progVal = 0;
msg = sprintf('Reading dicom files...');
hWaitBar = waitbar(progVal / progLim, msg, 'name', 'Load dicom images', 'WindowStyle', 'modal');

for iSlice = 1:nCTslice
    PixelSpacing(iSlice, :) = dicomInfo(iSlice).PixelSpacing;
    ImagePositionPatient(iSlice, :) = dicomInfo(iSlice).ImagePositionPatient;

    ffn = fullfile(Folder, dicomFileNames{iSlice});
    I = dicomread(ffn);
    M(:,:,1,iSlice) = I;

    if ishandle(hWaitBar)
        progVal = progVal + 1;
        msg = sprintf('Reading dicom files...');
        waitbar(progVal / progLim, hWaitBar, msg);
    end

end

dcmInfo = dicominfo(ffn);

ImageOrientationPatient = dcmInfo.ImageOrientationPatient;
Manufacturer = dcmInfo.Manufacturer;

% dicom info
        infoIS = cell(1, 7);
        infoIS(1) =cellstr([dcmInfo.PatientName.FamilyName, ', ', dcmInfo.PatientName.GivenName]);;
        infoIS(2) = cellstr(dcmInfo.PatientID);
        infoIS(3) = cellstr(dcmInfo.PatientBirthDate);
        infoIS(4) = cellstr(dcmInfo.Modality);
        if strcmp(infoIS(4), 'MR')
            infoIS(5) = cellstr(dcmInfo.SeriesDate);
            infoIS(6) = cellstr(dcmInfo.SeriesTime(1:6));
        elseif strcmp(infoIS(4), 'CT')
            infoIS(5) = cellstr(dcmInfo.AcquisitionDate);
            infoIS(6) = cellstr(dcmInfo.AcquisitionTime(1:6));
        end            
        infoIS(7) = cellstr(dcmInfo.FrameOfReferenceUID);
        
if ishandle(hWaitBar)
    close(hWaitBar);
end
