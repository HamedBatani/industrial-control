% input
ts = 0.01 ;
t = 0:ts:25;

u = chirp(t , 0.1, 25 , 50) ;

% systems
s = tf('s');
g1 = 20 * (s - 3)^2 / ((s + 1)^2 * (s + 0.8)^4) ;
g2 = 120 / (s + 1.6)^6 ;

g2.ioDelay = 1;

% apply function 
[m1_g1, m2_g1] = get_models(g1, u, t, ts);
[m1_g2, m2_g2] = get_models(g2, u, t, ts);

% plot
figure;
step(g1, m1_g1, m2_g1);
legend('true system', '1st order model', '2nd order model');
title('step responses for g1');

figure;
step(g2, m1_g2, m2_g2);
legend('true system', '1st order model', '2nd order model');
title('step responses for g2');
%  i tried defing a function so i can later do it with diffrent inputs
function [m1, m2] = get_models(g, u, t, ts)
    % obtain output
    y = lsim(g, u, t);
    
    u = u(:)'; 
    t = t(:)'; 
    y = y(:)';
    
    % find moments of input and output
    u0 = sum(u) * ts;
    u1 = sum(-t .* u) * ts;
    u2 = sum(t.^2 .* u) * ts;
    
    y0 = sum(y) * ts;
    y1 = sum(-t .* y) * ts;
    y2 = sum(t.^2 .* y) * ts;
    
    % find transfer function moments
    g0 = y0 / u0;
    g1 = (y1 - g0 * u1) / u0;
    g2 = (y2 - 2 * g1 * u1 - g0 * u2) / u0;
    
    % find parameters of models
    k = g0;
    tar = -g1 / g0;
    
    % first order 
    t1 = sqrt(g2 / g0 - tar^2);
    l1 = tar - t1;
    m1 = tf(k, [real(t1) 1], 'ioDelay', max(0, real(l1)));
    
    % second order 
    t2 = sqrt(g2 / (2 * g0) - 0.5 * tar^2);
    l2 = tar - 2 * t2;
    m2 = tf(k, conv([real(t2) 1], [real(t2) 1]), 'ioDelay', max(0, real(l2)));
end

% rich input

u_rich = zeros(size(t));
hold_time = 1; 
samples_per_hold = round(hold_time / ts);
active_duration = 10; 
num_holds = active_duration / hold_time;

% generating prbs
rng(1); 
for i = 1:num_holds
    level = randi([0, 1]); 
    start_idx = (i-1)*samples_per_hold + 1;
    end_idx = i*samples_per_hold;

    u_rich(start_idx:end_idx) = level;
end



[m1_g1_rich, m2_g1_rich] = get_models(g1, u_rich, t, ts);


[m1_g2_rich, m2_g2_rich] = get_models(g2, u_rich, t, ts);
% plot 
figure;
step(g1, m1_g1_rich, m2_g1_rich);
legend('true system', '1st order model (PRBS)', '2nd order model (PRBS)', 'Location', 'best');
title('step responses for g1 (PRBS input)');
figure;
step(g2, m1_g2_rich, m2_g2_rich);
legend('true system', '1st order model (PRBS)', '2nd order model (PRBS)', 'Location', 'best');
title('step responses for g2 (PRBS input)');

