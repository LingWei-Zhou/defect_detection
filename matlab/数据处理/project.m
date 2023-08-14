function p_out = project(p_in,T)
%计算点云数据转换到2D平面上的N*2的矩阵

% dimension of data and projection matrix
dim_norm = size(T,1);
dim_proj = size(T,2);

% do transformation in homogenuous coordinates
p2_in = p_in;
if size(p2_in,2)<dim_proj
  p2_in(:,dim_proj) = 1;
end
p2_out = (T*p2_in')';


% normalize homogeneous coordinates:  归一化齐次坐标
p_out = p2_out(:,1:dim_norm-1)./(p2_out(:,dim_norm)*ones(1,dim_norm-1));%看不懂这一系列变换的话可以看师兄的论文公式3-12,38页

