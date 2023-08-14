%plot ap
clear;clc;
yolov3='E:\研究生\毕设\中期\二维检测\总结\yolo 模型用的别人训练好的\plot\car_detection.txt';
faster_rcnn='E:\研究生\毕设\中期\二维检测\总结\faster_rcnn_原始\car_detection.txt';
ours='E:\研究生\毕设\中期\二维检测\总结\work_dirs_great\car_detection.txt';
% mm3d='E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\二维\mv3d.txt';
birdNet='E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\BirdNet+.txt';
pseudoLiDAR='E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\Pseudo-LiDAR.txt';
maff_net='E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\二维\MAFF-Net.txt';
MMMRFC ='E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\MM-MRFC.txt';


yolo_data=importdata(yolov3);
faster_rcnn_data=importdata(faster_rcnn);
ours_data=importdata(ours);
% mm3d_data=importdata(mm3d);
maff_net_data=importdata(maff_net);
birdNet_data=importdata(birdNet);
pseudoLiDAR_data=importdata(pseudoLiDAR);
MMMRFC_data=importdata(MMMRFC);
% 
% %存ap值
% file=fopen('E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\二维\ap.txt','w');
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','ours_data',sum(ours_data(:,2))*100/41,sum(ours_data(:,3))*100/41,sum(ours_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','yolo_data',sum(yolo_data(:,2))*100/41,sum(yolo_data(:,3))*100/41,sum(yolo_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','faster_rcnn_data',sum(faster_rcnn_data(:,2))*100/41,sum(faster_rcnn_data(:,3))*100/41,sum(faster_rcnn_data(:,4))*100/41);
% % fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','mm3d_data',sum(mm3d_data(:,2))*100/41,sum(mm3d_data(:,3))*100/41,sum(mm3d_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','maff_net_data',sum(maff_net_data(:,2))*100/41,sum(maff_net_data(:,3))*100/41,sum(maff_net_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','birdNet_data',sum(birdNet_data(:,2))*100/41,sum(birdNet_data(:,3))*100/41,sum(birdNet_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','pseudoLiDAR_data',sum(pseudoLiDAR_data(:,2))*100/41,sum(pseudoLiDAR_data(:,3))*100/41,sum(pseudoLiDAR_data(:,4))*100/41);
% fclose(file);
% b=sum(ours_data(:,2))/41;%ap值

% data=[ours_data(:,2:4),yolo_data(:,2:4),faster_rcnn_data(:,2:4)];
% plot(test_data(:,1),test_data(:,2:4),'LineWidth',2);
% legend('ours_Easy','ours_Moderate','ours_Hard','yolo_Easy','yolo_Moderate','yolo_Hard','faster_rcnn_Easy','faster_rcnn_Moderate','faster_rcnn_Hard','Location','southwest')

sum(MMMRFC_data(:,2))*100/41
sum(MMMRFC_data(:,3))*100/41
sum(MMMRFC_data(:,4))*100/41


data2=[ours_data(:,2),yolo_data(:,2),faster_rcnn_data(:,2),birdNet_data(:,2),maff_net_data(:,2),MMMRFC_data(:,2),pseudoLiDAR_data(:,2)];
plot(ours_data(:,1),data2(:,2),'-*m',ours_data(:,1),data2(:,3),'-b',ours_data(:,1),data2(:,4),'-xg',ours_data(:,1),data2(:,5),'-hy',ours_data(:,1),data2(:,6),'-^k',ours_data(:,1),data2(:,7),'-*c',ours_data(:,1),data2(:,1),'-r','LineWidth',5);
legend('YOLOV3','FasterRcnn','BirdNet','MAFFNet','MM-MRFC','PseudoLiDAR','LIF-CNN(OURS)','Location','southwest','Fontname', 'Times New Roman','FontSize',25);
xlabel('recall','Fontname', 'Times New Roman','FontSize',25);ylabel('precision','Fontname', 'Times New Roman','FontSize',25);
title('Easy','Fontname', 'Times New Roman','FontSize',25);
figure;
data3=[ours_data(:,3),yolo_data(:,3),faster_rcnn_data(:,3),birdNet_data(:,3),maff_net_data(:,3),MMMRFC_data(:,3),pseudoLiDAR_data(:,3)];
plot(ours_data(:,1),data3(:,2),'-*m',ours_data(:,1),data3(:,3),'-b',ours_data(:,1),data3(:,4),'-xg',ours_data(:,1),data3(:,5),'-hy',ours_data(:,1),data3(:,6),'-^k',ours_data(:,1),data3(:,7),'-*c',ours_data(:,1),data3(:,1),'-r','LineWidth',5);
% legend('oursModerate','yoloModerate','fasterRcnnModerate','mm3dModerate','maffNetModerate','Location','southwest');xlabel('recall');ylabel('precision');
legend('YOLOV3','FasterRcnn','BirdNet','MAFFNet','MM-MRFC','PseudoLiDAR','LIF-CNN(OURS)','Location','southwest','Fontname', 'Times New Roman','FontSize',25);
xlabel('recall','Fontname', 'Times New Roman','FontSize',25);ylabel('precision','Fontname', 'Times New Roman','FontSize',25);
title('Moderate','Fontname', 'Times New Roman','FontSize',25);
figure;
data4=[ours_data(:,4),yolo_data(:,4),faster_rcnn_data(:,4),birdNet_data(:,4),maff_net_data(:,4),MMMRFC_data(:,4),pseudoLiDAR_data(:,4)];
plot(ours_data(:,1),data4(:,2),'-*m',ours_data(:,1),data4(:,3),'-b',ours_data(:,1),data4(:,4),'-xg',ours_data(:,1),data4(:,5),'-hy',ours_data(:,1),data4(:,6),'-^k',ours_data(:,1),data4(:,7),'-*c',ours_data(:,1),data4(:,1),'-r','LineWidth',5);
legend('YOLOV3','FasterRcnn','BirdNet','MAFFNet','MM-MRFC','PseudoLiDAR','LIF-CNN(OURS)','Location','southwest','Fontname', 'Times New Roman','FontSize',25);
xlabel('recall','Fontname', 'Times New Roman','FontSize',25);ylabel('precision','Fontname', 'Times New Roman','FontSize',25);
title('Hard','Fontname', 'Times New Roman','FontSize',25);