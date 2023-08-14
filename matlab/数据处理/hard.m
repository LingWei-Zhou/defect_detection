function res = hard(data)
%UNTITLED2 此处显示有关此函数的摘要
% 判断是不是mid hard样本
%   此处显示详细说明
 res=-1;
 truncation=data(1);
 occlusion=data(2);
 h=data(7)-data(5);
%  if h<=25
%      res=1;
%  end
%  if truncation>=0.3
%      res=1;
%  end
%  if occlusion>=1
%      res=1;
%  end
%  if truncation>=0.5
%      res=2;
%  end
%  if occlusion>=2
%      res=2;
%  end
%  if h>50
%      res=0;%太大了就算了
%  end

%必须反着写，不然很多都满足res=2的条件
if occlusion<=2&&truncation<=0.5&&h>25
     res=2;
end
if occlusion<=1&&truncation<=0.3&&h>25
     res=1;
end
if occlusion<=0&&truncation<=0&&h>40
     res=0;
end
if h>300
     res=0;%太大了就算了,会出错
 end
end

