function [out] = ransac_fx(data1)


%%%三维平面拟合
%%%生成随机数据
%内点
mu=[0 0 0];  %均值
S=[2 0 4;0 4 0;4 0 8];  %协方差
%外点
mu=[2 2 2];
S=[8 1 4;1 8 2;4 2 8];  %协方差
%合并数据
data1=data1';
data=data1(1:3,:);
iter = 3000; 

%%% 绘制数据点
 
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
 out=[];
mask=abs(bestplane*[data; ones(1,size(data,2))])<sigma;    
hold on;
k = 1;
mask=find(~mask);
out=data1(:,mask)';


 
end

