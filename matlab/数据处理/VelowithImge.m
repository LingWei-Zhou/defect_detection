%����������ͶӰ�����Ӧ��2Dͼ���ϣ������Ƴ���

clear;clc;
basephoto_address='H:\���Ժ�\data\image\training\image_2\';
basevelo_address='H:\���Ժ�\data\image\training\velodyne\';
basecalib_address='H:\���Ժ�\data\image\training\calib\';
output_address='C:\Users\��������\Desktop\data\';
output_address2='C:\Users\��������\Desktop\data\';


for i=179:179%����Ҫ�����ͼƬ�ĵ�һ�ź����һ��    149  258
    
   

number=num2str(i,'%06d')
Type1='.png';Type2='.bin';Type3='.txt';
Truephoto_address=[basephoto_address number Type1];
Truevelo_address=[basevelo_address number Type2];
Truecalib_address=[basecalib_address number Type3];
output=[output_address number Type1];
output2=[output_address2 number Type1];

%��ȡ������ͼƬ
img = imread(Truephoto_address);
figure;imshow(img);hold on;
%��ȡ��������
fid = fopen(Truevelo_address,'rb');
velo = fread(fid,[4 inf],'single')';
% velo = velo(1:5:end,:); % ÿ��5����ȡһ���㣨ÿ��5��ȡһ�У�,�൱�ڳ������ӿ������ٶ�
fclose(fid);

%ȥ�����С��0m�ĵ�
idx = velo(:,1)<=0;
velo(idx,:) = [];


%ȥ����ƽ��
maxDistance = 0.3; % in meters
referenceVector = [0, 0, 1];
pc = pointCloud(velo(:,1:3));
[mode, inPlanePointIndices, outliers] = pcfitplane(pc, maxDistance, referenceVector);
pcWithoutGround = select(pc, outliers);
velo=velo(outliers,:);


%�������ڽ������������ת����2Dͼ���ϵľ���

T = loadCalibrationTrAndR0AndP2(Truecalib_address);

%�õ������������ת����ͼ��ƽ��ľ���
velo_img = project(velo(:,1:3),T);
velo_img=round(velo_img);
%indx= velo_img(:,2)==147;
%tabulate(velo_img(:,indx))
%��������ͼ������ĵ㡣ȥ����֮��ĵ�

x=velo_img(:,1);idx= x<=0|x>=size(img,2);velo_img(idx,:)=[];velo(idx,:)=[];
y=velo_img(:,2);idx= y<=0|y>=size(img,1);velo_img(idx,:)=[];velo(idx,:)=[];















%������������еĵ��Ӧ��2Dͼ���ϵ�λ��
cols = jet;

%img(:,:,4)=ones(size(img,1),size(img,2))*256;%ΪɶҪ��256�أ�����Ϊ����û�вɼ����ĵ���Զ���ĵ�
%img(:,:,5)=ones(size(img,1),size(img,2))*256;

velo(:,1)=round(velo(:,1));
velo(:,1)=kuozhan(velo(:,1));
% velo(:,4)=round(velo(:,4)*255);%��Ϊ����ǿ����0-1֮��







% %%��ʾϡ�����ͼ
% [m,n,~]=size(img);
% depth_img=zeros(m,n);
% 
% for i=1:size(velo_img,1)
%     u=floor(velo_img(i,2));
%     v=floor(velo_img(i,1));
%     if u>0 && u<=m && v>0 && v<=n && (depth_img(u,v)==0 || velo(i,1)<depth_img(u,v))
%         depth_img(u,v)=velo(i,1);
%     end
% end
% figure;imshow(depth_img,[]);






for i=1:size(velo_img,1)
  col_idx = round(velo(i,1))+1;%256�Ǹ�                                                                                                                                                                             ��jet���г������ģ�+1��Ϊ�˷�ֹ��0��ɺ���cols(col_idx,:)�Ĵ���
  plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
  %plot����������ԭ�������½�
end
%close all;
end
%�޷�����4ͨ��ͼ��