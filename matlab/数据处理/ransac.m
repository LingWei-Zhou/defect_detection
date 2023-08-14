clc;clear all;close all;

%%%三维平面拟合
%%%生成随机数据
%内点
mu=[0 0 0];  %均值
S=[2 0 4;0 4 0;4 0 8];  %协方差
data1=mvnrnd(mu,S,300);   %产生200个高斯分布数据
%外点
mu=[2 2 2];
S=[8 1 4;1 8 2;4 2 8];  %协方差
data2=mvnrnd(mu,S,100);     %产生100个噪声数据
%合并数据
data=[data1',data2'];
iter = 1000; 

%%% 绘制数据点
 figure;plot3(data(1,:),data(2,:),data(3,:),'o');hold on; % 显示数据点
 number = size(data,2); % 总点数
 bestParameter1=0; bestParameter2=0; bestParameter3=0; % 最佳匹配的参数
 sigma = 1;
 pretotal=0;     %符合拟合模型的数据的个数

for i=1:iter
 %%% 随机选择三个点
     idx = randperm(number,3); 
     sample = data(:,idx); 

     %%%拟合直线方程 z=ax+by+c
     plane = zeros(1,3);
     x = sample(:, 1);
     y = sample(:, 2);
     z = sample(:, 3);

     a = ((z(1)-z(2))*(y(1)-y(3)) - (z(1)-z(3))*(y(1)-y(2)))/((x(1)-x(2))*(y(1)-y(3)) - (x(1)-x(3))*(y(1)-y(2)));
     b = ((z(1) - z(3)) - a * (x(1) - x(3)))/(y(1)-y(3));
     c = z(1) - a * x(1) - b * y(1);
     plane = [a b -1 c];

     mask=abs(plane*[data; ones(1,size(data,2))]);    %求每个数据到拟合平面的距离
     total=sum(mask<sigma);              %计算数据距离平面小于一定阈值的数据的个数

     if total>pretotal            %找到符合拟合平面数据最多的拟合平面
         pretotal=total;
         bestplane=plane;          %找到最好的拟合平面
    end  
 end
 %显示符合最佳拟合的数据
mask=abs(bestplane*[data; ones(1,size(data,2))])<sigma;    
hold on;
k = 1;
for i=1:length(mask)
    if mask(i)
        inliers(1,k) = data(1,i);
        inliers(2,k) = data(2,i);
        plot3(data(1,i),data(2,i),data(3,i),'r+');
        k = k+1;
    end
end

 %%% 绘制最佳匹配平面
 bestParameter1 = bestplane(1);
 bestParameter2 = bestplane(2);
 bestParameter3 = bestplane(4);
 xAxis = min(inliers(1,:)):max(inliers(1,:));
 yAxis = min(inliers(2,:)):max(inliers(2,:));
 [x,y] = meshgrid(xAxis, yAxis);
 z = bestParameter1 * x + bestParameter2 * y + bestParameter3;
 surf(x, y, z);
 title(['bestPlane:  z =  ',num2str(bestParameter1),'x + ',num2str(bestParameter2),'y + ',num2str(bestParameter3)],'Fontname', 'Times New Roman','FontSize',15);
xlabel('x','Fontname', 'Times New Roman','FontSize',15);ylabel('y','Fontname', 'Times New Roman','FontSize',15);zlabel('z','Fontname', 'Times New Roman','FontSize',15);