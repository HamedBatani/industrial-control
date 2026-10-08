% set up 
mdl = 'ladrc_model';
load_system(mdl);
% i tried matching colors with original figures for easier grading 
color_1   = 'k'; 
color_01  = 'b';
color_10  = [0.8 0.8 0]; 

% variation of K
K_values = [1, 0.1, 10];
T = 1;

% figure for K variation
fig_K = figure('Name', 'Variation of K', 'Position', [100, 100, 800, 400]);

for i = 1:length(K_values)
    K = K_values(i);
    assignin('base', 'K', K);
    assignin('base', 'T', T);
    
    
    if K == 1
        c = color_1; lw = 2.5;
    elseif K == 0.1
        c = color_01; lw = 1.0;
    elseif K == 10
        c = color_10; lw = 1.0;
    end
    
    % run
    out = sim(mdl, 'StopTime', '3.0'); 
    
    % Plot y Fig 3a
    figure(fig_K);
    subplot(1, 2, 1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', c, 'LineWidth', lw, 'DisplayName', ['K = ', num2str(K)]);
    
    % plot u Fig 3b
    subplot(1, 2, 2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', c, 'LineWidth', lw, 'DisplayName', ['K = ', num2str(K)]);
end

% Format K variation plots
subplot(1, 2, 1);
plot([0 3], [1 1], 'k:', 'HandleVisibility', 'off'); % Reference line
title('(a)'); xlabel('t'); ylabel('y');
axis([0 3 0 1.4]); legend('Location', 'southeast');

subplot(1, 2, 2);
title('(b)'); xlabel('t'); ylabel('u');
axis([0 3 -5 20]); legend('Location', 'northeast');


%variation of T 
K = 1;
T_values = [1, 0.1, 10];

% figure for T variation
fig_T = figure('Name', 'Variation of T', 'Position', [100, 550, 800, 400]);

for i = 1:length(T_values)
    T = T_values(i);
    assignin('base', 'K', K);
    assignin('base', 'T', T);
    
   
    if T == 1
        c = color_1; lw = 2.5;
    elseif T == 0.1
        c = color_01; lw = 1.0;
    elseif T == 10
        c = color_10; lw = 1.0;
    end
    
    % run
    out = sim(mdl, 'StopTime', '2.0'); 
    
    % plot y Fig 3c
    figure(fig_T);
    subplot(1, 2, 1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', c, 'LineWidth', lw, 'DisplayName', ['T = ', num2str(T)]);
    
    % Plot u Fig 3d
    subplot(1, 2, 2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', c, 'LineWidth', lw, 'DisplayName', ['T = ', num2str(T)]);
end

subplot(1, 2, 1);
plot([0 2], [1 1], 'k:', 'HandleVisibility', 'off'); % Reference line
title('(c)'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]); legend('Location', 'southeast');

subplot(1, 2, 2);
title('(d)'); xlabel('t'); ylabel('u');
axis([0 2 -5 20]); legend('Location', 'northeast');


% Save all open figures as Fig3_a, Fig3_b, etc.
save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\a\a_1';
if ~exist(save_dir, 'dir')
    mkdir(save_dir); 
end

% Get all figures and sort them by their Number property
figs = findobj('Type', 'figure');
[~, idx] = sort([figs.Number]);
figs = figs(idx);

suffix = 'abcd';
for i = 1:min(length(figs), 4)
    exportgraphics(figs(i), fullfile(save_dir, ['Fig3_', suffix(i), '.jpg']), 'Resolution', 300);
end
