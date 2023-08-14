%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='E:/数据集/kitti/training/image_2/';
basevelo_address='E:/数据集/kitti/training/velodyne/';
basecalib_address='E:/数据集/kitti/training/calib/';
output_address='D:\毕设\插值\my\';
number='000007';
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];
Outputphoto_address=[output_address number Type3];
%读取并画出图片
img = imread(Truephoto_address);
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);


%读取点云数据
fid = fopen(Truevelo_address,'rb');
velo = fread(fid,[4 inf],'single')';
%velo = velo(1:5:end,:); % 每隔5个点取一个点（每隔5行取一行）,相当于抽样，加快运行速度
fclose(fid);




%去除深度小于5m的点
idx = velo(:,1)<=5;
velo(idx,:) = [];
step=[2,2];
window=[15,31];
t_y=floor(window(2)/2);t_x=floor(window(1)/2);
img_pad = padarray(img,[t_x,t_y]);
imshow(img_pad); hold on;
%栅格法去除地面点；
%  velo=ShanGe_CutGround(velo,0.2);
%RANSAC法去除地面点；
% velo=RANSAC_CutGround(velo);

%velo=ransac_fx(velo(:,1:4));%这个方法也实现了，但是效果不好


%地面分割

maxDistance = 0.3; % in meters
referenceVector = [0, 0, 1];
pc = pointCloud(velo(:,1:3));
[mode, inPlanePointIndices, outliers] = pcfitplane(pc, maxDistance, referenceVector);

pcWithoutGround = select(pc, outliers);
velo=velo(outliers,:);


%计算用于将激光点云数据转换到2D图像上的矩阵
T = loadCalibrationTrAndR0AndP2(Truecalib_address);

%得到激光点云数据转换到图像平面的矩阵
velo_img = project(velo(:,1:3),T);

cols = jet;
for i=1:size(velo_img,1)
  col_idx = round(256*5/velo(i,1));%256是根据jet的列长来定的
  plot(velo_img(i,1),velo_img(i,2),'.','LineWidth',4,'MarkerSize',10,'Color',cols(col_idx,:));
 
end
%仅保留在图像区域的点
x=velo_img(:,1);idx=x<0|x>size(img,2);velo_img(idx,:)=[];velo(idx,:)=[];
y=velo_img(:,2);idx=y<0|y>size(img,1);velo_img(idx,:)=[];velo(idx,:)=[];

velo_img(:,1)=velo_img(:,1)+t_y;%长边方向
velo_img(:,2)=velo_img(:,2)+t_x;

%画出激光点云中的点对应于2D图像上的位置
cols = jet;
for i=1:size(velo_img,1)
  col_idx = round(256*5/velo(i,1));%256是根据jet的列长来定的
  plot(velo_img(i,1),velo_img(i,2),'.','LineWidth',4,'MarkerSize',10,'Color',cols(col_idx,:));
 
end
[h,w,c]=size(img_pad);%h=375,w=3726

x=floor((h-window(1))/step(1));%总数是x+1个个，后面从0开始正好
y=floor((w-window(2))/step(2));
img_my=ones(x+1,y+1)*(-0);
img_my_duibi=ones(x+1,y+1)*(-0);
count=[];
count_duibi=[];
for i=0:x
    for j=0:y
        A=get_my(velo_img,[i*step(1),(i)*step(1)+window(1),j*step(2),(j)*step(2)+window(2)]);
        if isempty(A)
        else
            B=velo(A,1);
            %img_my(i+1,j+1)=(var(B)+std(A));
            img_my(i+1,j+1)=log(1+(var(B)+std(A)));
%             img_my_duibi(i+1,j+1)=max(B)-min(B);
            if(size(A,1)>0)
                 count=[count;img_my(i+1,j+1)];
%                  count_duibi=[count_duibi;img_my_duibi(i+1,j+1)];
            end
        end
    end
end


% imshow(img_my_duibi,[])
%% 方差图反转  相乘

max=max(count);
min=min(count);
[col,row]=find(img_my>0);
max_exp=1;min_exp=0;
img_my1=img_my;
k=(max_exp-min_exp)/(min-max);b=max_exp-k*min;
for mm=1:size(col,1)
    img_my(col(mm),row(mm))=k*img_my(col(mm),row(mm))+b;
end


img_my2=img_my1.*img_my;
img_my3=imresize(img_my2, step(1),'nearest');

[h,w,c]=size(img);%h=375,w=3726
img_write=ones(h,w);
img_write=img_my3(1:h,1:w)+0.2;
figure(7);
imshow(img_write);
image=im2double(imread('E:/数据集/data_road/training/image_2/um_000015.png'));
a1=image;
a1(:,:,2:3)=0;
figure(8);imshow(a1);mask_a1=a1;
mask_a1(:,:,1)=img_write.*mask_a1(:,:,1);figure(9);imshow(mask_a1,[]);

