s = tf('s');

Gp = 1/(s + 1);
Gaug = 1/(s*(s + 1));

P = 20*s + 40;
L = s + 8;

C = P/L;

T = feedback(C*Gaug,1);

t = 0:0.01:20;

r = t;

[y,t] = lsim(T,r,t);

e = r' - y;

figure
plot(t,r,'--',t,y,'LineWidth',1.5)
grid on
xlabel('Time (s)')
ylabel('Output')
title('Ramp Tracking')
legend('Ramp Input','System Output')

figure
plot(t,e,'LineWidth',1.5)
grid on
xlabel('Time (s)')
ylabel('Error')
title('Tracking Error')