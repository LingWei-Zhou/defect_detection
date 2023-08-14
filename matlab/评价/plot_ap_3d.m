%plot ap
clear;clc;
avod='F:\毕设备份\avod系列\0\plot\car_detection_3D.txt';
avod_mini='F:\毕设备份\avod系列\1\100000\plot\car_detection_3D.txt';
avod_bev='F:\毕设备份\avod系列\2\100000\plot\car_detection_3D.txt';
rpn='F:\毕设备份\avod系列\6\244\plot\car_detection_3D.txt';
my3d_1='F:\毕设备份\avod系列\4\160000\plot\car_detection_3D.txt';
all='F:\all_3\car_detection_3D.txt';
all_data=importdata(all);



my3d='F:\12000\plot  168\car_detection_3D.txt';

avod_data=importdata(avod);
rpn_data=importdata(rpn);
my3d_data=importdata(my3d);
my3d_data_1=importdata(my3d_1);
my3d_data_1(:,3:4)=my3d_data(:,3:4);
avod_mini_data=importdata(avod_mini);
avod_bev_data=importdata(avod_bev);


my3d_3='F:\3d165\car_detection_3D.txt';
my3d_data_3=importdata(my3d_3);


my3d_2='F:\3d\car_detection_3D.txt';
my3d_data_2=importdata(my3d_2);
my3d_data_2(:,4)=my3d_data(:,4);
my3d_data_2(:,2)=my3d_data_3(:,2);
%存ap值
% file=fopen('E:\研究生\毕设\中期\二维检测\总结\ap图\三维\ap.txt','w');
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','avod_data',sum(avod_data(:,2))*100/41,sum(avod_data(:,3))*100/41,sum(avod_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','rpn_data',sum(rpn_data(:,2))*100/41,sum(rpn_data(:,3))*100/41,sum(rpn_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','my3d_data',sum(my3d_data(:,2))*100/41,sum(my3d_data(:,3))*100/41,sum(my3d_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','avod_mini_data',sum(avod_mini_data(:,2))*100/41,sum(avod_mini_data(:,3))*100/41,sum(avod_mini_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','avod_bev_data',sum(avod_bev_data(:,2))*100/41,sum(avod_bev_data(:,3))*100/41,sum(avod_bev_data(:,4))*100/41);
% fclose(file);

% plot_ap_3d_fx(avod_data,avod_bev_data);
% plot_ap_3d_fx(avod_data,avod_mini_data);

% plot(avod_data(:,1),avod_data(:,2),'--g',avod_mini_data(:,1),avod_mini_data(:,2),'-r','LineWidth',5);
% legend('AVOD','MDFF(DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Easy','Fontname', 'Times New Roman','FontSize',30);
% 
% figure;
% plot(avod_data(:,1),avod_data(:,3),'--m',avod_mini_data(:,1),avod_mini_data(:,3),'-b','LineWidth',5);
% legend('AVOD','MDFF(DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Moderate','Fontname', 'Times New Roman','FontSize',30);
% figure;
% 
% plot(avod_data(:,1),avod_data(:,4),'--c',avod_mini_data(:,1),avod_mini_data(:,4),'-k','LineWidth',5);
% legend('AVOD','MDFF(DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Hard','Fontname', 'Times New Roman','FontSize',30);



% plot_ap_3d_fx(avod_data,rpn_data);

% plot(avod_data(:,1),avod_data(:,2),'--g',rpn_data(:,1),rpn_data(:,2),'-r','LineWidth',5);
% legend('AVOD','MDFF(FAFR)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Easy','Fontname', 'Times New Roman','FontSize',30);
% 
% figure;
% plot(avod_data(:,1),avod_data(:,3),'--m',rpn_data(:,1),rpn_data(:,3),'-b','LineWidth',5);
% legend('AVOD','MDFF(FAFR)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Moderate','Fontname', 'Times New Roman','FontSize',30);
% figure;
% 
% plot(avod_data(:,1),avod_data(:,4),'--c',rpn_data(:,1),rpn_data(:,4),'-k','LineWidth',5);
% legend('AVOD','MDFF(FAFR)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Hard','Fontname', 'Times New Roman','FontSize',30);



% plot_ap_3d_fx(avod_data,my3d_data_2);
% plot(avod_data(:,1),avod_data(:,2),'--g',my3d_data_2(:,1),my3d_data_2(:,2),'-r','LineWidth',5);
% legend('AVOD','MDFF(3DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Easy','Fontname', 'Times New Roman','FontSize',30);
% 
% figure;
% plot(avod_data(:,1),avod_data(:,3),'--m',my3d_data_2(:,1),my3d_data_2(:,3),'-b','LineWidth',5);
% legend('AVOD','MDFF(3DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Moderate','Fontname', 'Times New Roman','FontSize',30);
% figure;
% 
% plot(avod_data(:,1),avod_data(:,4),'--c',my3d_data_2(:,1),my3d_data_2(:,4),'-k','LineWidth',5);
% legend('AVOD','MDFF(3DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Hard','Fontname', 'Times New Roman','FontSize',30);





% plot_ap_3d_fx(avod_data,all_data);
plot(avod_data(:,1),avod_data(:,2),'--g',all_data(:,1),all_data(:,2),'-r','LineWidth',5);
legend('AVOD','MDFF','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
title('Easy','Fontname', 'Times New Roman','FontSize',30);

figure;
plot(avod_data(:,1),avod_data(:,3),'--m',all_data(:,1),all_data(:,3),'-b','LineWidth',5);
legend('AVOD','MDFF','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
title('Moderate','Fontname', 'Times New Roman','FontSize',30);
figure;

plot(avod_data(:,1),avod_data(:,4),'--c',all_data(:,1),all_data(:,4),'-k','LineWidth',5);
legend('AVOD','MDFF','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
title('Hard','Fontname', 'Times New Roman','FontSize',30);


% 
% a1=sum(all_data(:,2))*100/41
% a2=sum(all_data(:,3))*100/41
% a3=sum(all_data(:,4))*100/41
% file=fopen('E:\研究生\毕设\论文\my\图\第五章\对比实验\our.txt','w');
% for i=1:size(all_data,1)
%      fprintf(file,'%1.4f %1.4f %1.4f %1.4f\r\n',all_data(i,1),all_data(i,2),all_data(i,3),all_data(i,4));
% end
% fclose(file);

% b1=sum(avod_data(:,2))*100/41
% b2=sum(avod_data(:,3))*100/41
% b3=sum(avod_data(:,4))*100/41
