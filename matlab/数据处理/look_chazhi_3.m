%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='E:/数据集/data_road/training/image_2/';
basevelo_address='E:/数据集/data_road/training/velodyne/';
basecalib_address='E:/数据集/data_road/training/calib/';

output_address='D:\毕设\插值\my\';
output_address2='D:\毕设\插值\dt\';
output_address3='D:\毕设\插值\idw\';
output_address4='D:\毕设\插值\nn\';



for i=91:91%代表要处理的图片的第一张和最后一张
    


number=num2str(i,'um_%06d');
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];
output=[output_address number Type1];
output2=[output_address2 number Type1];
output3=[output_address3 number Type1];
output4=[output_address4 number Type1];
%读取并画出图片
img = imread(Truephoto_address);
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img); hold on;

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



img(:,:,4)=ones(size(img,1),size(img,2))*256;%为啥要用256呢，是因为觉得没有采集到的点是远处的点
img(:,:,5)=ones(size(img,1),size(img,2))*256;

velo(:,1)=round(velo(:,1));
% velo(:,1)=kuozhan(velo(:,1));
velo(:,4)=round(velo(:,4)*255);%因为反射强度在0-1之间
% velo(:,4)=kuozhan2(velo(:,4));
for i=1:size(velo_img,1)
  col_idx = round(velo(i,4))+1;%256是根                                                                                                                                                                             据jet的列长来定的，+1是为了防止有0造成后面cols(col_idx,:)的错误
 % plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
  %plot函数的坐标原点在左下角
  
  img(velo_img(i,2),velo_img(i,1),4)=velo(i,1);%是整数
  img(velo_img(i,2),velo_img(i,1),5)=velo(i,4);%是整数
end
%saveas(gcf,'3.jpg')
%data=getframe(gca);
%imwrite(data.cdata,['G:/刘对虹/data/image/training/image_my\',num2str(number,'%d'),'.png']);
channel=4;
[loc_nrow, loc_ncol] = find(img(:,:,channel)~=255);
N_tol = length(loc_nrow); prop = 0.2; N_get = round(N_tol*prop);
idx = randperm(N_tol); 
loc_new_row = loc_nrow(idx);loc_new_col = loc_ncol(idx);
gloc_new_row = loc_new_row(1:N_get);gloc_new_col = loc_new_col(1:N_get);

[img_sizex,img_sizey]=size(img(:,:,4));
bx=7;by=7;
%把边界去掉,因为这些地方的有可能没有插值到

    x=gloc_new_row;idxel= find((x<=bx|x>=img_sizex-bx)); gloc_new_row(idxel)=[];gloc_new_col(idxel)=[];
    y=gloc_new_col;idxel= find((y<=by|y>=img_sizey-by)); gloc_new_col(idxel)=[];gloc_new_row(idxel)=[];
    N_get=length(gloc_new_row);



img_g = img(:,:,channel);

% [aa,bb]=find(img_g~=255);


for i=1:N_get
    img_g(gloc_new_row(i), gloc_new_col(i)) = 255;
end





img_tmp = interp_fx_nobound(img_g, [-7,7], [-7, 7]);%边界也是使用的中值法  interp_fx边界使用的是插值法
img_tmp2=255*ones(size(img(:,:,channel)));
img_tmp2=dtinterp_fx(img_g);
% img_tmp3=IDW(img_g);
a=(img_tmp-img_tmp2);
%画出激光点云中的点对应于2D图像上的位置img_tmp2(i,j)
cols = jet;
l_low=size(img_tmp,1);
l_high=size(img_tmp,2);
for i=1:4:l_low
  for j=1:4:l_high
      col_idx =round(256*5/img_tmp2(i,j)); %256是根据jet的列长来定的
      plot(j,i,'p','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
      %这里要注意一下，i,j的顺序
  end
end
cols = jet;







end
