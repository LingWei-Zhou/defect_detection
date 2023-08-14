%plot ap
clear;clc;
%单目
AutoShape='E:\研究生\毕设\论文\my\图\第五章\对比实验\AutoShape.txt';
AutoShape_data=importdata(AutoShape);
SGM3D='E:\研究生\毕设\论文\my\图\第五章\对比实验\SGM3D.txt';
SGM3D_data=importdata(SGM3D);

%双目
YOLOStereo3D='E:\研究生\毕设\论文\my\图\第五章\对比实验\YOLOStereo3D.txt';
YOLOStereo3D_data=importdata(YOLOStereo3D);

%雷达
WS3D='E:\研究生\毕设\论文\my\图\第五章\对比实验\WS3D.txt';
WS3D_data=importdata(WS3D);
mv3d_lidar='E:\研究生\毕设\论文\my\图\第五章\对比实验\mv3d_lidar.txt';
mv3d_lidar_data=importdata(mv3d_lidar);
% pointpillar='E:\研究生\毕设\论文\my\图\第五章\对比实验\pointpillar.txt';
% pointpillar_data=importdata(pointpillar);
%融合
FPointNet='E:\研究生\毕设\论文\my\图\第五章\对比实验\F-PointNet.txt';
FPointNet_data=importdata(FPointNet);
MLOD='E:\研究生\毕设\论文\my\图\第五章\对比实验\MLOD.txt';
MLOD_data=importdata(MLOD);
mv3d='E:\研究生\毕设\论文\my\图\第五章\对比实验\mv3d.txt';
mv3d_data=importdata(mv3d);
our='E:\研究生\毕设\论文\my\图\第五章\对比实验\our.txt';
our_data=importdata(our);

%存ap值
% file=fopen('E:\研究生\毕设\论文\my\图\第五章\对比实验\ap.txt','w');
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','AutoShape_data',sum(AutoShape_data(:,2))*100/41,sum(AutoShape_data(:,3))*100/41,sum(AutoShape_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','SGM3D_data',sum(SGM3D_data(:,2))*100/41,sum(SGM3D_data(:,3))*100/41,sum(SGM3D_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','YOLOStereo3D_data',sum(YOLOStereo3D_data(:,2))*100/41,sum(YOLOStereo3D_data(:,3))*100/41,sum(YOLOStereo3D_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','WS3D_data',sum(WS3D_data(:,2))*100/41,sum(WS3D_data(:,3))*100/41,sum(WS3D_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','mv3d_lidar_data',sum(mv3d_lidar_data(:,2))*100/41,sum(mv3d_lidar_data(:,3))*100/41,sum(mv3d_lidar_data(:,4))*100/41);
% % fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','pointpillar_data',sum(pointpillar_data(:,2))*100/41,sum(pointpillar_data(:,3))*100/41,sum(pointpillar_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','FPointNet_data',sum(FPointNet_data(:,2))*100/41,sum(FPointNet_data(:,3))*100/41,sum(FPointNet_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','MLOD_data',sum(MLOD_data(:,2))*100/41,sum(MLOD_data(:,3))*100/41,sum(MLOD_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','mv3d_data',sum(mv3d_data(:,2))*100/41,sum(mv3d_data(:,3))*100/41,sum(mv3d_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','our_data',sum(our_data(:,2))*100/41,sum(our_data(:,3))*100/41,sum(our_data(:,4))*100/41);
% fclose(file);

data2=[AutoShape_data(:,2),SGM3D_data(:,2),YOLOStereo3D_data(:,2),WS3D_data(:,2),mv3d_lidar_data(:,2),FPointNet_data(:,2),MLOD_data(:,2),mv3d_data(:,2),our_data(:,2)];
plot(our_data(:,1),data2(:,1),'-^k',our_data(:,1),data2(:,2),'-^m',our_data(:,1),data2(:,3),'-^b',our_data(:,1),data2(:,4),'-og',our_data(:,1),data2(:,5),'-oy',our_data(:,1),data2(:,6),'-c',our_data(:,1),data2(:,7),'-b',our_data(:,1),data2(:,8),'-m',our_data(:,1),data2(:,9),'-r','LineWidth',14);
legend('AutoShape','SGM3D','YOLOStereo3D','WS3D','MV3DLIDAR','FPointNet','MLOD','MV3D','MDFF(Ours)','Location','southwest','Fontname', 'Times New Roman','FontSize',60);
xlabel('recall','Fontname', 'Times New Roman','FontSize',60);ylabel('precision','Fontname', 'Times New Roman','FontSize',60);
title('Easy','Fontname', 'Times New Roman','FontSize',60);
figure;
data3=[AutoShape_data(:,3),SGM3D_data(:,3),YOLOStereo3D_data(:,3),WS3D_data(:,3),mv3d_lidar_data(:,3),FPointNet_data(:,3),MLOD_data(:,3),mv3d_data(:,3),our_data(:,3)];
plot(our_data(:,1),data3(:,1),'-^k',our_data(:,1),data3(:,2),'-^m',our_data(:,1),data3(:,3),'-^b',our_data(:,1),data3(:,4),'-og',our_data(:,1),data3(:,5),'-oy',our_data(:,1),data3(:,6),'-c',our_data(:,1),data3(:,7),'-b',our_data(:,1),data3(:,8),'-m',our_data(:,1),data3(:,9),'-r','LineWidth',14);
legend('AutoShape','SGM3D','YOLOStereo3D','WS3D','MV3DLIDAR','FPointNet','MLOD','MV3D','MDFF(Ours)','Location','southwest','Fontname', 'Times New Roman','FontSize',60);
xlabel('recall','Fontname', 'Times New Roman','FontSize',60);ylabel('precision','Fontname', 'Times New Roman','FontSize',60);
title('Moderate', 'Fontname','Times New Roman','FontSize',60);
figure;
data4=[AutoShape_data(:,4),SGM3D_data(:,4),YOLOStereo3D_data(:,4),WS3D_data(:,4),mv3d_lidar_data(:,4),FPointNet_data(:,4),MLOD_data(:,4),mv3d_data(:,4),our_data(:,4)];
plot(our_data(:,1),data4(:,1),'-^k',our_data(:,1),data4(:,2),'-^m',our_data(:,1),data4(:,3),'-^b',our_data(:,1),data4(:,4),'-og',our_data(:,1),data4(:,5),'-oy',our_data(:,1),data4(:,6),'-c',our_data(:,1),data4(:,7),'-b',our_data(:,1),data4(:,8),'-m',our_data(:,1),data4(:,9),'-r','LineWidth',14);
legend('AutoShape','SGM3D','YOLOStereo3D','WS3D','MV3DLIDAR','FPointNet','MLOD','MV3D','MDFF(Ours)','Location','southwest','Fontname', 'Times New Roman','FontSize',60);
xlabel('recall','Fontname', 'Times New Roman','FontSize',60);ylabel('precision','Fontname', 'Times New Roman','FontSize',60);
title('Hard','Fontname', 'Times New Roman','FontSize',60);