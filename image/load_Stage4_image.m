close all
clear all

r = importdata('.\r.txt');
g = importdata('.\g.txt');
b = importdata('.\b.txt');

[m,n] = size(r); 
image = zeros(m,n,3);
image(:,:,1) = r;
image(:,:,2) = g;
image(:,:,3) = b;
% image = im2double(image)/65536;
figure, imshow(image)

%% proof that txt files and stage 4 size is not equal.
prophoto2 = im2double(imread('..\current_result.tif'));
%center aligned
eucliudian_error1 = sqrt((image(:,:,1)-...
    prophoto2(:,:,1)).^2 + ...
    (image(:,:,2)-...
    prophoto2(:,:,2)).^2 + ...
    (image(:,:,3)-...
    prophoto2(:,:,3)).^2);
sum(eucliudian_error1(:))
figure,
imagesc(eucliudian_error1, [0 0.01]);

% abs()