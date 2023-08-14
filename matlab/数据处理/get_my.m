function res = get_my(velo_img,local)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    res=[];
    x1=local(1);
    x2=local(2);
    y1=local(3);
    y2=local(4);
    for i=1:size(velo_img,1)
        y=velo_img(i,1);x=velo_img(i,2);%velo_img中第一个数据是范围更大的那个
        if((x1<=x)&&(x<=x2)&&(y1<=y)&&(y<=y2))
            res=[res;i];
        end
    end
end

