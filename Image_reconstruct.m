% convolution and plotting
% Last modification:02/16/2023
%%
addpath('files')

figure(1)
% montage(final_I)
Con_final = imgaussfilt3(final_I,1);

% xz MIP
xzMIP_F = squeeze(max(E_measure,[],1));
figure(2)
subplot(1,2,1);imshow(flip(xzMIP_F,1),[]);xlim([0 15])
xzMIP_J = squeeze(max(final_I,[],1));
% subplot(1,3,2);imshow(xzMIP_J,[])
xzMIP_B = squeeze(max(Con_final,[],1));
subplot(1,2,2);imshow(flip(xzMIP_B,1),[])
WriteTifStack(Con_final,'Con_final Image.tif',32); 
print('use ImageJ to open the Con_final.tif')
% volumeViewer(Con_final)
% sliceViewer(Con_final)
% volshow(Con_final)

