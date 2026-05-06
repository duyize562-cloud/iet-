function pop2=decodechrom(pop,spoint,length)
pop1=pop(:,spoint:spoint+length-1);
pop2=decodebinary(pop1);
end            %将二进制编码转化为十进制

