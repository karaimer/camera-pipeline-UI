close all
clear all
image = im2double(imread('..\2.tif'));

%% proof that txt files and stage 4 size is not equal.
prophoto2 = im2double(imread('..\3.tif'));
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