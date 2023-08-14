function img_copy = interp_fx(img,x,y)



k8=1;%8邻域的加权不包含4邻域  
k4=3;%4邻域的加权
mask=ones(size(img,1),size(img,2));

m=0;

for j=1:size(img,2)%先进行列便利
    label=0;
    for i=1:size(img,1)
       if img(i,j)==255  %遍历,找出需要插值的点
          label=label+1;
       end
       if label~=i
           
           break;
       end
       
    end
    mask(1:label,j)=0;
end

%读取并画出图片


img_copy=img;
[idx_u,idx_v]=find(img_copy~=255);
%x=[-5,5];
%y=[-7,7];
for i=-x(1)+1:size(img,1)-x(2)
    for j=-y(1)+1:size(img,2)-y(2)%图像边界的不进行插值
       
        
        if img_copy(i,j)==255
                a=[];
                count=1;
                for ii=x(1):x(2)
                    for jj=y(1):y(2)
                        if img(i+ii,j+jj)~=255
                            a(count)=img(i+ii,j+jj);
                            count=count+1;
                            if abs(ii)==1&&abs(jj)==1
                                for p=1:k8%让八领域的影响更大
                                    a(count)=img(i+ii,j+jj);
                                    count=count+1;
                                end;
                            end
                            
                            if (abs(ii)==1&&abs(jj)==0)||(abs(ii)==0&&abs(jj)==1)
                                for p=1:k4%让四领域的影响更大
                                    a(count)=img(i+ii,j+jj);
                                    count=count+1;
                                end;
                            end
                            
                        end
                    end
                    
                end
               
            if count-1>0 %减一是因为之前多加了1，大于2要求罢领域至少3个不是空
             img_copy(i,j)=median(a);
            end
            if img_copy(i,j)==255 &mask(i,j)~=0
                %最近邻,在所有不是255的点中的最近邻
                %找到所有非255与待插值点之间的距离
                for s=1:length(idx_u)
                    leng(s)=abs(i-idx_u(s))+abs(j-idx_v(s));
                end
                %找到所有非255与待插值点之间的最小距离,有可能有多个，只取第一个
                
                local=find(leng==min(leng));
                img_local_x=idx_u(local(1));
                img_local_y=idx_v(local(1));
                img_copy(i,j)=img_copy(img_local_x,img_local_y);
                
            end
            
        end
            
    end
end


%补充边界  训练用的数据并没有补充边界
boundx=[size(img,1)-x(2)+1:size(img,1)];
boundy=[1:-y(1),size(img,2)-y(2)+1:size(img,2)];
%先列
for j =1:length(boundy)
    cc=mask(:,j);
    ccc=min((find(cc~=0)));
    for i=ccc:size(img,1)
        
        ii=i;
        jj=boundy(j);
        %最近邻,在所有不是255的点中的最近邻
                %找到所有非255与待插值点之间的距离
                for s=1:length(idx_u)
                    leng(s)=abs(ii-idx_u(s))+abs(jj-idx_v(s));
                end
                %找到所有非255与待插值点之间的最小距离,有可能有多个，只取第一个
                
                local=find(leng==min(leng));
                img_local_x=idx_u(local(1));
                img_local_y=idx_v(local(1));
                img_copy(ii,jj)=img_copy(img_local_x,img_local_y);
    end
end
%最后几行

for i =size(img,1)-x(2)+1:size(img,1)
    
    for j=1:size(img,2)
        
        ii=i;
        jj=j;
        %最近邻,在所有不是255的点中的最近邻
                %找到所有非255与待插值点之间的距离
                for s=1:length(idx_u)
                    leng(s)=abs(ii-idx_u(s))+abs(jj-idx_v(s));
                end
                %找到所有非255与待插值点之间的最小距离,有可能有多个，只取第一个
                
                local=find(leng==min(leng));
                img_local_x=idx_u(local(1));
                img_local_y=idx_v(local(1));
                img_copy(ii,jj)=img_copy(img_local_x,img_local_y);
    end
end

end

