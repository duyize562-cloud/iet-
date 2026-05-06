function power=speedtopower(speed)
[m,n]=size(speed);
power=zeros(m,n);
for i=1:m
    for j=1:n
        
if speed(i,j)<=3
   power(i,j)=0;
elseif speed(i,j)<=14
    power(i,j)=1324.213-658.564*speed(i,j)+102.559*speed(i,j)*speed(i,j)-3.715*speed(i,j)*speed(i,j)*speed(i,j);
else
    power(i,j)=2000;
end

    end
end