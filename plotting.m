function fig=plotting(df,params,exit_msg)

lw=2;
fig = figure;
fig.Position = [50, 100, 1200, 770];
set(fig, 'color', 'w')
t = tiledlayout('flow', "TileSpacing", "compact", Padding = "compact");
nexttile
stairs(df.time, df.leafC, 'linewidth', 2, 'DisplayName', 'leafC');hold on
stairs(df.time, df.rootC, 'linewidth', 2, 'DisplayName', 'root C');
xlabel('time [day]');ylabel('[gC m^{-2}]')
yyaxis right
stairs(df.time, df.exuC, 'linewidth', 2, 'DisplayName', 'exu C');
xlabel('time [day]');ylabel('[gC m^{-2}]')
grid on;
set(gca, 'YScale','linear')
legend('show','Location','best');


nexttile
stairs(df.time, df.rootC./df.leafC, 'linewidth', 2, 'DisplayName', 'root:shoot');hold on
xlabel('time [day]');ylabel('[gC m^{-2}]')
grid on;
legend('show','Location','best');

nexttile
stairs(df.time, df.A-df.leaf_resp, 'linewidth', lw, 'DisplayName', 'net A = A-R_L'); hold on
% stairs(df.time, df.rootCSupply./df.S_norm, 'linewidth', lw, 'DisplayName', 'max rootCSupply');
stairs(df.time, df.rootCSupply, 'linewidth', lw, 'DisplayName', 'rootCSupply');
stairs(df.time, df.leaf_growth_rate, 'linewidth', lw, 'DisplayName', 'G_{leaf}');
legend('show','Location','best');
xlabel('time [day]');
grid on;
ylabel('[gC m^{-2}d^{-1}]')

nexttile
stairs(df.time, df.rootCSupply./(df.A-df.leaf_resp), 'linewidth', lw, 'DisplayName', 'S/A_{net}'); hold on
stairs(df.time, df.leaf_growth_rate./(df.A-df.leaf_resp), 'linewidth', lw, 'DisplayName', 'G_L/A_{net}'); hold on
% stairs(df.time,df.time*0+0.1, 'linewidth', lw, Color='k')
stairs(df.time,df.time*0+params.min_frac_leaf_growth, 'linewidth', lw, Color='k')
legend('show','Location','best');
xlabel('time [day]');ylim([0,1])
grid on

nexttile
stairs(df.time, df.rootCSupply, 'linewidth', lw, 'DisplayName', 'rootCSupply'); hold on
stairs(df.time, df.root_resp, 'linewidth', lw, 'DisplayName', 'root resp'); hold on
stairs(df.time, df.root_exu, 'linewidth', lw, 'DisplayName', 'root exu');
stairs(df.time, df.root_maintenance_resp, 'linewidth', lw, 'DisplayName', 'root main resp');
stairs(df.time, df.root_growth_rate, 'linewidth', lw, 'DisplayName', 'root G=S-E_x-R_R');
legend('show','Location','best');
xlabel('time [day]');
grid on;
ylabel('[gC m^{-2}d^{-1}]')


nexttile
stairs(df.time, (df.root_resp+df.root_maintenance_resp)./df.rootCSupply, 'linewidth', lw, 'DisplayName', 'R_{root}/S'); hold on
stairs(df.time, df.root_exu./df.rootCSupply, 'linewidth', lw, 'DisplayName', 'Ex/S');
stairs(df.time, df.root_growth_rate./df.rootCSupply, 'linewidth', lw, 'DisplayName', 'G_R/S');
stairs(df.time, df.rootN_uptake_norm, 'linewidth', lw, 'DisplayName', 'U_N/U_{N, pot}');
legend('show','Location','best');
xlabel('time [day]');
ylim([0,1])
grid on;

nexttile
stairs(df.time, df.CNM, 'linewidth', lw, 'DisplayName', 'mic CN');
ylim([5,20])
xlabel('time [day]');
legend('show','Location','best');
grid on

nexttile
stairs(df.time, df.leaf_N_uptake, 'linewidth', lw, 'DisplayName', 'pN');hold on
stairs(df.time, df.root_N_uptake, 'linewidth', lw, 'DisplayName', 'U_N');
stairs(df.time, df.root_N_uptake./df.rootN_uptake_norm, 'linewidth', lw, 'DisplayName', 'U_{N, pot}');
xlabel('time [day]');ylabel('[gN m^{-2} day^{-1}]')
legend('show','Location','best');
grid on

nexttile
stairs(df.time, df.root_N_uptake, 'linewidth', lw, 'DisplayName', 'U_N');hold on
stairs(df.time, df.leaf_N_uptake, 'linewidth', lw, 'DisplayName', 'p_N');
stairs(df.time, df.root_growth_rate./df.CNR, 'linewidth', lw, 'DisplayName', 'G_{root}/CN_R');
stairs(df.time, df.root_exu./params.CNE, 'linewidth', lw, 'DisplayName', 'E/CNE');
xlabel('time [day]');ylabel('[gN m^{-2} day^{-1}]')
lh=legend('show','Location','best');lh.NumColumns=2;
grid on

nexttile
stairs(df.time, df.inorgN, 'linewidth', lw, 'DisplayName', 'N Inorg');
xlabel('time [day]');ylabel('[gN m^{-2}]')
legend('show','Location','best');
grid on

