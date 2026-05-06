clear all;clc
load vWT2011;
vWT=vWT2011;                                   %2011年全年风速，每15分钟取一个点
vav=sum(vWT)/length(vWT);                      %年平均风速
v=[];                                          %v为全年8760h的风速，每1h取一个点
for i=3
    for j=1:8760
        v(j)=vWT(i);
        i=i+4;
    end
end
%%                                        %获得额定功率400kW风机出力
vc=0.5;vr=11;vF=25;PR=400;                      %切断风速3m/s,额定风速11m/s,截断风速25m/s
for i=1:length(v)
if (v(i)>=vc)&(v(i)<vr)
    Pwt(i)=PR*(v(i)-vc)/(vr-vc);
elseif(v(i)>=vr)&(v(i)<=vF)
    Pwt(i)=PR;
else
    Pwt(i)=0;
end
end                                                                
figure(1);plot(1:8760,Pwt);xlim([0 8760]);         %全年风机出力 
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}风机出力/\fontname{Times new roman}kW'])
%%                                           %获得额定功率为200kW的光伏出力、
load Ppv2011;
Ppv=Ppv2011;
figure(2);plot(1:8760,Ppv);xlim([0 8760]);         %全年光伏出力
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
%%                                           %获得夏季、过渡季、冬季光伏出力                                                
j=3000;                                             %夏季200kW光伏出力（3000-5232h）
for n=1:100
    m=1;
    for k=1:8760
        Ppvs(n,m)=Ppv(j);
        m=m+1;
        j=j+1;
        if m==26
            break
        end
    end
    j=j-1;
    if j==5232
        break
    end
end
for i=1:93                                      %夏季200kW光伏出力
       figure(3);plot(1:24,Ppvs(i,2:25)),xlim([1 24]);hold on
end
%%                                        %过渡季200kW光伏出力                                          
j=1296;                                         %春季200kW光伏出力（1296-3000h）
for n=1:100
    m=1;
    for k=1:8760
        Ppvsp(n,m)=Ppv(j);
        m=m+1;
        j=j+1;
        if m==26
            break
        end
    end
    j=j-1;
    if j==3000
        break
    end
end
for i=1:71                                      %春季200kW光伏出力                        
        figure(4);plot(1:24,Ppvsp(i,2:25)),xlim([1 24]);hold on
end
%%                                        %秋季200kW光伏出力（5232-7416h）
j=5232;
for n=1:100
    m=1;
    for k=1:8760
        Ppva(n,m)=Ppv(j);
        m=m+1;
        j=j+1;
        if m==26
            break
        end
    end
    j=j-1;
    if j==7416
        break
    end
end
for i=1:91                                      %秋季200kW光伏出力                         
       figure(4);plot(1:24,Ppva(i,2:25)),xlim([1 24]);hold on
end
Ppvinter=[Ppvsp;Ppva];
%%                                        %冬季200kW光伏出力
j=7416;
for n=1:100
    m=1;
    for k=1:8760
        Ppvw1(n,m)=Ppv(j);
        m=m+1;
        j=j+1;
        if m==26
            break
        end
    end
    j=j-1;
    if j==8760
        break
    end
end
for i=1:56                                     %冬季200kW光伏出力                  
       figure(5);plot(1:24,Ppvw1(i,1:24)),xlim([1 24]);hold on
end
%%
j=1;
for n=1:54
    m=1;
    for k=1:8760
        Ppvw2(n,m)=Ppv(j);
        m=m+1;
        j=j+1;
        if m==26
            break
        end
    end
    j=j-1;
    if j==1296
        break
    end
end
for i=1:54                             %冬季200kW光伏出力
      figure(5);plot(1:24,Ppvw2(i,1:24)),xlim([1 24]);hold on
end
Ppvw=[Ppvw1;Ppvw2];
%%                                %采用K-means聚类生成各季节典型日矗立曲线
data=Ppvs;
%%                                        %夏季光伏出力削减
TyDa=zeros(6,24);                               %一年提取6个典型日
N=2;                                            %设置聚类数目
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N,n);                              %初始化聚类中心
for x=1:N
    center(x,:)=data( randi(m,1),:);            %第一次随机产生聚类中心
