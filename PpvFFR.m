% clear all;clc
% load Ppvs;
% a=zeros(93,1);
% data=Ppvs;
% data=[a data];
% [m,n]=size(data);
% % subplot(2,3,1)
% % for i=1:m                                     %显示原始夏季光伏出力
% %     plot(0:24,data(i,:));
% %     ylim([0 200]);xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% % end
% Distance=zeros(m,m);
% p=1/m.*ones(1,m);
% Sdist=zeros(m,1);
% Sdistij=zeros(m,m);
% for i=1:m
%     for j=1:m
%         Distance(i,j)=norm(data(i,:)-data(j,:));
%     end
% end
% D= Distance;
% for k=0:(m-3)
% for i=1:m-k
%     for j=1:m-k
%         Sdistij(i,j)=p(i)*[p(j)*Distance(j,i)];
%     end
%         Sdist(1:m-k)=sum(Sdistij(1:m-k,:));
% end
% [~, temp1]=min(Sdist);                     %删除下标为temp1的场景  
% px=sort(Distance(temp1,:));
% temp2=find(Distance(temp1,:)==px(2));      %将temp1场景出现的场景加到temp2上
% p(temp2)=p(temp1)+p(temp2);
% p(temp1)=[];
% Distance(temp1,:)=[];Distance(:,temp1)=[];
% Sdistij(temp1,:)=[];Sdistij(:,temp1)=[];
% Sdist(temp1)=[];
% end
% [m1,n1]=find(D==Distance(1,2));
% subplot(1,3,1);plot(0:24,data(m1(2),:),'r');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% plot(0:24,data(m1(1),:),'b');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% %%                                                过渡季
% clear all;clc
% load Ppvinter;
% data=Ppvinter;
% a=zeros(162,1);
% data=[a data];
% [m,n]=size(data);
% % subplot(2,3,2)
% % for i=1:m                                     
% %     plot(0:24,data(i,:));
% %     ylim([0 200]);xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% % end
% Distance=zeros(m,m);
% p=1/m.*ones(1,m);
% Sdist=zeros(m,1);
% Sdistij=zeros(m,m);
% for i=1:m
%     for j=1:m
%         Distance(i,j)=norm(data(i,:)-data(j,:));
%     end
% end
% D= Distance;
% for k=0:(m-3)
% for i=1:m-k
%     for j=1:m-k
%         Sdistij(i,j)=p(i)*[p(j)*Distance(j,i)];
%     end
%         Sdist(1:m-k)=sum(Sdistij(1:m-k,:));
% end
% [~, temp1]=min(Sdist);                     %删除下标为temp1的场景  
% px=sort(Distance(temp1,:));
% temp2=find(Distance(temp1,:)==px(2));      %将temp1场景出现的场景加到temp2上
% p(temp2)=p(temp1)+p(temp2);
% p(temp1)=[];
% Distance(temp1,:)=[];Distance(:,temp1)=[];
% Sdistij(temp1,:)=[];Sdistij(:,temp1)=[];
% Sdist(temp1)=[];
% end
% [m1,n1]=find(D==Distance(1,2));
% subplot(1,3,2);plot(0:24,data(m1(2),:),'r');
% xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% ylim([0 150]);
% plot(0:24,data(m1(1),:),'b');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% %%                                            冬季
% clear all;clc
% load Ppvw;
% data=Ppvw;
% a=zeros(110,1);
% data=[a data];
% [m,n]=size(data);
% % subplot(2,3,3)
% % for i=1:m                                    
% %     plot(0:24,data(i,:))
% %     ylim([0 200]);;xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% % end
% Distance=zeros(m,m);
% p=1/m.*ones(1,m);
% Sdist=zeros(m,1);
% Sdistij=zeros(m,m);
% for i=1:m
%     for j=1:m
%         Distance(i,j)=norm(data(i,:)-data(j,:));
%     end
% end
% D= Distance;
% for k=0:(m-3)
% for i=1:m-k
%     for j=1:m-k
%         Sdistij(i,j)=p(i)*[p(j)*Distance(j,i)];
%     end
%         Sdist(1:m-k)=sum(Sdistij(1:m-k,:));
% end
% [~, temp1]=min(Sdist);                     %删除下标为temp1的场景  
% px=sort(Distance(temp1,:));
% temp2=find(Distance(temp1,:)==px(2));      %将temp1场景出现的场景加到temp2上
% p(temp2)=p(temp1)+p(temp2);
% p(temp1)=[];
% Distance(temp1,:)=[];Distance(:,temp1)=[];
% Sdistij(temp1,:)=[];Sdistij(:,temp1)=[];
% Sdist(temp1)=[];
% end
% [m1,n1]=find(D==Distance(1,2));
% subplot(1,3,3);plot(0:24,data(m1(2),:),'r');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% plot(0:24,data(m1(1),:),'b');
% ylim([0 150]);xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
%%      %%
clear all;clc
load Pwts;
load a;
data=Pwts;
data=[a data];
[m,n]=size(data);
% subplot(2,3,1)
% for i=1:m                                     %显示原始夏季光伏出力
%     plot(0:24,data(i,:));
%     ylim([0 400]);xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% end
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
subplot(1,3,1);plot(0:24,data(m1(2),:),'r');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
plot(0:24,data(m1(1),:),'b');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
%%                                                过渡季
clear all;clc
load Pwtinter;
load b;
data=Pwtinter;
data=[b data];
[m,n]=size(data);
% subplot(2,3,2)
% for i=1:m                                     
%     plot(0:24,data(i,:));
%     ylim([0 400]);xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% end
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
subplot(1,3,2);plot(0:24,data(m1(2),:),'r');
xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
ylim([0 400]);
plot(0:24,data(m1(1),:),'b');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
%%                                            冬季
clear all;clc
load Pwtw;
data=Pwtw;
load c;
data=[c data];
[m,n]=size(data);
% subplot(2,3,3)
% for i=1:m                                    
%     plot(0:24,data(i,:))
%     ylim([0 400]);;xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
% end
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
subplot(1,3,3);plot(0:24,data(m1(2),:),'r');xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
plot(0:24,data(m1(1),:),'b');
ylim([0 400]);xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on









        









        








        