nexttile
try
    stairs(df.time, df.root_exu_norm, 'linewidth', lw, 'DisplayName', 'root exu norm');hold on
    stairs(df.time, df.S_norm, 'linewidth', lw, 'DisplayName', 'S norm');

catch
    stairs(df.time, df.S_norm, 'linewidth', lw, 'DisplayName', 'S norm');hold on
end
legend('show','Location','best');
grid on

nexttile
stairs(df.time, df.CNR, 'linewidth', lw, 'DisplayName', 'root CN');hold on
stairs(df.time, df.CNleaf, 'linewidth', lw, 'DisplayName', 'CNleaf');
legend('show','Location','best');
grid on

nexttile
stairs(df.time, df.root_exu./df.A, 'linewidth', lw, 'DisplayName', 'Ex/A');
xlabel('time [day]');ylabel('[-]')
legend('show','Location','best');
grid on

% nexttile
% stairs(df.rootC, df.rootCSupply, 'linewidth', lw, 'DisplayName', 'S(root C)');hold on
% xlabel('root C');ylabel('S')
% legend('show','Location','best');
% grid on

nexttile
% stairs(df.inorgN, df.rootCSupply, 'linewidth', lw, 'DisplayName', 'S(inorgN)');hold on
% xlabel('inorgN');ylabel('S')
stairs(df.time, df.SOMC, 'linewidth', lw, 'DisplayName', 'SOM-C)');hold on
xlabel('time');ylabel('SOM-C')
yyaxis right
stairs(df.time, df.SOMN, 'linewidth', lw, 'DisplayName', 'SOM-N)');hold on
xlabel('time');ylabel('SOM-N')

legend('show','Location','best');
grid on

Cpartition1 = [trapz(df.time,df.A),...
    trapz(df.time,df.rootCSupply),...
    trapz(df.time,df.leaf_resp),...
    trapz(df.time,df.root_resp),...
    trapz(df.time,df.root_maintenance_resp),...
    trapz(df.time,df.root_exu),...
    trapz(df.time,df.root_growth_rate),...
    trapz(df.time,df.leaf_growth_rate),...
    ];
nexttile
x=categorical(["A","S","R_{leaf}","R_{root}","R_{main}","E_x","G-root","G-leaf"]);
x = reordercats(x,["A","S","R_{leaf}","R_{root}","R_{main}","E_x","G-root","G-leaf"]);
b=bar(x,Cpartition1);
% ylabel("fraction of assimilated C")
grid on
xtips2 = b.XEndPoints;
ytips2 = b.YEndPoints;
labels2 = arrayfun(@(x) sprintf(['%.' num2str(0) 'f'], x), b.YData, 'UniformOutput', false);

text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

Cpartition1 = [trapz(df.time,df.rootCSupply),...
    ...%trapz(df.time,df.leaf_resp),...
    ...%trapz(df.time,df.root_resp),...
    ...%trapz(df.time,df.root_maintenance_resp),...
    trapz(df.time,df.root_exu),...
    trapz(df.time,df.root_growth_rate),...
    trapz(df.time,df.leaf_growth_rate),...
    ]./trapz(df.time,df.Anet);
% figure;
% tiledlayout('flow', "TileSpacing", "compact", Padding = "compact");
nexttile
% x=categorical(["S","R_{leaf}","R_{root}","R_{main}","E_x","G-root","G-leaf"]);
x=categorical(["S","E_x","G-root","G-leaf"]);
x = reordercats(x,["S","E_x","G-root","G-leaf"]);
b=bar(x,Cpartition1);
ylabel("fraction of net assimilated C")
grid on
xtips2 = b.XEndPoints;
ytips2 = b.YEndPoints;
labels2 = arrayfun(@(x) sprintf(['%.' num2str(2) 'f'], x), b.YData, 'UniformOutput', false);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

if (~isempty(exit_msg))
    title(t,exit_msg)
end
    
%%
tol=1e-6;
df.C1=df.leaf_growth_rate > 0;
df.C2 = df.rootCSupply > 0;
df.C3 = (df.rootN_uptake_norm-1)<tol;
df.C4 = (params.min_frac_leaf_growth- df.frac_leaf_growth)<tol;
df.C5 = (params.min_frac_root_growth-df.frac_root_growth)<tol;
df.C6 = df.new_exu_constraint < 1 - params.min_frac_root_growth;
df.C7 = df.drootCdt > 0;
df.C8 = df.root_growth_rate>0;

const.C1 = 'leaf_growth_rate > 0';
const.C2 = 'rootCSupply > 0';
const.C3 = 'rootN_uptake_norm < 1';
const.C4 = sprintf('frac_leaf_growth > %1.2f', params.min_frac_leaf_growth);
const.C5 = sprintf('frac_root_growth > %1.2f)',params.min_frac_root_growth);
const.C6 = 'new_exu_constraint < %.2f';
const.C7 = 'drootCdt > 0';
const.C8 = 'root_growth_rate>0';
f=figure;tiledlayout('flow',TileSpacing='compact', Padding='compact')
f.Position=[272 271 775 577];f.Color='w';
for i=1:8
    nexttile
    stairs(df.time, df{:,"C"+num2str(i)}, LineWidth=1.5);
    title(const.("C"+num2str(i)), 'Interpreter','none')
    xlabel('time')
end