%%                                            冬季
clear all;clc
load Ppvw;
data=Ppvw;
[m,n]=size(data);
subplot(2,3,3)
for i=1:m                                    
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
D= Distance;
for k=0:(m-3)
for i=1:m-k
    for j=1:m-k
        Sdistij(i,j)=p(i)*[p(j)*Distance(j,i)];
    end
        Sdist(1:m-k)=sum(Sdistij(1:m-k,:));
end
[~, temp1]=min(Sdist);                     %删除下标为temp1的场景  
px=sort(Distance(temp1,:));
temp2=find(Distance(temp1,:)==px(2));      %将temp1场景出现的场景加到temp2上
p(temp2)=p(temp1)+p(temp2);
p(temp1)=[];
Distance(temp1,:)=[];Distance(:,temp1)=[];
Sdistij(temp1,:)=[];Sdistij(:,temp1)=[];
Sdist(temp1)=[];
end
[m1,n1]=find(D==Distance(1,2));
subplot(2,3,6);plot(0:24,data(m1(1),:),'r');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
plot(0:24,data(m1(2),:),'b');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on


