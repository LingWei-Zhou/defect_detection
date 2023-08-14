close all; dbstop error; clc;
disp('======= KITTI DevKit Demo =======');
%% ---------------加载相关数据，初始化
load('F:/data.mat');
%数据序号
img_idx=0;
%选择2号相机
cam=2;
%图片、点云以及坐标变换矩阵存储位置
base_dir  = 'F:/Raw_data/data_object/training';
calib_dir = 'F:/Raw_data/data_object/training/calib';
%% ------------计算投影矩阵
%读取矫正信息
calib = dlmread(sprintf('%s/%06d.txt',calib_dir,img_idx),' ',0,1);
%内参矩阵
P = calib(cam+1,:);
P = reshape(P ,[4,3])';
%旋转矩阵
R = calib(5,1:9);
R = reshape(R ,[3,3])';
R = [R(1,:),0;R(2,:),0;R(3,:),0;0,0,0,1];
%外参矩阵
T = calib(6,:);
T = reshape(T ,[4,3])';
T = [T;0,0,0,1];
%求得投影矩阵
P_velo_to_img =P*R*T;
%% ----------load and display image导入并显示相机图片
img = imread(sprintf('%s/image_2/%06d.png',base_dir,img_idx));
%fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
%imshow(img); hold on;

%% -------------load velodyne points导入点云图
fid = fopen(sprintf('%s/velodyne/%06d.bin',base_dir,img_idx),'rb');%先以二进制方式打开
velo = fread(fid,[4 inf],'single')';%将文件读取为single格式，维度为(n,4)
%velo = velo(1:5:end,:); % remove every 5th point for display speed每五个点只取一个点，为了方便显示，提高显示速度
fclose(fid);

%% ------------------去掉像平面之后的所有点
idx = find(velo(:,1)<5|velo(:,1)>50); %找到x坐标小于5的雷达点的索引
velo(idx,:) = [];%将这些点去掉
velo=velo(:,1:3);
%% ------------------投影到图像平面（不包含亮度信息）
velo_img = project(velo,P_velo_to_img);
%% ---------------彩色点云
%原图像维数
img_d1 = size(img,1);
img_d2 = size(img,2);
%预分配内存
velo_img_rgb = ones(size(velo_img,1),3) * 255;
%取点云对应像素的RGB值
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
%subplot(1,2,1);pcshow(ptCloud);
%% ------------提取二维bounding box对应的点云
%car为2，pedestrain为3
carorpedestrain=3;
%carorpedestrain=2;
xy_scale=table2cell(data(img_idx+1,carorpedestrain));
xy_scale=xy_scale{1,1};
id=find(velo_img(:,2)<xy_scale(1,2)+xy_scale(1,4)& velo_img(:,2)>xy_scale(1,2)& velo_img(:,1)<xy_scale(1,1)+xy_scale(1,3)& velo_img(:,1)>xy_scale(1,1));
velo=velo(id,:);
velo_img=velo_img(id,:);
%plot points彩色
cols = jet;
for i=1:size(velo_img,1)
    col_idx = round(64*5/velo(i,1));
   % plot(velo_img(i,1),velo_img(i,2),'.','LineWidth',4,'MarkerSize',8,'Color',cols(col_idx,:));
end
%% ------将提取的点云聚类绘图（欧氏距离）--------------
ptCloud = pointCloud(velo);
maxDistance = 0.3; %设定内围层点到拟合地面最远距离为0.3m
referenceVector = [0,0,1];%参考方向约束
[~,inliers,outliers] = pcfitplane(ptCloud,maxDistance,referenceVector);%拟合平面

%忽略地面将其余点分组，组间最小欧几里得距离为0.5m
ptCloudWithoutGround = select(ptCloud,outliers,'OutputSize','full');
distThreshold = 0.5;
[labels,numClusters] = pcsegdist(ptCloudWithoutGround,distThreshold);

%为地面添加标签
numClusters = numClusters+1;
labels(inliers) = numClusters;
%去掉地面类别,先找所在类别数目多于100的（滤掉一些杂点的干扰），然后找距离近的、聚合度高的
num=tabulate(labels(:));
num=num(1:size(num,1)-1,:);
id0=find(num(:,2)==max(num(:,2)));
number=num(id0,1);
idx=find(labels(:)==number);
velo=velo(idx,:);
ptCloud_data = pointCloud(velo);
%subplot(1,2,2);pcshow(ptCloud_data);
%------------------------
%利用颜色显示分类结果，地面为黑色
%labelColorIndex = labels+1;
%pcshow(ptCloud.Location,labelColorIndex);
%colormap([hsv(numClusters);[0 0 0]]);
%-------------------------------------
%搜索所有点（近优先，但该类别物体的点云数目应大于某阈值）
%velo_imgselect = project(velo,P_velo_to_img);
%plot(velo_imgselect(:,1),velo_imgselect(:,2),'y.');
%poly=polyfit(velo(:,2),velo(:,1),1);
%xx=min(velo(:,2)):max(velo(:,2));
%plot(velo(:,1),velo(:,2),'o')
%% ---------------在鸟瞰图上画框
velo_xy=velo(:,1:2);
num_before=+inf;
for sita=5:5:85
    k_1=tand(sita);
    k_2=-1/k_1;
    %%初始化参数
    b1=velo_xy(1,2)-k_1*velo_xy(1,1);
    b2=velo_xy(1,2)-k_1*velo_xy(1,1);
    c1=velo_xy(1,2)-k_2*velo_xy(1,1);
    c2=velo_xy(1,2)-k_2*velo_xy(1,1);
    %限制常数项
    for idx_velo=1:size(velo_xy,1)
        if velo_xy(idx_velo,2)<k_1*velo_xy(idx_velo,1)+b1
            b1=velo_xy(idx_velo,2)-k_1*velo_xy(idx_velo,1);
        end
        if velo_xy(idx_velo,2)>k_1*velo_xy(idx_velo,1)+b2
            b2=velo_xy(idx_velo,2)-k_1*velo_xy(idx_velo,1);
        end
        if velo_xy(idx_velo,2)<k_2*velo_xy(idx_velo,1)+c1
            c1=velo_xy(idx_velo,2)-k_2*velo_xy(idx_velo,1);
        end
        if velo_xy(idx_velo,2)>k_2*velo_xy(idx_velo,1)+c2
            c2=velo_xy(idx_velo,2)-k_2*velo_xy(idx_velo,1);
        end
    end
    %点到与之最近的直线的距离之和最小
    num_distance=0;
    for i_num=1:size(velo_xy,1)
        distance=(k_1*velo(i_num,1)-velo(i_num,2)+b1)^2/(k_1^2+1);
        if distance>(k_1*velo(i_num,1)-velo(i_num,2)+b2)^2/(k_1^2+1)
            distance=(k_1*velo(i_num,1)-velo(i_num,2)+b2)^2/(k_1^2+1);
        end
        if distance>(k_2*velo(i_num,1)-velo(i_num,2)+c1)^2/(k_2^2+1)
            distance=(k_2*velo(i_num,1)-velo(i_num,2)+c1)^2/(k_2^2+1);
        end
        if distance>(k_2*velo(i_num,1)-velo(i_num,2)+c2)^2/(k_2^2+1)
            distance=(k_2*velo(i_num,1)-velo(i_num,2)+c2)^2/(k_2^2+1);
        end
        num_distance=distance+num_distance;
    end
        if num_distance<num_before
            num_before=num_distance;
            num_kb=[k_1,k_2,b1,b2,c1,c2];
        end
