%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='D:\image_2\';
baselabel_address='D:\label_2\';
basecalib_address='H:\刘对虹\data\image\training\calib\';
val_txt='D:\val.txt';
val_data= importdata(val_txt);
detection_my='F:\200000\data\';
chongfu=10;%重复次数
for j= 1:length(val_data)%代表要处理的图片的第一张和最后一张
% i=val_data(j);
i=229;
number=num2str(i,'%06d')
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truelabel_address=[baselabel_address number Type3];
Truecalib_address=[basecalib_address number Type3];
detection_my_address=[detection_my number Type3];
%读取图片
img = imread(Truephoto_address);
fig = figure(1);axes('Position',[0 0 1 1]);hold on;imshow(img)
label = importdata(Truelabel_address);
if isempty(label)
    continue;
end
label_head = label.textdata;
label_data=label.data;

T = loadCalibrationP2(Truecalib_address);
location=ones(size(label_data,1),4);
location(:,1:3)=label_data(:,11:13);
locationcamera=floor(project(location,T));
imshow(img);hold on;        
    for i=1:size(locationcamera,1)                                                                                                                                                           
       plot(locationcamera(i,1),locationcamera(i,2),'o','LineWidth',4,'MarkerSize',1);
       %plot函数的坐标原点在左下角
    end

detection = importdata(detection_my_address);
if isempty(detection)
    continue;
end
detection_head = detection.textdata;
    
end