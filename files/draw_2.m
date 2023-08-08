function [blank_field,new_x,new_y] = draw_2(Image, Cores_Stats,radii)


%create a blank image 
[row, col] = size(Image);
blank_field = zeros(row, col);
new_x = Cores_Stats(:,2);
new_y = Cores_Stats(:,3);
new_centers = [new_x, new_y];
% centers = Cores_Stats(:,[2,1]);


% testing the location of the two aperture 
figure (2)
hold on
imshow(Image*20,[])
title('check whether the recreated aperture match to the core in the image, or adjust the adjust xy value')
viscircles(new_centers,radii);% mark the region of core after the  filtering 
% viscircles(new_centers,radii/3,'color','b');% mark the region of core after the  filtering 
hold off
