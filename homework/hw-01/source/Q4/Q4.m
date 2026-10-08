% first we define continuous system H
s = tf('s');
Hs = (-30*s^2 + 60*s + 90) / (s^3 + 20*s^2 + 81*s + 90);

% then we define sample time
Ts = 0.05; 

% noiw we dscretize using all methods
Hzoh = c2d(Hs, Ts, 'zoh');em
Hfoh = c2d(Hs, Ts, 'foh');
Himp = c2d(Hs, Ts, 'impulse');
Htus = c2d(Hs, Ts, 'tustin');
Hpre = c2d(Hs, Ts, 'prewarp', 5); % omega = 5 rad/s
Hmat = c2d(Hs, Ts, 'matched');
Hlsq = c2d(Hs, Ts, 'least-squares');

% custome axis intervlas ( just to get a better look ) 
opts = bodeoptions;
opts.XLim = [1, 100];
opts.YLim = {[-40 , 12] , [-5, 360]}; 

% Plot
figure;
bodeplot(Hs, Hzoh, Hfoh, Himp, Htus, Hpre, Hmat, Hlsq, opts);
grid on;

% add legend for clarity
legend('Continuous', 'ZOH', 'FOH', 'Impulse', 'Tustin', ...
       'Prewarp', 'Matched', 'Least-Squares', 'Location', 'best');
title('Frequency Response Comparison of Discretization Methods');
