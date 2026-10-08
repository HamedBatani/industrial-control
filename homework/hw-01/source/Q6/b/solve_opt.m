% first we define objective function
obj_fun = @(x) -2*x(1)*x(2) - x(2)*x(3);

% Initial guess
x0 = [1, 1, 1];

% bounds
lb = [0, 0, 0];
ub = [];

% fmincon
options = optimoptions('fmincon', 'Display', 'iter');
[x_opt, fval] = fmincon(obj_fun, x0, [], [], [], [], lb, ub, @mycon, options);

% display
disp('Optimal x:');
disp(x_opt);
disp('Minimum function value:');
disp(fval);

% local functio 
function [c, ceq] = mycon(x)
    % inequality constraint
    c = x(1)^2 + x(2)^2 + x(3)^2 - 64; 
    ceq = []; 
end
