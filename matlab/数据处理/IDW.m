function vq = IDW(input)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
vq=input;
[x,y]=find(input~=255);
v=input(find(input~=255));
[xq,yq]=find(input==255);
n=size(x,1);
nq=size(xq,1);
for i=1:nq
    for j=1:n
        r(j)=(xq(i)-x(j))^2+(yq(i)-y(j))^2;
    end
    if min(r)==0
        vq(xq(i),yq(i))=v(find(r==0));
    else
        rd=r.^(-1);
        w=rd/sum(rd);
        vq(xq(i),yq(i))=w*double(v);
    end
end
end