end
num_kb(3)=num_kb(3)-0.2;
num_kb(4)=num_kb(4)+0.2;
num_kb(5)=num_kb(5)-0.2;
num_kb(6)=num_kb(6)+0.2;
k1=num_kb(1);
k2=num_kb(2);
b1=num_kb(3);
b2=num_kb(4);
c1=num_kb(5);
c2=num_kb(6);
xandy_xy=ones(4,2);
%求四条直线交点的坐标
xandy_xy(1,1)=(c1-b1)/(k1-k2);xandy_xy(1,2)=k1*xandy_xy(1,1)+b1;
xandy_xy(2,1)=(c2-b1)/(k1-k2);xandy_xy(2,2)=k1*xandy_xy(2,1)+b1;
xandy_xy(3,1)=(c1-b2)/(k1-k2);xandy_xy(3,2)=k1*xandy_xy(3,1)+b2;
xandy_xy(4,1)=(c2-b2)/(k1-k2);xandy_xy(4,2)=k1*xandy_xy(4,1)+b2;
%绘图
plot(velo(:,1),velo(:,2),'o'); 
axis equal;
hold on;
plot(xandy_xy(:,1),xandy_xy(:,2),'*');
hold on;
line([min(xandy_xy(1,1),xandy_xy(2,1)),max(xandy_xy(1,1),xandy_xy(2,1))],...
[num_kb(1)*min(xandy_xy(1,1),xandy_xy(2,1))+num_kb(3),num_kb(1)*max(xandy_xy(1,1),xandy_xy(2,1))+num_kb(3)]);
x=min(xandy_xy(1,1),xandy_xy(2,1)):0.01:max(xandy_xy(1,1),xandy_xy(2,1));
y=num_kb(1)*x+num_kb(3);
plot(x,y,'r-');hold on;
x=min(xandy_xy(3,1),xandy_xy(4,1)):0.01:max(xandy_xy(3,1),xandy_xy(4,1));
y=num_kb(1)*x+num_kb(4);
plot(x,y,'r-');hold on;
x=min(xandy_xy(1,1),xandy_xy(3,1)):0.01:max(xandy_xy(1,1),xandy_xy(3,1));
y=num_kb(2)*x+num_kb(5);
plot(x,y,'r-');hold on;
x=min(xandy_xy(2,1),xandy_xy(4,1)):0.01:max(xandy_xy(2,1),xandy_xy(4,1));
y=num_kb(2)*x+num_kb(6);
plot(x,y,'r-');
h_max=max(velo(:,3))+0.2;
h_min=min(velo(:,3))-0.2;
%plot(min(velo(:,1)):0.1:max(velo(:,1)),(num_kb(1)*min(velo(:,1))+num_kb(3)):0.1:(num_kb(1)*max(velo(:,1))+num_kb(3)),'r-');hold on;
%plot(min(velo(:,1)):0.1:max(velo(:,1)),(num_kb(1)*min(velo(:,1))+num_kb(4)):0.1:(num_kb(1)*max(velo(:,1))+num_kb(4)),'r-');hold on;
%plot(min(velo(:,1)):0.1:max(velo(:,1)),;(num_kb(2)*min(velo(:,1))+num_kb(5)):0.1:(num_kb(2)*max(velo(:,1))+num_kb(5)),'r-');hold on;
%plot(min(velo(:,1)):0.1:max(velo(:,1)),(num_kb(2)*min(velo(:,1))+num_kb(6)):0.1:(num_kb(2)*max(velo(:,1))+num_kb(6)),'r-');
%plot([min(velo,1),k_1*min(velo,1)+b2],[max(velo,1),k_1*max(velo,1)+b2],'r-');hold on;
%plot([min(velo,1),k_2*min(velo,1)+c1],[max(velo,1),k_2*max(velo,1)+c1],'r-');hold on;
%plot([min(velo,1),k_2*min(velo,1)+c2],[max(velo,1),k_2*max(velo,1)+c2],'r-');
%在点云俯视图上画框
