clear;clc;close all;
% 主要目的:分割出地面，并对障碍物聚类
%
%% 
for img_idx = 20:20
    fid = fopen(sprintf('E:/数据集/kitti/training/velodyne/%06d.bin',img_idx),'rb');
    velo = fread(fid,[4 inf],'single');
    velo = velo(:,1:3); % 取前三列x y z
%     a = pointCloud(velo);
    points = (velo);
    a = pointCloud(points);
    pcloud(img_idx-14).ptCloud = a;
    fclose(fid);
end
%% 

%%选择要显示的点云
% 为了突出周围的环境, 车辆, 集中在一个地区的利益, 横跨20米左右的车辆, 40 米的前面和后面的车辆。
pc = pcloud(1).ptCloud;

% 设置感兴趣区域(单位米)
xBound  = 40; 
yBound  = 20; 
xlimits = [-xBound, xBound];
ylimits = [-yBound, yBound];
zlimits = pc.ZLimits;

player = pcplayer(xlimits, ylimits, zlimits);

% 裁剪指定范围内的点云
m=pc.Location;
indices = find(pc.Location(:, 2) >= -yBound ...
             & pc.Location(:,  2) <=  yBound ...
             & pc.Location(:,  1) >= -xBound ...
             & pc.Location(:,  1) <=  xBound);


% 将裁剪到的点显示出来
pc = select(pc, indices,'OutputSize','full');
view(player, pc);


%% 分割地平面和附近障碍物
% 找到地面平面并移除地面平面点。使用RANSAC算法检测和匹配地面平面。
% 平面的法线方向应大致沿 Z 轴向上指向。所有 inlier 点必须在地面平面的20厘米以内。

maxDistance = 0.3; % in meters
referenceVector = [0, 0, 1];
[mode, inPlanePointIndices, outliers] = pcfitplane(pc, maxDistance, referenceVector);

%%
% 标出地平面点。
pcGround = select(pc, inPlanePointIndices);

% 选择不属于地平面一部分的点。
pcWithoutGround = select(pc, outliers);

%% 检索半径在20米以内的点, 并将它们标记为障碍物。
sensorLocation   = [0,0,0]; % 将激光雷达传感器放在坐标系的中心
radius           = 40;      % in meters

nearIndices  = findNeighborsInRadius(pcWithoutGround, sensorLocation, radius);    
nearPointIndices = outliers(nearIndices);

% 标记障碍物点
pcObstacle = select(pc,nearPointIndices,'OutputSize','full');

% Cluster the points,ignoring the ground plane points.
distThreshold = 0.5;
[labels,numClusters] = pcsegdist(pcObstacle, distThreshold);

% Add an additional label for the ground plane.
numClusters = numClusters + 1;
labels(inPlanePointIndices) = numClusters;

% %% 将所有标记的点绘制到点云播放器中。使用前面设置的数字颜色标签。
labelColorIndex = labels+1;
labelColorIndex(:)=1;
labelColorIndex(inPlanePointIndices)=0;
pcshow(pc.Location,labelColorIndex)
colormap([hsv(numClusters);[0 0 0]])
title('Point Cloud Clusters')

colormap(player.Axes, [hsv(numClusters);[0 0 0]])
points1 = pc.Location;
view(player, points1, labelColorIndex);
title(player.Axes, 'Segmented Point Cloud');
