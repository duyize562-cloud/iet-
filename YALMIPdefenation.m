% 假设调度周期 T = 24
T = 24;

% 1. 可转移负荷 (对应你截图的公式 3-17)
P_in = sdpvar(1, T, 'full');      % 转入功率
P_out = sdpvar(1, T, 'full');     % 转出功率
Zeta_in = binvar(1, T, 'full');   % 转入状态 (0-1变量)
Zeta_out = binvar(1, T, 'full');  % 转出状态 (0-1变量)

% 2. 可削减负荷 (对应公式 3-18)
P_cut = sdpvar(1, T, 'full');     % 削减功率
Zeta_cut = binvar(1, T, 'full');  % 削减状态

% 3. 可中断负荷 (对应公式 3-19)
P_inter = sdpvar(1, T, 'full');   % 中断后的运行功率
Zeta_inter = binvar(1, T, 'full');% 运行状态 (1表示运行，0表示中断)

% 4. 其他系统变量 (如常规发电机出力、买卖电功率等)
P_g = sdpvar(1, T, 'full');       
P_buy = sdpvar(1, T, 'full');

