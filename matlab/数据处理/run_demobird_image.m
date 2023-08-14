function run_demobird_image (base_dir)
close all; dbstop error; clc;
disp('======= KITTI Demo =======');
%进度tracking 目前没啥卵用，效果不好，路沿和目标混在一起了，分辨率太低。考虑先对点云聚类，再投影到鸟瞰图。
% options (modify this to select your sequence)
base_dir  = 'D:/Raw_data/2011_09_26/2011_09_26_drive_0001_sync';
frame     = 70; % 0-based index 选取第0帧 

% load velodyne points导入点云图
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');%先以二进制方式打开
velo = fread(fid,[4 inf],'single')';%将文件读取为single格式，维度为(n,4)
%velo = velo(1:5:end,:); % remove every 5th point for display speed每五个点只取一个点，为了方便显示，提高显示速度
fclose(fid);
idx=find(velo(:,1)>50|velo(:,1)<0|velo(:,2)>20|velo(:,2)<-20|velo(:,3)<-3|velo(:,3)>3);%去掉前50m外，后，左右40m外的点,以及过高或过低的点
velo(idx,:)=[];
min1=min(velo(:,1));
min2=min(velo(:,2));

subplot(1,2,1);scatter3(velo(:,1),velo(:,2),velo(:,3),'.');
%映射到鸟瞰图平面，放大五倍
velo(:,1)=4*(round(velo(:,1)-min1))+1;
velo(:,2)=4*(round(velo(:,2)-min2))+1;


X=max(velo(:,1));
Y=max(velo(:,2));

%将散点图归入图像中
XY_plane=[velo(:,1),velo(:,2)];
image=zeros(X,Y);
velo(:,3)=round(-255*(velo(:,3)-max(velo(:,3)))/(max(velo(:,3))-min(velo(:,3))));
for i=1:size(XY_plane(:,1));
    if  image(XY_plane(i,1),XY_plane(i,2))==0
        image(XY_plane(i,1),XY_plane(i,2))=velo(i,3);
    else
        if velo(i,3)>image(XY_plane(i,1),XY_plane(i,2))
        image(XY_plane(i,1),XY_plane(i,2))=velo(i,3);
        end
    end
    
end

%test
img_depth=zeros(X,Y);
for i=1:X
    for j=1:Y
        if image(i,j)~=0
           img_depth(i,j)=image(i,j);
        else
           dis=img_scale(20); %遍历5空间
           num=0;
           while img_depth(i,j)==0 && num<size(dis,1)
           num=num+1;    
          %零元素，遍历5空间，第num行
          %--
          if i-dis(num,1)>0 && j-dis(num,2)>0
            if image(i-dis(num,1),j-dis(num,2))~=0
                img_depth(i,j)=image(i-dis(num,1),j-dis(num,2));
            end
          end
          %-+
          if i-dis(num,1)>0 && j+dis(num,2)<Y
            if image(i-dis(num,1),j+dis(num,2))~=0
                img_depth(i,j)=image(i-dis(num,1),j+dis(num,2));
            end
          end
          %+-
          if i+dis(num,1)<X && j-dis(num,2)>0
            if image(i+dis(num,1),j-dis(num,2))~=0
                img_depth(i,j)=image(i+dis(num,1),j-dis(num,2));
            end
          end
          %++
          if i+dis(num,1)<X && j+dis(num,2)<Y
            if image(i+dis(num,1),j+dis(num,2))~=0
                img_depth(i,j)=image(i+dis(num,1),j+dis(num,2));
            end
          end
           end
        end
    end
end

subplot(1,2,2);imshow(img_depth/255);