clear all;clc
load F_Ppv.mat;%基于历史数据，考虑风电和光伏在不同季节（夏、冬、过渡季）以及不同时段的相关性，
               % 生成10000种可能的风光出力全天曲线，并最终用聚类算法提取出2个最具代表性的“典型场景”及它们出现的概率。
%%       夏季光伏出力
load Ppvs.mat; 
[n,m]=size(Ppvs);
for i=1:m
    [xsort,id] = sort(F_Ppv(1:n,i));       %为了作图的需要，对X进行排序，xsort为分布函数排序
    x=Ppvs(id,i);                          %为光伏出力排序
    X=diff(xsort);                         %剔除x和xsort中元素相同的点，只保留一个
    k=find(X==0);
    x(k)=[];
    xsort(k)=[];
    pvs{i}=[x xsort];
end
%%          采用三次样条插值函数Spline拟合分布函数,以07点为例
load pvs;
x1=pvs{7}(:,1);
y1=pvs{7}(:,2);
figure(1)
plot(x1,y1,'b*');hold on           %原始数据
xlabel('07:00光伏出力/kW');  
ylabel('累积分布函数F(x)'); 
y2=[0;y1;0];
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
x2=0:0.02:a1(56);
n_len=length(x2); 
s = zeros(1, n_len);
for i=1:55
    for j=1:n_len
        if (x2(j)>=a1(i)) && (x2(j)<a1(i+1))
            s(j)=coe1(i,1)*(x2(j)-a1(i))^3+coe1(i,2)*(x2(j)-a1(i))^2+coe1(i,3)*(x2(j)-a1(i))+coe1(i,4);
        end
    end
end
figure(1)
plot(x2,s,'r-','LineWidth',1.5);hold on   %三次样条插值结果
legend('原始数据','三次样条插值','Location','NorthWest')
%%       过渡季光伏出力
load Ppvinter.mat; 
[n,m]=size(Ppvinter);
for i=1:m
    [xsort,id] = sort(F_Ppv(94:255,i));       %为了作图的需要，对X进行排序，xsort为分布函数排序
    x=Ppvinter(id,i);                         %为光伏出力排序
    X=diff(xsort);                            %剔除x和xsort中元素相同的点，只保留一个
    k=find(X==0);
    x(k)=[];
    xsort(k)=[];
    pvinter{i}=[x xsort];
end
%%      冬季光伏出力
load Ppvw.mat; 
[n,m]=size(Ppvw);
for i=1:m
    [xsort,id] = sort(F_Ppv(256:365,i));       %为了作图的需要，对X进行排序，xsort为分布函数排序
    x=Ppvw(id,i);                              %为光伏出力排序
    X=diff(x);                                 %剔除x和xsort中元素相同的点，只保留一个
    k=find(X==0);
    x(k)=[];
    xsort(k)=[];
    pvw{i}=[x xsort];
end
%%                            求解光伏出力各个时段累积分布函数的反函数
%求解夏季光伏出力07至20点的三次样条插值的参数apvs和coepvs
for i=1:14
    x1=pvs{i+6}(:,2);
    y1=pvs{i+6}(:,1);
    %%          三次样条插值
    y2=[0;y1;0];
    pp=csape(x1',y2','second');
    [a1,coe1]=unmkpp(pp);
    apvs{i}=a1;coepvs{i}=coe1;
end
%%         求解过渡季光伏出力07至20点的三次样条插值的参数apvinter和coepvinter
for i=1:14
    x1=pvinter{i+6}(:,2);
    y1=pvinter{i+6}(:,1);
    %%          三次样条插值
    y2=[0;y1;0];
    pp=csape(x1',y2','second');
    [a1,coe1]=unmkpp(pp);
    apvinter{i}=a1;coepvinter{i}=coe1;
end
%%          求解冬季光伏出力07至18点的三次样条插值的参数apvw和coepvw
for i=1:12
    x1=pvw{i+6}(:,2);
    y1=pvw{i+6}(:,1);
    %%          三次样条插值
    y2=[0;y1;0];
    pp=csape(x1',y2','second');
    [a1,coe1]=unmkpp(pp);
    apvw{i}=a1;coepvw{i}=coe1;
