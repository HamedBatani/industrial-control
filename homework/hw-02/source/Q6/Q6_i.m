s = tf('s');

Gaug = 1/(s*(s + 1));

P = 20*s + 40;
L = s + 8;

C = P/L;

Tdist = feedback(Gaug,C);

t = 0:0.01:20;

d = zeros(size(t));

idx = t >= 3;

d(idx) = t(idx) - 3;

[y,t] = lsim(Tdist,d,t);

figure
plot(t,d,'--',t,y,'LineWidth',1.5)
grid on
xlabel('Time (s)')
ylabel('Output')
title('Response to Ramp Disturbance')
legend('Ramp Disturbance','Output')