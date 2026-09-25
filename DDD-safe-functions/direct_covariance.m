function [K,A_pi,B_pi] = direct_covariance(data,G_x)
%% This function find K, A_pi, and B_pi from system data x, u and G_x
%% Process data
U_0 = data.u(1:end-1)';
X_1 = data.x(2:end, :)';
X_0 = data.x(1:end-1, :)';



T_NUM = length(U_0);
m = size(data.u,2);
n = size(data.x,2);

yalmip('clear');
R_sqrt = sqrtm(data.R);

% Check if a variable new dataset exists
if isfield(data, 'u_new') && isfield(data, 'x_new')
    U_0_new = data.u_new(1:end-1)';
    X_0_new = data.x_new(1:end-1, :)';
    Z = [X_0_new; U_0_new];
else
    warning('Only one set of data exist. The covariance will have noise bias.');
    Z = [X_0; U_0];
end

% Calculate unbiased covariances using the independent data
COV_U_0 = (1/T_NUM) * U_0 * Z';
COV_X_1 = (1/T_NUM) * X_1 * Z'; 
COV_X_0 = (1/T_NUM) * X_0 * Z';
% COV_PHI = (1/T_NUM) * [X_0; U_0] * Z'; 


U_0 = COV_U_0;
X_0 = COV_X_0;
X_1 = COV_X_1;
SK    = sdpvar(m+n,n,'full'); 
Sigma = sdpvar(n,n,'symmetric'); 
Y     = sdpvar(m,m,'symmetric'); 
Omega = sdpvar(m+n,m+n,'symmetric');
Constraints = [];
% 1
Constraints = [Constraints, X_0*SK == Sigma];
% 2
Constraints = [Constraints, Sigma >= eye(n)];
% 3
Constraints = [Constraints, [Y,               R_sqrt*U_0*SK;
            (R_sqrt*U_0*SK)',      Sigma] >= 0];
Constraints = [Constraints, [Sigma - eye(n),    X_1*SK;
                                    (X_1*SK)',       Sigma] >= 0];
Objective = trace(data.Q * Sigma) + trace(Y);

%% Setup YALMIP solver
options = sdpsettings('solver','mosek','verbose',0);
% Solve
sol = optimize(Constraints, Objective, options);
if sol.problem == 0
    SK_opt    = value(SK);
    Sigma_opt = value(Sigma);
    MK_opt = SK_opt/Sigma_opt;
    K_opt  = -U_0 * MK_opt;
    A_pi = X_1 * MK_opt;
    try
        B_pi = (eye(n)-A_pi)* G_x;
    catch error
        fprintf('An error occurred: %s\n', ME.message);
    end
    % M = data.Q + K_opt' * data.R * K_opt;
    % P_opt = dlyap(A_pi', M);
    K = K_opt;
    % P = P_opt;
    % S = Sigma_opt;
else 
    disp('Error: Could not solve the problem.');
    disp(['Solver message: ', sol.info]);
end
end

