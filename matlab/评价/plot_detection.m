%将点云数据投影在其对应的2D图像上，并绘制出来

clear;clc;
basephoto_address='D:\image_2\';
baselabel_address='D:\label_2\';
train_txt='D:\train.txt';
train_data= importdata(train_txt);
chongfu=10;%重复次数
for j= 1:length(train_data)%代表要处理的图片的第一张和最后一张
% i=train_data(j);
i=229
number=num2str(i,'%06d')
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truelabel_address=[baselabel_address number Type3];
%读取图片
img = imread(Truephoto_address);
figure(1);hold on;imshow(img)
A = importdata(Truelabel_address);
head = A.textdata;
data=A.data;
    for k = 1:length(head)
        f=head{k};
%         if f=="Car"||f=="Van"||f=="Truck"
%             rectangle('position',[data(k,4:5),data(k,6)-data(k,4),data(k,7)-data(k,5)],'edgecolor','r');%画框
%             判断是否为hard  mid目标
            position=floor(data(k,4:7))+1;
            rectangle('Position',[position(1:2),position(3)-position(1),position(4)-position(2)],'edgecolor','r');
                
            
%         end
        
    end
end