
%Last modification: 02/16/2023

close all
% simulate the  I1 and I0 by using the Gaussian
pixel_size = 2.56; % um per pixel
[Sx,Sy] = size(img_full);
%--------------------------------------------------------------------------
x_list = (-(Sx/2):1:(Sx/2-1)).*pixel_size;% space in um
y_list = (-(Sy/2):1:(Sy/2-1)).*pixel_size;
[XX YY] = meshgrid(x_list, y_list);

% 
z = (1:5:96);%20 slices
Rz = 0:7.3:226.3;
delta_psf = zeros(Sx,Sy,length(z));
average_psf = zeros(Sx,Sy,length(z));
psf_00 = zeros(Sx,Sy,length(z));

%--------------------------------------------------------------------------
% create the simulated I0 and I1
for zz = 1:length(z)
    Z = z(zz);
    
    psf_1 = 1./Z.^2.* exp(-4*log(2).* (XX.^2+YY.^2)./(Z.^2.*t1.^2));
    psf_1 = psf_1./max(max(psf_1));
    psf_0 = 1./Z.^2.* exp(-4*log(2).* (XX.^2+YY.^2)./(Z.^2.*t0.^2));
    psf_0 = psf_0./max(max(psf_0));
    alpha = sum(psf_0(:))./sum(psf_1(:))
    delta_psf(:,:,zz) = psf_0-alpha.*psf_1;
    %save
    average_psf(:,:,zz) = (psf_0+alpha.*psf_1)./2;
    psf_00(:,:,zz) = psf_0;
    psf_11(:,:,zz) = psf_1;
end
mesh(average_psf(:,:,3));colorbar

%%
%calculate M for simulate I
close all
MM = (-(Sx/2):1:(Sx/2-1))/Sx/pixel_size; % frequency.
NN = (-(Sy/2):1:(Sy/2-1))/Sy/pixel_size; % frequency.
[fx, fy] = meshgrid(MM, NN);
Cx = fftshift(fx);
Cy = fftshift(fy);
f_s = Cy.^2 + Cx.^2; % spacial frequency square
% sigma =27; %adjustable factors 1

%--------------------------------------------------------------------------
C = 10.^-2.*max(4.*pi.^2.*f_s(:));%epsilon 
%--------------------------------------------------------------------------

save_nMx = zeros(Sx,Sy,length(z));
save_nMy = zeros(Sx,Sy,length(z));
save_nMe = zeros(Sx,Sy,length(z));
for zz = 1:length(z)
    zz
    delta_I = delta_psf(:,:,zz);
    F_delta_I = fft2(delta_I);% fft of the delta image
%     F_delta_I = fftshift(F_delta_I);% shift the 0 to the center
    F_U = (F_delta_I)./(-4.*pi.^2.*(f_s).*(t1/t0-1)-C);
%     F_U = ifftshift(F_U);%shift back
    U_F = ifft2(F_U);  
    I_total = average_psf(:,:,zz);
    [px,py] = gradient(real(U_F));

    
    M_x = px./(I_total);
    M_y = py./(I_total);
    M_x(isinf(M_x))= 0 ;
    M_y(isinf(M_y))= 0 ;
%----------------------------------------------------------------------
    Me = sqrt(M_x.^2 +M_y.^2);
%----------------------------------------------------------------------
    save_nMx(:,:,zz) = M_x;
    save_nMy(:,:,zz) = M_y;
    save_nMe(:,:,zz) = Me; 
end





%%
% constructe the light field of the simulated I
u = -40; %assumption angle for u,v
v = -40;
du = 8;
dv = 8;
u_vector=u:du:abs(u);
v_vector=v:dv:abs(v);
u_slices=length(u_vector);
v_slices=length(v_vector);

R_E_psf = zeros(Sx,Sy,length(Rz),length(z)); 

for zz = 1:length(z)
    zz
    simulate_LF = zeros(Sx,Sy,u_slices,v_slices);
    for i = 1:u_slices
        U = u_vector(i);
        for j = 1:v_slices 
            V = v_vector(j);
                simulate_LF(:,:,i,j) =average_psf(:,:,zz).*exp(-2.*(U-save_nMx(:,:,zz)).^2 ./sigma.^2 - 2.*(V-save_nMy(:,:,zz)).^2 ./sigma.^2);
              
                simulate_LF(:,:,i,j) = simulate_LF(:,:,i,j)./ max(max(simulate_LF(:,:,i,j)));
        end 
    end


%--------------------------------------------------------------------------
%refocus these stuff
    [Rx,Ry,Ru,Rv] = size(simulate_LF);
    E_psf= zeros(Rx,Ry,length(Rz));

    for zzz = 1: length(Rz)
        Z = Rz(zzz);
        %----------------------------------------------------------------------
        %centriod shift 
        sigmaO = 3; % adjustable parameter
        h =sigma./t0;
        shift_unit = (Z.^2 + sigmaO.^2./t0.^2)./(Z.^2 + 2.*log(2).*h.^2 + sigmaO.^2./t0.^2);
        %----------------------------------------------------------------------

        L_sum = 0;
        for u = 1:Ru
            U = u_vector(u);
            for v = 1:Rv
                V = v_vector(v);
                xp_list = XX +U.*shift_unit;
                yp_list = YY +V.*shift_unit;
                LI = interp2(XX,YY,simulate_LF(:,:,u,v),xp_list,yp_list,'linear',0);
                L_sum = L_sum + LI;
            end
        end
    EE =  L_sum./(Ru.*Rv);
    E_psf(:,:,zzz) = EE;
    
    end
    R_E_psf(:,:,:,zz) = E_psf;
end
save('R_E_psf','R_E_psf')
print('done')