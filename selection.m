function [newpop]=selection(pop,fitvalue)
totalfit=sum(fitvalue);
fitvalue=fitvalue/totalfit;
fitvalue=cumsum(fitvalue);
[px py]=size(pop);
ms=sort(rand(px,1));
fitin=1;
newin=1;
while newin<=px
    if(ms(newin))<fitvalue(fitin)
        newpop(newin)=pop(fitin);
        newin=newin+1;
    else
        fitin=fitin+1;
    end
end                 %Ñ¡Ôñ

