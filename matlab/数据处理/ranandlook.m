%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='H:/刘对虹/data/image/training\image_2\';
basevelo_address='H:/刘对虹/data/image/training\velodyne\';
basecalib_address='H:/刘对虹/data/image/training\calib\';
number='000015';
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];

%读取并画出图片
img = imread(Truephoto_address);
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img); hold on;

%读取点云数据
fid = fopen(Truevelo_address,'rb');
velo = fread(fid,[4 inf],'single')';
%velo = velo(1:5:end,:); % 每隔5个点取一个点（每隔5行取一行）,相当于抽样，加快运行速度
fclose(fid);




%去除深度小于5m的点
idx = velo(:,1)<=5;
velo(idx,:) = [];

%栅格法去除地面点；
%  velo=ShanGe_CutGround(velo,0.2);
%RANSAC法去除地面点；
% velo=RANSAC_CutGround(velo);

%velo=ransac_fx(velo(:,1:4));%这个方法也实现了，但是效果不好

%地面分割

% maxDistance = 0.3; % in meters
% referenceVector = [0, 0, 1];
% pc = pointCloud(velo(:,1:3));
% [mode, inPlanePointIndices, outliers] = pcfitplane(pc, maxDistance, referenceVector);
% pcWithoutGround = select(pc, outliers);
% velo=velo(outliers,:);


%计算用于将激光点云数据转换到2D图像上的矩阵
T = loadCalibrationTrAndR0AndP2(Truecalib_address);

%得到激光点云数据转换到图像平面的矩阵
velo_img = project(velo(:,1:3),T);

%仅保留在图像区域的点
x=velo_img(:,1);idx=x<0|x>size(img,2);velo_img(idx,:)=[];velo(idx,:)=[];
y=velo_img(:,2);idx=y<0|y>size(img,1);velo_img(idx,:)=[];velo(idx,:)=[];


%画出激光点云中的点对应于2D图像上的位置
cols = jet;
for i=1:size(velo_img,1)
  col_idx = round(256*5/velo(i,1));%256是根据jet的列长来定的
  plot(velo_img(i,1),velo_img(i,2),'.','LineWidth',4,'MarkerSize',6,'Color',cols(100,:));
 
end