end
%%                                风机出力
load F_Pwt.mat;
%%       夏季
load Pwts.mat; 
[n,m]=size(Pwts);
for i=1:m
    [xsort,id] = sort(F_Pwt(1:n,i));       %为了作图的需要，对X进行排序，xsort为分布函数排序
    x=Pwts(id,i);                          %为风机出力排序
    X=diff(xsort);                         %剔除x和xsort中元素相同的点，只保留一个
    k=find(X==0);
    x(k)=[];
    xsort(k)=[];
    wts{i}=[x xsort];
end
%%       过渡季
load Pwtinter.mat; 
[n,m]=size(Pwtinter);
for i=1:m
    [xsort,id] = sort(F_Pwt(94:255,i));       %为了作图的需要，对X进行排序，xsort为分布函数排序
    x=Pwtinter(id,i);                         %为风机出力排序
    X=diff(xsort);                            %剔除x和xsort中元素相同的点，只保留一个
    k=find(X==0);
    x(k)=[];
    xsort(k)=[];
    wtinter{i}=[x xsort];
end
%%      冬季
load Pwtw.mat; 
[n,m]=size(Pwtw);
for i=1:m
    [xsort,id] = sort(F_Pwt(256:365,i));       %为了作图的需要，对X进行排序，xsort为分布函数排序
    x=Pwtw(id,i);                          %为风机出力排序
    X=diff(x);                         %剔除x和xsort中元素相同的点，只保留一个
    k=find(X==0);
    x(k)=[];
    xsort(k)=[];
    wtw{i}=[x xsort];
end
%%                               
%%                            求解风机出力各个时段累积分布函数的反函数
%求解夏季风机出力的三次样条插值的参数awts和coewts
for i=1:24
    x1=wts{i}(:,2);
    y1=wts{i}(:,1);
    %%          三次样条插值
    y2=[0;y1;0];
    pp=csape(x1',y2','second');
    [a1,coe1]=unmkpp(pp);
    awts{i}=a1;coewts{i}=coe1;
end
%%         求解过渡季风机出力的三次样条插值的参数awtinter和coewtinter
for i=1:24
    x1=wtinter{i}(:,2);
    y1=wtinter{i}(:,1);
    %%          三样条插值
    y2=[0;y1;0];
    pp=csape(x1',y2','second');
    [a1,coe1]=unmkpp(pp);
    awtinter{i}=a1;coewtinter{i}=coe1;
end
%%          求解冬季风机出力的三次样条插值的参数awtw和coewtw
for i=1:24
    x1=wtw{i}(:,2);
    y1=wtw{i}(:,1);
    %%          三次样条插值
    y2=[0;y1;0];
    pp=csape(x1',y2','second');
    [a1,coe1]=unmkpp(pp);
    awtw{i}=a1;coewtw{i}=coe1;
end
%%                        基于二元正态Copula函数建立每个时段的联合风光出力函数
%采用极大似然估计法求每个时段风光出力的积矩相关系数（Pearson），然后求得斯皮尔曼相关系数Spearman
X = Ppvs(:,7);                    %以7点钟为例
Y = Pwts(:,7);
%%                            %采用MATLAB自带函数
% 调用ksdensity函数分别计算原始样本X和Y处的核分布估计值
U = ksdensity(X,X,'function','cdf');
V = ksdensity(Y,Y,'function','cdf');
%%                            获得累积分布函数
U2 = ksdensity(X,X,'function','cdf');
V2 = ksdensity(Y,Y,'function','cdf');
[Xsort,id] = sort(X);  % 为了作图的需要，对X进行排序
figure(2);  % 新建一个图形窗口
plot(Xsort,U2(id),'b-.','LineWidth',1.5);hold on 
[Txsort,Tid] = sort(F_Ppv(1:93,7));    %为了作图的需要，对X进行排序
x=Ppvs(1:93,7);                        %F_Ppv为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',1.5);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel('07:00光伏出力/kW');  
ylabel('累积分布函数F(x)'); 

