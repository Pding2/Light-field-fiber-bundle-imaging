% Step 1: Ditial aperture filtering 
% Reference: A. Orth, etc.,Optical fiber bundles: Ultra-slim light field imaging probes
% Two images for full and small aperture will be saved
% last modified 2022-05-20
% by Peisheng Ding (peisheng.ding@mpi-halle.mpg.de, peisheng.ding@mail.utoronto.ca)

clc; 
clear ;
close all;
addpath('files')

%read the files and get the core location 
[filename,filepath]=uigetfile({'*'});% select the images 
Image = imread(strcat(filepath, filename));% the raw image
ReferenceImage = imread('files/single_layer/Reference.tif');
% 
Image = imresize(Image,2,'bicubic');% double the size of the image to aviod the edging effect
ReferenceImage = imresize(ReferenceImage, 2, 'bicubic');
%--------------------------------------------------------------------------

% adaptive threshold 
SelectedRegion = ReferenceImage;
adaptiveImage = adaptive_threshold(SelectedRegion,[14,14],0.02);%adaptive threshold with [7,7] window size
clear SelectedRegion

%-------------------------------------------------------------------------------------------

figure(88)
imshow(Image*70,[])
title('circle a partial region for faster computation')
adaptiveImage = ROI (adaptiveImage);% region of interest
% ReferenceImage = ROI(ReferenceImage);
close(88)

%-------------------------------------------------------------------------------------------

%Cores_locations
[Cores_Stats, radii,radii2] = cores_locations(adaptiveImage);% find the Centroid index of cores

%-------------------------------------------------------------------------------------------

%adjust the location of the core for matching, check figure(2) for the reference 
adjust_x = 0.5; 
adjust_y = -1;
Cores_Stats(:,2) = Cores_Stats(:,2) + adjust_x;
Cores_Stats(:,3) = Cores_Stats(:,3) + adjust_y;
[blank_field,new_x,new_y] = draw_2(Image, Cores_Stats,radii); % new_col&row is the indx of the Centroid core locations

%--------------------------------------------------------------------------------------------
%% average the cores
close all
figure (88)
imshow(Image*70,[])
title('circle a region that you want to calculate the averged core value')
RawImage = ROI(Image);
% Image = double(RawImage)./max(double(RawImage(:)));%normalizd the max value to 1
Image = double(RawImage)./(2.^16);
close(88)


%--------------------------------------------------------------------------

% The pixel corresponding to the center of each core is set to the mean of
% all the pixels with in R pixels from the core center; A_cores is a
% struct,A_cores.average_R is the value of the average center pixel
%%
%calculating the average value of each cores
tic
A_cores = average_cores(Image, Cores_Stats,blank_field,radii);
toc
%--------------------------------------------------------------------------
%%
%interpolation for the cladding region ;go the the files/interpolation_cladding to define
%vq is the interpolated images
[Xq_R, Yq_R, vq_R] = Interpolant_cladding(new_x, new_y,A_cores.average_R');
[Xq_B, Yq_B, vq_B] = Interpolant_cladding(new_x, new_y,A_cores.average_B');
draw_1(Xq_R, Yq_R, vq_R,Xq_B, Yq_B, vq_B)
save('vq_R&vq_B','vq_R','vq_B')

%%
% FWHM detecting. Only for signle beads detection
%vq_R = vq_R./max(max(vq_R));
%vq_B = vq_B./max(max(vq_B));
%[maxval,maxind]=max(vq_R(:));
%[center_row,center_col]=ind2sub(size(vq_R),maxind)% to detect the peak pixel position
%fullwidth_B = find_FWHM(vq_R);
%fullwidth_B = find_FWHM(vq_B);

%%
close all
% background substrction
[img_full, img_small] = background_sub(vq_R, vq_B);
subplot(1,2,1)
imshow(img_full*10,[]);colorbar
title('full')
subplot(1,2,2)
imshow(img_small,[]);colorbar
title('small')
save('full&small','img_full','img_small')
