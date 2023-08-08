% deconvoluion
% % Last modification:5/20/2022


clear
addpath('files')
load('R_E_psf') % stimulated psf, psf in center, 5D matrix with varied Rz and Z
load('refocused_measure')% refocused stacks of the measured images, with varied Rz
[X,Y,Rz,Z] = size(R_E_psf);
% load('W_matrix')% transformational W
ws = 17;
W = Build_W(R_E_psf,ws);
W(isnan(W))=0;
[m,n] = size(W);

%%
%--------------------------------------------------------------------------
% e.g. for 110*100 image, the finial image will be 96*96
% final_I = zeros(X-14,Y-14,Z);% the matrix for the final deconvolved image stack
final_I = zeros(X,Y,Z);% the matrix for the final deconvolved image stack
resi = zeros(X,Y,Rz);

block_row = (X-14)./3; % sub block along y direction;There are 32 sub blocks in each direction
block_col = (Y-14)./3;



tic;
for sub_col = 1:block_col %
    sub_col
    for sub_row = 1:block_row
    
%--------------------------------------------------------------------------
        %matrix division by lsqnonneg
        A = E_measure(1+(sub_row-1)*3:ws+(sub_row-1)*3,1+(sub_col-1)*3:ws+(sub_col-1)*3,:);
        A_v = reshape(A,ws*ws*32,1);
        [H,resnorm,residual] = lsqnonneg(W,A_v,struct('Display','notify','TolX',10*eps*norm(W,1)*length(W)));
        HM = reshape(H,[ws,ws,20]);
%--------------------------------------------------------------------------
        %discard the solution all, but the cental 3*3 sub_block
        [Hx,Hy,Hz] = size(HM);
        row_3 = 8+(sub_row-1)*3;
        col_3 = 8+(sub_col-1)*3;
        % to write each 3*3 sub block into the final image
        final_I(row_3:row_3+2,col_3:col_3+2,:) = HM(ceil(Hx/2)-1:ceil(Hx/2)+1, ceil(Hx/2)-1:ceil(Hx/2)+1, :);        
    end
end

save('after deconvolution.mat','final_I')
toc;