[Ysort,id] = sort(Y);  % 为了作图的需要，对Y进行排序
figure(3);  % 新建一个图形窗口
plot(Ysort,V2(id),'b-.','LineWidth',1.5);hold on
[Txsort,Tid] = sort(F_Pwt(1:93,7));    %为了作图的需要，对X进行排序
x=Pwts(1:93,7);                        %F_Pwt为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',1.5);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel('07:00风机出力/kW');  
ylabel('累积分布函数F(x)'); 
%%
%***********************求Copula中参数的估计值******************************
% 调用copulafit函数估计二元正态Copula中的线性相关参数
a=F_Ppv(1:93,7);b=F_Pwt(1:93,7);
rho_norm = copulafit('Gaussian',[a,b]);%极大似然估计求积矩相关系数（Pearson）
%%
%********************绘制Copula的密度函数和分布函数图************************
[Udata,Vdata] = meshgrid(linspace(0,1,31));  % 为绘图需要，产生新的网格数据
% 调用copulapdf函数计算网格点上的二元正态Copula密度函数值
Cpdf_norm = copulapdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
% 调用copulacdf函数计算网格点上的二元正态Copula分布函数值
Ccdf_norm = copulacdf('Gaussian',[Udata(:), Vdata(:)],rho_norm);
%%
% 绘制二元正态Copula的密度函数和分布函数图
figure(4);  % 新建图形窗口
surf(Udata,Vdata,reshape(Cpdf_norm,size(Udata)));  % 绘制二元正态Copula密度函数图
xlabel('光伏出力概率');  % 为X轴加标签
ylabel('风机出力概率');  % 为Y轴加标签
zlabel('二元Normal-Copula概率密度函数值');  % 为z轴加标签
figure(5);  % 新建图形窗口
surf(Udata,Vdata,reshape(Ccdf_norm,size(Udata)));  % 绘制二元正态Copula分布函数图
xlabel('光伏出力概率');  % 为X轴加标签
ylabel('风机出力概率');  % 为Y轴加标签
zlabel('二元Normal-Copula累积分布函数值');  % 为z轴加标签
%%
%采用极大似然估计法求每个时段风光出力的积矩相关系数（Pearson）
%%      求解夏季07点至20点二元Normal-Copula函数相关参数rho_norms
rho_norms=zeros(28,2);
k=1;
for i=1:14
    a=F_Ppv(1:93,i+6);b=F_Pwt(1:93,i+6);
    rho_norm = copulafit('Gaussian',[a,b]);%极大似然估计
    rho_norms(k:k+1,:)=rho_norm;
    k=k+2;
end
%%     求解过渡季07点至20点二元Normal-Copula函数相关参数rho_norminter
rho_norminter=zeros(28,2);
k=1;
for i=1:14
    a=F_Ppv(94:255,i+6);b=F_Pwt(94:255,i+6);
    rho_norm = copulafit('Gaussian',[a,b]);%极大似然估计
    rho_norminter(k:k+1,:)=rho_norm;
    k=k+2;
end
%%     求解过渡季07点至18点二元Normal-Copula函数相关参数rho_normw
rho_normw=zeros(24,2);
k=1;
for i=1:12
    a=F_Ppv(256:365,i+6);b=F_Pwt(256:365,i+6);
    rho_norm = copulafit('Gaussian',[a,b]);%极大似然估计
    rho_normw(k:k+1,:)=rho_norm;
    k=k+2;
end
%%           对每个时段的联合分布函数进行随机抽样
N=10000;
Cs=zeros(N,28);          %夏季07至20点
k=2;
for i=1:14
    C=copularnd('Gaussian',rho_norms(k,1),N);
    C1= pvs{1,i+6}(1,2)+ (pvs{1,i+6}(end,2)-pvs{1,i+6}(1,2)).*C(:,1);
    C2= wts{1,i+6}(1,2)+ (wts{1,i+6}(end,2)-wts{1,i+6}(1,2)).*C(:,2);
    Cs(:,k-1:k)=[C1 C2];
    k=k+2;
