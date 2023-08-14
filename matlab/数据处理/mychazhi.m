%加权中值插值

clear;clc;
basephoto_address='E:/数据集/kitti/training/image_2/';
basevelo_address='E:/数据集/kitti/training/velodyne/';
basecalib_address='E:/数据集/kitti/training/calib/';

output_address='D:\毕设\插值\my\';
output_address2='D:\毕设\插值\dt\';

for i=7:7%代表要处理的图片的第一张和最后一张
    
   

number=num2str(i,'%06d');
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];
output=[output_address number Type1];
output2=[output_address2 number Type1];

%读取并画出图片
img = imread(Truephoto_address);
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img);
size(img)
hold on;

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
velo_img=round(velo_img);
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
tabulate(velo(:,1));
velo(:,4)=round(velo(:,4)*255);
tabulate(velo(:,4))
velo(:,1)=kuozhan(velo(:,1));
velo(:,4)=kuozhan2(velo(:,4));
for i=1:size(velo_img,1)
  col_idx = round(velo(i,4))+1;%256是根                                                                                                                                                                             据jet的列长来定的，+1是为了防止有0造成后面cols(col_idx,:)的错误
  plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
  %plot函数的坐标原点在左下角
  
  img(velo_img(i,2),velo_img(i,1),4)=velo(i,1);%是整数
  img(velo_img(i,2),velo_img(i,1),5)=velo(i,4);%是整数
end
%saveas(gcf,'3.jpg')
%data=getframe(gca);
%imwrite(data.cdata,['G:/刘对虹/data/image/training/image_my\',num2str(number,'%d'),'.png']);





k8=1;%8邻域的重复
k4=3;%4邻域的重复
img_copy=img(:,:,4);
img_2=img_copy;
x=[-5,5];
y=[-7,7];
for i=-x(1)+1:size(img_2,1)-x(2)
    for j=-y(1)+1:size(img_2,2)-y(2)%图像边界的不进行插值
       
        
        if img_copy(i,j)==255
                a=[];
                count=1;
                for ii=x(1):x(2)
                    for jj=y(1):y(2)
                        if img_2(i+ii,j+jj)~=255
                            a(count)=img_2(i+ii,j+jj);
                            count=count+1;
                            if abs(ii)==1&&abs(jj)==1
                                for p=1:k8%让八领域的影响更大
                                    a(count)=img_2(i+ii,j+jj);
                                    count=count+1;
                                end
                            end
                            
                            if (abs(ii)==1&&abs(jj)==0)||(abs(ii)==0&&abs(jj)==1)
                                for p=1:k4%让四领域的影响更大
                                    a(count)=img_2(i+ii,j+jj);
                                    count=count+1;
                                end
                            end
                            
                        end
                    end
                    
                end
               
            if count-1>0 %减一是因为之前多加了1，大于2要求罢领域至少3个不是空
             img_copy(i,j)=median(a);
            end
        end
            
    end
end

imwrite(img_copy,output);
imwrite(img(:,:,5),output2);
%close all;
end
%无法保存4通道图像