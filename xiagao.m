%%                         %获取高斯核函数f及其分布函数F
clear all;clc
load YearPpv;
syms x y n a h f;
%%                         %进行季节性划分
n=93;                          %夏季天数                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=7:20                     %07点至20点
y=YearPpv(1:n,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                   %采用经验带宽公式
F1s(j-6)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1inter
end
%%
n=162;                         %过渡季天数                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=7:20                     %07点至18点
y=YearPpv(94:255,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                   %采用经验带宽公式
F1inter(j-6)=subs(F,{'h','f'},{h_opt,0}); %代入数值计算F1s
end
%%
n=110;                         %冬季天数                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=7:18                     %07点至20点
y=YearPpv(256:365,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);               %采用经验带宽公式
F1w(j-6)=subs(F,{'h','f'},{h_opt,0}); %代入数值计算F1w
end
%%
n=93;                                 %夏季
F11=0;
F_Ppvs=zeros(n,14);
for k=1:14
    for j=1:n
     y(j)=YearPpv(j,k+6);
     a=YearPpv(1:n,k+6);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1s(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=YearPpv(i,k+6);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Ppvs(i,k)=eval(F111(1,i));       %获取分布函数
    end
   F11=0;
end
A=zeros(n,10);
U=zeros(n,10);
for i=1:10
U(:,i)=ksdensity(A(:,i),A(:,i),'function','cdf');
end
F_Ppvs=[U(:,1:6) F_Ppvs U(:,7:10)];
%%
n=162;                                    %过渡季
F11=0;
F_Ppvinter=zeros(n,14);
for k=1:14
    for j=94:255
     y(j)=YearPpv(j,k+6);
     a=YearPpv(94:255,k+6);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1inter(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=94:255
     x(i)=YearPpv(i,k+6);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Ppvinter(i,k)=eval(F111(1,i));    %获取分布函数
    end
   F11=0;
end
A=zeros(n,10);
U=zeros(n,10);
for i=1:10
U(:,i)=ksdensity(A(:,i),A(:,i),'function','cdf');
end
F_Ppvinter=[U(:,1:6) F_Ppvinter U(:,7:10)];
%%
n=110;                                     %冬季
F11=0;
F_Ppvw=zeros(n,12);
for k=1:12
    for j=256:365
     y(j)=YearPpv(j,k+6);
     a=YearPpv(256:365,k+6);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1w(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=256:365
     x(i)=YearPpv(i,k+6);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Ppvw(i,k)=eval(F111(1,i));       %获取分布函数
    end
   F11=0;
end
A=zeros(n,12);
U=zeros(n,12);
for i=1:12
U(:,i)=ksdensity(A(:,i),A(:,i),'function','cdf');
end
F_Ppvw=[U(:,1:6) F_Ppvw U(:,7:12)];
%%
load YearPwt;
syms x y n a h f;
%%                         %进行季节性划分
n=93;                          %夏季天数                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=1:24                     %07点至20点
y=YearPwt(1:n,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                 %采用经验带宽公式
F1s(j)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1s
end
%%
n=162;                         %过渡季天数                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=1:24                     %07点至20点
y=YearPwt(94:255,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                 %采用经验带宽公式
F1inter(j)=subs(F,{'h','f'},{h_opt,0}); %代入数值计算F1inter
end
%%
n=110;                         %冬季天数                           
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=1:24                     %07点至18点
y=YearPwt(256:365,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);             %采用经验带宽公式
F1w(j)=subs(F,{'h','f'},{h_opt,0}); %代入数值计算F1s
end
%%
n=93;                               %夏季
F11=0;
F_Pwts=zeros(n,24);
for k=1:24
    for j=1:n
     y(j)=YearPwt(j,k);
     a=YearPwt(1:n,k);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1s(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=YearPwt(i,k);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Pwts(i,k)=eval(F111(1,i));         %获取分布函数
    end
   F11=0;
end
%%
n=162;                                    %过渡季
F11=0;
F_Pwtinter=zeros(n,24);
for k=1:24
    for j=94:255
     y(j)=YearPwt(j,k);
     a=YearPwt(94:255,k);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1inter(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=94:255
     x(i)=YearPwt(i,k);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Pwtinter(i,k)=eval(F111(1,i));     %获取分布函数
    end
   F11=0;
end
%%
n=110;                                     %冬季
F11=0;
F_Pwtw=zeros(n,24);
for k=1:24
    for j=256:365
     y(j)=YearPwt(j,k);
     a=YearPwt(256:365,k);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1w(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=256:365
     x(i)=YearPwt(i,k);
     F111(i)=subs(F11,{'x'},{x(i)});
     F_Pwtw(i,k)=eval(F111(1,i));        %获取分布函数
    end
   F11=0;
end
%%                                  %夏季光伏出力
Ppvs=YearPpv(1:93,:);
for i=1:24                              
[xsort,id]=sort(F_Ppvs(1:93,i));         %对X进行排序，xsort为分布函数排序
x=Ppvs(id,i);                            %x为光伏出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pvs{i}=[x xsort];
end
%%                                  %过渡季光伏出力
Ppvinter=YearPpv(94:255,:);
for i=1:24                              
[xsort,id]=sort(F_Ppvinter(1:162,i));    %对X进行排序，xsort为分布函数排序
x=Ppvinter(id,i);                        %x为光伏出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pvinter{i}=[x xsort];
end
%%                                  %冬季光伏出力
Ppvw=YearPpv(256:365,:);
for i=1:24                           
[xsort,id]=sort(F_Ppvw(1:110,i));        %对X进行排序，xsort为分布函数排序
x=Ppvw(id,i);                            %x为光伏出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pvw{i}=[x xsort];
end
%%                                  %夏季风机出力
Pwts=YearPwt(1:93,:);
for i=1:24                               
[xsort,id]=sort(F_Pwts(1:93,i));         %对X进行排序，xsort为分布函数排序
x=Pwts(id,i);                            %x为风机出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
wts{i}=[x xsort];
end
%%                                  %过渡季风机出力
Pwtinter=YearPwt(94:255,:);
for i=1:24                            
[xsort,id]=sort(F_Pwtinter(1:162,i));    %对X进行排序，xsort为分布函数排序
x=Pwtinter(id,i);                        %x为风机出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
wtinter{i}=[x xsort];
end
%%                                  %冬季风机出力
Pwtw=YearPwt(256:365,:);
for i=1:24                        
[xsort,id]=sort(F_Pwtw(1:110,i));        %对X进行排序，xsort为分布函数排序
x=Pwtw(id,i);                            %x为光伏出力排序
X=diff(xsort);                           %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
wtw{i}=[x xsort];
end
%%                                  %采用三次样条插值函数Spline拟合分布函数,以12点为例
x1=pvs{12}(:,1);
y1=pvs{12}(:,2);
figure(1)
plot(x1,y1,'b*');hold on                 %原始数据
xlabel('12:00光伏出力/kW');  
ylabel('累积分布函数F(x)'); 
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
figure(1)
plot(x2,s,'r-','LineWidth',0.75);hold on   %三次样条插值结果
legend('原始数据','三次样条插值','Location','NorthWest')
%%                           %求解光伏出力各个时段累积分布函数的反函数
for i=1:14
x1=pvs{i+6}(:,2);
y1=pvs{i+6}(:,1);
y2=[0;y1;0];                      %三次样条插值
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
apvs{i}=a1;coepvs{i}=coe1;
end
%%
for i=1:14
x1=pvinter{i+6}(:,2);
y1=pvinter{i+6}(:,1);
y2=[0;y1;0];                      %三次样条插值
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
apvinter{i}=a1;coepvinter{i}=coe1;
end
%%
for i=1:12
x1=pvw{i+6}(:,2);
y1=pvw{i+6}(:,1);
y2=[0;y1;0];                      %三次样条插值
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
apvw{i}=a1;coepvw{i}=coe1;
end
%%                           %求解风机出力各个时段累积分布函数的反函数
for i=1:24
x1=wts{i}(:,2);
y1=wts{i}(:,1);
y2=[0;y1;0];                     %三次样条插值
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
awts{i}=a1;coewts{i}=coe1;
end
for i=1:24
x1=wtinter{i}(:,2);
y1=wtinter{i}(:,1);
y2=[0;y1;0];                     %三次样条插值
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
awtinter{i}=a1;coewtinter{i}=coe1;
end
for i=1:24
x1=wtw{i}(:,2);
y1=wtw{i}(:,1);
y2=[0;y1;0];                     %三次样条插值
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
awtw{i}=a1;coewtw{i}=coe1;
end
%%                              %基于二元正态Copula函数建立每个时段的联合风光出力函数
X = Ppvs(:,12);                      %以12点钟为例
Y = Pwts(:,12);
%%                              %采用MATLAB自带函数
% 调用ksdensity函数分别计算原始样本X和Y处的核分布估计值
U = ksdensity(X,X,'function','cdf');
V = ksdensity(Y,Y,'function','cdf');
%%                              %获得累积分布函数
U2 = ksdensity(X,X,'function','cdf');
V2 = ksdensity(Y,Y,'function','cdf');
[Xsort,id] = sort(X);               %为了作图的需要，对X进行排序
figure(2);                          %新建一个图形窗口
plot(Xsort,U2(id),'b-.','LineWidth',0.75);hold on 
[Txsort,Tid] = sort(F_Ppvs(:,12));    %为了作图的需要，对X进行排序
x=Ppvs(:,12);                     %F_Ppv为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',0.75);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel('12:00光伏出力/kW');  
ylabel('累积分布函数F(x)'); 
[Ysort,id] = sort(Y);                %为了作图的需要，对Y进行排序
figure(3);                           %新建一个图形窗口
plot(Ysort,V2(id),'b-.','LineWidth',0.75);hold on
[Txsort,Tid] = sort(F_Pwts(:,12));    %为了作图的需要，对X进行排序
x=Pwts(:,12);                     %F_Pwt为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',0.75);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); %加标注框
xlabel('12:00风机出力/kW');  
ylabel('累积分布函数F(x)'); 
%%
%***********************求Copula中参数的估计值******************************
% 调用copulafit函数估计二元正态Copula中的线性相关参数
a=F_Ppvs(:,12);b=F_Pwts(:,12);
rho_norm = copulafit('Gaussian',[a,b]);%极大似然估计求积矩相关系数（Pearson）
%%
%********************绘制Copula的密度函数和分布函数图************************
[Udata,Vdata] = meshgrid(linspace(0,1,31));  %为绘图需要，产生新的网格数据
% 调用copulapdf函数计算网格点上的二元正态Copula密度函数值
Cpdf_norm = copulapdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
% 调用copulacdf函数计算网格点上的二元正态Copula分布函数值
Ccdf_norm = copulacdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
%%
% 绘制二元正态Copula的密度函数和分布函数图
figure(4);  %新建图形窗口
surf(Udata,Vdata,reshape(Cpdf_norm,size(Udata)));  %绘制二元正态Copula密度函数图
xlabel('光伏出力概率');                     %为X轴加标签
ylabel('风机出力概率');                     %为Y轴加标签
zlabel('二元Normal-Copula概率密度函数值');   %为z轴加标签
figure(5);  %新建图形窗口
surf(Udata,Vdata,reshape(Ccdf_norm,size(Udata)));  %绘制二元正态Copula分布函数图
xlabel('光伏出力概率');                     %为X轴加标签
ylabel('风机出力概率');                     %为Y轴加标签
zlabel('二元Normal-Copula累积分布函数值');   %为z轴加标签
%%                                        %求二元Normal-Copula函数相关参数rho_norms
n=93;                                           %夏季
rho_norms=zeros(48,2);
k=1;
for i=1:24
a=F_Ppvs(:,i);b=F_Pwts(:,i);
rho_norm=copulafit('Gaussian',[a,b]);           %极大似然估计
rho_norms(k:k+1,:)=rho_norm;
k=k+2;
end
%%
n=162;                                          %过渡季
rho_norminter=zeros(48,2);
k=1;
for i=1:24
a=F_Ppvinter(:,i);b=F_Pwtinter(:,i);
rho_norm=copulafit('Gaussian',[a,b]);           %极大似然估计
rho_norminter(k:k+1,:)=rho_norm;
k=k+2;
end
%%
n=110;                                          %夏季
rho_normw=zeros(48,2);
k=1;
for i=1:24
a=F_Ppvw(:,i);b=F_Pwtw(:,i);
rho_norm=copulafit('Gaussian',[a,b]);           %极大似然估计
rho_normw(k:k+1,:)=rho_norm;
k=k+2;
end
%%                               %对每个时段的联合分布函数进行随机抽样
N=10000;
CPs=zeros(N,48);                    %夏季 
CPinter=zeros(N,48);                %过渡季 
CPw=zeros(N,48);                    %冬季 
k=2;
for i=1:24
    Cs=copularnd('Gaussian',rho_norms(k,1),N);          %夏季
    C1= pvs{1,i}(1,2)+ (pvs{1,i}(end,2)-pvs{1,i}(1,2)).*Cs(:,1);
    C2= wts{1,i}(1,2)+ (wts{1,i}(end,2)-wts{1,i}(1,2)).*Cs(:,2);
    CPs(:,k-1:k)=[C1 C2];
    Cinter=copularnd('Gaussian',rho_norminter(k,1),N);  %过渡季
    C1= pvinter{1,i}(1,2)+ (pvinter{1,i}(end,2)-pvinter{1,i}(1,2)).*Cinter(:,1);
    C2= wtinter{1,i}(1,2)+ (wtinter{1,i}(end,2)-wtinter{1,i}(1,2)).*Cinter(:,2);
    CPinter(:,k-1:k)=[C1 C2];
    Cw=copularnd('Gaussian',rho_normw(k,1),N);          %冬季 
    C1= pvw{1,i}(1,2)+ (pvw{1,i}(end,2)-pvw{1,i}(1,2)).*Cw(:,1);
    C2= wtw{1,i}(1,2)+ (wtw{1,i}(end,2)-wtw{1,i}(1,2)).*Cw(:,2);
    CPw(:,k-1:k)=[C1 C2];
    k=k+2;
end
%%                              %求解三次样条插值函数
syms x a coe;
s=sym('coe(i,1)*(x-a(i))^3+coe(i,2)*(x-a(i))^2+coe(i,3)*(x-a(i))+coe(i,4)');                  
cPpvs=zeros(N,24);
cPpvinter=zeros(N,24);
cPpvw=zeros(N,24);
cPpvs1=zeros(N,1);cPpvinter1=zeros(N,1);cPpvw1=zeros(N,1);
cPwts=zeros(N,24);
cPwtinter=zeros(N,24);
cPwtw=zeros(N,24);
cPwts1=zeros(N,1);cPwtinter1=zeros(N,1);cPwtw1=zeros(N,1);
for k=1:24
    for j=1:N
        Ls=length(wts{1,k});             %夏季风机出力
        Linter=length(wtinter{1,k});     %过渡季风机出力
        Lw=length(wtw{1,k});             %过渡季风机出力
        for i=1:Ls-1                          
            if (CPs(j,2*k)>=wts{1,k}(i,2))&(CPs(j,2*k)<wts{1,k}(i+1,2))
            s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awts{1,k}(i),coewts{1,k}(i,1),coewts{1,k}(i,2),coewts{1,k}(i,3),coewts{1,k}(i,4)});
            s2=subs(s1,{'x'},{CPs(j,2*k)});
            cPwts1(j)=eval(s2);
            end
        end
        for i=1:Linter-1                          
            if (CPinter(j,2*k)>=wtinter{1,k}(i,2))&(CPinter(j,2*k)<wtinter{1,k}(i+1,2))
            s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awtinter{1,k}(i),coewtinter{1,k}(i,1),coewtinter{1,k}(i,2),coewtinter{1,k}(i,3),coewtinter{1,k}(i,4)});
            s2=subs(s1,{'x'},{CPinter(j,2*k)});
            cPwtinter1(j)=eval(s2);
            end
        end
        for i=1:Lw-1                          
            if (CPw(j,2*k)>=wtw{1,k}(i,2))&(CPw(j,2*k)<wtw{1,k}(i+1,2))
            s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awtw{1,k}(i),coewtw{1,k}(i,1),coewtw{1,k}(i,2),coewtw{1,k}(i,3),coewtw{1,k}(i,4)});
            s2=subs(s1,{'x'},{CPw(j,2*k)});
            cPwtw1(j)=eval(s2);
            end
        end
    end
    cPwts(1:N,k)=cPwts1;
    cPwtinter(1:N,k)=cPwtinter1;
    cPwtw(1:N,k)=cPwtw1;
end
%%
for k=7:20
    for j=1:N
        Ls=length(pvs{1,k});            %夏季光伏出力
        Linter=length(pvinter{1,k});    %过渡季光伏出力
        for i=1:Ls-1                  
            if (CPs(j,2*k-1)>=pvs{1,k}(i,2))&(CPs(j,2*k-1)<pvs{1,k}(i+1,2))
             s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apvs{1,k}(i),coepvs{1,k}(i,1),coepvs{1,k}(i,2),coepvs{1,k}(i,3),coepvs{1,k}(i,4)});
             s2=subs(s1,{'x'},{CPs(j,2*k-1)});
             cPpvs1(j)=eval(s2);
            end
        end
        for i=1:Linter-1                  
            if (CPinter(j,2*k-1)>=pvinter{1,k}(i,2))&(CPinter(j,2*k-1)<pvinter{1,k}(i+1,2))
             s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apvinter{1,k}(i),coepvinter{1,k}(i,1),coepvinter{1,k}(i,2),coepvinter{1,k}(i,3),coepvinter{1,k}(i,4)});
             s2=subs(s1,{'x'},{CPinter(j,2*k-1)});
             cPpvinter1(j)=eval(s2);
            end
        end
    end
    cPpvs(1:N,k)=cPpvs1;
    cPpvinter(1:N,k)=cPpvinter1;
