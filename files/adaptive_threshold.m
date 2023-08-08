% An adaptive thresholding by means
% ws is the local window size.
% C is substraction to manupullation
function bw = adaptive_threshold(IM,ws,C)
IM = mat2gray(IM);% convert all to 0 and 1
mean_IM = imfilter(IM,fspecial('average',ws),'replicate');
substract = IM-mean_IM-C;
bw=im2bw(substract,0);
figure(1); imshow(bw); title('adaptive threshold')


