%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='E:/数据集/kitti/training/image_2/';
basevelo_address='E:/数据集/kitti/training/velodyne/';
basecalib_address='E:/数据集/kitti/training/calib/';
output_address='D:\毕设\插值\my\';
number='000007';
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];
Outputphoto_address=[output_address number Type3];
%读取并画出图片
img = imread(Truephoto_address);
% figure(1)
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img);hold on;


%读取点云数据
fid = fopen(Truevelo_address,'rb');
velo = fread(fid,[4 inf],'single')';
%velo = velo(1:5:end,:); % 每隔5个点取一个点（每隔5行取一行）,相当于抽样，加快运行速度
fclose(fid);


%去除深度小于5m的点
idx = velo(:,1)<=5;
velo(idx,:) = [];
% step=[2,2];
% window=[15,31];
% t_y=floor(window(2)/2);t_x=floor(window(1)/2);
% img_pad = padarray(img,[t_x,t_y]);
% imshow(img_pad); hold on;
%栅格法去除地面点；
%  velo=ShanGe_CutGround(velo,0.2);
%RANSAC法去除地面点；

x = velo(:,1);
y = velo(:,2);
z = velo(:,3);
data = pointCloud([x y z]);


velo=RANSAC_CutGround(velo);


x = velo(:,1);
y = velo(:,2);
z = velo(:,3);
data = pointCloud([x y z]);

%velo=ransac_fx(velo(:,1:4));%这个方法也实现了，但是效果不好

T = loadCalibrationTrAndR0AndP2(Truecalib_address);
% 
% %得到激光点云数据转换到图像平面的矩阵
velo_img = project(velo(:,1:3),T);
% 
cols = jet;
for i=1:size(velo_img,1)
    col_idx = round(256*5/velo(i,1));%256是根据jet的列长来定的
    plot(velo_img(i,1),velo_img(i,2),'.','LineWidth',4,'MarkerSize',10,'Color',cols(col_idx,:));
%  
end

%地面分割