function [offset_x,offset_y] = offset_p(size_1_p,size_2_p,position)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% 随机移动 
% position: y1,x1,y2,x2  size_1_p:x   size_2_p:y
h=position(4)-position(2);
w=position(3)-position(1);
s1 = randi(size_1_p-h,1,1);
s2 = randi(size_2_p-w,1,1);
offset_x=s1-position(2);
offset_y=s2-position(1);
end

