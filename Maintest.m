clc;
clear;
T=24;
speed0=zeros(2*T,1);
speed0=xlsread('wind.xls',1,'I2:I49');%读取风速
speed=zeros(T,1);
for i=1:T
   speed(i)=(speed0(2*i-1)+speed0(2*i))/2; 
end%记算每小时的平均风速

tic;
[scenario,pro]=genpowersce(speed,100);%根据风速生成100个场景，每个场景的概率是pro

scenario=scenario/100;%除以100是换算成MW之类的单位,不记得了，这不是重点
[w,q]=fastforward(scenario',pro',10);%将100个场景削减成10个场景，场景对应的概率是q（核心程序）
tottime=toc
rew=w';
