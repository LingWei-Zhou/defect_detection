%***************获取彩色点云，点云聚类(基于欧氏距离的分类）**************
clear;close all; dbstop error; clc;
%% 初始化
%点云与图像路径
base_dir  = 'E:/数据集/kitti/training/image_2';
%坐标变换矩阵路径
fid = 'E:/数据集/kitti/training';

calib_path_tmpl = [calib_dir  '/calib/' '%06d.txt'];

cam = 2; % 第2个摄像头
frame = 7; % 第0帧(第一张图片)

R_rect = zeros(4,4);
T_vc = zeros(4,4);
    
fid = fopen(sprintf(calib_path_tmpl,frame), 'r');
P2 = readVariable(sprintf(calib_path_tmpl,frame),'P2',3,4);
    
R_rect(1:3,1:3) = readVariable(sprintf(calib_path_tmpl,frame),'R0_rect',3,3);
R_rect(4,4) = 1;
    
T_vc(1:3,:) = readVariable(sprintf(calib_path_tmpl,frame),'Tr_velo_to_cam',3,4);
T_vc(4,4) = 1;
    
P_velo_to_img = P2 * R_rect * T_vc;

fclose(fid);
 
%计算点云到图像平面的投影矩阵
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1}; % R_rect：纠正旋转使图像平面共面
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;% 内外参数 P_rect：矫正后的投影矩阵

%% 读取图像并显示
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));%图像img
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);

%% 读取点云
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');%先以二进制方式打开
velo = fread(fid,[4 inf],'single')';%点云velo
%velo = velo(1:5:end,:); %提升显示效率
fclose(fid);
 
%删除图像平面后面的所有点
idx = velo(:,1)<5;
velo(idx,:) = [];

id=find(velo(:,1)>50|velo(:,2)>20|velo(:,2)<-20|velo(:,3)<-3|velo(:,3)>3);%只用一定空间范围内的点云数据进行场景重建
velo(id,:)=[];
 

%% 将点云投影到图像平面
%velo_img为点云在图像上的坐标
velo_img = project(velo(:,1:3),P_velo_to_img);
 
%原图像维数
img_d1 = size(img,1);
img_d2 = size(img,2);
 
%预分配内存
velo_img_rgb = ones(size(velo_img,1),3) * 255;
 


%% 取点云对应像素的RGB值
for i=1:size(velo_img,1)
    %取整，将点云数据和图像数据的坐标统一
    y=round(velo_img(i,1));
    x=round(velo_img(i,2));
     
    %排除在图像外的点云数据
    if x>0 && x<=img_d1 && y>0 && y<=img_d2       
        velo_img_rgb(i,1:3) = img(x,y,1:3);
    end
end
 
%取原点云x,y,z，绘制彩色散点图
velo_xyz = velo(:,1:3);
color_m = colormap(velo_img_rgb./255);


%绘图
ptCloud = pointCloud(velo_xyz,'Color',color_m);
subplot(1,2,1);pcshow(ptCloud);
%% ------点云聚类绘图（欧氏距离）--------------
maxDistance = 0.3; %设定内围层点到拟合地面最远距离为0.3m
referenceVector = [0,0,1];%参考方向约束
[~,inliers,outliers] = pcfitplane(ptCloud,maxDistance,referenceVector);%拟合平面
%忽略地面将其余点分组，组间最小欧几里得距离为0.5m
ptCloudWithoutGround = select(ptCloud,outliers,'OutputSize','full');
distThreshold = 1;
[labels,numClusters] = pcsegdist(ptCloudWithoutGround,distThreshold);
%为地面添加标签
numClusters = numClusters+1;
labels(inliers) = numClusters;
%利用颜色显示分类结果，地面为黑色
labelColorIndex = labels+1;
subplot(1,2,2);pcshow(ptCloud.Location,labelColorIndex);
colormap([hsv(numClusters);[0 0 0]]);

function A = readVariable(fid,name,M,N)
    % rewind
    fseek(fid,0,'bof');

    % search for variable identifier
    success = 1;
    while success>0
      [str,success] = fscanf(fid,'%s',1);
      if strcmp(str,[name ':'])
        break;
      end
    end

    % return if variable identifier not found
    if ~success
      A = [];
      return;
    end

    % fill matrix
    A = zeros(M,N);
    for m=1:M
      for n=1:N
        [val,success] = fscanf(fid,'%f',1);
        if success
          A(m,n) = val;
        else
          A = [];
          return;
        end
      end
    end
end

