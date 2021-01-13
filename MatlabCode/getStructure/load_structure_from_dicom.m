function plan = load_structure_from_dicom(rsFile)

% Contour data:
%
% plan.structureData.numbers
%     Structure number.
%
% plan.structureData.names
%     Structure names.
%
% plan.structureData.structures(iStructure).contours(iContour).segments(iSegment).points(iPoint,1:3)
%     First "structures" is the Matlab struct of plan structure.
%     Second "structures" is the structure data.
%
% plan.structureData.structures(iStructure).contours(iContour).z
%     Easy access of structure contour z positions.

% Assume rsFile is a valid RT structure set filename.
plan.structureData.filename = rsFile;

% Get structure DICOM info.
rsDicom = dicominfo(plan.structureData.filename, 'UseVRHeuristic', false);

% Get patient identification.
plan.patientName = rsDicom.PatientName;
plan.patientId = rsDicom.PatientID;

% For robustness, find valid structures and contours.
% Just in case there is structure inconsistency or not in same order.
structureNumbers = structfun(@get_structure_numbers, rsDicom.StructureSetROISequence); % find all structure numbers in roi definition.
contourNumbers = structfun(@get_structure_numbers, rsDicom.ROIContourSequence); % find all structure numbers in contour definition.
plan.structureData.numbers = sort(intersect(structureNumbers, contourNumbers)); % find the structure numbers that appear in both roi and contour definitions.
[validStructures, locStructures] = ismember(structureNumbers, plan.structureData.numbers); % find valid structures.
[validContours, locContours] = ismember(contourNumbers,   plan.structureData.numbers); % find valid contours.
locStructures = locStructures(validStructures); % find indexes of valid structures.
locContours = locContours(validContours); % find indexes of valid contours.

% Remove structures and contours that only appear in either roi or
% contour but not in both, and then sort by structure number.
plan.structureData.names = structfun(@get_structure_names,rsDicom.StructureSetROISequence);
plan.structureData.names = plan.structureData.names(locStructures);
plan.structureData.structures = structfun(@get_structure_contours, rsDicom.ROIContourSequence);
plan.structureData.structures = plan.structureData.structures(locContours);

% Remove empty contours.
nStructures = length(plan.structureData.structures); % number of structures.
validContours = true(length(plan.structureData.structures), 1);
for iStructure = 1 : nStructures
    validContours(iStructure) = ~isempty(plan.structureData.structures(iStructure).contours);
end
plan.structureData.names = plan.structureData.names(validContours);
plan.structureData.numbers = plan.structureData.numbers(validContours);
plan.structureData.structures = plan.structureData.structures(validContours);
nStructures = length(plan.structureData.structures); % UPDATED number of structures after empty contours are removed.

% Get z positions of all slices.
slicePos = [];
for iStructure = 1 : nStructures
    slicePos = [slicePos [plan.structureData.structures(iStructure).contours.z]]; % Small array, so growing doesn't matter.
end
plan.structureData.slicePos = unique(slicePos);

% Get the min and max structure contour point x/y positions.
minX = zeros(nStructures, 1);
maxX = zeros(nStructures, 1);
minY = zeros(nStructures, 1);
maxY = zeros(nStructures, 1);
for iStructure = 1 : nStructures
    [minX(iStructure), maxX(iStructure), minY(iStructure), maxY(iStructure)] = ...
        get_contour_min_max_xy(plan.structureData.structures(iStructure).contours);
end
plan.structureData.xMin = min(minX);
plan.structureData.xMax = max(maxX);
plan.structureData.yMin = min(minY);
plan.structureData.yMax = max(maxY);

% Remove duplicate contour data to relieve memory pressure.
rsDicom.ROIContourSequence = [];
rsDicom.ROIContourSequence.userMessage = ...
    'Original data were removed because they have been converted to easier-to-use private format.';

% Keep structure DICOM header info.
plan.structureData.rsDicom = rsDicom;