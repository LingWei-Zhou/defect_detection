function res = plot_ap_3d_fx(avod,data)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
figure;
res=0;
plot(avod(:,1),avod(:,2),'--g',avod(:,1),data(:,2),'-r',avod(:,1),avod(:,3),'--m',avod(:,1),data(:,3),'-b',avod(:,1),avod(:,4),'--c',avod(:,1),data(:,4),'-k','LineWidth',3);
% legend('AVODEasy','MDFF(DF)Easy','AVODModerate','MDFF(DF)Moderate','AVODHard','MDFF(DF)Hard','Location','southwest','Fontname', 'Times New Roman','FontSize',15);
% legend('AVODEasy','MDFF(FAFR)Easy','AVODModerate','MDFF(FAFR)Moderate','AVODHard','MDFF(FAFR)Hard','Location','southwest','Fontname', 'Times New Roman','FontSize',15);
% legend('AVODEasy','MDFF(3DF)Easy','AVODModerate','MDFF(3DF)Moderate','AVODHard','MDFF(3DF)Hard','Location','southwest','Fontname', 'Times New Roman','FontSize',15);
legend('AVODEasy','MDFFEasy','AVODModerate','MDFFModerate','AVODHard','MDFFHard','Location','southwest','Fontname', 'Times New Roman','FontSize',15);
xlabel('recall','Fontname', 'Times New Roman','FontSize',15);ylabel('precision','Fontname', 'Times New Roman','FontSize',15);
end

