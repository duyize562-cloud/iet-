function [objvalue]=calobjvalue(pop)
temp1=decodechrom(pop,1,15);
temp2=decodechrom(pop,16,15);
x1=pi+temp1*pi/(2^15-1);
x2=pi+temp2*pi/(2^15-1);
objvalue=sin(x1.^2.*x2)+cos(x1./x2)+3;
end            %计算目标函数值
