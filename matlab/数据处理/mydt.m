%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='E:/数据集/data_road/training/image_2/';
basevelo_address='E:/数据集/data_road/training/velodyne/';
basecalib_address='E:/数据集/data_road/training/calib/';
output_address='D:\毕设\插值\my\';
output_address2='D:\毕设\插值\dt\';
output_address3='D:\毕设\插值\idw\';

for i=20:20%代表要处理的图片的第一张和最后一张
    
   

number=num2str(i,'um_%06d');
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];
output=[output_address number Type1];
output2=[output_address2 number Type1];
output3=[output_address3 number Type1];

%读取并画出图片
img = imread(Truephoto_address);

%读取点云数据
fid = fopen(Truevelo_address,'rb');
velo = fread(fid,[4 inf],'single')';
% velo = velo(1:5:end,:); % 每隔5个点取一个点（每隔5行取一行）,相当于抽样，加快运行速度
fclose(fid);

%去除深度小于0m的点
idx = velo(:,1)<=0;
velo(idx,:) = [];

%计算用于将激光点云数据转换到2D图像上的矩阵

T = loadCalibrationTrAndR0AndP2(Truecalib_address);

%得到激光点云数据转换到图像平面的矩阵
velo_img = project(velo(:,1:3),T);
velo_img=round(velo_img);%离散的，不稠密的
%indx= velo_img(:,2)==147;
%tabulate(velo_img(:,indx))
%仅保留在图像区域的点。去掉这之外的点

x=velo_img(:,1);idx= x<=0|x>=size(img,2);velo_img(idx,:)=[];velo(idx,:)=[];
y=velo_img(:,2);idx= y<=0|y>=size(img,1);velo_img(idx,:)=[];velo(idx,:)=[];





%画出激光点云中的点对应于2D图像上的位置
cols = jet;

img(:,:,4)=ones(size(img,1),size(img,2))*256;%为啥要用256呢，是因为觉得没有采集到的点是远处的点
img(:,:,5)=ones(size(img,1),size(img,2))*256;

velo(:,1)=round(velo(:,1));
velo(:,1)=kuozhan(velo(:,1));%深度拉伸
velo(:,4)=round(velo(:,4)*255);%因为反射强度在0-1之间
velo(:,4)=kuozhan2(velo(:,4));%强度拉伸





for i=1:size(velo_img,1)
  col_idx = round(velo(i,4))+1;%256是根                                                                                                                                                                             据jet的列长来定的，+1是为了防止有0造成后面cols(col_idx,:)的错误
 % plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
  %plot函数的坐标原点在左下角
  
  img(velo_img(i,2),velo_img(i,1),4)=velo(i,1);%是整数
  img(velo_img(i,2),velo_img(i,1),5)=velo(i,4);%是整数
end


%DT = delaunayTriangulation(velo_img)
img_interp3=dtinterp_fx(img(:,:,4));











%saveas(gcf,'3.jpg')
%data=getframe(gca);
%imwrite(data.cdata,['G:/刘对虹/data/image/training/image_my\',num2str(number,'%d'),'.png']);


figure;imshow(img_interp3);

%imwrite(img_interp3,output3);
%close all;
end
%无法保存4通道图像