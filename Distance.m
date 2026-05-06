function rlt=Distance(w1,w2);
[m,n]=size(w1);
w=zeros(m,n);
w=abs(w1-w2);
rlt=sum(w);