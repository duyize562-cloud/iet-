%% 清理环境
clear; clc; close all;

%% 1. 数据准备
% 如果你有数据文件，请取消下面一行的注释并替换文件名：
% load('your_data.mat'); 

% --- 模拟数据部分 (如果没有加载外部数据，请确保 Ppvs 和 Pwts 已定义) ---
% 这里假设 Ppvs 和 Pwts 是包含至少10列的矩阵
if ~exist('Ppvs', 'var')
    fprintf('未检测到 Ppvs，生成模拟数据进行演示...\n');
    Ppvs = randn(100, 10); 
    Pwts = Ppvs * 0.8 + randn(100, 10) * 0.2; % 增加相关性
end

% 提取第10列数据
X = Ppvs(:, 10);
Y = Pwts(:, 10);

%% 2. 绘制频率直方图
[fx, xc] = ecdf(X);
figure('Name', '沪市直方图');
ecdfhist(fx, xc, 30);
xlabel('沪市日收益率'); ylabel('f(x)');

[fy, yc] = ecdf(Y);
figure('Name', '深市直方图');
ecdfhist(fy, yc, 30);
xlabel('深市日收益率'); ylabel('f(y)');

%% 3. 计算经验分布函数值 (关键修正点)
% 使用 tiedrank 替代复杂的排序映射，计算原始样本对应的经验分布值 [0,1]
U = tiedrank(X) / (length(X) + 1);
V = tiedrank(Y) / (length(Y) + 1);

% 为了绘图，保留 U1, V1 命名
U1 = U; V1 = V;

%% 4. 核分布估计
U2 = ksdensity(X, X, 'function', 'cdf');
V2 = ksdensity(Y, Y, 'function', 'cdf');

% 绘制经验分布 vs 核分布
[Xsort, idX] = sort(X);
figure('Name', '沪市分布拟合');
plot(Xsort, U1(idX), 'c', 'LineWidth', 5); hold on;
plot(Xsort, U2(idX), 'k-.', 'LineWidth', 2);
legend('经验分布函数', '核分布估计', 'Location', 'NorthWest');
xlabel('沪市日收益率'); ylabel('F(x)');

[Ysort, idY] = sort(Y);
figure('Name', '深市分布拟合');
plot(Ysort, V1(idY), 'c', 'LineWidth', 5); hold on;
plot(Ysort, V2(idY), 'k-.', 'LineWidth', 2);
legend('经验分布函数', '核分布估计', 'Location', 'NorthWest');
xlabel('深市日收益率'); ylabel('F(y)');

%% 5. 绘制二元频数/频率直方图
figure('Name', '二元频数直方图');
hist3([U, V], [30, 30]);
xlabel('U（沪市）'); ylabel('V（深市）'); zlabel('频数');

figure('Name', '二元频率直方图');
hist3([U, V], [30, 30]);
h = get(gca, 'Children');
cuv = get(h, 'ZData');
set(h, 'ZData', cuv * 30 * 30 / length(X));
xlabel('U（沪市）'); ylabel('V（深市）'); zlabel('c(u,v)');

%% 6. Copula 参数估计
% 估计正态 Copula 参数
rho_norm = copulafit('Gaussian', [U, V]);
% 估计 t-Copula 参数
[rho_t, nuhat] = copulafit('t', [U, V]);

fprintf('正态 Copula 相关系数: %.4f\n', rho_norm);
fprintf('t-Copula 相关系数: %.4f, 自由度: %.4f\n', rho_t, nuhat);

%% 7. 绘制 Copula 密度与分布函数
[Ugrid, Vgrid] = meshgrid(linspace(0, 1, 31));
u_vec = Ugrid(:); v_vec = Vgrid(:);

% 正态 Copula
Cpdf_norm = copulapdf('Gaussian', [u_vec, v_vec], rho_norm);
Ccdf_norm = copulacdf('Gaussian', [u_vec, v_vec], rho_norm);

% t-Copula
Cpdf_t = copulapdf('t', [u_vec, v_vec], rho_t, nuhat);
Ccdf_t = copulacdf('t', [u_vec, v_vec], rho_t, nuhat);

% 绘图示例：正态 Copula 密度
figure('Name', '正态 Copula 密度');
surf(Ugrid, Vgrid, reshape(Cpdf_norm, size(Ugrid)));
xlabel('U'); ylabel('V'); zlabel('c(u,v)');

%% 8. 相关系数对比
Kendall_norm = copulastat('Gaussian', rho_norm);
Spearman_norm = copulastat('Gaussian', rho_norm, 'type', 'Spearman');
Kendall_data = corr([X, Y], 'type', 'Kendall');

fprintf('原始数据的 Kendall 秩相关系数:\n'); disp(Kendall_data);

%% 9. 模型评价 (平方欧氏距离)
% 定义经验 Copula
C_emp_func = @(u, v) mean((U <= u) .* (V <= v));

% 计算原始样本点处的经验 Copula 值
CUV_emp = zeros(size(U));
for i = 1:length(U)
    CUV_emp(i) = C_emp_func(U(i), V(i));
end

% 计算参数化 Copula 在样本点处的值
Cgau = copulacdf('Gaussian', [U, V], rho_norm);
Ct = copulacdf('t', [U, V], rho_t, nuhat);

% 平方欧氏距离
dgau2 = sum((CUV_emp - Cgau).^2);
dt2 = sum((CUV_emp - Ct).^2);

fprintf('正态 Copula 平方欧氏距离: %.6f\n', dgau2);
fprintf('t-Copula 平方欧氏距离: %.6f\n', dt2);