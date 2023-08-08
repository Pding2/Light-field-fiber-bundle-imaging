function [F_R, F_B] = dummy_filter(vq_R,vq_B)
%--------------------------------------------------------------------------
%for thresholding the beads cling to the surface
%%
a = vq_R;
b = vq_B;

J_R = adaptthresh(a,'neigh',[5 5],'Statistic','median');
BW_R = imbinarize(a,J_R);
figure(1);imshow(a*70)
a(BW_R) = NaN;
figure(2); imshow(a*10,[])

% F_R = fillmissing(a,'linear',1,'EndValues','nearest');
F_R = inpaint_nans(a,0);

figure(3); imshow(F_R*70)



%--------------------------------------------------------------------------
J_B = adaptthresh(b,'neigh',[5 5],'Statistic','median');
BW_B= imbinarize(b,J_B);
figure(4);imshow(b*70)
b(BW_B) = NaN;
figure(5); imshow(b*10,[])

% F_B = fillmissing(b,'linear',1,'EndValues','nearest');
F_B = inpaint_nans(b,0);

figure(6); imshow(F_B*70)
