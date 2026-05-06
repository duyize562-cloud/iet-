clear all;clc
load Ppvs;
x=Ppvs(:,7);
for i=1:93
    F1(i)=GKF1(x(i));
end
[xsort,id] = sort(F1);    %为了作图的需要，对X进行排序
figure;                   %新建一个图形窗口
plot(x(id),xsort,'k-.','LineWidth',2); 
F1=F1';
