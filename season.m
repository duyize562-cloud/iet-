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
    Pwt(i)=PR*(v(i)-vc)/(vr-vc);
elseif(v(i)>=vr)&(v(i)<=vF)
    Pwt(i)=PR;
else
    Pwt(i)=0;
end
end                                                                
figure(1);plot(1:8760,Pwt);xlim([0 8760]);        %全年风机出力
%                                         %划分为夏季，过渡季和冬季
%%
for i=13
    for j=1:8760
        Ppvr(j)=Pac(i);
        i=i+12;
    end
end
Ppvr=Ppvr.*200/5.1/1000;
Ppvr=Ppvr';
figure(2);plot(1:8760,Ppvr);xlim([0 8760]);        %全年光伏出力
%%
for i=1:8760
    if (2880<i)&(i<5088)
        Ppv(i)=Ppvr(i)*1.25;
    else
        Ppv(i)=Ppvr(i);
    end
end
Ppv=Ppv';
figure(3);plot(1:8760,Ppv);xlim([0 8760]);        %全年光伏出力
%%                                          %获得夏季、过渡季、冬季光伏出力 
clc                                               %夏季200kW光伏出力（3000-5232h）
j=3000;
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
for i=1:93                            %夏季200kW光伏出力
       subplot(2,3,4);  plot(0:24,Ppvs(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%                                        %过渡季200kW光伏出力
clc                                             %春季200kW光伏出力（1296-3000h）
j=1296;
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
for i=1:71
                                 %春季200kW光伏出力
        subplot(2,3,5); plot(0:24,Ppvsp(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
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
for i=1:91
                                %秋季200kW光伏出力
       subplot(2,3,5);  plot(0:24,Ppva(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
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
for i=1:56
                                %冬季200kW光伏出力
       subplot(2,3,6);  plot(0:24,Ppvw1(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
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
for i=1:54
                               %冬季200kW光伏出力
       subplot(2,3,6);  plot(0:24,Ppvw2(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Ppvw=[Ppvw1;Ppvw2];
%%                                        %获得夏季、过渡季、冬季400kW风机出力

clc                                               %夏季400kW风机出力（3000-5232h）
j=3000;
for n=1:100
    m=1;
    for k=1:8760
        Pwts(n,m)=Pwt(j);
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
                             %夏季4000kW风机出力
   subplot(2,3,1); plot(0:24,Pwts(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%                                        %过渡季400kW风机出力
clc                                             %春季400kW风机出力（1296-3000h）
j=1296;
for n=1:100
    m=1;
    for k=1:8760
        Pwtsp(n,m)=Pwt(j);
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
                                  %春季400kW风机出力
    subplot(2,3,2);plot(0:24,Pwtsp(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%                                        %秋季400kW风机出力
j=5232;
for n=1:100
    m=1;
    for k=1:8760
        Pwta(n,m)=Pwt(j);
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
                                %秋季400kW风机出力
    subplot(2,3,2);plot(0:24,Pwta(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Pwtinter=[Pwtsp;Pwta];
%%                                        %冬季400kW风机出力
j=7416;
for n=1:100
    m=1;
    for k=1:8760
        Pwtw1(n,m)=Pwt(j);
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
for i=1:56                                %冬季400kW风机出力
    subplot(2,3,3);plot(0:24,Pwtw1(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
%%
j=1;
for n=1:54
    m=1;
    for k=1:8760
        Pwtw2(n,m)=Pwt(j);
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
                              %冬季400kV出力
    subplot(2,3,3); plot(0:24,Pwtw2(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Pwtw=[Pwtw1;Pwtw2];
%%
