clc
clear
close all

%% read image
img = imread('coins.png');

%% add speckle noise
img_n = imnoise(img,'speckle',0.2);

%% show noisy image
imshow(img_n); title('image with speckle noise')

img_n_double = double(img_n);
img_n_log = log10(img_n_double);

%% create Haar basis functions
[lod,hid,lor,hir] = wfilters('haar');

%% wavelet transformation on building image for 4 levels
% level 1
[bA1,bH1,bV1,bD1] = dwt2(img_n_log,lod,hid);
% level 2
[bA2,bH2,bV2,bD2] = dwt2(bA1,lod,hid);
% level 3
[bA3,bH3,bV3,bD3] = dwt2(bA2,lod,hid);
% level 4
[bA4,bH4,bV4,bD4] = dwt2(bA3,lod,hid);

%% for level 4
M_1 = size(bD1,1) * size(bD1,2);

sigma_nD_1 = median(reshape(bD1,1,M_1)) / 0.6745;

T_1 = (1/log(1+1)) * sigma_nD_1 * sqrt(2 * log10(M_1));

sigma_fD_1 = sqrt(sum(sum(bD1 .^ 2)) / M_1);

sigma_gD_1 = sqrt(max(((sigma_fD_1 ^ 2) - (sigma_nD_1 ^ 2)),0));

for i = size(bD1,1)
    for j = size(bD1,2)
        if bD1(i,j) <= T_1
            gD1(i,j) = 0;
        else
        gD1(i,j) = sign(bD1(i,j)) * ...
            max(abs(bD1(i,j)) - (sigma_nD_1^2 ...
            +sqrt(sigma_nD_1^4 + 2 * sigma_nD_1^2 * sigma_gD_1^2)),0);
        end
    end
end

% bH4
sigma_nH_1 = median(reshape(bH1,1,M_1)) / 0.6745;

T_1 = (1/log(1+1)) * sigma_nH_1 * sqrt(2 * log10(M_1));

sigma_fH_1 = sqrt(sum(sum(bH4 .^ 2)) / M_1);

sigma_gH_1 = sqrt(max(((sigma_fH_1 ^ 2) - (sigma_nH_1 ^ 2)),0));

for i = size(bH1,1)
    for j = size(bH1,2)
        if bH1(i,j) <= T_1
            gH1(i,j) = 0;
        else
        gH1(i,j) = sign(bH1(i,j)) * ...
            max(abs(bH1(i,j)) - (sigma_nH_1^2 ...
            +sqrt(sigma_nH_1^4 + 2 * sigma_nH_1^2 * sigma_gH_1^2)),0);
        end
    end
end