end
%%
Cinter=zeros(N,28);          %过渡季07至20点
k=2;
for i=1:14
    C=copularnd('Gaussian',rho_norminter(k,1),N);
    C1= pvinter{1,i+6}(1,2)+ (pvinter{1,i+6}(end,2)-pvinter{1,i+6}(1,2)).*C(:,1);
    C2= wtinter{1,i+6}(1,2)+ (wtinter{1,i+6}(end,2)-wtinter{1,i+6}(1,2)).*C(:,2);
    Cinter(:,k-1:k)=[C1 C2];
    k=k+2;
end
%%
Cw=zeros(N,24);          %冬季07至18点
k=2;
for i=1:12
    C=copularnd('Gaussian',rho_normw(k,1),N);
    C1= pvw{1,i+6}(1,2)+ (pvw{1,i+6}(end,2)-pvw{1,i+6}(1,2)).*C(:,1);
    C2= wtw{1,i+6}(1,2)+ (wtw{1,i+6}(end,2)-wtw{1,i+6}(1,2)).*C(:,2);
    Cw(:,k-1:k)=[C1 C2];
    k=k+2;
end

%%                        %求解夏季07至20点具有相关性的光伏与风机出力cPpvs,cPwts
cPpvs=zeros(N,14);
cPpvs1=zeros(N,1);
cPwts=zeros(N,14);
cPwts1=zeros(N,1);
for k=1:14
    for j=1:N
        L=length(pvs{1,k+6});          %夏季光伏出力
        L1=length(wts{1,k+6});         %夏季风机出力
        for i=1:L-1                    %光伏
            if (Cs(j,2*k-1)>=pvs{1,k+6}(i,2)) && (Cs(j,2*k-1)<pvs{1,k+6}(i+1,2))
                dx = Cs(j,2*k-1) - apvs{1,k}(i);
                cPpvs1(j) = coepvs{1,k}(i,1)*dx^3 + coepvs{1,k}(i,2)*dx^2 + coepvs{1,k}(i,3)*dx + coepvs{1,k}(i,4);
                break;
            end
        end
        for i=1:L1-1                    %风机        
            if (Cs(j,2*k)>=wts{1,k+6}(i,2)) && (Cs(j,2*k)<wts{1,k+6}(i+1,2))
                dx = Cs(j,2*k) - awts{1,k+6}(i);
                cPwts1(j) = coewts{1,k+6}(i,1)*dx^3 + coewts{1,k+6}(i,2)*dx^2 + coewts{1,k+6}(i,3)*dx + coewts{1,k+6}(i,4);
                break;
            end
        end
    end
    cPpvs(1:N,k)=cPpvs1;
    cPwts(1:N,k)=cPwts1;
end
%%                        %求解过渡季07至20点具有相关性的光伏与风机出力cPpvinter,cPwtinter
cPpvinter=zeros(N,14);
cPpvinter1=zeros(N,1);
cPwtinter=zeros(N,14);
cPwtinter1=zeros(N,1);
for k=1:14
    for j=1:N
        L=length(pvinter{1,k+6});          %夏季光伏出力
        L1=length(wtinter{1,k+6});         %夏季风机出力
        for i=1:L-1                    %光伏
            if (Cinter(j,2*k-1)>=pvinter{1,k+6}(i,2)) && (Cinter(j,2*k-1)<pvinter{1,k+6}(i+1,2))
                dx = Cinter(j,2*k-1) - apvinter{1,k}(i);
                cPpvinter1(j) = coepvinter{1,k}(i,1)*dx^3 + coepvinter{1,k}(i,2)*dx^2 + coepvinter{1,k}(i,3)*dx + coepvinter{1,k}(i,4);
                break;
            end
        end
        for i=1:L1-1                    %风机        
            if (Cinter(j,2*k)>=wtinter{1,k+6}(i,2)) && (Cinter(j,2*k)<wtinter{1,k+6}(i+1,2))
                dx = Cinter(j,2*k) - awtinter{1,k+6}(i);
                cPwtinter1(j) = coewtinter{1,k+6}(i,1)*dx^3 + coewtinter{1,k+6}(i,2)*dx^2 + coewtinter{1,k+6}(i,3)*dx + coewtinter{1,k+6}(i,4);
                break;
            end
        end
    end
    cPpvinter(1:N,k)=cPpvinter1;
    cPwtinter(1:N,k)=cPwtinter1;
