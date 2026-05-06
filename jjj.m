load Ppv2011;
Ppv=Ppv2011;
j=7416;
for n=1:100
    m=1;
    for k=1:8760
        Ppvw1(n,m)=Ppv(j);
        m=m+1;
        j=j+1;
        if m==26
            break
        end
    end
    j=j-1;
    if j==8760
        break
    end
end
for i=1:56                                     %¶¬¼¾200kW¹â·ü³öÁ¦                  
       figure(5);plot(1:24,Ppvw1(i,1:24)),xlim([1 24]);hold on
end