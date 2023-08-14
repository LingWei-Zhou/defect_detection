function run_demo_getimg(base_dir)

close all; dbstop error; clc;

% options (modify this to select your sequence)
if nargin<1            %�����������Ϊ0
 % base_dir  = '/mn/karlsruhe_dataset/2011_09_26/2011_09_26_drive_0009_sync';
 base_dir  = 'D:/Raw_data/2011_09_26/2011_09_26_drive_0001_sync';
end

cam       = 2; % 0-based index ѡȡ2���������ɫ��
frame     = 70; % 0-based index ѡȡ��0֡ 


% load and display image���벢��ʾ���ͼƬ
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
%����ͼƬʾ��D:/Raw_data/2011_09_26/2011_09_26_drive_0001_sync/image_02/data/0000000000.png
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img); 
