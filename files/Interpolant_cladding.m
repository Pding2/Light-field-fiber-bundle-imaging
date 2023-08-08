% interpolate the blank cladding between cores
% last modified 2022-08-20
% by Peisheng Ding (peisheng.ding@mpi-halle.mpg.de, peisheng.ding@mail.utoronto.ca)


function [Xq, Yq, vq] = Interpolant_cladding(getX, getY,pppp)

%-----------------------------------sacttered Interpolation----------------------------------
% convert the coordination in raw image into a image
% that is 8 times fewer pixels than raw image
% X = getX./2048.*256; 
% Y = getY./2048.*256;

X = getX./16;
Y = getY./16;

F = scatteredInterpolant(X,Y,double(pppp));%matlab scatterInterpalant function
F.Method = 'linear';
F.ExtrapolationMethod = 'nearest';
xg = 20:1:221;% define a range for reconstruction
yg = 20:1:221;

[Yq,Xq] = ndgrid(xg,yg);
vq = double(F(Xq,Yq));
