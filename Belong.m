function rel=Belong(a,set,num)
rel=0;
for i=1:num
   if a==set(i)
      rel=1;
      break;
   end
end