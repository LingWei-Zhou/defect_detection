function velo_out = RANSAC_CutGround(velo)
% RANSAC地面点拟合;并将这些地面点删除了

k=10;%最大迭代次数
all_num=size(velo,1);%总点数
min_distance=0.1;%最小距离（m）
best_num=0;

for i=1:k
    maxz=10;
    
    while maxz>0.2
        idx=randperm(all_num,3);%随机取三个点（的索引）
        sample=velo(idx,1:3);
        maxz=max([abs(sample(1,3)-sample(2,3)),abs(sample(1,3)-sample(3,3)),abs(sample(3,3)-sample(2,3))]);
    end
     plane = zeros(1,3);
     x = sample(:, 1);
     y = sample(:, 2);
     z = sample(:, 3);

     a = ((z(1)-z(2))*(y(1)-y(3)) - (z(1)-z(3))*(y(1)-y(2)))/((x(1)-x(2))*(y(1)-y(3)) - (x(1)-x(3))*(y(1)-y(2)));
     b = ((z(1) - z(3)) - a * (x(1) - x(3)))/(y(1)-y(3));
     c = z(1) - a * x(1) - b * y(1);
     plane = [a b -1 c];  
%     [a,b,c,d]=get_plane(sample);%求的平面方程表示为ax+by+cz+d=0;
%     plane=[a,b,c,d];
    %计算每个点到平面的距离（distance为1*all_num大小的矩阵）
    distance=abs(plane*[velo(:,1:3)';ones(1,all_num)])/sqrt(plane(1,1)^2+plane(1,2)^2+plane(1,3)^2);
    total=sum(distance<min_distance);%与平面距离小于阈值的点的个数
    if total>best_num
        best_num=total;
        bestplane=plane;
    end
end
distance=abs(bestplane*[velo(:,1:3)';ones(1,all_num)])/sqrt(bestplane(1,1)^2+bestplane(1,2)^2+bestplane(1,3)^2);
index=distance<min_distance;
velo(index,:)=[];
velo_out=velo;

end

