figure;
% =========================================================
% Plotting Parameters 
% =========================================================
lw_data   = 2;          % Line width for system state/input data
lw_bound  = 1.5;        % Line width for boundaries and references
plot_length = 3;        % The time plot should plot out
% Line Colors (Bounded Data)
color =  get(gca,'ColorOrder');
col_pos1  = color(1,:);  % blue for Position 1
col_pos2  = color(5,:);  % Green for Position 2
col_vel1  = color(1,:);  % blue for Velocity 1
col_vel2  = color(5,:);  % blue for Velocity 2
col_u     = color(1,:);  % blue for Control Input

% Line Colors (Unbounded Data - Lighter shades for contrast)
col_pos1_no = color(1,:); % Blue for Position 1 (No Bound)
col_pos2_no = color(5,:);  % Green for Position 2 (No Bound)
col_vel1_no = color(1,:); % Cyan/Light Blue for Velocity 1 (No Bound)
col_vel2_no = color(5,:);  % Light Green for Velocity 2 (No Bound)
col_u_no    = color(1,:); % Plum/Light Purple for Control Input (No Bound)

% Boundaries and References
col_bound = color(7,:);  % darkRed for Constraints
col_phase = 'r';
phase_alpha = 0.1;
col_ref   = 'k';  % Black for Reference 
col_ref_CG = color(4,:);

% =========================================================
% Figure Setup
% =========================================================
tiledlayout(4, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

% ---------------------------------------------------------
% Tile 1: Angular Positions (x1, x2) & Constraints
% ---------------------------------------------------------
nexttile(1)
hold on; grid on;

% Plot Real Data (Bounded)
plot(t, REAL_x_CG(:,1), '-', 'Color', col_pos1, 'LineWidth', lw_data)

% Plot Real Data (No Bound)
plot(t, REAL_x_no(:,1), ':', 'Color', col_pos1_no, 'LineWidth', lw_data)

% Plot References and Constraints
plot(t, Ref, '-.', 'Color', col_ref, 'LineWidth', lw_bound) % Dynamic Reference
plot(t, Ref_CG, '-.', 'Color', col_ref_CG, 'LineWidth', lw_bound) % Reference CG
% Constraint for theta_1
yregion(data.z_desire(1),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.z_desire(2),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'FaceColor','r','FaceAlpha',0.1,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
ylabel("Angular Position [rad]", 'Interpreter', 'latex')
legend('$\theta_1$ (With CG)', '$\theta_1$ (Unconstrained)','Reference','Reference (With CG)', 'Limit $\pm \theta_1$','Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); % Fix X-axis
ylim([-0.1 1.1]);
yticks(0:0.2:1);
% ---------------------------------------------------------
% Tile 2: Angular Positions (x1, x2) & Constraints
% ---------------------------------------------------------
nexttile(2)
hold on; grid on;

% Plot Real Data (Bounded)
plot(t, REAL_x_CG(:,2), '-', 'Color', col_pos2, 'LineWidth', lw_data)

% Plot Real Data (No Bound)
plot(t, REAL_x_no(:,2), ':', 'Color', col_pos2_no, 'LineWidth', lw_data)

% Constraint for theta_2 
yregion(data.z_desire(3),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.z_desire(4),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
ylabel("Angular Position [rad]", 'Interpreter', 'latex')
legend('$\theta_2$ (With CG)', '$\theta_2$ (Unconstrained)','Limit $\pm \theta_2$', 'Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); % Fix X-axis
ylim([-0.15 0.15]);
yticks(-0.15:0.05:0.15)
% ---------------------------------------------------------
% Tile 3: Angular Velocities (x3, x4)
% ---------------------------------------------------------
nexttile(3)
hold on; grid on;

% Plot Real Data (Bounded)
plot(t, REAL_x_CG(:,3), '-', 'Color', col_vel1, 'LineWidth', lw_data)
plot(t, REAL_x_CG(:,4), '-', 'Color', col_vel2, 'LineWidth', lw_data)

% Plot Real Data (No Bound)
plot(t, REAL_x_no(:,3), ':', 'Color', col_vel1_no, 'LineWidth', lw_data)
plot(t, REAL_x_no(:,4), ':', 'Color', col_vel2_no, 'LineWidth', lw_data)
% Constraint for theta_1 dot 
yregion(data.z_desire(5),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.z_desire(6),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)

ylabel("Angular Velocity [rad/s]", 'Interpreter', 'latex')
legend('$\dot \theta_1$ (With CG)', '$\dot \theta_2$ (With CG)', '$\dot \theta_1$ (Unconstrained)', '$\dot \theta_2$ (Unconstrained)','Limit $\pm \dot\theta$', ...
       'Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); % Fix X-axis
ylim([-6 6]);
yticks(-6:2:6);
% ---------------------------------------------------------
% Tile 4: Control Input (u) & Constraints
% ---------------------------------------------------------
nexttile(4)
hold on; grid on;

% Plot Control Input (Bounded and No Bound) using stairs for discrete control
stairs(t, REAL_u_CG, '-', 'Color', col_u, 'LineWidth', lw_data)
stairs(t, REAL_u_no, ':', 'Color', col_u_no, 'LineWidth', lw_data)
% Plot Constraints (+b and -b)
yregion(data.b(1),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.b(2),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)

xlabel("$t$ [s]", 'Interpreter', 'latex')
ylabel("$u(t)$ [Input]", 'Interpreter', 'latex')
legend('Input $u$ (With CG)', 'Input $u$ (Unconstrained)', 'Limit $\pm b$', 'Interpreter', 'latex', 'Location', 'northwest')
xlim([0, plot_length]); % Fix X-axis
ylim([-7 7]);
yticks(-2:2:6);
hold off;