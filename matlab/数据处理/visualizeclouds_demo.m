%***************��ȡ��ɫ���ƣ����ƾ���(����ŷ�Ͼ���ķ��ࣩ**************
clear;close all; dbstop error; clc;
%% ��ʼ��
%������ͼ��·��
base_dir  = 'E:/���ݼ�/kitti/training/image_2';
%����任����·��
fid = 'E:/���ݼ�/kitti/training';

calib_path_tmpl = [calib_dir  '/calib/' '%06d.txt'];

cam = 2; % ��2������ͷ
frame = 7; % ��0֡(��һ��ͼƬ)

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
 
%������Ƶ�ͼ��ƽ���ͶӰ����
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1}; % R_rect��������תʹͼ��ƽ�湲��
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;% ������� P_rect���������ͶӰ����

%% ��ȡͼ����ʾ
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));%ͼ��img
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);

%% ��ȡ����
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');%���Զ����Ʒ�ʽ��
velo = fread(fid,[4 inf],'single')';%����velo
%velo = velo(1:5:end,:); %������ʾЧ��
fclose(fid);
 
%ɾ��ͼ��ƽ���������е�
idx = velo(:,1)<5;
velo(idx,:) = [];

id=find(velo(:,1)>50|velo(:,2)>20|velo(:,2)<-20|velo(:,3)<-3|velo(:,3)>3);%ֻ��һ���ռ䷶Χ�ڵĵ������ݽ��г����ؽ�
velo(id,:)=[];
 

%% ������ͶӰ��ͼ��ƽ��
%velo_imgΪ������ͼ���ϵ�����
velo_img = project(velo(:,1:3),P_velo_to_img);
 
%ԭͼ��ά��
img_d1 = size(img,1);
img_d2 = size(img,2);
 
%Ԥ�����ڴ�
velo_img_rgb = ones(size(velo_img,1),3) * 255;
 


%% ȡ���ƶ�Ӧ���ص�RGBֵ
for i=1:size(velo_img,1)
    %ȡ�������������ݺ�ͼ�����ݵ�����ͳһ
    y=round(velo_img(i,1));
    x=round(velo_img(i,2));
     
    %�ų���ͼ����ĵ�������
    if x>0 && x<=img_d1 && y>0 && y<=img_d2       
        velo_img_rgb(i,1:3) = img(x,y,1:3);
    end
end
 
%ȡԭ����x,y,z�����Ʋ�ɫɢ��ͼ
velo_xyz = velo(:,1:3);
color_m = colormap(velo_img_rgb./255);


%��ͼ
ptCloud = pointCloud(velo_xyz,'Color',color_m);
subplot(1,2,1);pcshow(ptCloud);
%% ------���ƾ����ͼ��ŷ�Ͼ��룩--------------
maxDistance = 0.3; %�趨��Χ��㵽��ϵ�����Զ����Ϊ0.3m
referenceVector = [0,0,1];%�ο�����Լ��
[~,inliers,outliers] = pcfitplane(ptCloud,maxDistance,referenceVector);%���ƽ��
%���Ե��潫�������飬�����Сŷ����þ���Ϊ0.5m
ptCloudWithoutGround = select(ptCloud,outliers,'OutputSize','full');
distThreshold = 1;
[labels,numClusters] = pcsegdist(ptCloudWithoutGround,distThreshold);
%Ϊ������ӱ�ǩ
numClusters = numClusters+1;
labels(inliers) = numClusters;
%������ɫ��ʾ������������Ϊ��ɫ
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

