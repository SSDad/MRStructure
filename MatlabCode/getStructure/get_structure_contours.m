function structure = get_structure_contours(contourData)
% get the contours for one structure.

if ~isfield(contourData, 'ContourSequence')
%if  isempty(fieldnames(contourData.ContourSequence))    %  Zhen  5/22/2015
    structure.contours = [];
    flag = 1;  
    return;
end

[segments, zs] = structfun(@get_segment_points, contourData.ContourSequence);
[zs, sortedInd] = sort(zs); % sort z positions.
segments = segments(sortedInd); % Sort segments by their z positions.

roundedZ = round(zs*100); % Round (z*100) to avoid rounding error of the z positions.
nSegs = histc(roundedZ, unique(roundedZ)); % Find the number of appearances of individual z positions.
nSlices = length(nSegs); 

if nSlices == 0
       structure.contours = [];
else
 
% Reorganize segments so that segments with same z are on same slice.
iSegment = 0; % An index referencing the segments.
structure.contours(nSlices, 1).z = 0; % Pre-allocating struct memory only speeds up the program slightly. Maybe my dataset is too small.
for iSlice = 1 : nSlices
    for iSeg = 1 : nSegs(iSlice) % Could have more than one segments on one slice.
        iSegment = iSegment + 1;
        structure.contours(iSlice).segments(iSeg) = segments(iSegment); % Place in same slice.
    end
    structure.contours(iSlice).z = zs(iSegment); % Assign a unique z position to a slice.
end

for iSlice = 1 : length(structure.contours)
    nSegments = length(structure.contours(iSlice).segments);
    
    if nSegments == 1
        structure.contours(iSlice).segments.isRoi = true;
        continue;
    end
    
    for iSeg1 = 1 : nSegments
        structure.contours(iSlice).segments(iSeg1).isRoi = true;
        for iSeg2 = 1 : nSegments
            if iSeg1 == iSeg2
                continue;
            end
            
            if any(inpolygon(...
                    structure.contours(iSlice).segments(iSeg1).points(:, 1), ...
                    structure.contours(iSlice).segments(iSeg1).points(:, 2), ...
                    structure.contours(iSlice).segments(iSeg2).points(:, 1), ...
                    structure.contours(iSlice).segments(iSeg2).points(:, 2)))
                structure.contours(iSlice).segments(iSeg1).isRoi = ~structure.contours(iSlice).segments(iSeg1).isRoi;
            end
        end
    end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [segment, z] = get_segment_points(segmentData)
segment = [];
z = nan;

if ~isempty(segmentData.ContourData)
    segment.points = reshape(segmentData.ContourData, 3, [])';
    segment.points(:, 3) = [];
    segment.nPoints = segmentData.NumberOfContourPoints;
    segment.type = segmentData.ContourGeometricType;
    z = segmentData.ContourData(3);
end
% segment.RefSOPI_UID = segmentData.ContourImageSequence.Item_1.ReferencedSOPInstanceUID;
%%%% For robustness.
%%%% But TPS should NOT have this problem. So, disable this check.
% if length(unique(segment.points(:, 3))) > 1
%     warning('More than one z position in a contour in one slice. There should be only one.');
% end