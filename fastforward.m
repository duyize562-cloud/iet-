function [w,q]=fastforward(sce,pro,n)%场景削减函数，将sce保存的场景，场景的概率是pro，削减成n个w场景，概率是q（核心程序）
[N,T]=size(sce);
w=zeros(n,T);
q=zeros(n,1);
Dmetrics=zeros(N,N);
tempDmetrics=zeros(N,N);
Zu=zeros(1,N);

Jtotnum=N;%J集合，总数量，集合值，被选值
Jset=zeros(1,N);
%Jindex=0;

Itotnum=0;%I集合，总数量，集合值，被选值
Iset=zeros(1,N);
Iindex=0;

sum=0;


for j=1:N%初始化J集合
   Jset(j)=j; 
end


for i=1:N %c(Wk,Wu),k,u=1...N
    for j=1:N
        Dmetrics(i,j)=Distance(sce(i,:),sce(j,:));
    end
end

for j=1:N %第一次求Zu=∑Pk*c(Wk,Wu)   u=1...N
    sum=0;
    for i=1:N
       sum=sum+pro(i)*Dmetrics(i,j); 
    end
    Zu(j)=sum;
end

min=inf;
for j=1:N%获得I集合中的第一个数据
   if Zu(j)<min
      min=Zu(j);
      Iindex=j;
   end
end
Iset(1)=Iindex;
Itotnum=1;

for j=1:N%第一次更新J集合数据
   if j==Iindex
       for k=j:N-1
          Jset(k)=Jset(k+1); 
       end
       break;
   end
end
Jtotnum=N-1;

%min=inf;
for k=2:n%从第2步进行到第n步

for i=1:N%求第i步的ci(Wk,Wu),k,u∈J(i-1)
    for j=1:N
        tempi=Belong(i,Iset,Itotnum);
        tempj=Belong(j,Iset,Itotnum);
        if tempi==0 && tempj==0%更新第i步的ci(Wk,Wu),k,u∈J(i-1)
            tempDmetrics(i,j)=mini(Dmetrics(i,j),Dmetrics(i,Iindex));
        else
            tempDmetrics(i,j)=Dmetrics(i,j);
        end
    end
end

for j=1:Jtotnum%求第i步的Zu
    sum=0;
   for i=1:Jtotnum
       sum=sum+pro(Jset(i))*tempDmetrics(Jset(i),Jset(j));
   end
   Zu(j)=sum;
end

min=inf;%求第i步的ui
for j=1:Jtotnum
    if Zu(j)<min
       min=Zu(j);
       Iindex=Jset(j);
    end
end
Iset(k)=Iindex;
Itotnum=Itotnum+1;

for j=1:Jtotnum%重新分配J集合，更新J中的数量
   if Jset(j)==Iindex
      for i=j:Jtotnum-1
         Jset(i)=Jset(i+1); 
      end
      break;
   end
end
Jtotnum=Jtotnum-1;

end

for i=1:Itotnum%初始化集合I中按元素顺序排列的概率
   q(i)=pro(Iset(i));    
end

for j=1:Jtotnum%重新计算各削减场景的概率分布
   min=inf;
   for i=1:Itotnum
       if Dmetrics(Jset(j),Iset(i))<min
          min=Dmetrics(Jset(j),Iset(i));
          Iindex=i;
       end
   end
   q(Iindex)=q(Iindex)+pro(Jset(j));
end

for i=1:Itotnum%确定最终场景
   w(i,:)=sce(Iset(i),:); 
end





