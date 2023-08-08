function [new_img_R, new_img_B] = background_sub(Image, vq_R, vq_B)
figure(10)
imshow(vq_R,[],'InitialMagnification','fit')
title('circle a region for background substraction')
%function of selected interested region for background substraction 
Selected_background_Region = ROI(vq_R);
back_mean_R = mean2(vq_R(logical(Selected_background_Region)));
back_mean_B = mean2(vq_B(logical(Selected_background_Region)));
if isnan(back_mean_R)
    new_img_R = vq_R;   
    new_img_B = vq_B;   
else
    new_img_R = vq_R - double(back_mean_R);
    new_img_B = vq_B - double(back_mean_B);
end

new_img_R(new_img_R<0) = 0;
new_img_B(new_img_B<0) = 0;
new_img_R(find(new_img_R<0.01*max(max(new_img_R)))) = 0;
new_img_B(find(new_img_B<0.01*max(max(new_img_B)))) = 0;
close (figure(10))