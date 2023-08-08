% Step 2: Raw image refocusing 
% Cite: Optical fiber bundles: Ultra-slim light field imaging probes
% last modified 2022-05-20
% by Peisheng Ding (peisheng.ding@mpi-halle.mpg.de, peisheng.ding@mail.utoronto.ca)

addpath('files')
close all;
%% getting Mx and My

% t1 = 0.40;
% t0 = 0.32;
t1 = 0.352;
t0 = 0.285;
img_small(isnan(img_small))=0;
img_full(isnan(img_full))=0;
img_small = img_small./max(img_small(:));%normalization 
img_full = img_full./max(img_full(:));
sum_I0 = sum(img_small(:));%total intensity of I0
sum_I1 = sum(img_full(:));
alpha_sum = sum_I0./sum_I1; % the ratio of the total intensity of the two images 
alpha = (t0./t1).^2;
close all

delta_I = img_small - alpha.* img_full;%difference image
figure(1);imagesc(delta_I);colorbar;title('delta I')



[N, M] = size(delta_I);
sigma = 25;
% convert pixels to microns 
%----------------------------------------
pixcel_size = 2.56; % microns
%---------------------------------------
%spatial frequency
MM = (-(M/2):1:(M/2-1))/M/pixcel_size; % frequency coordinate X.
NN = (-(N/2):1:(N/2-1))/N/pixcel_size; % frequency coordinate Y.
%----------------------------------------

% Peppa pig
close all
[fx, fy] = meshgrid(MM, NN);
Cx = fftshift(fx);
Cy = fftshift(fy);
f_s = Cy.^2 + Cx.^2; % spacial frequency 
C = 10.^-2.*max(4.*pi.^2.*f_s(:));%epsilon 
%----------------------------------------
H = 1./(-4.*pi.^2.*(fx.^2+fy.^2)*0.25-C);
figure(2);mesh(H);title('H')
%-------------------------------------------------------------
F_delta_I = fft2(delta_I);% fft of the delta image
% F_delta_I = fftshift(F_delta_I);% shift the 0 to the center
F_U = (F_delta_I)./(-4.*pi.^2.*(f_s).*(t1/t0-1)-C);% the 1.23 is got from the tan1/tan0, and the value C should be added before the last brackets
% F_U = ifftshift(F_U);%shift back
U_F = ifft2(F_U);

%--------------------------------------------------------------------

I_total = (img_small+alpha.*img_full)./2; 

%----------------------------------------------
[px,py] = gradient(real(U_F));

p_normalized = sqrt(px.^2+ py.^2);
figure(16);imshow((p_normalized),[]);colorbar;title('gradient U')
M_x = px./(I_total);
M_y = py./(I_total);
M_x(isinf(M_x))= 0 ;
M_y(isinf(M_y))= 0 ;

M_normalized = sqrt(M_x.^2+ M_y.^2);
figure(66);imshow((M_normalized),[]);colorbar;title('Me')
%----------------------------------------------
[M_draw,N_draw]= meshgrid(1:M, 1:N);
figure(11); quiver(M_draw,N_draw,real(px),real(py));title('gradient U')
figure(5);quiver(M_draw,N_draw,real(M_x),real(M_y));title('M')

%% light field

%For Calculating a PSF with the properties, as discussed
close all
x_pixels = size(I_total,1);%Change to number of x pixels in imagea
y_pixels = size(I_total,2);%change to number of Y pixels in image
u = -40; %assumption angle for u,v
v = -40;
du = 8;
dv = 8;
u_vector=u:du:abs(u);
v_vector=v:dv:abs(v);
u_slices=length(u_vector);
v_slices=length(v_vector);
gauss = exp(-2.*(-0-M_x).^2 ./sigma.^2 - 2.*(0-M_y).^2 ./sigma.^2);
subplot(2,1,1);mesh(gauss);title(['visulizing the gauss part when sigma = ' num2str(sigma)]); colorbar
subplot(2,1,2);imagesc(gauss);colorbar

%multipuly

F = zeros(x_pixels,y_pixels,u_slices,v_slices);
    for i = 1:u_slices
         U = u_vector(i);
        for j = 1:v_slices 
            V = v_vector(j);
                F(:,:,i,j) =I_total.*exp(-2.*(U-M_x).^2 ./sigma.^2 - 2.*(V-M_y).^2 ./sigma.^2);
              
                F(:,:,i,j) = F(:,:,i,j)./ max(max(F(:,:,i,j)));
        end 
    end
    
Write_4DStack(F,'lightfield.tif',32)
save('Lightfield_function.mat','F')
figure(2);imshow(F(:,:,round(size(F,3)/2),round(size(F,4)./2)),[],'InitialMagnification', 'fit')    


%%
% refocusing
Rz = 0:7.3:226.3;% 32 slices

[Sx,Sy,Su,Sv] = size(F);
%--------------------------------------------------------------------------
x_list = (-(Sx/2):1:(Sx/2-1)).*pixcel_size;
y_list = (-(Sy/2):1:(Sy/2-1)).*pixcel_size;
[XX, YY] = meshgrid(y_list, x_list);
E_measure = zeros(Sx,Sy,length(Rz));% refocused stacks for measured images
plot_centroid_shift = [];

for rz = 1: length(Rz)
    Z = Rz(rz);
    
    %----------------------------------------------------------------------
    %centriod shift 
    sigmaO = 10; %adjustable parameter
    h =sigma./t0;
    shift_unit = (Z.^2 + sigmaO.^2./t0.^2)./(Z.^2 + 2.*log(2).*h.^2 + sigmaO.^2./t0.^2);
    plot_centroid_shift(rz) = shift_unit;
    %--------------------------------------------------------------------    

    L_sum = 0;
    for u = 1:Su
        U = u_vector(u);
        for v = 1:Sv
            V = v_vector(v);
            xp_list = XX +U.*shift_unit*1;
            yp_list = YY +V.*shift_unit*1;

            LI = interp2(XX,YY,F(:,:,u,v),xp_list,yp_list,'linear',0);
            L_sum = L_sum + LI;
        end
    end
E = L_sum./(Su.*Sv);
E(find(E<0.01*max(max(E))))=0;
E_measure(:,:,rz) = E;
end
% E_measure(:,:,1) = 0;
WriteTifStack(E_measure,'focal_stacks_E_measure.tif',32)
save('refocused_measure','E_measure')
print('done')
%%