function [xMin, xMax, yMin, yMax] = get_contour_min_max_xy(contours)

nContours = length(contours);

minX = zeros(nContours, 3); % There can't be more than 3 contour segments in reality.
maxX = zeros(nContours, 3);
minY = zeros(nContours, 3);
maxY = zeros(nContours, 3);

for iContour = 1 : length(contours)
    for iSegment = 1 : length(contours(iContour).segments)
        points = contours(iContour).segments(iSegment).points;
        minX(iContour, iSegment) = min(points(:, 1));
        maxX(iContour, iSegment) = max(points(:, 1));
        minY(iContour, iSegment) = min(points(:, 2));
        maxY(iContour, iSegment) = max(points(:, 2));
    end
end

xMin = min(minX(:));
xMax = max(maxX(:));
yMin = min(minY(:));
yMax = max(maxY(:));

