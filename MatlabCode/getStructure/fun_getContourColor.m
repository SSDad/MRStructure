function contourColor = fun_getContourColor(contourData)

contourColor = {[255; 0; 0]};

if isfield(contourData, 'ROIDisplayColor')
    contourColor = {contourData.ROIDisplayColor};
end
