clear all
clc
popsize=1;
chromlength=17;
x1=zeros(popsize,chromlength);
x2=zeros(popsize,chromlength);
pop=zeros(popsize,chromlength);
k=1;
x=[];
y=[];
eps=0.005;
while k<21
%     for i=1:20
%         for j=1:20
          if abs(x1+x2-4)<=eps
          x(k)=x1;
          y(k)=x2;
          pop(k,:)=pop11;
          k=k+1;
          end
%         end
          if k>20
            break
          else
          pop11=round(rand(popsize,chromlength));
          temp1=decodechrom(pop11,1,8);
          temp2=decodechrom(pop11,9,9);
          x1=3-temp1*2/(2^8-1);
          x2=5-temp2*3/(2^9-1);
        end
%     end
end
    
        
        
    
