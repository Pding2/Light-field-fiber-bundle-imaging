function [] = draw_1(Xq_R, Yq_R, vq_R,Xq_B, Yq_B, vq_B)

figure(4);
subplot(2,2,1)
imagesc(vq_R)
title('full')
subplot(2,2,2)
imagesc(vq_B)
title('small')
subplot(2,2,3)
mesh(Xq_R,Yq_R,vq_R)
subplot(2,2,4)
mesh(Xq_B,Yq_B,vq_B)