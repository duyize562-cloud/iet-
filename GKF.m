%%                        %获取高斯核函数f及其分布函数F
clear all;clc
load Ppvs;
syms x y n a h f;
n=93;                         %夏季天数  
y=Ppvs(:,8);
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h                       %高斯核函数
F=int(f,x,-10^10,x);            %分布函数
S=std(y);
h_opt=1.059*S*n^(-1/5);       %采用经验带宽公式
F1=subs(F,{'h','f'},{h_opt,0})     %代入数值计算F1






    


    
    