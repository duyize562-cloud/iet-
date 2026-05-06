clear all; clc; close all;

%% 1. 数据加载与基础处理
load vWT2011; % 确保文件存在
load Ppv2011;
vWT = vWT2011; 
v = vWT(3:4:8760*4); % 每小时取一个点

% 风机出力计算 (400kW)
vc=0.5; vr=11; vF=25; PR=400;
Pwt = zeros(1, 8760);
for i=1:8760
    if (v(i)>=vc)&&(v(i)<vr)
        Pwt(i)=PR*(v(i)-vc)/(vr-vc);
    elseif(v(i)>=vr)&&(v(i)<=vF)
        Pwt(i)=PR;
    else
        Pwt(i)=0;
    end
end

% 展示全年的原始出力图 (Figure 1 & 2)
figure(1); plot(1:8760,Pwt); xlim([0 8760]); title('全年风机出力');
figure(2); plot(1:8760,Ppv2011); xlim([0 8760]); title('全年光伏出力');

%% 2. 季节数据划分
% 按照你原代码的索引划分
idx_s = 3000:5231;      % 夏季
idx_inter = [1296:2999, 5232:7415]; % 过渡季
idx_w = [1:1295, 7416:8760]; % 冬季

reformat = @(data, idx) reshape(data(idx(1:floor(length(idx)/24)*24)), 24, [])';

Ppvs = reformat(Ppv2011, idx_s);
Ppvinter = reformat(Ppv2011, idx_inter);
Ppvw = reformat(Ppv2011, idx_w);

% 绘制季节叠加图 (Figure 3, 4, 5)
figure(3); plot(1:24, Ppvs'); xlim([1 24]); title('夏季原始光伏叠加'); hold on;
figure(4); plot(1:24, Ppvinter'); xlim([1 24]); title('过渡季原始光伏叠加'); hold on;
figure(5); plot(1:24, Ppvw'); xlim([1 24]); title('冬季原始光伏叠加'); hold on;

%% 3. 数值化概率建模 (避开 sym 报错)
% 将所有光伏数据整合
YearPpv = [Ppvs(:, 1:24); Ppvinter(:, 1:24); Ppvw(:, 1:24)];
YearPwt = reshape(Pwt(1:365*24), 24, 365)';

% 计算 07:00 的分布用于展示 (Figure 9, 10, 11)
h_hour = 7;
X_pv = YearPpv(:, h_hour);
Y_wt = YearPwt(:, h_hour);

% 核密度估计
[f_pv, x_grid] = ecdf(X_pv);
[f_wt, y_grid] = ecdf(Y_wt);

figure(9); plot(x_grid, f_pv, 'b*'); title('07:00 光伏分布拟合');
figure(10); plot(x_grid, ksdensity(X_pv, x_grid, 'function', 'cdf'), 'r-'); title('07:00 光伏分布曲线');
figure(11); plot(y_grid, ksdensity(Y_wt, y_grid, 'function', 'cdf'), 'g-'); title('07:00 风机分布曲线');

%% 4. Copula 相关性建模 (Figure 12 & 13)
U = ksdensity(X_pv, X_pv, 'function', 'cdf');
V = ksdensity(Y_wt, Y_wt, 'function', 'cdf');
rho = copulafit('Gaussian', [U, V]);

[Ugrid, Vgrid] = meshgrid(linspace(0,1,31));
Cpdf = reshape(copulapdf('Gaussian', [Ugrid(:), Vgrid(:)], rho), 31, 31);
Ccdf = reshape(copulacdf('Gaussian', [Ugrid(:), Vgrid(:)], rho), 31, 31);

figure(12); surf(Ugrid, Vgrid, Cpdf); title('Copula 概率密度面');
figure(13); surf(Ugrid, Vgrid, Ccdf); title('Copula 累积分布面');

%% 5. 随机采样与 K-means 最终缩减 (Figure 14 & 15)
N_sim = 10000;
cPpv = zeros(N_sim, 24);
cPwt = zeros(N_sim, 24);

% 快速数值采样逻辑
for h = 1:24
    Xh = YearPpv(:, h);
    Yh = YearPwt(:, h);
    if std(Xh)>0 && std(Yh)>0
        Uh = ksdensity(Xh, Xh, 'function', 'cdf');
        Vh = ksdensity(Yh, Yh, 'function', 'cdf');
        rh = copulafit('Gaussian', [Uh, Vh]);
        uv = copularnd('Gaussian', rh, N_sim);
        [fx, gx] = ecdf(Xh); [fy, gy] = ecdf(Yh);
        cPpv(:, h) = interp1(fx, gx, uv(:,1), 'linear', 'extrap');
        cPwt(:, h) = interp1(fy, gy, uv(:,2), 'linear', 'extrap');
    end
end

% 聚类生成 6 个典型场景
N_clus = 6;
[idx, centers] = kmeans([cPpv, cPwt], N_clus, 'Replicates', 3);

% 绘制最终输出 (Figure 14 & 15)
figure(14); plot(1:24, centers(:, 1:24)'); title('最终缩减：6类光伏典型场景');
figure(15); plot(1:24, centers(:, 25:48)'); title('最终缩减：6类风机典型场景');

% 输出概率
for i = 1:N_clus
    fprintf('场景 %d 概率: %.4f\n', i, sum(idx==i)/N_sim);
end