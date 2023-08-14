close all; dbstop error; clc;
disp('======= KITTI DevKit Demo =======');
%% ---------------����������ݣ���ʼ��
load('F:/data.mat');
%�������
img_idx=0;
%ѡ��2�����
cam=2;
%ͼƬ�������Լ�����任����洢λ��
base_dir  = 'F:/Raw_data/data_object/training';
calib_dir = 'F:/Raw_data/data_object/training/calib';
%% ------------����ͶӰ����
%��ȡ������Ϣ
calib = dlmread(sprintf('%s/%06d.txt',calib_dir,img_idx),' ',0,1);
%�ڲξ���
P = calib(cam+1,:);
P = reshape(P ,[4,3])';
%��ת����
R = calib(5,1:9);
R = reshape(R ,[3,3])';
R = [R(1,:),0;R(2,:),0;R(3,:),0;0,0,0,1];
%��ξ���
T = calib(6,:);
T = reshape(T ,[4,3])';
T = [T;0,0,0,1];
%���ͶӰ����
P_velo_to_img =P*R*T;
%% ----------load and display image���벢��ʾ���ͼƬ
img = imread(sprintf('%s/image_2/%06d.png',base_dir,img_idx));
%fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
%imshow(img); hold on;

%% -------------load velodyne points�������ͼ
fid = fopen(sprintf('%s/velodyne/%06d.bin',base_dir,img_idx),'rb');%���Զ����Ʒ�ʽ��
velo = fread(fid,[4 inf],'single')';%���ļ���ȡΪsingle��ʽ��ά��Ϊ(n,4)
%velo = velo(1:5:end,:); % remove every 5th point for display speedÿ�����ֻȡһ���㣬Ϊ�˷�����ʾ�������ʾ�ٶ�
fclose(fid);

%% ------------------ȥ����ƽ��֮������е�
idx = find(velo(:,1)<5|velo(:,1)>50); %�ҵ�x����С��5���״�������
velo(idx,:) = [];%����Щ��ȥ��
velo=velo(:,1:3);
%% ------------------ͶӰ��ͼ��ƽ�棨������������Ϣ��
velo_img = project(velo,P_velo_to_img);
%% ---------------��ɫ����
%ԭͼ��ά��
img_d1 = size(img,1);
img_d2 = size(img,2);
%Ԥ�����ڴ�
velo_img_rgb = ones(size(velo_img,1),3) * 255;
%ȡ���ƶ�Ӧ���ص�RGBֵ
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
%subplot(1,2,1);pcshow(ptCloud);
%% ------------��ȡ��άbounding box��Ӧ�ĵ���
%carΪ2��pedestrainΪ3
carorpedestrain=3;
%carorpedestrain=2;
xy_scale=table2cell(data(img_idx+1,carorpedestrain));
xy_scale=xy_scale{1,1};
id=find(velo_img(:,2)<xy_scale(1,2)+xy_scale(1,4)& velo_img(:,2)>xy_scale(1,2)& velo_img(:,1)<xy_scale(1,1)+xy_scale(1,3)& velo_img(:,1)>xy_scale(1,1));
velo=velo(id,:);
velo_img=velo_img(id,:);
%plot points��ɫ
cols = jet;
for i=1:size(velo_img,1)
    col_idx = round(64*5/velo(i,1));
   % plot(velo_img(i,1),velo_img(i,2),'.','LineWidth',4,'MarkerSize',8,'Color',cols(col_idx,:));
end
%% ------����ȡ�ĵ��ƾ����ͼ��ŷ�Ͼ��룩--------------
ptCloud = pointCloud(velo);
maxDistance = 0.3; %�趨��Χ��㵽��ϵ�����Զ����Ϊ0.3m
referenceVector = [0,0,1];%�ο�����Լ��
[~,inliers,outliers] = pcfitplane(ptCloud,maxDistance,referenceVector);%���ƽ��

%���Ե��潫�������飬�����Сŷ����þ���Ϊ0.5m
ptCloudWithoutGround = select(ptCloud,outliers,'OutputSize','full');
distThreshold = 0.5;
[labels,numClusters] = pcsegdist(ptCloudWithoutGround,distThreshold);

%Ϊ������ӱ�ǩ
numClusters = numClusters+1;
labels(inliers) = numClusters;
%ȥ���������,�������������Ŀ����100�ģ��˵�һЩ�ӵ�ĸ��ţ���Ȼ���Ҿ�����ġ��ۺ϶ȸߵ�
num=tabulate(labels(:));
num=num(1:size(num,1)-1,:);
id0=find(num(:,2)==max(num(:,2)));
number=num(id0,1);
idx=find(labels(:)==number);
velo=velo(idx,:);
ptCloud_data = pointCloud(velo);
%subplot(1,2,2);pcshow(ptCloud_data);
%------------------------
%������ɫ��ʾ������������Ϊ��ɫ
%labelColorIndex = labels+1;
%pcshow(ptCloud.Location,labelColorIndex);
%colormap([hsv(numClusters);[0 0 0]]);
%-------------------------------------
%�������е㣨�����ȣ������������ĵ�����ĿӦ����ĳ��ֵ��
%velo_imgselect = project(velo,P_velo_to_img);
%plot(velo_imgselect(:,1),velo_imgselect(:,2),'y.');
%poly=polyfit(velo(:,2),velo(:,1),1);
%xx=min(velo(:,2)):max(velo(:,2));
%plot(velo(:,1),velo(:,2),'o')
%% ---------------�����ͼ�ϻ���
velo_xy=velo(:,1:2);
num_before=+inf;
for sita=5:5:85
    k_1=tand(sita);
    k_2=-1/k_1;
    %%��ʼ������
    b1=velo_xy(1,2)-k_1*velo_xy(1,1);
    b2=velo_xy(1,2)-k_1*velo_xy(1,1);
    c1=velo_xy(1,2)-k_2*velo_xy(1,1);
    c2=velo_xy(1,2)-k_2*velo_xy(1,1);
    %���Ƴ�����
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
    %�㵽��֮�����ֱ�ߵľ���֮����С
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
%������ֱ�߽��������
xandy_xy(1,1)=(c1-b1)/(k1-k2);xandy_xy(1,2)=k1*xandy_xy(1,1)+b1;
xandy_xy(2,1)=(c2-b1)/(k1-k2);xandy_xy(2,2)=k1*xandy_xy(2,1)+b1;
xandy_xy(3,1)=(c1-b2)/(k1-k2);xandy_xy(3,2)=k1*xandy_xy(3,1)+b2;
xandy_xy(4,1)=(c2-b2)/(k1-k2);xandy_xy(4,2)=k1*xandy_xy(4,1)+b2;
%��ͼ
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
%�ڵ��Ƹ���ͼ�ϻ���
