% function run_demoVelodyne (base_dir,calib_dir)
% KITTI RAW DATA DEVELOPMENT KIT
% 原始数据-点云投影到像平面 
% 
%Demonstrates projection of the velodyne points into the image plane
%
% Input arguments:
% base_dir .... absolute path to sequence base directory (ends with _sync)
% calib_dir ... absolute path to directory that contains calibration files

% clear and close everything
close all; dbstop error; clc;
disp('======= KITTI DevKit Demo =======');

% options (modify this to select your sequence)
% if nargin<1
  base_dir  = 'H:/刘对虹/Raw_data/2011_09_26/2011_09_26_drive_0005_sync';
% end
% if nargin<2
  calib_dir = 'H:/刘对虹/Raw_data/2011_09_26';
% end
cam       = 2; % 0-based index
frame     = 0; % 0-based index

% load calibration
calib = loadCalibrationCamToCam(fullfile(calib_dir,'calib_cam_to_cam.txt'));
Tr_velo_to_cam = loadCalibrationRigid(fullfile(calib_dir,'calib_velo_to_cam.txt'));

% compute projection matrix velodyne->image plane
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1};
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;

% load and display image
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img); hold on;

% load velodyne points
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');
velo = fread(fid,[4 inf],'single')';
%velo = velo(1:5:end,:); % remove every 5th point for display speed
velo = velo(:,:);
fclose(fid);

% remove all points behind image plane (approximation
idx = velo(:,1)<5;
velo(idx,:) = [];

% project to image plane (exclude luminance)
velo_img = project(velo(:,1:3),P_velo_to_img);

% plot points
% cols = jet;
% for i=1:size(velo_img,1)
%   col_idx = round(64*5/velo(i,1));
%   plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
% end
%深度图初始化
[m,n,~]=size(img);
depth_img=zeros(m,n);

for i=1:size(velo_img,1)
    u=floor(velo_img(i,2));
    v=floor(velo_img(i,1));
    if u>0 && u<=m && v>0 && v<=n && (depth_img(u,v)==0 || velo(i,1)<depth_img(u,v))
        depth_img(u,v)=velo(i,1);
    end
end
%%显示稀疏深度图
figure;imshow(depth_img);
%%已知深度点
[idx_u,idx_v]=find(depth_img~=0);
[idx_uo,idx_vo]=find(depth_img==0);
P=[];
for i=1:size(idx_u)
    P=[P;depth_img(idx_u(i),idx_v(i))];
end

DT = delaunayTriangulation([idx_u,idx_v]);
Pq=[idx_uo,idx_vo];
vi = nearestNeighbor(DT,Pq);
Vq = P(vi);
for i=1:size(Pq,1)
    depth_img(Pq(i,1),Pq(i,2))=Vq(i);
end
figure;imshow(depth_img,[]);