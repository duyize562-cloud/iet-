data=cPwtw;
[m,n]=size(data);
Distance=zeros(m,m);
pPwtw=1/m.*ones(1,m);
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
        Sdistij(i,j)=pPwtw(i)*[pPwtw(j)*Distance(j,i)];
    end
        Sdist(1:m-k)=sum(Sdistij(1:m-k,:));
end
[~, temp1]=min(Sdist);                     %删除下标为temp1的场景  
px=sort(Distance(temp1,:));
temp2=find(Distance(temp1,:)==px(2));      %将temp1场景出现的场景加到temp2上
pPwtw(temp2)=pPwtw(temp1)+pPwtw(temp2);
pPwtw(temp1)=[];
Distance(temp1,:)=[];Distance(:,temp1)=[];
Sdistij(temp1,:)=[];Sdistij(:,temp1)=[];
Sdist(temp1)=[];
end
[m1,n1]=find(D==Distance(1,2));
figure(11)
plot(1:24,data(m1(1),:),'r');hold on
plot(1:24,data(m1(2),:),'b');