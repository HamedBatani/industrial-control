s = tf('s');

Gp = 1/(s + 1);
Gaug = 1/(s*(s + 1));

P = 20*s + 40;
L = s + 8;

C = P/L;

T = feedback(C*Gaug,1);

disp('Closed-loop poles:')
pole(T)

figure
pzmap(T)
grid on
title('Closed-Loop Pole Map')