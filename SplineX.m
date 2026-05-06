clear all; clc;

%%                        基于二元正态Copula函数建立每个时段的联合风光出力函数
X = YearPpv(:,7);                    %以7点钟为例
Y = YearPwt(:,7);
%%                            %采用MATLAB自带函数
% 调用ksdensity函数分别计算原始样本X和Y处的核分布估计值
U = ksdensity(X,X,'function','cdf');
V = ksdensity(Y,Y,'function','cdf');
%%                            获得累积分布函数
U2 = ksdensity(X,X,'function','cdf');
V2 = ksdensity(Y,Y,'function','cdf');
[Xsort,id] = sort(X);  % 为了作图的需要，对X进行排序
figure(2);  % 新建一个图形窗口
plot(Xsort,U2(id),'b-.','LineWidth',0.75);hold on 
[Txsort,Tid] = sort(F_Ppv(:,7));    %为了作图的需要，对X进行排序
x=YearPpv(:,7);                        %F_Ppv为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',0.75);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel('07:00光伏出力/kW');  
ylabel('累积分布函数F(x)'); 
[Ysort,id] = sort(Y);  % 为了作图的需要，对Y进行排序
figure(3);  % 新建一个图形窗口
plot(Ysort,V2(id),'b-.','LineWidth',0.75);hold on
[Txsort,Tid] = sort(F_Pwt(:,7));    %为了作图的需要，对X进行排序
x=YearPwt(:,7);                        %F_Pwt为采用高斯核函数得到的分布函数值
plot(x(Tid),Txsort,'r-','LineWidth',0.75);
legend('ksdensity核分布估计','高斯核密度估计', 'Location','NorthWest'); % 加标注框
xlabel('07:00风机出力/kW');  
ylabel('累积分布函数F(x)'); 
%%
%***********************求Copula中参数的估计值******************************
% 调用copulafit函数估计二元正态Copula中的线性相关参数
a=F_Ppv(:,7);b=F_Pwt(:,7);

% 修复2：强制限制数据严格在 0 和 1 之间，防止 copulafit 崩溃报错
a(a >= 1) = 0.9999; a(a <= 0) = 0.0001;
b(b >= 1) = 0.9999; b(b <= 0) = 0.0001;

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
%%      求解07点至20点二元Normal-Copula函数相关参数rho_normP
rho_normP=zeros(28,2);
k=1;
for i=1:14
    a=F_Ppv(:,i+6);b=F_Pwt(:,i+6);
    % 修复2：循环内部同样需要限制边界，防止报错
    a(a >= 1) = 0.9999; a(a <= 0) = 0.0001;
    b(b >= 1) = 0.9999; b(b <= 0) = 0.0001;
    rho_norm=copulafit('Gaussian',[a,b]);%极大似然估计
    rho_normP(k:k+1,:)=rho_norm;
    k=k+2;
end
%%           对每个时段的联合分布函数进行随机抽样
N=10000;
CP=zeros(N,28);          %07至20点
k=2;
% 注意：此处假设你的工作区或者前面的代码里已经计算并存在 pv 和 wt 这两个元胞数组变量
for i=1:14
    C=copularnd('Gaussian',rho_normP(k,1),N);
    C1= pv{1,i+6}(1,2)+ (pv{1,i+6}(end,2)-pv{1,i+6}(1,2)).*C(:,1);
    C2= wt{1,i+6}(1,2)+ (wt{1,i+6}(end,2)-wt{1,i+6}(1,2)).*C(:,2);
    CP(:,k-1:k)=[C1 C2];
    k=k+2;
end

%%                        %求解07至20点具有相关性的光伏与风机出力cPpv,cPwt
cPpv=zeros(N,14);
cPpv1=zeros(N,1);
cPwt=zeros(N,14);
cPwt1=zeros(N,1);

