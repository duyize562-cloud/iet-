f=0;h=0.5;n=93;
x1=Ppvs(:,10);
F=zeros(1,100);
x=Ppvs(:,10);
for i=1:n
for j=1:n
    F(i)=F(j)+(f*x(i))/50 + erfi((2^(1/2)*(x(i) - x1(j))*(-1/h^2)^(1/2))/2)/(100*(-1/h^2)^(1/2));
end
end
