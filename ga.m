clear all
clc
popsize=20;          %群体大小
chromlength=30;      %个体长度
pc=0.6950;           %交叉概率
pm=0.2;              %变异概率
pop=initpop(popsize,chromlength);  %随机产生初始群体
for i=1:20        %循环次数
    [objvalue]=calobjvalue(pop);   %计算目标函数值
    fitvalue=calfitvalue(objvalue);%计算群体中每个个体的适应度
    [newpop]=selection(pop,fitvalue);%复制
    [newpop]=crossover(pop,pc);      %交叉
    [newpop]=mutation(pop,pm);       %变异
    [bestindividual,bestfit]=best(pop,fitvalue);%求出群体中适应值最大的个体及其适应值
    y(i)=max(bestfit);
    n(i)=i;
    pop5=bestindividual;
    temp1=decodechrom(pop5,1,15);
    temp2=decodechrom(pop5,16,15);
    x1(i)=pi+temp1*pi/(2^15-1);
    x2(i)=pi+temp2*pi/(2^15-1);
    pop=newpop;
%      for j=1:20
%          k=1;
%          if abs(x1(j)+x2(j)-4)<=0.005
%              pop(k,:)=pop1(j,:);
%              k=k+1;
%          end
%          if k==20
%              break
%          end
%      end         
end
% fplot('sin(x1.^2.*x2)+cos(x1./x2)+3',[pi 2*pi])
% hold on
% plot(x,y,'r*')
fmax=max(y);


    
   