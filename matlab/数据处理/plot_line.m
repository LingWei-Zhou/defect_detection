clear;clc;
x=[0:1:500];
y=kuozhan(x);
figure;
%xlabel('原始灰度值');

plot(x,y,'r','LineWidth',6);
xlabel('原始灰度值','Fontname', '宋体','FontSize',30);
ylabel('拉伸灰度值','Fontname', '宋体','FontSize',30);

hold on;