% 性能优化：去除了极慢的 syms 和 eval，使用多项式直接代数计算，避免卡死
for k=1:14
    for j=1:N
        L=length(pv{1,k+6});          %光伏出力
        L1=length(wt{1,k+6});         %风机出力
        for i=1:L-1                    %光伏
            if (CP(j,2*k-1)>=pv{1,k+6}(i,2)) && (CP(j,2*k-1)<pv{1,k+6}(i+1,2))
                dx = CP(j,2*k-1) - apv{1,k}(i);
                cPpv1(j) = coepv{1,k}(i,1)*dx^3 + coepv{1,k}(i,2)*dx^2 + coepv{1,k}(i,3)*dx + coepv{1,k}(i,4);
                break;
            end
        end
        for i=1:L1-1                    %风机        
            if (CP(j,2*k)>=wt{1,k+6}(i,2)) && (CP(j,2*k)<wt{1,k+6}(i+1,2))
                dx = CP(j,2*k) - awt{1,k+6}(i);
                cPwt1(j) = coewt{1,k+6}(i,1)*dx^3 + coewt{1,k+6}(i,2)*dx^2 + coewt{1,k+6}(i,3)*dx + coewt{1,k+6}(i,4);
                break;
            end
        end
    end
    cPpv(1:N,k)=cPpv1;
    cPwt(1:N,k)=cPwt1;
end
%%                                %得到全天数据
for i=1:6
    a=YearPwt(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    A(1:N,i)=a(idx) ; % sampling
end
for i=21:24
    a=YearPwt(:,i);
    m=length(a); %dimension
    idx= ceil(m*rand(1,N)) ;  %generate n random index between 1 and m
    B(1:N,i-20)=a(idx) ; % sampling
end
%%
cPpv=[zeros(N,6) cPpv zeros(N,4)];
cPwt=[A cPwt B];
%                           采用K-means典型日光伏出力、风机出力曲线
%%                                        %光伏出力削减
N1=6;                                            %设置聚类数目
data=cPpv;
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
cen1pv=0;cen2pv=0;cen3pv=0;cen4pv=0;cen5pv=0;cen6pv=0;
for i=1:m
    if pattern(i,n)==1 
         cen1pv=cen1pv+1;
    elseif pattern(i,n)==2
         cen2pv=cen2pv+1;
    elseif pattern(i,n)==3
         cen3pv=cen3pv+1;
    elseif pattern(i,n)==4
         cen4pv=cen4pv+1;
    elseif pattern(i,n)==5
         cen5pv=cen5pv+1;
    elseif pattern(i,n)==6
         cen6pv=cen6pv+1;
    end
end
figure(6);
plot(1:24,center(1,:),'g');xlim([1 24]);hold on
plot(1:24,center(2,:),'m');hold on
plot(1:24,center(3,:),'b');hold on
plot(1:24,center(4,:),'c');hold on
plot(1:24,center(5,:),'g');hold on
plot(1:24,center(6,:),'r');
cen1pv=cen1pv/m;
cen2pv=cen2pv/m;                                    %计算各个场景出现的概率
cen3pv=cen3pv/m;
cen4pv=cen4pv/m;    
cen5pv=cen5pv/m;
cen6pv=cen6pv/m;     

%%                                        %风机出力削减
N1=6;                                            %设置聚类数目
data=cPwt;
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
cen1wt=0;cen2wt=0;cen3wt=0;cen4wt=0;cen5wt=0;cen6wt=0;

% 修复3：将原本非法的 else pattern(i,n)==2 修正为 elseif，并补全 N1=6 的情况
for i=1:m
    if pattern(i,n)==1 
         cen1wt=cen1wt+1;
    elseif pattern(i,n)==2
         cen2wt=cen2wt+1;
    elseif pattern(i,n)==3
         cen3wt=cen3wt+1;
    elseif pattern(i,n)==4
         cen4wt=cen4wt+1;
    elseif pattern(i,n)==5
         cen5wt=cen5wt+1;
    elseif pattern(i,n)==6
         cen6wt=cen6wt+1;
    end
end

figure(7); % 更改为图7，防止与前面的光伏聚类图相互覆盖
plot(1:24,center(1,:),'g');xlim([1 24]);hold on
plot(1:24,center(2,:),'m');hold on
plot(1:24,center(3,:),'b');hold on
plot(1:24,center(4,:),'c');hold on
plot(1:24,center(5,:),'g');hold on
plot(1:24,center(6,:),'r');
cen1wt=cen1wt/m;
cen2wt=cen2wt/m;                                    
cen3wt=cen3wt/m;
cen4wt=cen4wt/m;    
cen5wt=cen5wt/m;
cen6wt=cen6wt/m;                                   %计算各个场景出现的概率