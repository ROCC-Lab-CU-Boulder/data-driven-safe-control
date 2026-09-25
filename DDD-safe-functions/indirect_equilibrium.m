function [A,B,K,A_pi,B_pi] = indirect_equilibrium(data, G_x, G_u)
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
    warning("Detact second dataset was defined. Running cross-covariance process.");
    U_0 = (1/T_NUM) * U_0 * Omega';
    X_1 = (1/T_NUM) * X_1 * Omega'; 
    X_0 = (1/T_NUM) * X_0 * Omega';
end
m = size(data.u,2);
n = size(data.x,2);
% %% Indirect Approach with Equilibrum subset using solver
% yalmip('clear');
% A = sdpvar(n,n,'full');
% B = sdpvar(n,m,'full');
% Objective = norm(X_1-[A, B]*[X_0;U_0],'fro');
% Constraints = [A,B]*[G_x; G_u] == G_x;
% options = sdpsettings('solver','mosek','verbose',0);
% sol = optimize(Constraints, Objective, options);
% A = value(A);
% B = value(B);
% [K, P] = dlqr(A, B, data.Q, data.R);
% A_pi = A-B*K;
% B_pi = B * (G_u + K * G_x);
% Form the augmented data and constraint matrices
G = [G_x; G_u];
Z = [X_0; U_0];
Z_dagger = pinv(Z);
% N = G'/(Z*Z');
% M = (N*G)\N;
V = Z_dagger * G;
V_dagger = pinv(V);
% I = eye(n + m); %Apply [A_hat B_hat] = X_1 * Z^dagger * (I - G * M) + G_x * M
% Theta_hat = X_1 * pinv(Z) * (I - G * M) + G_x * M;
Theta_hat = X_1 * Z_dagger + (G_x - X_1 * V) * (V_dagger * Z_dagger);

% Extract A and B
A = Theta_hat(:, 1:n);
B = Theta_hat(:, n+1:end);

% LQR and Policy Calculation
[K, P] = dlqr(A, B, data.Q, data.R);
A_pi = A - B * K;
B_pi = B * (G_u + K * G_x);
end
