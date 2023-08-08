function [new_img_R, new_img_B] = background_sub(vq_R, vq_B)


vq_R(isnan(vq_R))=0;
vq_B(isnan(vq_B))=0;
figure(10)
imshow(vq_R*70,'InitialMagnification','fit')
title('circle a region for background substraction')
%function of selected interested region for background substraction 
Selected_background_Region = ROI(vq_R);
back_mean_R = mean2(vq_R(logical(Selected_background_Region)));% mean of the selected backgroudn reagion
back_mean_B = mean2(vq_B(logical(Selected_background_Region)));



new_img_R = vq_R - 1.05.*double(back_mean_R);% substract the mean from the image
new_img_B = vq_B - 1.05.*double(back_mean_B);
% new_img_R(find(new_img_R<0.01*max(max(new_img_R)))) = 0;
% new_img_B(find(new_img_B<0.01*max(max(new_img_B)))) = 0;
new_img_R(new_img_R<0) = 0;% set the value that lower than 0 to 0
new_img_B(new_img_B<0) = 0;
close (figure(10))
