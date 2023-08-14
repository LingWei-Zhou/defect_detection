function velo_out = RANSAC_CutGround(velo)
% RANSAC��������;������Щ�����ɾ����

k=10;%����������
all_num=size(velo,1);%�ܵ���
min_distance=0.1;%��С���루m��
best_num=0;

for i=1:k
    maxz=10;
    
    while maxz>0.2
        idx=randperm(all_num,3);%���ȡ�����㣨��������
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
%     [a,b,c,d]=get_plane(sample);%���ƽ�淽�̱�ʾΪax+by+cz+d=0;
%     plane=[a,b,c,d];
    %����ÿ���㵽ƽ��ľ��루distanceΪ1*all_num��С�ľ���
    distance=abs(plane*[velo(:,1:3)';ones(1,all_num)])/sqrt(plane(1,1)^2+plane(1,2)^2+plane(1,3)^2);
    total=sum(distance<min_distance);%��ƽ�����С����ֵ�ĵ�ĸ���
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

