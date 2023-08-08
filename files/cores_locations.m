% Last modification:01/22/2023
% by Peisheng Ding (peisheng.ding@mpi-halle.mpg.de, peisheng.ding@mail.utoronto.ca)

function [filtered_image,radii,radii2] = cores_locations(image_input)
% this function detect the cores loaction by regionprops
% The the outlier data are removed by defining an reasnable range of the core
% radiis. And the new filtered matrix is outputed

%detecting the cores region from the ROI
stats = regionprops('table',image_input,'Centroid','MajorAxisLength','MinorAxisLength','Area');
Stats =table2array(stats); %convert table to matrix
[numRows,numCols] = size(Stats);
filtered_image = [];% creat a empty array
for i = 1:numRows
    a = Stats(i,4);
    b = Stats(i,5);
    r = (a+b)./4; %calculate the radius of the core
        if r > 4 & r < 10   %!!!!choose a reasonable range of the
%         radii. THIS NEED TO BE CHANGE BASED ON THE CORE OF THE FIBER !!!
%         if r > 2.5 & r < 4
            filtered_image = [filtered_image;Stats(i,:)];
        else
            filtered_image = [filtered_image];
        end
        
end
radii = (filtered_image(:,4)+filtered_image(:,5))./4;
radii2 = sqrt(filtered_image(:,1)./pi);









