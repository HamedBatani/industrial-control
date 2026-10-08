s = tf('s');
g = 1/(s+1)^8 ;
[y, t] = step(g, 40);
dt = t(2) - t(1) ;
k = y(end);

% part a ( residence time approximation method was used here )

a0 = sum(k - y) * dt;
t_a = a0 / k;

g_a = tf(k, [t_a 1]) ;

fprintf('part a:\n')
fprintf('k: %f\n', k)

fprintf('t_a: %f\n', t_a)

% part b ( area method )
tar = a0 / k ;
idx = find(t <= tar, 1, 'last');
a1 = sum(y(1:idx)) * dt;

t_b = (exp(1) * a1) /k;
l_b = tar - t_b;

g_b = tf(k, [t_b 1], 'ioDelay', l_b);

fprintf('\npart b:\n')
fprintf('k: %f\n', k)
fprintf('t_b: %f\n', t_b)
fprintf('l_b: %f\n', l_b)

% part c ( four parameter model )
dydt = diff(y) ./ diff(t);
[m, im] = max(dydt);
tm = t(im);
ym = y(im);

l_c = tm - ym/m; 
a_val = abs(ym - m*tm); 

% as disscused in class , 0.2 and 0.8 would be good time to match
idx_20 = find(y >= 0.2*k, 1);
t20 = t(idx_20);
idx_80 = find(y >= 0.8*k, 1);
t80 = t(idx_80);

% numerical solve for t1 and t2
fun = @(x) [1 - (x(1)*exp(-(t20-l_c)/x(1)) - x(2)*exp(-(t20-l_c)/x(2)))/(x(1)-x(2)) - 0.2; ...
            1 - (x(1)*exp(-(t80-l_c)/x(1)) - x(2)*exp(-(t80-l_c)/x(2)))/(x(1)-x(2)) - 0.8];
        
x0 = [2; 1]; 
opts = optimoptions('fsolve', 'Display', 'off');
sol = fsolve(fun, x0, opts);

t1_c = sol(1);
t2_c = sol(2);

fprintf('\npart c:\n')

fprintf('k: %f\n', k)

fprintf('t1_c: %f\n', t1_c)
fprintf('t2_c: %f\n', t2_c)
fprintf('l_c: %f\n', l_c)
g_c = tf(k, conv([t1_c 1], [t2_c 1]), 'ioDelay', l_c);

% plot to compare
figure;
step(g, g_a, g_b, g_c, 40)

legend('original', 'part a', 'part b', 'part c')
