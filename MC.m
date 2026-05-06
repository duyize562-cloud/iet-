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
%%                        %求解三次样条插值函数的反函数
syms x a coe;
s=sym('coe(i,1)*(x-a(i))^3+coe(i,2)*(x-a(i))^2+coe(i,3)*(x-a(i))+coe(i,4)');
Inv=finverse(s);
%%                        %求解夏季07至20点具有相关性的光伏与风机出力cPpvs,cPwts
cPpvs=zeros(N,14);
for k=1:14
    for j=1:N
        L=length(pvs{1,k+6});          %夏季光伏出力
        L1=length(wts{1,k+6});         %夏季风机出力
        for i=1:L-1                    %光伏
            if (Cs(j,2*k-1)>=pvs{1,k+6}(i,2))&(Cs(j,2*k-1)<pvs{1,k+6}(i+1,2))
            Inv1s=subs(Inv,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apvs{1,k}(i),coepvs{1,k}(i,1),coepvs{1,k}(i,2),coepvs{1,k}(i,3),coepvs{1,k}(i,4)});
            Inv2s=subs(Inv1s,{'x'},{Cs(j,2*k-1)});
            cPpvs1(j)=eval(Inv2s);
            end
        end
        for i=1:L1-1                    %风机        
            if (Cs(j,2*k)>=wts{1,k+6}(i,2))&(Cs(j,2*k)<wts{1,k+6}(i+1,2))
            Inv1s=subs(Inv,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awts{1,k+6}(i),coewts{1,k+6}(i,1),coewts{1,k+6}(i,2),coewts{1,k+6}(i,3),coewts{1,k+6}(i,4)});
            Inv2s=subs(Inv1s,{'x'},{Cs(j,2*k)});
            cPwts1(j)=eval(Inv2s);
            end
        end
    end
    cPpvs(1:N,k)=real(cPpvs1)-imag(cPpvs1);
    cPwts(1:N,k)=real(cPwts1)-imag(cPwts1);
end
%%                        %求解过渡季07至20点具有相关性的光伏与风机出力cPpvinter,cPwtinter
cPpvinter=zeros(N,14);
for k=1:14
    for j=1:N
        L=length(pvinter{1,k+6});          %过渡季光伏出力
        L1=length(wtinter{1,k+6});         %过渡季季风机出力
        for i=1:L-1                    %光伏
            if (Cinter(j,2*k-1)>=pvinter{1,k+6}(i,2))&(Cinter(j,2*k-1)<pvinter{1,k+6}(i+1,2))
            Inv1inter=subs(Inv,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apvinter{1,k}(i),coepvinter{1,k}(i,1),coepvinter{1,k}(i,2),coepvinter{1,k}(i,3),coepvinter{1,k}(i,4)});
            Inv2inter=subs(Inv1inter,{'x'},{Cinter(j,2*k-1)});
            cPpvinter1(j)=eval(Inv2inter);
            end
        end
        for i=1:L1-1                    %风机        
            if (Cinter(j,2*k)>=wtinter{1,k+6}(i,2))&(Cinter(j,2*k)<wtinter{1,k+6}(i+1,2))
            Inv1inter=subs(Inv,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awtinter{1,k+6}(i),coewtinter{1,k+6}(i,1),coewtinter{1,k+6}(i,2),coewtinter{1,k+6}(i,3),coewtinter{1,k+6}(i,4)});
            Inv2inter=subs(Inv1inter,{'x'},{Cinter(j,2*k)});
            cPwtinter1(j)=eval(Inv2inter);
            end
        end
    end
    cPpvinter(1:N,k)=real(cPpvinter1)-imag(cPpvinter1);
    cPwtinter(1:N,k)=real(cPwtinter1)-imag(cPwtinter1);
end
%%                        %求解冬季07至18点具有相关性的光伏与风机出力cPpvs,cPwts
cPpvw=zeros(N,12);
for k=1:12
    for j=1:N
        L=length(pvw{1,k+6});          %冬季光伏出力
        L1=length(wtw{1,k+6});         %冬季风机出力
        for i=1:L-1                    %光伏
            if (Cw(j,2*k-1)>=pvw{1,k+6}(i,2))&(Cw(j,2*k-1)<pvw{1,k+6}(i+1,2))
            Inv1w=subs(Inv,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apvw{1,k}(i),coepvw{1,k}(i,1),coepvw{1,k}(i,2),coepvw{1,k}(i,3),coepvw{1,k}(i,4)});
            Inv2w=subs(Inv1w,{'x'},{Cw(j,2*k-1)});
            cPpvw1(j)=eval(Inv2w);
            end
        end
        for i=1:L1-1                    %风机        
            if (Cw(j,2*k)>=wtw{1,k+6}(i,2))&(Cw(j,2*k)<wtw{1,k+6}(i+1,2))
            Inv1w=subs(Inv,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awtw{1,k+6}(i),coewtw{1,k+6}(i,1),coewtw{1,k+6}(i,2),coewtw{1,k+6}(i,3),coewtw{1,k+6}(i,4)});
            Inv2w=subs(Inv1w,{'x'},{Cw(j,2*k)});
            cPwtw1(j)=eval(Inv2w);
            end
        end
    end
    cPpvw(1:N,k)=real(cPpvw1)-imag(cPpvw1);
    cPwtw(1:N,k)=real(cPwtw1)-imag(cPwtw1);
end
%%                                %得到全天数据
%简单随机抽样
N=10000;
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

