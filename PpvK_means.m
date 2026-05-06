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
%%                                         %获得额定功率400kW风机出力
vc=0.5;vr=11;vF=25;PR=400;                       %切断风速3m/s,额定风速11m/s,截断风速25m/s
for i=1:length(v)
if (v(i)>=vc)&(v(i)<vr)
    Pwt(i)=PR*(v(i)-vc)/(vr-vc);
elseif(v(i)>=vr)&(v(i)<=vF)
    Pwt(i)=PR;
else
    Pwt(i)=0;
end
end                                                                
figure(1);plot(1:8760,Pwt);xlim([0 8760]);      %全年风机出力 
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}风机出力/\fontname{Times new roman}kW'])
%%                                           %获得额定功率为200kW的光伏出力、
load Ppv2011;
Ppv=Ppv2011;
figure(2);plot(1:8760,Ppv);xlim([0 8760]);        %全年光伏出力
xlabel(['\fontname{Times new roman}\itt/\rmh']);  
ylabel(['\fontname{宋体}光伏出力/\fontname{Times new roman}kW'])
%%                                          %获得夏季、过渡季、冬季光伏出力                                                
j=3000;                                            %夏季200kW光伏出力（3000-5232h）
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
    center(x,:)=data( randi(m,1),:);           %第一次随机产生聚类中心
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
cen1s=cen1s/m;
cen2s=cen2s/m;                                   %计算各个场景出现的概率
%%                                         %过渡季光伏出力削减
data=Ppvinter;
N=2;                                            %设置聚类数目
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N,n);                              %初始化聚类中心
for x=1:N
    center(x,:)=data( randi(m,1),:);           %第一次随机产生聚类中心
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
cen1inter=cen1inter/m;
cen2inter=cen2inter/m;                                    %计算各个场景出现的概率
%%                                                 %冬季季光伏出力削减
data=Ppvw;
N=2;                                            %设置聚类数目
[m,n]=size(data);
pattern=zeros(m,n+1);
center=zeros(N,n);                              %初始化聚类中心
for x=1:N
    center(x,:)=data( randi(m,1),:);           %第一次随机产生聚类中心
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
cen1w=cen1w/m;
cen2w=cen2w/m;                                   %计算各个场景出现的概率
%%
Ppvs=Ppvs(:,2:25);Ppvinter=Ppvinter(:,2:25);Ppvw=Ppvw(:,1:24);
