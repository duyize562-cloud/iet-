clear all;clc
load Ppvs;
load Pwts;
load F_Ppv;
load F_Pwt;
X = Ppvs(:,12);                    %以7点钟为例
Y = Pwts(:,12);
%%                            %采用MATLAB自带函数
% 调用ksdensity函数分别计算原始样本X和Y处的核分布估计值
U = ksdensity(X,X,'function','cdf');
V = ksdensity(Y,Y,'function','cdf');
%%                            获得累积分布函数
U2 = ksdensity(X,X,'function','cdf');
V2 = ksdensity(Y,Y,'function','cdf');
[Xsort,id] = sort(X);  % 为了作图的需要，对X进行排序
figure(1);  % 新建一个图形窗口
plot(Xsort,U2(id),'b-.','LineWidth',1.5);hold on 
[Txsort,Tid] = sort(F_Ppv(1:93,12));    %为了作图的需要，对X进行排序
x=Ppvs(1:93,12);                        %F_Ppv为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',1.5);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel('07:00光伏出力/kW');  
ylabel('累积分布函数F(x)'); 
[Ysort,id] = sort(Y);  % 为了作图的需要，对Y进行排序
figure(2);  % 新建一个图形窗口
plot(Ysort,V2(id),'b-.','LineWidth',1.5);hold on
[Txsort,Tid] = sort(F_Pwt(1:93,12));    %为了作图的需要，对X进行排序
x=Pwts(1:93,12);                        %F_Pwt为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',1.5);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel('07:00风机出力/kW');  
ylabel('累积分布函数F(x)'); 
%%
%***********************求Copula中参数的估计值******************************
% 调用copulafit函数估计二元正态Copula中的线性相关参数
a=F_Ppv(1:93,7);b=F_Pwt(1:93,12);
rho_norm = copulafit('Gaussian',[a,b]);%极大似然估计求积矩相关系数（Pearson）
%%
%********************绘制Copula的密度函数和分布函数图************************
[Udata,Vdata] = meshgrid(linspace(0,1,100));  % 为绘图需要，产生新的网格数据
% 调用copulapdf函数计算网格点上的二元正态Copula密度函数值
Cpdf_norm = copulapdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
% 调用copulacdf函数计算网格点上的二元正态Copula分布函数值
Ccdf_norm = copulacdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
%%
% 绘制二元正态Copula的密度函数和分布函数图
figure(3);  % 新建图形窗口
surf(Udata,Vdata,reshape(Cpdf_norm,size(Udata)));  % 绘制二元正态Copula密度函数图
xlabel('光伏出力概率');  % 为X轴加标签
ylabel('风机出力概率');  % 为Y轴加标签
zlabel('二元Normal-Copula概率密度函数值');  % 为z轴加标签
figure(4);  % 新建图形窗口
surf(Udata,Vdata,reshape(Ccdf_norm,size(Udata)));  % 绘制二元正态Copula分布函数图
xlabel('光伏出力概率');  % 为X轴加标签
ylabel('风机出力概率');  % 为Y轴加标签
zlabel('二元Normal-Copula累积分布函数值');  % 为z轴加标签
%%
%**************求Kendall秩相关系数和Spearman秩相关系数***********************
% 调用copulastat函数求二元正态Copula对应的Kendall秩相关系数
Kendall_norm = copulastat('Gaussian',rho_norm)
% 调用copulastat函数求二元正态Copula对应的Spearman秩相关系数
Spearman_norm = copulastat('Gaussian',rho_norm,'type','Spearman')