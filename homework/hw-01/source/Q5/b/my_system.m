function y = my_system(u)
%#codegen
% define state persistent variable
persistent x;

% initialize state
if isempty(x)
    x = zeros(2, 1);
end

% system matrices
a = [0.8, 0.3; -0.2, 0.7];
b = [0.2; 0.1];
c = [1, 0];

% compute output
y = c * x;

% update state
x = a * x + b * u;
end
