figure;
% =========================================================
% Plotting Parameters
% =========================================================
lw_data = 2;
lw_bound = 1.5;
plot_length = 3;

color = get(gca,'ColorOrder');

col_pos1 = color(1,:);
col_pos2 = color(5,:);
col_vel1 = color(1,:);
col_vel2 = color(5,:);
col_u = color(1,:);

col_bound = color(7,:);
col_phase = 'r';
phase_alpha = 0.1;
col_ref = 'k';
col_ref_CG = color(4,:);

% =========================================================
% Figure Setup
% =========================================================
tiledlayout(4,1,'TileSpacing','compact','Padding','compact');

% ---------------------------------------------------------
% Tile 1: Angular Position theta_1
% ---------------------------------------------------------
nexttile(1)
hold on; grid on;

plot(t,REAL_x_CG(:,1),'-','Color',col_pos1,'LineWidth',lw_data)
plot(t_sim,x_sim(:,1),':','Color',col_pos1,'LineWidth',lw_data)

stairs(t,Ref,'-.','Color',col_ref,'LineWidth',lw_bound)
stairs(t,Ref_CG,'--','Color',col_ref_CG,'LineWidth',lw_bound)
stairs(t_sim(1:end-1),v_sim(:,1),':','Color',col_ref_CG,'LineWidth',lw_bound)

yregion(data.z_desire(1),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.z_desire(2),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)

ylabel("Angular Position [rad]",'Interpreter','latex')
legend('$\theta_1$ (Experiment)','$\theta_1$ (Simulation)','Reference','CG Reference (Experiment)','CG Reference (Simulation)','Limit $\pm\theta_1$','Interpreter','latex','Location','northwest')

xlim([0,plot_length])
ylim([-0.1 1.1])
yticks(0:0.2:1)

% ---------------------------------------------------------
% Tile 2: Angular Position theta_2
% ---------------------------------------------------------
nexttile(2)
hold on; grid on;

plot(t,REAL_x_CG(:,2),'-','Color',col_pos2,'LineWidth',lw_data)
plot(t_sim,x_sim(:,2),':','Color',col_pos2,'LineWidth',lw_data)

yregion(data.z_desire(3),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.z_desire(4),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)

ylabel("Angular Position [rad]",'Interpreter','latex')
legend('$\theta_2$ (Experiment)','$\theta_2$ (Simulation)','Limit $\pm\theta_2$','Interpreter','latex','Location','northwest')

xlim([0,plot_length])
ylim([-0.15 0.15])
yticks(-0.15:0.05:0.15)

% ---------------------------------------------------------
% Tile 3: Angular Velocities
% ---------------------------------------------------------
nexttile(3)
hold on; grid on;

plot(t,REAL_x_CG(:,3),'-','Color',col_vel1,'LineWidth',lw_data)
plot(t,REAL_x_CG(:,4),'-','Color',col_vel2,'LineWidth',lw_data)

plot(t_sim,x_sim(:,3),':','Color',col_vel1,'LineWidth',lw_data)
plot(t_sim,x_sim(:,4),':','Color',col_vel2,'LineWidth',lw_data)

yregion(data.z_desire(5),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.z_desire(6),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)

ylabel("Angular Velocity [rad/s]",'Interpreter','latex')
legend('$\dot{\theta}_1$ (Experiment)','$\dot{\theta}_2$ (Experiment)','$\dot{\theta}_1$ (Simulation)','$\dot{\theta}_2$ (Simulation)','Limit $\pm\dot{\theta}$','Interpreter','latex','Location','northwest')

xlim([0,plot_length])
ylim([-6 6])
yticks(-6:2:6)

% ---------------------------------------------------------
% Tile 4: Control Input
% ---------------------------------------------------------
nexttile(4)
hold on; grid on;


stairs(t,REAL_u_CG,'-','Color',col_u,'LineWidth',lw_data)
stairs(t_sim(1:end-1),u_sim(:,1),':','Color',col_u,'LineWidth',lw_data)

yregion(data.b(1),Inf,'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)
yregion(-Inf,-data.b(2),'FaceColor',col_phase,'FaceAlpha',phase_alpha,'EdgeColor',col_bound,'LineStyle','--','LineWidth',lw_bound)

xlabel("$t$ [s]",'Interpreter','latex')
ylabel("$u(t)$ [Input]",'Interpreter','latex')
legend('Input $u$ (Experiment)','Input $u$ (Simulation)','Limit $\pm b$','Interpreter','latex','Location','northwest')

xlim([0,plot_length])
ylim([-7 7])
yticks(-6:2:6)

hold off;