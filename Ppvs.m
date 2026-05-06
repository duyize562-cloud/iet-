clc;
j=3000;
for n=1:100
    m=1;
    for k=1:8760
        A1(n,m)=Ppv(j);
        m=m+1;
        j=j+1;
        if m==26
            break
        end
    end
    j=j-1;
    if j==5232
        break
    end
end
for i=1:93
    plot(0:24,A1(i,:)),xlim([0 24]),set(gca,'xtick',[0:4:24]),hold on
end