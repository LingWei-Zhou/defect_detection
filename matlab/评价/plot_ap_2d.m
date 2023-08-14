%plot ap
clear;clc;
ours='E:\研究生\毕设\中期\二维检测\总结\work_dirs_great\car_detection.txt';
ours_data=importdata(ours);

noloss='E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\二维\noloss.txt';
noloss_data=importdata(noloss);
novelo='E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\二维\novelo.txt';
novelo_data=importdata(novelo);

% plot(noloss_data(:,1),noloss_data(:,2),'--g',ours_data(:,1),ours_data(:,2),'-r',noloss_data(:,1),noloss_data(:,3),'--m',ours_data(:,1),ours_data(:,3),'-b',noloss_data(:,1),noloss_data(:,4),'--c',ours_data(:,1),ours_data(:,4),'-k','LineWidth',3);
% legend('LIF-CNN(Smoth)Easy','LIF-CNN(OSL)Easy','LIF-CNN(Smoth)Moderate','LIF-CNN(OSL)Moderate','LIF-CNN(Smoth)Hard','LIF-CNN(OSL)Hard','Location','southwest','Fontname', 'Times New Roman','FontSize',15)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',15);ylabel('precision','Fontname', 'Times New Roman','FontSize',15);

plot(noloss_data(:,1),noloss_data(:,2),'--g',ours_data(:,1),ours_data(:,2),'-r','LineWidth',5);
legend('LIF-CNN(Smoth)','LIF-CNN(OSL)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
title('Easy','Fontname', 'Times New Roman','FontSize',30);

figure;
plot(noloss_data(:,1),noloss_data(:,3),'--m',ours_data(:,1),ours_data(:,3),'-b','LineWidth',5);
legend('LIF-CNN(Smoth)','LIF-CNN(OSL)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
title('Moderate','Fontname', 'Times New Roman','FontSize',30);
figure;

plot(noloss_data(:,1),noloss_data(:,4),'--c',ours_data(:,1),ours_data(:,4),'-k','LineWidth',5);
legend('LIF-CNN(Smoth)','LIF-CNN(OSL)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
title('Hard','Fontname', 'Times New Roman','FontSize',30);









% plot(novelo_data(:,1),novelo_data(:,2),'--g',ours_data(:,1),ours_data(:,2),'-r',novelo_data(:,1),novelo_data(:,3),'--m',ours_data(:,1),ours_data(:,3),'-b',novelo_data(:,1),novelo_data(:,4),'--c',ours_data(:,1),ours_data(:,4),'-k','LineWidth',3);
% legend('LIF-CNN(RGB)Easy','LIF-CNN(DF)Easy','LIF-CNN(RGB)Moderate','LIF-CNN(DF)Moderate','LIF-CNN(RGB)Hard','LIF-CNN(DF)Hard','Location','southwest','Fontname', 'Times New Roman','FontSize',15)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',15);ylabel('precision','Fontname', 'Times New Roman','FontSize',15);

% plot(novelo_data(:,1),novelo_data(:,2),'--g',ours_data(:,1),ours_data(:,2),'-r','LineWidth',5);
% legend('LIF-CNN(RGB)','LIF-CNN(DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Easy','Fontname', 'Times New Roman','FontSize',30);
% 
% figure;
% plot(novelo_data(:,1),novelo_data(:,3),'--m',ours_data(:,1),ours_data(:,3),'-b','LineWidth',5);
% legend('LIF-CNN(RGB)','LIF-CNN(DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Moderate','Fontname', 'Times New Roman','FontSize',30);
% figure;
% 
% plot(novelo_data(:,1),novelo_data(:,4),'--c',ours_data(:,1),ours_data(:,4),'-k','LineWidth',5);
% legend('LIF-CNN(RGB)','LIF-CNN(DF)','Location','southwest','Fontname', 'Times New Roman','FontSize',30)
% xlabel('recall','Fontname', 'Times New Roman','FontSize',30);ylabel('precision','Fontname', 'Times New Roman','FontSize',30);
% title('Hard','Fontname', 'Times New Roman','FontSize',30);







% %存ap值
% file=fopen('E:\研究生\毕设\中期\二维检测\总结\其他方法的数据\二维\ap.txt','w');
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','ours_data',sum(ours_data(:,2))*100/41,sum(ours_data(:,3))*100/41,sum(ours_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','noloss',sum(noloss_data(:,2))*100/41,sum(noloss_data(:,3))*100/41,sum(noloss_data(:,4))*100/41);
% fprintf(file,'%s %2.2f %2.2f %2.2f\r\n','novelo',sum(novelo_data(:,2))*100/41,sum(novelo_data(:,3))*100/41,sum(novelo_data(:,4))*100/41);
% fclose(file);
% 
% 
% data2=[ours_data(:,2),noloss_data(:,2),novelo_data(:,2)];
% plot(ours_data(:,1),data2(:,2),'-*g',ours_data(:,1),data2(:,3),'-b',ours_data(:,1),data2(:,1),'-r','LineWidth',3);
% legend('nolossEasy','noveloEasy','oursEasy','Location','southwest');xlabel('recall');ylabel('precision');
% 
% figure;
% data3=[ours_data(:,3),noloss_data(:,3),novelo_data(:,3)];
% plot(ours_data(:,1),data3(:,2),'-*g',ours_data(:,1),data3(:,3),'-b',ours_data(:,1),data3(:,1),'-r','LineWidth',3);
% legend('nolossModerate','noveloModerate','oursModerate','Location','southwest');xlabel('recall');ylabel('precision');
% 
% figure;
% data4=[ours_data(:,4),noloss_data(:,4),novelo_data(:,4)];
% plot(ours_data(:,1),data4(:,2),'-*g',ours_data(:,1),data4(:,3),'-b',ours_data(:,1),data4(:,1),'-r','LineWidth',3);
% legend('nolossHard','noveloHard','oursHard','Location','southwest');xlabel('recall');ylabel('precision');


