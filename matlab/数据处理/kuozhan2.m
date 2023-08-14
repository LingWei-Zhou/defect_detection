function [outputArg1] = kuozhan2(inputArg1)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
n=10;%与后半截的斜率有关
t=100;%分界点
outputArg1=zeros(1,length(inputArg1));
for i=1:length(inputArg1)
 if inputArg1(i)==0
    outputArg1(i)=255;
 elseif inputArg1(i)>t
    outputArg1(i)=255-(55*n./(inputArg1(i)-(t-n)));
 else
    outputArg1(i)=2*inputArg1(i);
 end
end
end

