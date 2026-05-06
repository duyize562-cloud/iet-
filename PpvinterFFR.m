clear all;clc
load Ppvinter;
data=Ppvinter;
[m,n]=size(data);
figure(1)
for i=1:m                                      %显示原始夏季光伏出力
    plot(0:24,data(i,:));xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end
Distance=zeros(m,m);
p=1/m.*ones(1,m);
Sdist=zeros(m,1);
Sdistij=zeros(m,m);
for i=1:m
    for j=1:m
        Distance(i,j)=norm(data(i,:)-data(j,:));
    end
end
D=Distance;

for i=1:m
    for j=1:m
        Distance(i,j)=norm(data(i,:)-data(j,:));
    end
end
for i=1:m
    for j=1:m
        Sdistij(i,j)=p(i)*[p(j)*Distance(j,i)];
    end
        Sdist(1:m)=sum(Sdistij(1:m,:));
end
[~, temp1]=min(Sdist);                     %删除下标为temp1的场景  
px=sort(Distance(temp1,:));
temp2=find(Distance(temp1,:)==px(2));      %将temp1场景出现的场景加到temp2上
p(temp2)=p(temp1)+p(temp2);
p(temp1)=[];
Distance(temp1,:)=[];Distance(:,temp1)=[];
Sdistij(temp1,:)=[];Sdistij(:,temp1)=[];
Sdist(temp1)=[];










        
