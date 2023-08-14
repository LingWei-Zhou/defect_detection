function label(base_dir,calib_dir)
if nargin<1
  % base_dir = '/mnt/karlsruhe_dataset/2011_09_26/2011_09_26_drive_0009_sync';
  % base_dir = '/media/data/kitti/2012_raw_data_extract/2011_09_26/2011_09_26_drive_0056';
  base_dir ='D:/Raw_data/2011_09_26/2011_09_26_drive_0005_sync';
end
if nargin<2
  % calib_dir = '/media/data/kitti/2012_raw_data_extract/2011_09_26';
  calib_dir = 'D:/Raw_data/2011_09_26';
end
cam       = 2; % 0-based index 选取2号相机（彩色）

load ('data.mat');
img_idx = 0;
i=0;
while img_idx<108
    img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,img_idx));

    img_idx = img_idx +1;
    var=round(data_remember{img_idx,:});
    for num_1=1:size(var,1)
       image=imcrop(img,var(num_1,:));
       i=i+1;
       imwrite(image,[num2str(i),'.jpg']);
        %save('%s_%s.png',img_idx,num_1,'image')
    end
end
    
    