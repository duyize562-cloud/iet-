n=365;
A2=zeros(365,6);A3=zeros(365,4);
A=[A2 A3];
A1=YearPwt(:,1:6);B1=YearPwt(:,21:24);
B=[A1 B1];
U=zeros(365,10);V=zeros(365,10);
rho_normAD=zeros(20,2);
k=1;
for i=1:10
U(:,i)=ksdensity(A(:,i),A(:,i),'function','cdf');
V(:,i)=ksdensity(B(:,i),B(:,i),'function','cdf');
rho_norm = copulafit('Gaussian',[U(:,i),V(:,i)]);%极大似然估计求积矩相关系数（Pearson）
rho_normAD(k:k+1,:)=rho_norm;
k=k+2;
end
[n,m]=size(A2);
a=max(YearPpv(:,7));
for i=1:m
[xsort,id] = sort(U(1:n,i));         %对X进行排序，xsort为分布函数排序
x=A(id,i);                             %为光伏出力排序
X=diff(xsort);                                 %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pvAD{i}=[x xsort;a,1];
end
%%
[n,m]=size(A3);
b=max(YearPpv(:,20));
for i=1:m
[xsort,id] = sort(U(1:n,i+6));         %对X进行排序，xsort为分布函数排序
x=A(id,i);                             %为光伏出力排序
X=diff(xsort);                                 %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
pvAD{i+6}=[x xsort;b,1];
end
%%
[n,m]=size(B);
for i=1:m
[xsort,id] = sort(V(1:n,i));         %对X进行排序，xsort为分布函数排序
x=B(id,i);                             %为光伏出力排序
X=diff(xsort);                                 %剔除x和xsort中元素相同的点，只保留一个
k=find(X==0);
x(k)=[];
xsort(k)=[];
wtAD{i}=[x xsort];
end
%%                            %求解光伏出力各个时段累积分布函数的反函数
for i=1:10
x1=pvAD{i}(:,2);
y1=pvAD{i}(:,1);
%%          三次样条插值
y2=[0;y1;0];
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
apvAD{i}=a1;coepvAD{i}=coe1;
end
%%                            %求解光伏出力各个时段累积分布函数的反函数
for i=1:10
x1=wtAD{i}(:,2);
y1=wtAD{i}(:,1);
%%          三次样条插值
y2=[0;y1;0];
pp=csape(x1',y2','second');
[a1,coe1]=unmkpp(pp);
awtAD{i}=a1;coewtAD{i}=coe1;
end
%%
N=10000;
CPAD=zeros(N,20);          %夏季07至20点
k=2;
for i=1:10
    C=copularnd('Gaussian',rho_normAD(k,1),N);
    C1= pvAD{1,i}(1,2)+ (pvAD{1,i}(end,2)-pvAD{1,i}(1,2)).*C(:,1);
    C2= wtAD{1,i}(1,2)+ (wtAD{1,i}(end,2)-wtAD{1,i}(1,2)).*C(:,2);
    CPAD(:,k-1:k)=[C1 C2];
    k=k+2;
end
%%                        %求解三次样条插值函数
syms x a coe;
s=sym('coe(i,1)*(x-a(i))^3+coe(i,2)*(x-a(i))^2+coe(i,3)*(x-a(i))+coe(i,4)');
%%                        %求解07至20点具有相关性的光伏与风机出力cPpv,cPwt
cPpvAD=zeros(N,10);
cPpvAD1=zeros(N,1);
cPwtAD=zeros(N,10);
cPwtAD1=zeros(N,1);
for k=1:10
    for j=1:N
        L=length(pvAD{1,k});          %夏季光伏出力
        L1=length(wtAD{1,k});         %夏季风机出力
        for i=1:L-1                    %光伏
            if (CPAD(j,2*k-1)>=pvAD{1,k}(i,2))&(CPAD(j,2*k-1)<pvAD{1,k}(i+1,2))
             s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{apvAD{1,k}(i),coepvAD{1,k}(i,1),coepvAD{1,k}(i,2),coepvAD{1,k}(i,3),coepvAD{1,k}(i,4)});
             s2=subs(s1,{'x'},{CPAD(j,2*k-1)});
             cPpvAD1(j)=eval(s2);
            end
        end
        for i=1:L1-1                    %风机        
            if (CPAD(j,2*k)>=wtAD{1,k}(i,2))&(CPAD(j,2*k)<wtAD{1,k}(i+1,2))
            s1=subs(s,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{awtAD{1,k}(i),coewtAD{1,k}(i,1),coewtAD{1,k}(i,2),coewtAD{1,k}(i,3),coewtAD{1,k}(i,4)});
            s2=subs(s1,{'x'},{CPAD(j,2*k)});
            cPwtAD1(j)=eval(s2);
            end
        end
    end
    cPpvAD(1:N,k)=cPpvAD1;
    cPwtAD(1:N,k)=cPwtAD1;
end