end
pattern(:,1:n)=data(:,:);
while 1
distence=zeros(1,N);
num=zeros(1,N);
new_center=zeros(N,n);
for x=1:m
    for y=1:N
    distence(y)=norm(data(x,:)-center(y,:));    %计算到每个类的距离
    end
    [~, temp]=min(distence);                    %求最小的距离
    pattern(x,n+1)=temp;         
end
k=0;
for y=1:N
    for x=1:m
        if pattern(x,n+1)==y
           new_center(y,:)=new_center(y,:)+pattern(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1
        k=k+1;
    end
end
if k==N
     break;
else
     center=new_center;
end
end
[m, n]=size(pattern);
cen1s=0;cen2s=0;
for i=1:m
    if pattern(i,n)==1 
         cen1s=cen1s+1;
    else pattern(i,n)==2
         cen2s=cen2s+1;
end
end
figure(6);plot(1:24,center(1,2:25),'r');xlim([1 24]);hold on
figure(6);plot(1:24,center(2,2:25),'b');xlim([1 24]);
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
cen1s=cen1s/m;
cen2s=cen2s/m;                                   %计算各个场景出现的概率
%%                                         %过渡季光伏出力削减
data=Ppvinter;
N=2;                                             %设置聚类数目
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N,n);                               %初始化聚类中心
for x=1:N
    center(x,:)=data( randi(m,1),:);             %第一次随机产生聚类中心
end
pattern(:,1:n)=data(:,:);
while 1
distence=zeros(1,N);
num=zeros(1,N);
new_center=zeros(N,n);
for x=1:m
    for y=1:N
    distence(y)=norm(data(x,:)-center(y,:));    %计算到每个类的距离
    end
    [~, temp]=min(distence);                    %求最小的距离
    pattern(x,n+1)=temp;         
end
k=0;
for y=1:N
    for x=1:m
        if pattern(x,n+1)==y
           new_center(y,:)=new_center(y,:)+pattern(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1
        k=k+1;
    end
end
if k==N
     break;
else
     center=new_center;
end
end
[m, n]=size(pattern);
cen1inter=0;cen2inter=0;
for i=1:m
    if pattern(i,n)==1 
         cen1inter=cen1inter+1;
    else pattern(i,n)==2
         cen2inter=cen2inter+1;
end
end
figure(7);plot(1:24,center(1,2:25),'r');xlim([1 24]);hold on
figure(7);plot(1:24,center(2,2:25),'b');xlim([1 24]);
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
cen1inter=cen1inter/m;
cen2inter=cen2inter/m;                                    %计算各个场景出现的概率
%%                                                 %冬季季光伏出力削减
data=Ppvw;
N=2;                                            %设置聚类数目
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N,n);                              %初始化聚类中心
for x=1:N
    center(x,:)=data( randi(m,1),:);            %第一次随机产生聚类中心
end
pattern(:,1:n)=data(:,:);
while 1
distence=zeros(1,N);
num=zeros(1,N);
new_center=zeros(N,n);
for x=1:m
    for y=1:N
    distence(y)=norm(data(x,:)-center(y,:));    %计算到每个类的距离
    end
    [~, temp]=min(distence);                    %求最小的距离
    pattern(x,n+1)=temp;         
