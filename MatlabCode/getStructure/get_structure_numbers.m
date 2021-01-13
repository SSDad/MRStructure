function structureNumber = get_structure_numbers(roi)

if isfield(roi, 'ROINumber')
    structureNumber = roi.ROINumber;
elseif isfield(roi, 'ReferencedROINumber')
    structureNumber = roi.ReferencedROINumber;
else
    warning('Structure number missing.');
    structureNumber = NaN;
end
