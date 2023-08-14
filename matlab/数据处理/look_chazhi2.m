%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='E:/数据集/kitti/training/image_2/';
basevelo_address='E:/数据集/kitti/training/velodyne/';
basecalib_address='E:/数据集/kitti/training/calib/';
output_address='D:/毕设/插值/my/';
output_address2='D:/毕设/插值/dt/';
output_address3='D:/毕设/插值/idw/';
output_address4='D:/毕设/插值/nn/';

sum_my=0;
sum_dt=0;
sum_idw=0;
e1=0;
e2=0;
e3=0;
countt=0;

for i=7:7%代表要处理的图片的第一张和最后一张
    
   

number=num2str(i,'%06d');
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];
output=[output_address number Type1];
output2=[output_address2 number Type1];
output3=[output_address3 number Type1];
output4=[output_address4 number Type1];
%

%读取并画出图片
img = imread(Truephoto_address);
% figure;
% imshow(img); hold on;

%读取点云数据
fid = fopen(Truevelo_address,'rb');
velo = fread(fid,[4 inf],'single')';
% velo = velo(1:5:end,:); % 每隔5个点取一个点（每隔5行取一行）,相当于抽样，加快运行速度
fclose(fid);

%去除深度小于0m的点
idx = velo(:,1)<=5;
velo(idx,:) = [];

%计算用于将激光点云数据转换到2D图像上的矩阵

T = loadCalibrationTrAndR0AndP2(Truecalib_address);

%得到激光点云数据转换到图像平面的矩阵
velo_img = project(velo(:,1:3),T);
velo_img=round(velo_img);
%indx= velo_img(:,2)==147;
%tabulate(velo_img(:,indx))
%仅保留在图像区域的点。去掉这之外的点

x=velo_img(:,1);idx= x<=0|x>=size(img,2);velo_img(idx,:)=[];velo(idx,:)=[];
y=velo_img(:,2);idx= y<=0|y>=size(img,1);velo_img(idx,:)=[];velo(idx,:)=[];

%画出激光点云中的点对应于2D图像上的位置
% cols = jet;

img(:,:,4)=ones(size(img,1),size(img,2))*256;%为啥要用256呢，是因为觉得没有采集到的点是远处的点
img(:,:,5)=ones(size(img,1),size(img,2))*256;

velo(:,1)=round(velo(:,1));
velo(:,1)=kuozhan(velo(:,1));
velo(:,4)=round(velo(:,4)*255);%因为反射强度在0-1之间
velo(:,4)=kuozhan2(velo(:,4));
for i=1:size(velo_img,1)
%   col_idx = round(velo(i,4))+1;%256是根                                                                                                                                                                             据jet的列长来定的，+1是为了防止有0造成后面cols(col_idx,:)的错误
 % plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
  %plot函数的坐标原点在左下角
  img(velo_img(i,2),velo_img(i,1),4)=velo(i,1);%是整数
  img(velo_img(i,2),velo_img(i,1),5)=velo(i,4);%是整数
end
%saveas(gcf,'3.jpg')
%data=getframe(gca);
%imwrite(data.cdata,['G:/刘对虹/data/image/training/image_my\',num2str(number,'%d'),'.png']);
channel=4;
[loc_nrow, loc_ncol] = find(img(:,:,channel)~=255);% 不需要插值的点
N_tol = length(loc_nrow); prop = 0.2; N_get = round(N_tol*prop);
idx = randperm(N_tol); %随机产生范围为n_tol的数n_tol个
loc_new_row = loc_nrow(idx);loc_new_col = loc_ncol(idx);
gloc_new_row = loc_new_row(1:N_get);gloc_new_col = loc_new_col(1:N_get);

[img_sizex,img_sizey]=size(img(:,:,4));
bx=7;by=7;
%把边界去掉,因为这些地方的有可能没有插值到

x=gloc_new_row;idxel= find((x<=bx|x>=img_sizex-bx)); gloc_new_row(idxel)=[];gloc_new_col(idxel)=[];
y=gloc_new_col;idxel= find((y<=by|y>=img_sizey-by)); gloc_new_col(idxel)=[];gloc_new_row(idxel)=[];
N_get=length(gloc_new_row);



img_g = img(:,:,channel);



for i=1:N_get
    img_g(gloc_new_row(i), gloc_new_col(i)) = 255;
end




%插值

img_tmp = interp_fx_nobound(img_g, [-7,7], [-7, 7]);%边界也是使用的中值法  interp_fx边界使用的是插值法
tmp_velo_img = [loc_new_row(N_get+1:N_tol),loc_new_col(N_get+1:N_tol)];
%最邻近插值
img_tmp2=255*ones(size(img(:,:,channel)));
img_tmp2=dtinterp_fx(img_g);
%反距离加权插值
img_tmp3=IDW(img_g);

%显示
figure
imagesc(img_tmp);
colormap(gray);
figure
imagesc(img_tmp2);
colormap(gray);
figure
imagesc(img_tmp3);
colormap(gray);

for i=1:N_get
   eval1(i)=img_tmp(gloc_new_row(i), gloc_new_col(i));%自己的
   eval2(i)=img_tmp2(gloc_new_row(i), gloc_new_col(i));%dt插值
   eval3(i)=img_tmp3(gloc_new_row(i), gloc_new_col(i));%idw插值
   groundt(i)=img(gloc_new_row(i), gloc_new_col(i),channel);
end

t1=eval1 - groundt;
t2=eval2 - groundt;
t_t=1;
%画出激光点云中的点对应于2D图像上的位置
figure
cols = jet;
lashen=5;
for i=1:N_get
    if t1(1,i)<=t_t
        continue;
    end
  col_idx = round(256*t_t/t1(1,i));%256是根据jet的列长来定的
  if col_idx>255
      col_idx=255;
  end
  plot(gloc_new_col(i),gloc_new_row(i),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
end


%读取并画出图片
figure;img = imread(Truephoto_address);
imshow(img); hold on;
%画出激光点云中的点对应于2D图像上的位置

cols = jet;
for i=1:N_get
    if t2(1,i)<=t_t
        continue;
    end
  col_idx = round(256*t_t/t2(1,i));%256是根据jet的列长来定的
  if col_idx>255
      col_idx=255;
  end
  plot(gloc_new_col(i),gloc_new_row(i),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
end


t3=eval3 - groundt;
%读取并画出图片
figure;img = imread(Truephoto_address);
imshow(img); hold on;
%画出激光点云中的点对应于2D图像上的位置
cols = jet;
for i=1:N_get
    if t3(1,i)<=t_t
        continue;
    end
    if col_idx>255
      col_idx=255;
    end
  col_idx = round(256*t_t/t3(1,i));%256是根据jet的列长来定的
  plot(gloc_new_col(i),gloc_new_row(i),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
end

end
