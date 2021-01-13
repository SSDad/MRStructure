function structureInd = get_structure_ind(plan, structureNo)
% get the structure index (position in the structure sequence)
% by number or name.

if isnumeric(structureNo)
    structureInd = find([plan.structureData.numbers] == structureNo);
    if isempty(structureInd)
        disp(['Invalid structure number ' str2num(structureNo) '.']);
    elseif length(structureInd) > 1
        disp(['At least two structures share same number ' str2num(structureNo) '.']);
        structureInd = [];
    end
elseif ischar(structureNo)
    structureInd = find(strcmpi(plan.structureData.names, structureNo));
    if isempty(structureInd) % Structure not found.
        disp(['Structure "' structureNo '" doesn''t exist.']);
    elseif length(structureInd) > 1
        disp(['At least two structure share same name "' structureNo '".']);
        structureInd = [];
    end
else
    disp('Invalid structure number or name in function call get_structure_vol');
    structureInd = [];
end

