s = tf('s');

Gp = 1/(s + 1);

K = 5;

Tprop = feedback(K*Gp,1);

t = 0:0.01:20;

r = t;

[y,t] = lsim(Tprop,r,t);

e = r' - y;

figure
plot(t,r,'--',t,y,'LineWidth',1.5)
grid on
xlabel('Time (s)')
ylabel('Output')
title('Ramp Tracking with Proportional Controller')
legend('Ramp Input','System Output')

figure
plot(t,e,'LineWidth',1.5)
grid on
xlabel('Time (s)')
ylabel('Error')
title('Tracking Error with Proportional Controller')