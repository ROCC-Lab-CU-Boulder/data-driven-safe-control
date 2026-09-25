function [A,B,K] = indirect_classic(data)
%% Process data
U_0 = data.u(1:end-1)';
X_1 = data.x(2:end, :)';
X_0 = data.x(1:end-1, :)';
% Check if a variable new dataset exists
if isfield(data, 'u_new') && isfield(data, 'x_new')
    T_NUM = length(U_0);
    U_0_new = data.u_new(1:end-1)';
    X_0_new = data.x_new(1:end-1, :)';
    Omega = [X_0_new; U_0_new];
    warning("Detact second dataset was defined. Running cross-covariance process.")
    U_0 = (1/T_NUM) * U_0 * Omega';
    X_1 = (1/T_NUM) * X_1 * Omega'; 
    X_0 = (1/T_NUM) * X_0 * Omega';
end
m = size(data.u,2);
n = size(data.x,2);
% %% Indirect Approach LTI Problem
% yalmip('clear');
% A = sdpvar(n,n,'full');
% B = sdpvar(n,m,'full');
% Objective = norm(X_1-[A, B]*[X_0;U_0],'fro');
% Constraints = [];
% options = sdpsettings('solver','mosek','verbose',0);
% sol = optimize(Constraints, Objective, options);
% A = value(A);
% B = value(B);
%% Indirect Approach solution
M = X_1/[X_0;U_0];
A = M(:, 1:n);
B = M(:, n+1:end);
[K] = dlqr(A, B, data.Q, data.R);
end

