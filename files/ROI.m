% function of selecting the region of interesting 
function blackMaskedImage = ROI(ReferenceImage)
h = drawfreehand();% confine a region
binaryImage = h.createMask();
% xy = round(getPosition(h));
% x = xy(:, 2); % Columns.
% y = xy(:, 1); % Rows
% keep only the part of the image that's inside the mask, zero outside mask.
blackMaskedImage = ReferenceImage;
blackMaskedImage(~binaryImage) = 0;

% Get coordinates of the boundary of the freehand drawn region.
% structBoundaries = bwboundaries(binaryImage);
% xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
% x = xy(:, 2); % Columns.
% y = xy(:, 1); % Rows

%--------------------------------------------------------------------------
% useless
% Label the binary image and computer the centroid and center of mass.
% labeledImage = bwlabel(binaryImage);
% measurements = regionprops(binaryImage, grayImage, ...
%     'area', 'Centroid', 'WeightedCentroid', 'Perimeter');
% area = measurements.Area
% centroid = measurements.Centroid
% centerOfMass = measurements.WeightedCentroid
% perimeter = measurements.Perimeter