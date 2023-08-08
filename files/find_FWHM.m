% detecting the FWHM of a sigle beads
% last modified 2022-05-25

function fullwidth = find_FWHM(new_img)
%---------------------------find the FWHM-------------------------------
%find the center of the intensity plot
% BW = new_img > 0.1;
% CH = bwconvhull(BW);
% imshow(CH);
% hhh = regionprops(CH,'Centroid');
% center_row = hhh.Centroid(2);
% center_col = hhh.Centroid(1);

% [maxval,maxind]=max(new_img(:));
% [center_row,center_col]=ind2sub(size(new_img),maxind);
close all
center_row = 210;
center_col = 212;

horizontalProfile_0 = double(new_img(round(center_row), :));
x = 1:length(horizontalProfile_0);
horizontalProfile_1 = smooth(x,horizontalProfile_0,0.2,'loess');
% horizontalProfile = smoothdata(horizontalProfile_1, 'gaussian');

[pks,locs,widths,proms] = findpeaks(horizontalProfile_1,x,'SortStr','descend','NPeaks',1,'Annotate','extents');

% figure (5);findpeaks(horizontalProfile,x,'SortStr','descend','NPeaks',1,'Annotate','extents')%for testing 
figure (6);plot(x,horizontalProfile_0,'-o',x,horizontalProfile_1,'-x')


%another fitting method
% gauss = 'a.*exp(-(x-b).^2./(2.*c.^2))+d';
gauss = 'a.*exp(-4*log(2)*(x-b).^2./(c.^2))+d';
a = max(horizontalProfile_0);
startPoints = [a locs 3 0];
f = fit(x',horizontalProfile_0',gauss,'Start', startPoints);
figure(7); plot(f,x,horizontalProfile_0)

Coeffs = coeffvalues(f); c = Coeffs(3); peak = Coeffs(1);
% FWHM = 2.*sqrt(2.*log(2)).*c;
FWHM = c;
FWHM


% % Find the half max value.
% halfMax = (min(horizontalProfile_0) + max(horizontalProfile_0)) / 2;
% % Find where the data first drops below half the max.
% index1 = find(horizontalProfile_0 >= halfMax, 1, 'first');
% % Find where the data last rises above half the max.
% index2 = find(horizontalProfile_0 >= halfMax, 1, 'last');
% fwhm = index2-index1 + 1; % FWHM in indexes.

%draw the FWHM line
figure(8)
hold on
imagesc(new_img)
% line([locs-widths./2,locs+widths./2],[center_row,center_row])
line([center_col-FWHM./2,center_col+FWHM./2],[center_row,center_row],'LineWidth',1,'color','red')
hold off
% widths;
% disp(fwhm)


fullwidth.FWHM = FWHM;
fullwidth.widths = widths;
fullwidth.center_col = center_col;
fullwidth.center_row = center_row;



%-----2dguassin fit failed-----------------------------
% g = fittype( ' a*exp(-( ((x-b)/c)^2 + ((y-d)/e)^2 ) ) + f ', 'independent', {'x', 'y'},...
%      'dependent', 'z' ,'coefficients',{'a','b','c','d','e','f'});
% fit_model = fit([Xq_R(:) Yq_R(:)], vq_R(:), g)
% % fit_model = fit([Xq_R(:) Yq_R(:)], vq_R(:), 'a + b*exp(-(((x-c1)*cosd(t1)+(y-c2)*sind(t1))/w1)^2-((-(x-c1)*sind(t1)+(y-c2)*cosd(t1))/w2)^2)')
% 
% plot(fit_model, [Xq_R(:) Yq_R(:)], vq_R(:))

