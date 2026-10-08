% set up

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\c\c_2';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% fixed parameters from paper
K         = 1;
T         = 1;
T_settle  = 1;
b0        = K/T;
Ts        = 0.01;
noise_var = 0.0001;
t_end     = 2.0;

k_ob_vals = [5, 1, 2, 10];

% i tried matching colors with original figures for easier grading
colors = {'k','b','g','r'};
lws    = [2.5, 1, 1, 1];

fig = figure('Name','Fig20 - Observer Pole Effect','Position',[100,100,900,400]);

t = 0:Ts:t_end;
N = length(t);

% controller gains (fixed)
s_CL = -4 / T_settle;
Kp   = -s_CL;

% plant discretization (fixed)
a_p = exp(-Ts/T);
b_p = K*(1 - exp(-Ts/T));

% discrete matrices (fixed)
Ad = [1, Ts; 0, 1];
Bd = [b0*Ts; 0];
Cd = [1, 0];

for idx = 1:length(k_ob_vals)
    k_ob = k_ob_vals(idx);

    % ESO poles
    s_ESO = k_ob * s_CL;
    z_ESO = exp(s_ESO * Ts);

    % observer gains from paper eq(25)
    l1 = 1 - z_ESO^2;
    l2 = (1/Ts) * (1 - z_ESO)^2;
    Ld = [l1; l2];

    % initialise
    x_hat = [0; 0];
    u_k   = 0;
    y_p   = 0;
    y_arr = zeros(1,N);
    u_arr = zeros(1,N);

    for k = 1:N
        % measurement with noise
        y_meas = y_p + sqrt(noise_var)*randn();

        % ESO update (current form)
        x_hat = (Ad - Ld*Cd*Ad)*x_hat + (Bd - Ld*Cd*Bd)*u_k + Ld*y_meas;

        % control law
        r_k = 1; % step reference
        u_k = (1/b0)*(Kp*(r_k - x_hat(1)) - x_hat(2));

        % plant update
        y_p = a_p*y_p + b_p*u_k;

        y_arr(k) = y_meas;
        u_arr(k) = u_k;
    end

    subplot(1,2,1); hold on; grid on;
    plot(t, y_arr, 'Color', colors{idx}, 'LineWidth', lws(idx), ...
         'DisplayName', ['kESO = ', num2str(k_ob)]);

    subplot(1,2,2); hold on; grid on;
    plot(t, u_arr, 'Color', colors{idx}, 'LineWidth', lws(idx), ...
         'DisplayName', ['kESO = ', num2str(k_ob)]);
end

subplot(1,2,1);
plot([0 t_end],[1 1],'k:','HandleVisibility','off');
title('(a)'); xlabel('t'); ylabel('y');
axis([0 t_end 0 1.2]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(b)'); xlabel('t'); ylabel('u');
axis([0 t_end 0 4]); legend('Location','northeast','FontSize',7);

% Code to save the figure would go here
fname = fullfile(save_dir, 'Fig20_ObserverPoles.jpg');
exportgraphics(fig, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);