end
%%                        %求解冬季07至18点具有相关性的光伏与风机出力cPpvw,cPwtw
cPpvw=zeros(N,12);
cPpvw1=zeros(N,1);
cPwtw=zeros(N,12);
cPwtw1=zeros(N,1);
for k=1:12
    for j=1:N
        L=length(pvw{1,k+6});          %夏季光伏出力
        L1=length(wtw{1,k+6});         %夏季风机出力
        for i=1:L-1                    %光伏
            if (Cw(j,2*k-1)>=pvw{1,k+6}(i,2)) && (Cw(j,2*k-1)<pvw{1,k+6}(i+1,2))
                dx = Cw(j,2*k-1) - apvw{1,k}(i);
                cPpvw1(j) = coepvw{1,k}(i,1)*dx^3 + coepvw{1,k}(i,2)*dx^2 + coepvw{1,k}(i,3)*dx + coepvw{1,k}(i,4);
                break;
            end
        end
        for i=1:L1-1                    %风机        
            if (Cw(j,2*k)>=wtw{1,k+6}(i,2)) && (Cw(j,2*k)<wtw{1,k+6}(i+1,2))
                dx = Cw(j,2*k) - awtw{1,k+6}(i);
                cPwtw1(j) = coewtw{1,k+6}(i,1)*dx^3 + coewtw{1,k+6}(i,2)*dx^2 + coewtw{1,k+6}(i,3)*dx + coewtw{1,k+6}(i,4);
                break;
            end
        end
    end
    cPpvw(1:N,k)=cPpvw1;
    cPwtw(1:N,k)=cPwtw1;
end
%%                                %得到全天数据
for i=1:6
    a=Pwts(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    As(1:N,i)=a(idx) ; % sampling
    a=Pwtinter(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    Ainter(1:N,i)=a(idx) ; % sampling
    a=Pwtw(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    Aw(1:N,i)=a(idx) ; % sampling
end
for i=21:24
    a=Pwts(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    Bs(1:N,i-20)=a(idx) ; % sampling
    a=Pwtinter(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    Binter(1:N,i-20)=a(idx) ; % sampling
end
for i=19:24
    a=Pwtw(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    Bw(1:N,i-18)=a(idx) ; % sampling
end
%%
cPpvs=[zeros(N,6) cPpvs zeros(N,4)];
cPpvinter=[zeros(N,6) cPpvinter zeros(N,4)];
cPpvw=[zeros(N,6) cPpvw zeros(N,6)];
cPwts=[As cPwts Bs];
cPwtinter=[Ainter cPwtinter Binter];
cPwtw=[Aw cPwtw Bw];
%                           采用K-means聚类提取夏季、过渡季、冬季典型日光伏出力、风机出力曲线
%  %夏季光伏出力削减
N1=2;                                            %设置聚类数目
data=cPpvw;
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N1,n);                              %初始化聚类中心
for x=1:N1
    center(x,:)=data( randi(N,1),:);           %第一次随机产生聚类中心
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
cen1cPpvs=0;cen2cPpvs=0;
for i=1:m
    if pattern(i,n)==1 
         cen1cPpvs=cen1cPpvs+1;
    elseif pattern(i,n)==2    % 修复了原本缺失的 if 导致语法报错的地方
         cen2cPpvs=cen2cPpvs+1;
    end
end
figure(6);
plot(1:24,center(1,:),'r');xlim([1 24]);hold on
plot(1:24,center(2,:),'b');
cen1cPpvs=cen1cPpvs/m;
cen2cPpvs=cen2cPpvs/m;                                    %计算各个场景出现的概率