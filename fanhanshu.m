syms x a coe;
s=sym('coe(i,1)*(x-a(i))^3+coe(i,2)*(x-a(i))^2+coe(i,3)*(x-a(i))+coe(i,4)');
Invs=finverse(s)

% Invs=subs(Invs,{'a(i)','coe(i,1)','coe(i,2)','coe(i,3)','coe(i,4)'},{a1(55),coe1(55,1),coe1(55,2),coe1(55,3),coe1(55,4)});
% Invs=subs(Invs,{'x'},{0.9946})
% eval(Invs)
load pvs;
for i=1:14
x1=pvs{i+6}(:,1);
y1=pvs{i+6}(:,2);
%%          三次样条插值
L=length(x1);
x1_pie=[y1(L)-y1(1)]/[x1(L)-x1(1)];
xL_pie=[y1(L)-y1(L-1)]/[x1(L)-x1(L-1)];
y2=[x1_pie;x1;xL_pie];
pp=csape(x1',y1','complete');
[a1,coe1]=unmkpp(pp);
a1s{i}=a1;coe1s{i}=coe1;
end