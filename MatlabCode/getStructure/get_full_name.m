function fullname = get_full_name(nameStruct)

if isfield(nameStruct, 'GivenName')
    fullname = nameStruct.GivenName;
else
    fullname = '';
end

if isfield(nameStruct, 'MiddleName')
    fullname = [fullname ' ' nameStruct.MiddleName];
end

if isfield(nameStruct, 'FamilyName')
    fullname = [fullname ' ' nameStruct.FamilyName];
end

fullname = strtrim(fullname);