end
k=0;
for y=1:N
    for x=1:m
        if pattern(x,n+1)==y
           new_center(y,:)=new_center(y,:)+pattern(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1
        k=k+1;
    end
end
if k==N
     break;
else
     center=new_center;
end
end
[m, n]=size(pattern);
cen1w=0;cen2w=0;
for i=1:m
    if pattern(i,n)==1 
         cen1w=cen1w+1;
    else pattern(i,n)==2
         cen2w=cen2w+1;
end
end
figure(8)
plot(1:24,center(1,1:24),'r');xlim([1 24]);hold on
plot(1:24,center(2,1:24),'b');xlim([1 24]);
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
cen1w=cen1w/m;
cen2w=cen2w/m;                                   %计算各个场景出现的概率
%%%%%%%%%%%%%%%%%%%%%%%%%%获取高斯核函数f及其分布函数F%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
Ppvs=Ppvs(:,2:25);Ppvinter=Ppvinter(:,2:25);Ppvw=Ppvw(:,1:24);
YearPpv=[Ppvs;Ppvinter;Ppvw];
syms x y n a h f;
n=365;                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=7:20                     %07点至20点
y=YearPpv(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j-6)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1
end
%%
F11=0;
F_Ppv=zeros(n,24);
for k=1:14
    for j=1:n
     y(j)=YearPpv(j,k+6);
     a=YearPpv(:,k+6);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=YearPpv(i,k+6);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Ppv(i,k+6)=eval(F111(1,i));            %获取分布函数
    end
   F11=0;
end
%%
YearPwt=zeros(365,24);
i=1;
for j=1:365
      for k=1:24
            YearPwt(j,k)=Pwt(i);
            i=i+1;
      end
end
syms x y n a h f;
n=365;                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=1:24                     %07点至20点
y=YearPwt(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j)=subs(F,{'h','f'},{h_opt,0});       %代入数值计算F1
end
%%
F11=0;
F_Pwt=zeros(n,24);
for k=1:24
    for j=1:n
     y(j)=YearPwt(j,k);
     a=YearPwt(:,k);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=YearPwt(i,k);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Pwt(i,k)=eval(F111(1,i));         %获取分布函数
    end
   F11=0;
end
%%                                  %全年光伏出力
[n,m]=size(YearPpv);
for i=7:20                               %计算07点至20点
[xsort,id] = sort(F_Ppv(1:n,i));         %对X进行排序，xsort为分布函数排序
x=YearPpv(id,i);                         %x为光伏出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pv{i}=[x xsort];
end
A1=zeros(n,6);                    %计算1-6点
A2=zeros(n,4);                    %计算21-24点
A=[A1 A2];
B1=YearPwt(:,1:6);B2=YearPwt(:,21:24);
B=[B1 B2];
U=zeros(n,10);
for i=1:10
U(:,i)=ksdensity(A(:,i),A(:,i),'function','cdf');
V(:,i)=ksdensity(B(:,i),B(:,i),'function','cdf');
rho_norm=copulafit('Gaussian',[U(:,i),V(:,i)]);%极大似然估计
rho_normAD(k:k+1,:)=rho_norm;
k=k+2;
end
[n,m]=size(A1);
for i=1:m
[xsort,id] = sort(U(1:n,i));           %对X进行排序，xsort为分布函数排序
x=A(id,i);                             %为光伏出力排序
X=diff(xsort);                         %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pv{i}=[x xsort;1.2568,1];
end
[n,m]=size(A2);
for i=1:m
[xsort,id] = sort(U(1:n,i+6));           %对X进行排序，xsort为分布函数排序
x=A(id,i+6);                             %x为光伏出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pv{i+20}=[x xsort;0.1726,1];
end
%%                                %全年风机出力
[n,m]=size(YearPwt);
for i=1:m
[xsort,id] = sort(F_Pwt(1:n,i));       %对X进行排序，xsort为分布函数排序
x=YearPwt(id,i);                       %x为风机出力排序
X=diff(xsort);                         %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
wt{i}=[x xsort];
end
%%                                %采用三次样条插值函数Spline拟合分布函数,以07点为例
x1=pv{7}(:,1);
y1=pv{7}(:,2);
figure(9)
plot(x1,y1,'b*');hold on              %原始数据
xlabel(['\fontname{Times new roman}07:00\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
ylabel(['\fontname{宋体}累积分布函数\fontname{Times new roman}F(x)'])
y2=[0;y1;0];
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
 L=length(a1);
 x2=0:0.1:a1(L);
 n=length(x2);
 for i=1:L-1
    for j=1:n
        if (x2(j)>=a1(i))&(x2(j)<a1(i+1))
        s(j)=coe1(i,1)*(x2(j)-a1(i))^3+coe1(i,2)*(x2(j)-a1(i))^2+coe1(i,3)*(x2(j)-a1(i))+coe1(i,4);
        end
    end
 end
figure(9)
plot(x2,s,'r-','LineWidth',0.75);hold on   %三次样条插值结果
legend('原始数据','三次样条插值','Location','NorthWest')
%%                            %求解光伏出力各个时段累积分布函数的反函数
for i=1:24
x1=pv{i}(:,2);
y1=pv{i}(:,1);
y2=[0;y1;0];                      %三次样条插值
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
apv{i}=a1;coepv{i}=coe1;
end
%%                            %求解风机出力各个时段累积分布函数的反函数
for i=1:24
x1=wt{i}(:,2);
y1=wt{i}(:,1);
%%          三次样条插值
y2=[0;y1;0];
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
awt{i}=a1;coewt{i}=coe1;
end
%%                              %基于二元正态Copula函数建立每个时段的联合风光出力函数
X = YearPpv(:,7);                    %以7点钟为例
Y = YearPwt(:,7);
%%                              %采用MATLAB自带函数
% 调用ksdensity函数分别计算原始样本X和Y处的核分布估计值
U = ksdensity(X,X,'function','cdf');
V = ksdensity(Y,Y,'function','cdf');
%%                              %获得累积分布函数
U2 = ksdensity(X,X,'function','cdf');
V2 = ksdensity(Y,Y,'function','cdf');
[Xsort,id] = sort(X);               %为了作图的需要，对X进行排序
figure(10);                          %新建一个图形窗口
plot(Xsort,U2(id),'b-.','LineWidth',0.75);hold on 
[Txsort,Tid] = sort(F_Ppv(:,7));    %为了作图的需要，对X进行排序
x=YearPpv(:,7);                     %F_Ppv为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',0.75);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel(['\fontname{Times new roman}07:00\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
ylabel(['\fontname{宋体}累积分布函数\fontname{Times new roman}F(x)'])
[Ysort,id] = sort(Y);               %为了作图的需要，对Y进行排序
figure(11);                          %新建一个图形窗口
plot(Ysort,V2(id),'b-.','LineWidth',0.75);hold on
[Txsort,Tid] = sort(F_Pwt(:,7));    %为了作图的需要，对X进行排序
x=YearPwt(:,7);                     %F_Pwt为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',0.75);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); %加标注框
xlabel(['\fontname{Times new roman}07:00\fontname{宋体}风机出力/\fontname{Times new roman}kW'])
ylabel(['\fontname{宋体}累积分布函数\fontname{Times new roman}F(y)'])
%%
%***********************求Copula中参数的估计值******************************
% 调用copulafit函数估计二元正态Copula中的线性相关参数
a=F_Ppv(:,7);b=F_Pwt(:,7);
rho_norm = copulafit('Gaussian',[a,b]);%极大似然估计
%%
%********************绘制Copula的密度函数和分布函数图************************
[Udata,Vdata] = meshgrid(linspace(0,1,31));  %为绘图需要，产生新的网格数据
% 调用copulapdf函数计算网格点上的二元正态Copula密度函数值
Cpdf_norm = copulapdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
% 调用copulacdf函数计算网格点上的二元正态Copula分布函数值
Ccdf_norm = copulacdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
%%
% 绘制二元正态Copula的密度函数和分布函数图
figure(12);  %新建图形窗口
surf(Udata,Vdata,reshape(Cpdf_norm,size(Udata)));  %绘制二元正态Copula密度函数图
xlabel(['\fontname{宋体}光伏出力概率'])
ylabel(['\fontname{宋体}风机出力概率'])
zlabel(['\fontname{宋体}二元\fontname{Times new roman}Normal-Copula\fontname{宋体}概率密度函数值'])
figure(13);  %新建图形窗口
surf(Udata,Vdata,reshape(Ccdf_norm,size(Udata)));  %绘制二元正态Copula分布函数图
xlabel(['\fontname{宋体}光伏出力概率'])
ylabel(['\fontname{宋体}风机出力概率'])
zlabel(['\fontname{宋体}二元\fontname{Times new roman}Normal-Copula\fontname{宋体}累积分布函数值'])
%%                                    %二元Normal-Copula函数相关参数rho_normP
rho_normP=zeros(28,2);
k=1;
for i=1:14
a=F_Ppv(:,i+6);b=F_Pwt(:,i+6);
rho_norm=copulafit('Gaussian',[a,b]);      %极大似然估计
rho_normP(k:k+1,:)=rho_norm;
k=k+2;
end
rho=zeros(48,2);
rho=[rho_normAD(1:12,:);rho_normP;rho_normAD(13:20,:)];
%%                                   %对每个时段的联合分布函数进行随机抽样
N=10000;
CP=zeros(N,48);     
k=2;
for i=1:24
    C=copularnd('Gaussian',rho(k,1),N);
    C1= pv{1,i}(1,2)+ (pv{1,i}(end,2)-pv{1,i}(1,2)).*C(:,1);
    C2= wt{1,i}(1,2)+ (wt{1,i}(end,2)-wt{1,i}(1,2)).*C(:,2);
    CP(:,k-1:k)=[C1 C2];
    k=k+2;
end
%%                              %求解三次样条插值函数
syms x a coe;
s=sym('coe(i,1)*(x-a(i))^3+coe(i,2)*(x-a(i))^2+coe(i,3)*(x-a(i))+coe(i,4)');                  
cPpv=zeros(N,24);
cPpv1=zeros(N,1);
cPwt=zeros(N,24);
cPwt1=zeros(N,1);
for k=1:24
    for j=1:N
        L=length(pv{1,k});          %夏季光伏出力
        L1=length(wt{1,k});         %夏季风机出力
        for i=1:L-1                  
            if (CP(j,2*k-1)>=pv{1,k}(i,2))&(CP(j,2*k-1)<pv{1,k}(i+1,2))
             s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apv{1,k}(i),coepv{1,k}(i,1),coepv{1,k}(i,2),coepv{1,k}(i,3),coepv{1,k}(i,4)});
             s2=subs(s1,{'x'},{CP(j,2*k-1)});
             cPpv1(j)=eval(s2);
            end
        end
        for i=1:L1-1                          
            if (CP(j,2*k)>=wt{1,k}(i,2))&(CP(j,2*k)<wt{1,k}(i+1,2))
            s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awt{1,k}(i),coewt{1,k}(i,1),coewt{1,k}(i,2),coewt{1,k}(i,3),coewt{1,k}(i,4)});
            s2=subs(s1,{'x'},{CP(j,2*k)});
            cPwt1(j)=eval(s2);
            end
        end
    end
    cPpv(1:N,k)=cPpv1;
    cPwt(1:N,k)=cPwt1;
