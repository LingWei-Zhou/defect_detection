function label_image(base_dir,calib_dir)
if nargin<1
  % base_dir = '/mnt/karlsruhe_dataset/2011_09_26/2011_09_26_drive_0009_sync';
  % base_dir = '/media/data/kitti/2012_raw_data_extract/2011_09_26/2011_09_26_drive_0056';
  base_dir ='D:/Raw_data/2011_09_26/2011_09_26_drive_0005_sync';
end
if nargin<2
  % calib_dir = '/media/data/kitti/2012_raw_data_extract/2011_09_26';
  calib_dir = 'D:/Raw_data/2011_09_26';
end
cam = 2; % 0-based index

% get image sub-directory
image_dir = fullfile(base_dir, sprintf('/image_%02d/data', cam));%fullfile - 从各个部分构建完整文件名

% get number of images for this dataset 
nimages = length(dir(fullfile(image_dir, '*.png')));%dir - 列出文件夹内容

% read calibration for the day读取坐标变换
[veloToCam, K] = loadCalibration(calib_dir);

% read tracklets for the selected sequence
tracklets = readTracklets([base_dir '/tracklet_labels.xml']); % slow version
%tracklets = readTrackletsMex([base_dir '/tracklet_labels.xml']); % fast version

% extract tracklets
% LOCAL OBJECT COORDINATE SYSTEM:
%   x -> facing right
%   y -> facing forward
%   z -> facing up

for it = 1:numel(tracklets)

 % shortcut for tracklet dimensions在标签中提取对应长宽高
  w = tracklets{it}.w;
  h = tracklets{it}.h;
  l = tracklets{it}.l;

  % set bounding box corners约束盒
  corners(it).x = [l/2, l/2, -l/2, -l/2, l/2, l/2, -l/2, -l/2]; % front/back前后
  corners(it).y = [w/2, -w/2, -w/2, w/2, w/2, -w/2, -w/2, w/2]; % left/right左右
  corners(it).z = [0,0,0,0,h,h,h,h]; % 上下
  
  % get translation and orientation
  t{it} = [tracklets{it}.poses(1,:); tracklets{it}.poses(2,:); tracklets{it}.poses(3,:)];
  rz{it} = wrapToPi(tracklets{it}.poses(6,:));
  occlusion{it} = tracklets{it}.poses(8,:);
end

% 3D bounding box faces (indices for corners)
face_idx = [ 1,2,6,5   % front face
             2,3,7,6   % left face
             3,4,8,7   % back face
             4,1,5,8]; % right face

% main loop (start at first image of sequence)
img_idx = 0;
while img_idx<108
      data_r=[];
  % compute bounding boxes for visible tracklets
  for it = 1:numel(tracklets)

    % get relative tracklet frame index (starting at 0 with first appearance; 
    % xml data stores poses relative to the first frame where the tracklet appeared)
    pose_idx = img_idx-tracklets{it}.first_frame+1; % 0-based => 1-based MATLAB index

    % only draw tracklets that are visible in current frame
    if pose_idx<1 || pose_idx>(size(tracklets{it}.poses,2))
      continue;
    end

    % compute 3d object rotation in velodyne coordinates
    % VELODYNE COORDINATE SYSTEM:
    %   x -> facing forward
    %   y -> facing left
    %   z -> facing up
    R = [cos(rz{it}(pose_idx)), -sin(rz{it}(pose_idx)), 0;
         sin(rz{it}(pose_idx)),  cos(rz{it}(pose_idx)), 0;
                             0,                      0, 1];

    % rotate and translate 3D bounding box in velodyne coordinate system
    corners_3D      = R*[corners(it).x;corners(it).y;corners(it).z];
    corners_3D(1,:) = corners_3D(1,:) + t{it}(1,pose_idx);
    corners_3D(2,:) = corners_3D(2,:) + t{it}(2,pose_idx);
    corners_3D(3,:) = corners_3D(3,:) + t{it}(3,pose_idx);
    corners_3D      = (veloToCam{cam+1}*[corners_3D; ones(1,size(corners_3D,2))]);
    
    % generate an orientation vector and compute coordinates in velodyneCS
    orientation_3D      = R*[0.0, 0.7*l; 0.0, 0.0; 0.0, 0.0];
    orientation_3D(1,:) = orientation_3D(1,:) + t{it}(1, pose_idx);
    orientation_3D(2,:) = orientation_3D(2,:) + t{it}(2, pose_idx);
    orientation_3D(3,:) = orientation_3D(3,:) + t{it}(3, pose_idx);
    orientation_3D      = (veloToCam{cam+1}*[orientation_3D; ones(1,size(orientation_3D,2))]);
    
    % only draw 3D bounding box for objects in front of the image plane
    if any(corners_3D(3,:)<0.5) || any(orientation_3D(3,:)<0.5) 
      continue;
    end

    % project the 3D bounding box into the image plane将三维约束盒投影到二维像平面
    corners_2D     = projectToImage(corners_3D, K);
    orientation_2D = projectToImage(orientation_3D, K);
    
    % compute and draw the 2D bounding box from the 3D box projection
    % 根据3D约束盒的投影计算并绘制2D约束盒
    box.x1 = min(corners_2D(1,:));
    box.x2 = max(corners_2D(1,:));
    box.y1 = min(corners_2D(2,:));
    box.y2 = max(corners_2D(2,:));
    %zijia待定data_remember(i,:)={[]};
   if box.x1<0
       box.x1=0;
   end
   
   data_r=[data_r;box.x1,box.y1,abs(box.y2-box.y1),abs(box.x2-box.x1)];
   
  end
  img_idx = img_idx+1;  % next frame
  data_remember(img_idx,:)={data_r};
end
save('data.mat','data_remember')
% clean up
% close all;





