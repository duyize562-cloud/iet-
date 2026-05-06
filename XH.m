%%                         %获取高斯核函数f及其分布函数F
clear all;clc
load Ppvs;
syms x y n a h f;
n=93;                          %夏季天数  
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=7:20                     %07点至20点
y=Ppvs(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j-6)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1
end
%%
F11=0;
Fs=zeros(n,24)
for k=1:14
    for j=1:n
     y(j)=Ppvs(j,k+6);
     a=Ppvs(:,k+6);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=Ppvs(i,k+6);
     F111(i)=subs(F11,{'x'},{x(i)});
     Fs(i,k+6)=eval(F111(1,i));            %获取分布函数
    end
   F11=0;
end
%%                         %过渡季
load Ppvinter;
syms x y n a h f;
n=162;                          %过渡季天数  
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=7:20                     %07点至20点
y=Ppvinter(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j-6)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1
end
%%
F11=0;
Finter=zeros(n,24)
for k=1:14
    for j=1:n
     y(j)=Ppvinter(j,k+6);
     a=Ppvinter(:,k+6);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=Ppvinter(i,k+6);
     F111(i)=subs(F11,{'x'},{x(i)});
     Finter(i,k+6)=eval(F111(1,i));            %获取分布函数
    end
   F11=0;
end
%%                                        %冬季
load Ppvw;
syms x y n a h f;
n=110;                          %过渡季天数  
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=7:18                     %07点至18点
y=Ppvw(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j-6)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1
end
%%
F11=0;
Fw=zeros(n,24)
for k=1:12
    for j=1:n
     y(j)=Ppvw(j,k+6);
     a=Ppvw(:,k+6);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=Ppvw(i,k+6);
     F111(i)=subs(F11,{'x'},{x(i)});
     Fw(i,k+6)=eval(F111(1,i));            %获取分布函数
    end
   F11=0;
end
F_Ppv=[Fs;Finter;Fw];
%%                                   %风机出力
load Pwts;
syms x y n a h f;
n=93;                          %夏季天数  
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=1:24                    
y=Pwts(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1
end
%%
F11=0;
Fs=zeros(n,24)
for k=1:24
    for j=1:n
     y(j)=Pwts(j,k);
     a=Pwts(:,k);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=Pwts(i,k);
     F111(i)=subs(F11,{'x'},{x(i)});
     Fs(i,k)=eval(F111(1,i));            %获取分布函数
    end
   F11=0;
end
%%                         %过渡季
load Pwtinter;
syms x y n a h f;
n=162;                          %过渡季天数  
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=1:24                     
y=Pwtinter(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1
end
%%
F11=0;
Finter=zeros(n,24)
for k=1:24
    for j=1:n
     y(j)=Pwtinter(j,k);
     a=Pwtinter(:,k);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=Pwtinter(i,k);
     F111(i)=subs(F11,{'x'},{x(i)});
     Finter(i,k)=eval(F111(1,i));            %获取分布函数
    end
   F11=0;
end
%%                                        %冬季
load Pwtw;
syms x y n a h f;
n=110;                          %过渡季天数  
f=0;
for i=1:n
        f=sym('f+exp(-(x-y(i))^2/2/h^2)/sqrt(2*pi)');
end
f=f/n/h;                       %高斯核函数
F=int(f,x,-10^10,x);           %分布函数
for j=1:24                     
y=Pwtw(:,j);
S=std(y);
h_opt=1.059*S*n^(-1/5);                  %采用经验带宽公式
F1(j)=subs(F,{'h','f'},{h_opt,0});     %代入数值计算F1
end
%%
F11=0;
Fw=zeros(n,24)
for k=1:24
    for j=1:n
     y(j)=Pwtw(j,k);
     a=Pwtw(:,k);
     S=std(a);
     h_opt=1.059*S*n^(-1/5); 
     F11=F11+subs(F1(1,k),{'y(i)','h'},{y(j),h_opt});
    end
    for i=1:n
     x(i)=Pwtw(i,k);
     F111(i)=subs(F11,{'x'},{x(i)});
     Fw(i,k)=eval(F111(1,i));            %获取分布函数
    end
   F11=0;
end
F_Pwt=[Fs;Finter;Fw];
        
        
        
            
        
   






    


    
    