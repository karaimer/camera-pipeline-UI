close all
clear all

% r1 = importdata('C:\Users\hakki\Downloads\camera-pipeline-UI-master\camera-pipeline-UI-master\image\r.txt');
% g1 = importdata('C:\Users\hakki\Downloads\camera-pipeline-UI-master\camera-pipeline-UI-master\image\g.txt');
% b1 = importdata('C:\Users\hakki\Downloads\camera-pipeline-UI-master\camera-pipeline-UI-master\image\b.txt');
% [m,n] = size(r1); 
% image1 = zeros(m,n,3);
% image1(:,:,1) = r1;
% image1(:,:,2) = g1;
% image1(:,:,3) = b1;

% save image as binary file 
% fd = fopen('x.txt','w');
%     fwrite(fd,image1(:,:,1)','double');
%     fclose(fd);
%     
% fd2 = fopen('y.txt','w');
%     fwrite(fd2,image1(:,:,2)','double');
%     fclose(fd2);
% fd3 = fopen('z.txt','w');
%     fwrite(fd3,image1(:,:,3)','double');
%     fclose(fd3);
    
% image = im2double(image)/65536;
% figure, imshow(image1)

    fd1 = fopen('r.txt','r');
    fd2 = fopen('g.txt','r');
    fd3 = fopen('b.txt','r');
    r = fread(fd1,[ 3008 2000], 'double');
    fclose(fd1);
    g = fread(fd2,[ 3008 2000], 'double');
    fclose(fd2);
    b = fread(fd3,[ 3008 2000], 'double');
    fclose(fd3);
    
    
    
image = zeros(2000, 3008, 3);
image(:,:,1) = r';
image(:,:,2) = g';
image(:,:,3) = b';
image = im2double(image);
figure, imshow(image)

%% proof that txt files and stage 4 size is not equal.
% prophoto2 = im2double(imread('..\current_result.tif'));
%center aligned
eucliudian_error1 = sqrt((image(:,:,1)-...
    image1(:,:,1)).^2 + ...
    (image(:,:,2)-...
    image1(:,:,2)).^2 + ...
    (image(:,:,3)-...
    image1(:,:,3)).^2);
sum(eucliudian_error1(:))
figure,
imagesc(eucliudian_error1, [0 0.01]);

% abs()
