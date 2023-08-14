%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='H:/刘对虹/data/image/training\image_2\';
basevelo_address='H:/刘对虹/data/image/training\velodyne\';
basecalib_address='H:/刘对虹/data/image/training\calib\';
output_address='E:\研究生\毕设\中期\会议-写\插值\my\';
output_address2='E:\研究生\毕设\中期\会议-写\插值\dt\';
output_address3='E:\研究生\毕设\中期\会议-写\插值\idw\';
output_address4='E:\研究生\毕设\中期\会议-写\插值\nn\';

sum_my=0;
sum_dt=0;
sum_idw=0;
e1=0;
e2=0;
e3=0;
countt=0;

for i=206:206%代表要处理的图片的第一张和最后一张
    
   

number=num2str(i,'%06d');
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
velo(:,1)=kuozhan(velo(:,1));
velo(:,4)=round(velo(:,4)*255);%因为反射强度在0-1之间
velo(:,4)=kuozhan2(velo(:,4));
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



% [aaa,bbb]=find(img_g~=255);
%插值
t1=clock;
img_tmp = interp_fx_nobound(img_g, [-7,7], [-7, 7]);%边界也是使用的中值法  interp_fx边界使用的是插值法
t2=clock;
e1=e1+etime(t2,t1);
% [aaaa,bbbb]=find(img_g~=255);
% leng=size(aaaa,1)

tmp_velo_img = [loc_new_row(N_get+1:N_tol),loc_new_col(N_get+1:N_tol)];

img_tmp2=255*ones(size(img(:,:,channel)));
t1=clock;
img_tmp2=dtinterp_fx(img_g);
t2=clock;
e2=e2+etime(t2,t1);
%反距离加权插值
t1=clock;
img_tmp3=IDW(img_g);
t2=clock;
e3=e3+etime(t2,t1);
% imshow(img_g);
% figure;imshow(img_tmp3)
imwrite(img_tmp3,output3);
%{
% evalution
[x,y]=meshgrid(aaaa,bbbb);
%[xi,yi]=meshgrid(gloc_new_row,gloc_new_col);
img_mesh=ones([leng,leng]);
for i=1:leng
    for j=1:leng
        img_mesh(i,j)=img_g(x(i,j),y(i,j));
    end
end
lllen=size(gloc_new_row,1)
for i =1:lllen
    gloc_new_row(i)
    gloc_new_col(i)
    near(i)=interp2(x,y,img_mesh,gloc_new_col(i),gloc_new_row(i),'Nearest');%这里这里
end
%}
for i=1:N_get
   eval1(i)=img_tmp(gloc_new_row(i), gloc_new_col(i));%自己的
   eval2(i)=img_tmp2(gloc_new_row(i), gloc_new_col(i));%dt插值
   eval3(i)=img_tmp3(gloc_new_row(i), gloc_new_col(i));%dt插值
   groundt(i)=img(gloc_new_row(i), gloc_new_col(i),channel);
end
num=size(groundt,2)

tmp_value = norm(double(eval1 - groundt),2);
%tmp = tmp_value/norm(double(groundt),2);%自己的
%tmp = tmp_value/(num*256);%自己的,我觉得应该用这个，因为对于所有的灰度值需要一视同仁，看看在这个256个数的范围内会有多达的误差
tmp =tmp_value/sqrt(num);%还是不应该用256


tmp_value2 = norm(double(eval2 - groundt),2);
%tmp2 = tmp_value2/norm(double(groundt),2);%dt插值
tmp2 = tmp_value2/sqrt(num);%dt插值


tmp_value3 = norm(double(eval3 - groundt),2);
%tmp3 = tmp_value3/norm(double(groundt),2);%IDW
tmp3 = tmp_value3/sqrt(num);%IDW

sum_my=sum_my+tmp;
sum_dt=sum_dt+tmp2;
sum_idw=sum_idw+tmp3;



countt=countt+1

%figure;imshow(img_tmp);figure;imshow(img_tmp2);
%hold on;
% imwrite(img_tmp,output);
% imwrite(img_tmp2,output2);
% imwrite(img_tmp3,output3);
% imwrite(img_g,output4);
%close all;
end
sum_my=sum_my/countt;
sum_dt=sum_dt/countt;
sum_idw=sum_idw/countt;%误差
e_my=e1/countt;%时间  my
e_dt=e2/countt;%dt
e_idw=e3/countt;%idw
% tmp11 = tmp11/countt%计算均方根误差
% tmp22 = tmp22/countt%计算均方根误差
% tmp33 = tmp33/countt%计算均方根误差
%无法保存4通道图像