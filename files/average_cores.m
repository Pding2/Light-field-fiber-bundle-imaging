%calculating the average vaule of each individual fiber bundle core
%Last modification: 02/01/2023
% by Peisheng Ding (peisheng.ding@mpi-halle.mpg.de, peisheng.ding@mail.utoronto.ca)



function A_cores= average_cores(Image, Cores_Stats,blank_field,radii)
% %---------------------------------------------------------------------------------------
[xgrid, ygrid] = meshgrid(1:size(Image,2), 1:size(Image,1));
average_R = [];
average_B = [];
sum_R = 0;
sum_B = 0;


for ii = 1:size(Cores_Stats,1)
    area_each_core_full = ((xgrid-Cores_Stats(ii,2)).^2 + (ygrid-Cores_Stats(ii,3)).^2) <= (radii(ii,1).*1.2).^2;% define the position of each cores
    pixelvalues_R = Image(area_each_core_full); %pixesl value per cores
    sum_R = sum_R + sum(pixelvalues_R(:));
    mean_each_R = mean(pixelvalues_R);% the means pixsel values for each cores
    average_R(ii) = mean_each_R;
    
    
%-----------------------------------------------------------------------------------------------------------

    area_each_core_small = ((xgrid-Cores_Stats(ii,2)).^2 + (ygrid-Cores_Stats(ii,3)).^2) <= ((radii(ii,1))*1.2./3).^2;% define the position of each cores
    pixelvalues_B = Image(area_each_core_small); %pixesl value per cores
    sum_B = sum_B + sum(pixelvalues_B(:));
    mean_each_B = mean(pixelvalues_B);
    average_B(ii) = mean_each_B;


end

A_cores.average_R = average_R;% value of each center pixel
% A_cores.new_img_R = new_img_R;
A_cores.sum_R = sum_R;% sum of all the pixels
% new_img_B = double(blank_field);
A_cores.average_B = average_B;
% A_cores.new_img_B = new_img_B;
A_cores.sum_B = sum_B;


