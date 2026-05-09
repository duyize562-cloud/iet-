% === 极简极速版 minlp.m ===
clear all; close all; clc;

tic; % 开始计时

% 1. 配置 APMonitor 服务器
addpath('apm');
server = 'http://xps.apmonitor.com'; % 也可以换 'http://apmonitor.com'
app = 'SUC_DR_Model';                % 给你的应用起个名字

% 2. 清理旧缓存并加载新模型
apm(server, app, 'clear all');
apm_load(server, app, 'minlp.apm');  % 加载你刚才保存的 apm 文件

% 3. 核心：调用云端顶级混合整数求解器 APOPT
apm_option(server, app, 'nlc.solver', 1); % 1表示启用 APOPT MINLP 求解器
apm_option(server, app, 'nlc.imode', 3);  % 3表示稳态优化模式

% 4. 一键求解
disp('正在云端求解两阶段随机机组组合模型，请稍候...');
apm(server, app, 'solve');                

% 5. 获取并展示结果
sol = apm_sol(server, app);
disp(['求解完成！总耗时 ', num2str(toc), ' 秒']);

% 打开网页版结果查看器（可选）
apm_var(server, app);
