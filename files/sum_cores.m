function A_cores= sum_cores(Image, Cores_Stats,blank_field,radii)
% %---------------------------------------------------------------------------------------
[xgrid, ygrid] = meshgrid(1:size(Image,2), 1:size(Image,1));

core_R = [];
core_B = [];
new_col = Cores_Stats(:,2);
new_row = Cores_Stats(:,3);
% radii = (Cores_Stats(:,3)+Cores_Stats(:,4))./4;
sum_R = 0;
sum_B = 0;


for ii = 1:size(Cores_Stats,1)
    area_each_core_full = ((xgrid-Cores_Stats(ii,2)).^2 + (ygrid-Cores_Stats(ii,3)).^2) <= radii(ii,1).^2;% define the position of each cores
    pixelvalues = Image(area_each_core_full); %pixesl value per cores
    sum_R = sum_R + sum(pixelvalues(:));
%     mean_each = sum(pixelvalues)./sum(area_each_core_full(:));
%     mean_each = mean(pixelvalues);% the means pixsel values for each cores
%     blank_field(round(new_row(ii)), round (new_col(ii))) = mean_each; % rewrite the pixels inside the cores to average 
    blank_field(round(new_row(ii)), round (new_col(ii))) = sum(pixelvalues(:)); % rewrite the pixels inside the cores to sum of all the pixcels 
%      average_R(ii) = mean_each;
    core_R(ii) = sum(pixelvalues(:));
end

new_img_R = double(blank_field);
A_cores.new_img_R = new_img_R;
A_cores.sum_R = sum_R;
A_cores.core_R = core_R;


% for small apture 
for ii = 1:size(Cores_Stats,1)% these two for loop can be combined, maybe it will be faster; 
    area_each_core_small = ((xgrid-Cores_Stats(ii,2)).^2 + (ygrid-Cores_Stats(ii,3)).^2) <= (radii(ii,1)./3).^2;% define the position of each cores
%     area_each_core_full = ((xgrid-Cores_Stats(ii,1)).^2 + (ygrid-Cores_Stats(ii,2)).^2) <= radii(ii,1).^2;% define the position of each cores
    pixelvalues = Image(area_each_core_small); %pixesl value per cores
    sum_B = sum_B + sum(pixelvalues(:));
%     mean_each = mean(pixelvalues);% the means pixsel values for each cores
%     mean_each = sum(pixelvalues)./sum(area_each_core_small(:));
%     mean_each = sum(pixelvalues)./sum(area_each_core_full(:));
%     blank_field(round(new_row(ii)), round (new_col(ii))) = mean_each; % rewrite the pixels inside the cores to average 
    blank_field(round(new_row(ii)), round (new_col(ii))) = sum(pixelvalues(:)); % rewrite the pixels inside the cores to sum of all the pixcels 
%     average_B(ii) = mean_each;
    core_B(ii) = sum(pixelvalues(:));
end
new_img_B = double(blank_field);
A_cores.new_img_B = new_img_B;
A_cores.sum_B = sum_B;
A_cores.core_B = core_B;







% function [getX, getY, pppp,new_img] = average_cores(Image, Cores_Stats, radii,blank_field)
% %---------------------------------------------------------------------------------------
% % average the pixel value for each core and rewrite the region inside the
% % average value and get the coorinations and value of the cores
% [xgrid, ygrid] = meshgrid(1:size(Image,2), 1:size(Image,1));
% average = [];
% get_position = blank_field;
% 
% 
% for ii = 1:size(Cores_Stats,1)
%     area_each_core = ((xgrid-Cores_Stats(ii,1)).^2 + (ygrid-Cores_Stats(ii,2)).^2) <= radii(ii,1).^2;% define the position of each cores
%     pixelvalues = Image(area_each_core); %pixesl value per cores
%     mean_each = mean(pixelvalues);% the means pixsel values for each cores
%     blank_field(area_each_core) = mean_each; % rewrite the pixels inside the cores to average 
%     average(ii) = mean_each;
%     get_position = get_position + area_each_core;% get the psotion of the cores 
% end
% 
% new_img = uint8(blank_field);
% [getX, getY] = find(get_position==1);% get the x, y of the cores
% get_logicalPosition = logical(get_position);%;;double2logical
% pppp = new_img(get_logicalPosition);%get the value for the core to getX, getY, by using the logical array

% -------------------used to test--------------------------
% figure (3)
% imshow(uint8(new_img))
% imshow(uint8(new_img))