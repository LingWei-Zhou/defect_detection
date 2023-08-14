function depth_img = dtinterp_fx(depth_img)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明  最邻近插值

mask=ones(size(depth_img,1),size(depth_img,2));

m=0;

for j=1:size(depth_img,2)%先进行列遍历
    label=0;
    for i=1:size(depth_img,1)
       if depth_img(i,j)==255  %遍历,找出需要插值的点
          label=label+1;
       end
       if label~=i
           break;
       end
       
    end
    mask(1:label,j)=0;
end



[idx_u,idx_v]=find(depth_img~=255);
[idx_uo,idx_vo]=find(depth_img==255);
P=[];
for i=1:size(idx_u)
    P=[P;depth_img(idx_u(i),idx_v(i))];
end

DT = delaunayTriangulation([idx_u,idx_v]);
%figure
%plot(DT);
Pq=[idx_uo,idx_vo];
vi = nearestNeighbor(DT,Pq);%最近邻
Vq = P(vi);
for i=1:size(Pq,1)
    depth_img(Pq(i,1),Pq(i,2))=Vq(i);
end
mask=uint8(mask);
depth_img=mask.*depth_img;%要不要用模板滤波


end

