figure;
% =========================================================
% Plotting Parameters
% =========================================================
lw_data   = 2;          % Line width for system state/input data
lw_bound  = 1.5;        % Line width for boundaries and references
plot_length = 3;        % The time plot should plot out

% Line Colors (Real Test Data - Solid)
color =  get(gca,'ColorOrder');
col_pos1  = color(1,:);  % Blue for Position 1
col_pos2  = color(5,:);  % Green for Position 2
col_vel1  = color(1,:);  % Blue for Velocity 1
col_vel2  = color(5,:);  % Green for Velocity 2
col_u     = color(1,:);  % Blue for Control Input

% Line Colors (Simulated Data - Dashed)
col_pos1_sim = color(1,:); % Blue for Position 1 (Sim)
col_pos2_sim = color(5,:); % Green for Position 2 (Sim)
col_vel1_sim = color(1,:); % Blue for Velocity 1 (Sim)
col_vel2_sim = color(5,:); % Green for Velocity 2 (Sim)
col_u_sim    = color(1,:); % Blue for Control Input (Sim)

% Boundaries and References
col_ref   = 'k';  % Black for Reference 

% =========================================================
% Figure Setup
% =========================================================
tiledlayout(4, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

% ---------------------------------------------------------
% Tile 1: Angular Position (x1)
% ---------------------------------------------------------
nexttile(1)
hold on; grid on;
% Simulation Data (Dashed)
plot(t_sim, x_no_constraint_sim(:,1), '--', 'Color', col_pos1_sim, 'LineWidth', lw_data)
% Real Data (Solid)
plot(t, REAL_x_no(:,1), '-', 'Color', col_pos1, 'LineWidth', lw_data)
% Reference 
plot(t, r .* ones(size(t)), '-.', 'Color', col_ref, 'LineWidth', lw_bound);
ylabel("Angular Position [rad]", 'Interpreter', 'latex')
legend('$\theta_1$ (Sim)', ...
       '$\theta_1$ (Real)', ...
       'Reference', 'Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); 
ylim([-0.1 1.2]);
yticks(0:0.2:1);
% ---------------------------------------------------------
% Tile 2: Angular Position (x2)
% ---------------------------------------------------------
nexttile(2)
hold on; grid on;
% Simulation Data (Dashed)
plot(t_sim, x_no_constraint_sim(:,2), '--', 'Color', col_pos2_sim, 'LineWidth', lw_data)
% Real Data (Solid)
plot(t, REAL_x_no(:,2), '-', 'Color', col_pos2, 'LineWidth', lw_data)
ylabel("Angular Position [rad]", 'Interpreter', 'latex')
legend('$\theta_2$ (Sim)', ...
       '$\theta_2$ (Real)', ...
       'Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); 
ylim([-0.6 0.6]);
yticks(-0.6:0.2:0.6);

% ---------------------------------------------------------
% Tile 3: Angular Velocities (x3, x4)
% ---------------------------------------------------------
nexttile(3)
hold on; grid on;
% Simulation Data (Dashed)
plot(t_sim, x_no_constraint_sim(:,3), '--', 'Color', col_vel1_sim, 'LineWidth', lw_data)
plot(t_sim, x_no_constraint_sim(:,4), '--', 'Color', col_vel2_sim, 'LineWidth', lw_data)
% Real Data (Solid)
plot(t, REAL_x_no(:,3), '-', 'Color', col_vel1, 'LineWidth', lw_data)
plot(t, REAL_x_no(:,4), '-', 'Color', col_vel2, 'LineWidth', lw_data)
ylabel("Angular Velocity [rad/s]", 'Interpreter', 'latex')
legend('$\dot \theta_1$ (Sim)', '$\dot \theta_2$ (Sim)', ...
       '$\dot \theta_1$ (Real)', '$\dot \theta_2$ (Real)', ...
       'Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); 
ylim([-10 10]);
yticks(-10:5:10);

% ---------------------------------------------------------
% Tile 4: Control Input (u)
% ---------------------------------------------------------
nexttile(4)
hold on; grid on;
% Simulation Data (Dashed)
stairs(t_sim(1:end-1), u_no_constraint_sim, '-', 'Color', col_u_sim, 'LineWidth', lw_data)
% Real Data (Solid)
stairs(t, REAL_u_no, ':', 'Color', col_u, 'LineWidth', lw_data)
xlabel("$t$ [s]", 'Interpreter', 'latex')
ylabel("$u(t)$ [Input]", 'Interpreter', 'latex')
legend('Control $u$ (Sim)', 'Control $u$ (Real)', 'Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); 
ylim([-5 10]);
hold off;