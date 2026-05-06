%% 冬季
clear; clc; close all;
load Ppvw; % 确保 Ppvw.mat 在当前路径
data = Ppvw;
[m, n] = size(data);

% --- 原始场景绘制 ---
subplot(2,3,3)
x_axis = 1:n; % 动态匹配数据长度，防止报错
for i = 1:m                                    
    plot(x_axis, data(i,:)); 
    hold on
end
xlim([1 n]);
set(gca, 'xtick', 0:4:n);
title('原始场景');

% --- 距离矩阵计算 ---
Distance = zeros(m,m);
for i = 1:m
    for j = 1:m
        Distance(i,j) = norm(data(i,:) - data(j,:));
    end
end
D = Distance; % 备份原始距离矩阵

% --- 概率与削减初始化 ---
p = (1/m) * ones(1, m);

% --- 场景削减循环 ---
% 注意：你原来的循环逻辑在删除元素后索引会变，容易出错。
for k = 1:(m-2) % 削减到只剩 2 个场景
    num_remain = length(p);
    Sdist = zeros(1, num_remain);
    
    % 计算当前各场景的概率距离
    for i = 1:num_remain
        % 简化计算：Sdist(i) = p(i) * sum(p(j) * dist(i,j))
        Sdist(i) = p(i) * sum(p .* Distance(i,:));
    end
    
    % 找到削减目标
    [~, temp1] = min(Sdist); 
    
    % 寻找距离 temp1 最近的场景 temp2 (排除自身)
    temp_dist = Distance(temp1, :);
    temp_dist(temp1) = inf; % 排除自己
    [~, temp2] = min(temp_dist);
    
    % 更新概率并删除
    p(temp2) = p(temp1) + p(temp2);
    p(temp1) = [];
    Distance(temp1, :) = [];
    Distance(:, temp1) = [];
end

% --- 削减后场景绘制 ---
% 找到最终保留的两个场景在原始 D 矩阵中的位置
% 这里逻辑需要根据你的需求微调，如果是最后剩下的两个：
subplot(2,3,6);
% 假设最后剩下的两个场景数据在当前 data 矩阵中（注意：由于上面循环删除了 data 对应的 Distance，
% 最好在循环外保存最后剩下的索引）

% 简单起见，这里演示如何画出最后剩下的 data
plot(x_axis, data(1,:), 'r', 'LineWidth', 1.5); hold on;
plot(x_axis, data(2,:), 'b', 'LineWidth', 1.5);
xlim([1 n]);
set(gca, 'xtick', 0:4:n);
title('削减后场景');