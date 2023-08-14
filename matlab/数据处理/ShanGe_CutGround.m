function velo_out = ShanGe_CutGround(velo_in,heightlimit)
%栅格法滤除地面点

xmin=floor(min(velo_in(:,1)));ymin=floor(min(velo_in(:,2)));
x=ceil(max(velo_in(:,1)))-xmin;%x的范围取整
y=ceil(max(velo_in(:,2)))-ymin;%y的范围取整
d=1;
Max=-inf*ones(x,y);Min=-Max;
%求出每个栅格z的最大和最小值
for i=1:size(velo_in,1)
    m=ceil(velo_in(i,1)-xmin);n=ceil(velo_in(i,2)-ymin);
    if(velo_in(i,3)>Max(m,n))
        Max(m,n)=velo_in(i,3);
    end
    if(velo_in(i,3)<Min(m,n))
        Min(m,n)=velo_in(i,3);
    end
end


for m=1:x
    for n=1:y
        if(Max(m,n)-Min(m,n)<heightlimit)
            soyin=(velo_in(:,1)>xmin+(m-1)*d)&(velo_in(:,1)<=xmin+m*d)&(velo_in(:,2)>ymin+(n-1)*d)&(velo_in(:,2)<=ymin+n*d);
            velo_in(soyin,:)=[];
        end
    end
end
velo_out=velo_in;
end

