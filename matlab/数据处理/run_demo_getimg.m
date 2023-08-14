function run_demo_getimg(base_dir)

close all; dbstop error; clc;

% options (modify this to select your sequence)
if nargin<1            %输入变量个数为0
 % base_dir  = '/mn/karlsruhe_dataset/2011_09_26/2011_09_26_drive_0009_sync';
 base_dir  = 'D:/Raw_data/2011_09_26/2011_09_26_drive_0001_sync';
end

cam       = 2; % 0-based index 选取2号相机（彩色）
frame     = 70; % 0-based index 选取第0帧 


% load and display image导入并显示相机图片
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
%读入图片示例D:/Raw_data/2011_09_26/2011_09_26_drive_0001_sync/image_02/data/0000000000.png
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img); 
