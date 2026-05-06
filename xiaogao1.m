%% 1. 初始化与数据加载
clear all; clc; close all;
% 假设 YearPpv 和 YearPwt 已经存在于路径中
load YearPpv; 
load YearPwt;

%% 2. 符号变量定义（仅保留必要的）
syms x h; 

%% 3. 处理光伏 (PV) 出力分布
% 定义季节天数
seasons_n = [93, 162, 110]; % 夏、过渡、冬
seasons_range = {1:93, 94:255, 256:365};
seasons_name = {'Summer', 'Inter', 'Winter'};

% ---------------- PV 核密度估计 ----------------
% 以夏季为例演示修正后的循环逻辑（其他季节逻辑相同）
n = seasons_n(1);
% 修改点：不再使用 sym('字符串')，直接数值累加生成符号表达式
F1s = cell(1, 14); % 使用 cell 存储不同小时的分布函数表达式
for j = 7:20
    y_data = YearPpv(seasons_range{1}, j);
    S = std(y_data);
    h_opt = 1.059 * S * n^(-1/5);
    
    % 修正后的累加方式：
    f_temp = 0;
    for i = 1:n
        % 直接进行符号运算，不带引号
        f_temp = f_temp + exp(-(x - y_data(i))^2 / (2 * h_opt^2)) / (sqrt(2 * pi) * h_opt);
    end
    f_temp = f_temp / n;
    % 计算分布函数（积分）
    F1s{j-6} = int(f_temp, x, -inf, x); 
end

% (注：为了篇幅，过渡季和冬季的积分逻辑与上方一致，请参照修改)

%% 4. 计算所有样本的分布函数值 (F_Ppvs等)
% 这里建议使用 MATLAB 自带的 ksdensity 以提高计算速度，
% 因为 subs 在 10000 次循环中会极其缓慢。
F_Ppvs = zeros(93, 14);
for k = 1:14
    X_col = YearPpv(1:93, k+6);
    F_Ppvs(:, k) = ksdensity(X_col, X_col, 'function', 'cdf');
end
% 拼接其他时段（补零）
A = zeros(93, 10);
U_pv = zeros(93, 10);
for i = 1:10
    U_pv(:, i) = ksdensity(A(:, i), A(:, i), 'function', 'cdf');
end
F_Ppvs = [U_pv(:, 1:6), F_Ppvs, U_pv(:, 7:10)];

% (风电 YearPwt 的处理逻辑同理)

%% 5. Copula 函数建模与采样
% 以夏季 12 点为例
X_12 = YearPpv(1:93, 12);
Y_12 = YearPwt(1:93, 12);
U_12 = ksdensity(X_12, X_12, 'function', 'cdf');
V_12 = ksdensity(Y_12, Y_12, 'function', 'cdf');

% 估计高斯 Copula 参数
rho_norm = copulafit('Gaussian', [U_12, V_12]);

% 生成 10000 个联合分布随机样本
N = 10000;
rng('default'); % 保证结果可复现
Cs = copularnd('Gaussian', rho_norm, N);

%% 6. 反函数求解 (由概率回到功率)
% 原代码使用 subs 求解三次样条非常慢
% 建议使用 interp1 数值插值代替符号运算
cPpvs = zeros(N, 24);
cPwts = zeros(N, 24);

for k = 1:24
    % 构造光伏累积分布的数值对应关系
    [f_val, x_val] = ecdf(YearPpv(1:93, k));
    % 使用数值插值实现反函数：输入概率 Cs(:,1)，输出功率
    cPpvs(:, k) = interp1(f_val, x_val, Cs(:, 1), 'linear', 'extrap');
    
    % 风电同理
    [fw_val, xw_val] = ecdf(YearPwt(1:93, k));
    cPwts(:, k) = interp1(fw_val, xw_val, Cs(:, 2), 'linear', 'extrap');
end

%% 7. K-means 场景缩减
data_combined = [cPpvs, cPwts];
N_clusters = 2; % 缩减为 2 个典型场景

% 使用 MATLAB 官方高性能函数代替手写循环
[idx, centers] = kmeans(data_combined, N_clusters, 'Replicates', 5);

% 计算每个场景的概率
prob = zeros(1, N_clusters);
for i = 1:N_clusters
    prob(i) = sum(idx == i) / N;
end

%% 8. 结果可视化
figure;
subplot(2,1,1);
plot(1:24, centers(1, 1:24), 'r', 'LineWidth', 1.5); hold on;
plot(1:24, centers(2, 1:24), 'b', 'LineWidth', 1.5);
title('PV Typical Scenarios'); xlabel('Hour'); ylabel('Power (kW)');

subplot(2,1,2);
plot(1:24, centers(1, 25:48), 'r', 'LineWidth', 1.5); hold on;
plot(1:24, centers(2, 25:48), 'b', 'LineWidth', 1.5);
title('Wind Typical Scenarios'); xlabel('Hour'); ylabel('Power (kW)');

disp('典型场景概率：');
disp(prob);