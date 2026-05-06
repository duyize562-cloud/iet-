clc
vWT=vWT2011(3:35042);                          %2011年全年风速，每15分钟取一个点
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
    P_W(i)=PR*(v(i)-vc)/(vr-vc);
elseif(v(i)>=vr)&(v(i)<=vF)
    P_W(i)=PR;
else
    P_W(i)=0;
end
end   
 P_W= P_W./400';
figure(1);plot(1:8760,P_W);xlim([0 8760]);ylim([0 1]);          %全年风机出力
%                                         %划分为夏季，过渡季和冬季
%%
for i=13
    for j=1:8760
        P_PVr(j)=Pac(i);
        i=i+12;
    end
end
P_PVr=P_PVr.*200/5.1/1000;
P_PVr=P_PVr./200;
figure(2);plot(1:8760,P_PVr);xlim([0 8760]);ylim([0 1]);        %全年光伏出力
%%
for i=1:8760
    if (2880<i)&(i<5088)
        P_PV(i)=P_PVr(i)*1.25;
    else
        P_PV(i)=P_PVr(i);
    end
end
P_PV=P_PV';
figure(3);plot(1:8760,P_PV);xlim([0 8760]);ylim([0 1]);        %全年光伏出力
%%                                          %获得夏季、过渡季、冬季光伏出力 
clc                                               %夏季200kW光伏出力（3000-5232h）
j=3000;
for n=1:100
    m=1;
    for k=1:8760
        P_PVs(n,m)=P_PV(j);
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
for i=1:93
    figure(4)                                   %夏季200kW光伏出力
    ylim([0 1]);
    plot(0:24,P_PVs(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%                                        %过渡季200kW光伏出力
clc                                             %春季200kW光伏出力（1296-3000h）
j=1296;
for n=1:100
    m=1;
    for k=1:8760
        Ppvsp(n,m)=P_PV(j);
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
for i=1:71
    figure(5)                                   %春季200kW光伏出力
    ylim([0 1]);
    plot(0:24,Ppvsp(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%                                        %秋季200kW光伏出力（5232-7416h）
j=5232;
for n=1:100
    m=1;
    for k=1:8760
        Ppva(n,m)=P_PV(j);
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
for i=1:91
    figure(5)                                   %秋季200kW光伏出力
    plot(0:24,Ppva(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Ppvinter=[Ppvsp;Ppva];
%%                                        %冬季200kW光伏出力
j=7416;
for n=1:100
    m=1;
    for k=1:8760
        Ppvw1(n,m)=P_PV(j);
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
for i=1:56
    figure(6)                                   %冬季200kW光伏出力
    ylim([0 1]);
    plot(0:24,Ppvw1(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%
j=1;
for n=1:54
    m=1;
    for k=1:8760
        Ppvw2(n,m)=P_PV(j);
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
for i=1:54
    figure(6)                                   %冬季200kW光伏出力
    plot(0:24,Ppvw2(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Ppvw=[Ppvw1;Ppvw2];
%%                                        %获得夏季、过渡季、冬季400kW风机出力

clc                                               %夏季400kW风机出力（3000-5232h）
j=3000;
for n=1:100
    m=1;
    for k=1:8760
        Pwts(n,m)=P_W(j);
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
for i=1:93
    figure(7)                                   %夏季4000kW风机出力
    ylim([0 1]);
    plot(0:24,Pwts(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%                                        %过渡季400kW风机出力
clc                                             %春季400kW风机出力（1296-3000h）
j=1296;
for n=1:100
    m=1;
    for k=1:8760
        Pwtsp(n,m)=P_W(j);
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
for i=1:71
    figure(8)                                   %春季400kW风机出力
    ylim([0 1]);
    plot(0:24,Pwtsp(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%                                        %秋季400kW风机出力
j=5232;
for n=1:100
    m=1;
    for k=1:8760
        Pwta(n,m)=P_W(j);
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
for i=1:91
    figure(8)                                   %秋季400kW风机出力
    plot(0:24,Pwta(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Pwtinter=[Pwtsp;Pwta];
%%                                        %冬季400kW风机出力
j=7416;
for n=1:100
    m=1;
    for k=1:8760
        Pwtw1(n,m)=P_W(j);
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
for i=1:56
    figure(9)                                   %冬季400kW风机出力
    ylim([0 1]);
    plot(0:24,Pwtw1(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%
j=1;
for n=1:54
    m=1;
    for k=1:8760
        Pwtw2(n,m)=P_W(j);
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
for i=1:54
    figure(9)                                   %冬季400kV出力
    plot(0:24,Pwtw2(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Pwtw=[Pwtw1;Pwtw2];
%%