end
%%                                 %采用K-means典型日光伏出力、风机出力曲线                
N1=6;                                   %设置聚类数目
data=cPpv;                              %光伏出力出力削减
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N1,n);                     %初始化聚类中心
for x=1:N1
    center(x,:)=data( randi(N,1),:);    %第一次随机产生聚类中心
end
pattern(:,1:n)=data(:,:);
while 1
distence=zeros(1,N1);
num=zeros(1,N1);
new_center=zeros(N1,n);
for x=1:m
    for y=1:N1
    distence(y)=norm(data(x,:)-center(y,:));    %计算到每个类的距离
    end
    [~, temp]=min(distence);                    %求最小的距离
    pattern(x,n+1)=temp;         
end
k=0;
for y=1:N1
    for x=1:m
        if pattern(x,n+1)==y
           new_center(y,:)=new_center(y,:)+pattern(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1
        k=k+1;
    end
end
if k==N1
     break;
else
     center=new_center;
end
end
[m, n]=size(pattern);
cen1=0;cen2=0;cen3=0;cen4=0;cen5=0;cen6=0;
for i=1:m
    if pattern(i,n)==1 
         cen1=cen1+1;
    elseif pattern(i,n)==2
         cen2=cen2+1;
    elseif pattern(i,n)==3
         cen3=cen3+1;
    elseif pattern(i,n)==4
         cen4=cen4+1;
    elseif pattern(i,n)==5
         cen5=cen5+1;
    else pattern(i,n)==6
         cen6=cen6+1;
    end
end
centerpv=center;
figure(14);
plot(1:24,center(1,:),'g-*','MarkerSize',3,'LineWidth',0.75);xlim([1 24]);hold on
plot(1:24,center(2,:),'m-o','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(3,:),'b-+','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(4,:),'c-x','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(5,:),'k-^','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(6,:),'r-square','MarkerSize',3,'LineWidth',0.75);
legend('场景1','场景2','场景3','场景4','场景5','场景6', 'Location','NorthWest');
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
cen1=cen1/m;
cen2=cen2/m;                                    %计算各个场景出现的概率
cen3=cen3/m;
cen4=cen4/m;    
cen5=cen5/m;
cen6=cen6/m;    
%%                                        %光伏&风机出力组合聚类以保证关联性及各场景出现的概率相同
N1=6;                                           %设置聚类数目
Data=[cPpv cPwt];
[m,n]=size(Data);
pattern=zeros(m,n+1);
center=zeros(N1,n);                             %初始化聚类中心
for x=1:N1
    center(x,:)=Data( randi(N,1),:);            %第一次随机产生聚类中心
end
pattern(:,1:n)=Data(:,:);
while 1
distence=zeros(1,N1);
num=zeros(1,N1);
new_center=zeros(N1,n);
for x=1:m
    for y=1:N1
    distence(y)=norm(Data(x,:)-center(y,:));    %计算到每个类的距离
    end
    [~, temp]=min(distence);                    %求最小的距离
    pattern(x,n+1)=temp;         
end
k=0;
for y=1:N1
    for x=1:m
        if pattern(x,n+1)==y
           new_center(y,:)=new_center(y,:)+pattern(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1
        k=k+1;
    end
end
if k==N1
     break;
else
     center=new_center;
end
end
[m, n]=size(pattern);
cen1=0;cen2=0;cen3=0;cen4=0;cen5=0;cen6=0;
for i=1:m
    if pattern(i,n)==1 
         cen1=cen1+1;
    elseif  pattern(i,n)==2
         cen2=cen2+1;
    elseif pattern(i,n)==3
         cen3=cen3+1;
    elseif pattern(i,n)==4
         cen4=cen4+1;
    elseif pattern(i,n)==5
         cen5=cen5+1;
         else  pattern(i,n)==6
         cen6=cen6+1;
end
end
T=center;
cen1=cen1/m;
cen2=cen2/m;                                  
cen3=cen3/m;
cen4=cen4/m;    
cen5=cen5/m;
cen6=cen6/m;                                    %计算各个场景出现的概率
%%                                        %风机出力削减
N1=6;                                           %设置聚类数目
data=cPwt;
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N1,n);                             %初始化聚类中心
for x=1:N1
    center(x,:)=data( randi(N,1),:);            %第一次随机产生聚类中心
end
pattern(:,1:n)=data(:,:);
while 1
distence=zeros(1,N1);
num=zeros(1,N1);
new_center=zeros(N1,n);
for x=1:m
    for y=1:N1
    distence(y)=norm(data(x,:)-center(y,:));    %计算到每个类的距离
    end
    [~, temp]=min(distence);                    %求最小的距离
    pattern(x,n+1)=temp;         
end
k=0;
for y=1:N1
    for x=1:m
        if pattern(x,n+1)==y
           new_center(y,:)=new_center(y,:)+pattern(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1
        k=k+1;
    end
end
if k==N1
     break;
else
     center=new_center;
end
end
[m, n]=size(pattern);
cen1=0;cen2=0;cen3=0;cen4=0;cen5=0;cen6=0;
for i=1:m
    if pattern(i,n)==1 
         cen1=cen1+1;
    elseif  pattern(i,n)==2
         cen2=cen2+1;
    elseif pattern(i,n)==3
         cen3=cen3+1;
    elseif pattern(i,n)==4
         cen4=cen4+1;
    elseif pattern(i,n)==5
         cen5=cen5+1;
         else  pattern(i,n)==6
         cen6=cen6+1;
end
end
figure(15);
centerwt=center;
plot(1:24,center(1,:),'g-*','MarkerSize',3,'LineWidth',0.75);xlim([1 24]);hold on
plot(1:24,center(2,:),'m-o','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(3,:),'b-+','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(4,:),'c-x','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(5,:),'k-^','MarkerSize',3,'LineWidth',0.75);hold on
plot(1:24,center(6,:),'r-square','MarkerSize',3,'LineWidth',0.75);
legend('场景1','场景2','场景3','场景4','场景5','场景6', 'Location','NorthWest');
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}风机出力/\fontname{Times new roman}kW'])
cen1=cen1/m;
cen2=cen2/m;                                  
cen3=cen3/m;
cen4=cen4/m;    
cen5=cen5/m;
cen6=cen6/m;                                    %计算各个场景出现的概率
%%







