function run_demobird_image (base_dir)
close all; dbstop error; clc;
disp('======= KITTI Demo =======');
%����tracking Ŀǰûɶ���ã�Ч�����ã�·�غ�Ŀ�����һ���ˣ��ֱ���̫�͡������ȶԵ��ƾ��࣬��ͶӰ�����ͼ��
% options (modify this to select your sequence)
base_dir  = 'D:/Raw_data/2011_09_26/2011_09_26_drive_0001_sync';
frame     = 70; % 0-based index ѡȡ��0֡ 

% load velodyne points�������ͼ
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');%���Զ����Ʒ�ʽ��
velo = fread(fid,[4 inf],'single')';%���ļ���ȡΪsingle��ʽ��ά��Ϊ(n,4)
%velo = velo(1:5:end,:); % remove every 5th point for display speedÿ�����ֻȡһ���㣬Ϊ�˷�����ʾ�������ʾ�ٶ�
fclose(fid);
idx=find(velo(:,1)>50|velo(:,1)<0|velo(:,2)>20|velo(:,2)<-20|velo(:,3)<-3|velo(:,3)>3);%ȥ��ǰ50m�⣬������40m��ĵ�,�Լ����߻���͵ĵ�
velo(idx,:)=[];
min1=min(velo(:,1));
min2=min(velo(:,2));

subplot(1,2,1);scatter3(velo(:,1),velo(:,2),velo(:,3),'.');
%ӳ�䵽���ͼƽ�棬�Ŵ��屶
velo(:,1)=4*(round(velo(:,1)-min1))+1;
velo(:,2)=4*(round(velo(:,2)-min2))+1;


X=max(velo(:,1));
Y=max(velo(:,2));

%��ɢ��ͼ����ͼ����
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
           dis=img_scale(20); %����5�ռ�
           num=0;
           while img_depth(i,j)==0 && num<size(dis,1)
           num=num+1;    
          %��Ԫ�أ�����5�ռ䣬��num��
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