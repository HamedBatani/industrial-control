
% I) first we define system matrices
A = [ -2   1    0    0    0;
       0 -1.2  0.5   0    0;
       0   0   -3    0   0.8;
       0   0    0   -1.5 -0.6;
       0   0    0     0   -4 ];

B = [0; 1; 0; 1; 0] ;

C = [1 0.5 1 0 0.2] ;

D = 0;

% II)now we  define time vector and input u
Ts = 0.01;                 % sampling time
t  = 0:Ts:50;              % time vector
u  = zeros(size(t));       % init input
% piecewise input
u(t>=5  & t<=15) = 2;
u(t>=25 & t<=35) = -1;

function [X, Y] = euler_sim(A,B,C,D,Ts,t,u,x0)

    % III) define storage for state
    X = zeros(length(x0), length(t));
    X(:,1) = x0;
    % IV) define storage for output
    Y = zeros(size(t));
    Y(1) = C * x0 + D * u(1);
    % V–VI) euler loop
    for i = 2:length(t)
        xd = A*X(:,i-1) + B*u(i-1);         % state derivative
        X(:,i) = X(:,i-1) + Ts * xd;        % euler update
        Y(i)   = C*X(:,i) + D*u(i);         % output update
    end
end
% initial condition cases
x0a = [1;0;0;0;0];
x0b = [0;0;1;0;0];
x0c = [1;0;0;0;1];
% simulate all cases
[Xa, Ya] = euler_sim(A,B,C,D,Ts,t,u,x0a);
[Xb, Yb] = euler_sim(A,B,C,D,Ts,t,u,x0b);
[Xc, Yc] = euler_sim(A,B,C,D,Ts,t,u,x0c);


% plot

figure('Color','w','Position',[200 100 1200 800])
subplot(3,2,1)
plot(t, Xa,'LineWidth',1.8)
title('case a: states','color','k')
xlabel('t (s)'), ylabel('x_i(t)')
grid on
legend('x1','x2','x3','x4','x5','location','best')
set(gca,'fontsize',10)
subplot(3,2,2)
plot(t, Ya,'m','LineWidth',2.2)
title('case a: output y(t)','color','k')
xlabel('t (s)'), ylabel('y(t)')
grid on
set(gca,'fontsize',10)


subplot(3,2,3)
plot(t, Xb,'LineWidth',1.8)
title('case b: states','color','k')
xlabel('t (s)'), ylabel('x_i(t)')
grid on
legend('x1','x2','x3','x4','x5','location','best')
set(gca,'fontsize',10)
subplot(3,2,4)
plot(t, Yb,'m','LineWidth',2.2)
title('case b: output y(t)','color','k')
xlabel('t (s)'), ylabel('y(t)')
grid on
set(gca,'fontsize',10)

subplot(3,2,5)
plot(t, Xc,'LineWidth',1.8)
title('case c: states','color','k')
xlabel('t (s)'), ylabel('x_i(t)')
grid on
legend('x1','x2','x3','x4','x5','location','best')
set(gca,'fontsize',10)

subplot(3,2,6)
plot(t, Yc,'m','LineWidth',2.2)
title('case c: output y(t)','color','k')
xlabel('t (s)'), ylabel('y(t)')
grid on
set(gca,'fontsize',10)


