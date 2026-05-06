function [windpower,proba]=genpowersce(speed,num)
[T,n]=size(speed);
elps=randn(T,num)*1;%生成正态随机分布数
err=zeros(T,num);%风速误差
forespeed=zeros(T,num);%预测风速
windpower=zeros(T,num);%预测风电
proba=zeros(1,num);
for j=1:T%生成风速预测误差序列
    if j==1
       err(j,:)=elps(j,:); 
    else
       err(j,:)=0.78*err(j-1,:)+elps(j,:)-0.34*elps(j-1,:);
    end
end

for i=1:num%计算风速以及平均风速误差
   forespeed(:,i)=err(:,i)+speed;
   proba(i)=1/num;
end

windpower=speedtopower(forespeed);%预测值风电出力