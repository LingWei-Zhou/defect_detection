clear;clc;

output_address='G:/刘对虹/data/image/training\image_my\';
output_address2='G:/刘对虹/data/image/training\image_my2\';
k8=1;
k4=3;
for i=100:100%代表要处理的图片的第一张和最后一张
    
   

number=num2str(i,'%06d');
Type1='.png';Type2='.bin';Type3='.txt';

output=[output_address number Type1];
output2=[output_address2 number Type1];

%读取并画出图片
img = imread(output);
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
imshow(img);
size(img)
hold on;
img_copy=img;
x=[-5,5];
y=[-7,7];
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
                                end
                            end
                            
                            if (abs(ii)==1&&abs(jj)==0)||(abs(ii)==0&&abs(jj)==1)
                                for p=1:k4%让四领域的影响更大
                                    a(count)=img(i+ii,j+jj);
                                    count=count+1;
                                end
                            end
                            
                        end
                    end
                    
                end
               
            if count-1>0 %减一是因为之前多加了1，大于2要求罢领域至少3个不是空
             img_copy(i,j)=median(a);
            end
        end
            
    end
end

figure;
imshow(img_copy);
size(img_copy)
hold on;

end
