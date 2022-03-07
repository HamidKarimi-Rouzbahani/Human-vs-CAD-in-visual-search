clc;
clear all;
close all;

mask_width=500;
mask_height=700;
noise_spatial_freq=-1;% -1 =1/f; -2=1/f^2; ...
noise_intensity=128;

Noise_mask=spatialPattern([mask_width mask_height],noise_spatial_freq);
Noise_mask=uint8(((Noise_mask-(min(min(Noise_mask))))./max(max(Noise_mask))).*noise_intensity);
imshow(Noise_mask)

imwrite(Noise_mask,['Noise_mask.png']);
