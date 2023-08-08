function W = Build_W(R_E_psf,ws)
% Last modification:2/16/2023
% create the transformation matrix for deconvolution
%--------------------------------------------------------------------------
block = zeros(ws,ws,32);% 17*17 subblock
[Bx,By,Bz] = size(block); %size of the subblock
[px,py,pRz,Pz] = size(R_E_psf);

shift_row_block = 0:1:ws-1;% for blockii, I need -55~-38 shift for block 1
shift_col_block = 0:1:ws-1;
c_row = floor(px/2+1);
c_col = floor(py/2+1);
for Z = 1: Pz
    psfz1 = R_E_psf(:,:,:,Z);% for Z =1;
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    psf_iz = zeros(ws,ws,pRz);
 
    for b = 1:ws % this is for the shift of the psf
        shift_col = shift_col_block(b);
        for a = 1:ws
            shift_row = shift_row_block(a);
    %----------------------------------------------------------------------
            psf_iz = psfz1(c_row - shift_row:c_row+ws-1 - shift_row,c_col - shift_col:c_col+ws-1 - shift_col,:); %center at [56 56] for the first block, it is 1 to17need to vary later 
            
     %---------------------------------------------------------------------
     % IMPORTANT!!!!here
                W_col = reshape(psf_iz,Bx*By*pRz,1);% this is the first col of W, need to be varied later
                row_N = (Z-1).*Bx.*By+(b-1).*Bx +a %row number
                W(:,row_N) = W_col;
        end
    end
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end

end