end
cPpvs=[zeros(93,6) cPpvs zeros(93,4)];
cPpvinter=[zeros(93,6) cPpvinter zeros(93,4)];
for k=7:18
    for j=1:N
        Lw=length(pvw{1,k});            %冬季光伏出力
        for i=1:Lw-1                  
            if (CPw(j,2*k-1)>=pvw{1,k}(i,2))&(CPw(j,2*k-1)<pvw{1,k}(i+1,2))
             s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apvw{1,k}(i),coepvw{1,k}(i,1),coepvw{1,k}(i,2),coepvw{1,k}(i,3),coepvw{1,k}(i,4)});
             s2=subs(s1,{'x'},{CPw(j,2*k-1)});
             cPpvw1(j)=eval(s2);
            end
        end
    end
    cPpvw(1:N,k)=cPpvw1;
end
cPpvw=[zeros(93,6) cPpvs zeros(93,6)];
%%                                 %采用K-means典型日光伏出力、风机出力曲线                
N1=2;                                   %设置聚类数目
data=[cPpvs cPwts];                           
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
cen1=0;cen2=0;
for i=1:m
    if pattern(i,n)==1 
         cen1=cen1+1;
    else pattern(i,n)==2
         cen2=cen2+1;
    end
end
centers=center;
figure(6);
plot(1:24,center(1,1:24),'r');xlim([1 24]);hold on
plot(1:24,center(2,1:24),'b');hold on
figure(7);
plot(1:24,center(1,25:48),'r');xlim([1 24]);hold on
plot(1:24,center(2,25:48),'b');hold on
cen1s=cen1/m;
cen2s=cen2/m;                                   %计算各个场景出现的概率  
%%
N1=2;                                   %设置聚类数目
data=[cPpvinter cPwtinter];                           
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
cen1=0;cen2=0;
for i=1:m
    if pattern(i,n)==1 
         cen1=cen1+1;
    else pattern(i,n)==2
         cen2=cen2+1;
    end
end
centerinter=center;
figure(9);
plot(1:24,center(1,1:24),'r');xlim([1 24]);hold on
plot(1:24,center(2,1:24),'b');hold on
figure(10);
plot(1:24,center(1,25:48),'r');xlim([1 24]);hold on
plot(1:24,center(2,25:48),'b');hold on
cen1inter=cen1/m;
cen2inter=cen2/m;                                   %计算各个场景出现的概率
%%
N1=2;                                   %设置聚类数目
data=[cPpvw cPwtw];                           
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
cen1=0;cen2=0;
for i=1:m
    if pattern(i,n)==1 
         cen1=cen1+1;
    else pattern(i,n)==2
         cen2=cen2+1;
    end
end
centerw=center;
figure(11);
plot(1:24,center(1,1:24),'r');xlim([1 24]);hold on
plot(1:24,center(2,1:24),'b');hold on
figure(12);
plot(1:24,center(1,25:48),'r');xlim([1 24]);hold on
plot(1:24,center(2,25:48),'b');hold on
cen1w=cen1/m;
cen2w=cen2/m;                                   %计算各个场景出现的概率  
%%





