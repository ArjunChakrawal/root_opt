%% variation of initial soil inorg N and init CN ratio
close all
clear all
terminal_time=120;

df_t=table();
scenario=["base","low min. N","high SOM C:N"];

% base scenario------------------------------------------------
[params, state_init]=params_base_condition();
[df, ~,~] = solve_ocp(terminal_time, state_init, params,100, []);
Lines  = readlines('out.txt');
exit_msg = Lines(32);
% plotting(df,params,exit_msg);
df.scenario = repmat(scenario(1), height(df), 1);
df_t=[df_t;df];

% N_i scenario------------------------------------------------
[params, state_init]=params_base_condition();
state_init.inorgN = 7.5;
[df, ~,~] = solve_ocp(terminal_time, state_init, params,100, []);
Lines  = readlines('out.txt');
exit_msg = Lines(32);
% plotting(df,params,exit_msg);
df.scenario = repmat(scenario(2), height(df), 1);
df_t=[df_t;df];

% soil CN scenario ------------------------------------------------
[params, state_init]=params_base_condition();
state_init.SOMN = state_init.SOMC /20; % gN/m2
[df, ~,~] = solve_ocp(terminal_time, state_init, params,100, []);
Lines  = readlines('out.txt');
exit_msg = Lines(32);
% plotting(df,params,exit_msg);
df.scenario = repmat(scenario(3), height(df), 1);
df_t=[df_t;df];
%% ---------------------------------------------------------------

fig = figure;fig.Position=[224   100   1000   900];
fig.Color='w';
[ax, ~] = tight_subplot(4,1, [.04 .05],[.075 .05],[0.1 .02]);
t=tiledlayout(4,3);
ax(1) = nexttile([1,2]);
ax(2) = nexttile([1,2]);
ax(3) = nexttile([1,2]);
ax(4) = nexttile([1,2]);
ax(5) = nexttile();
ax(6) = nexttile();
ax(7) = nexttile();
ax(8) = nexttile();
for i=1:8
    hold(ax(i),'on');
end
color=copper(3);

yvar = ["leaf_growth_rate","rootCSupply","root_growth_rate","root_exu"];

for j=1:4
    temp=[];
    for i=1:3
        df = df_t(strcmp(df_t.scenario,scenario(i)), :);
        temp =[temp,trapz(df.time, df{:,yvar(j)})];
    end
    b=bar(ax(4+j), categorical(scenario), temp);
    b.FaceColor = 'flat';
    b.CData = color;
    b.FaceAlpha=0.75;
    b.EdgeColor="flat";
end

scenario = string(ax(5).XTickLabel);

lstyle = ["-","-","-"];
lw = [1,1,1]*2;

for i =1:3
    df = df_t(strcmp(df_t.scenario,scenario(i)), :);
    stairs(ax(1),df.time, df.leaf_growth_rate./df.Anet, 'linewidth', lw(i), ...
        'LineStyle' ,lstyle(i),"Color",color(i,:), 'DisplayName', '\itG_{L}/A_{net}');
    stairs(ax(2), df.time, df.rootCSupply./df.Anet, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itS/A_{net}');
    % stairs(ax(3),df.time, df.root_growth_rate./df.rootCSupply, 'linewidth', lw(i), ...
    %     'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itG_{R}/S');
    % stairs(ax(4),df.time, df.root_exu./df.rootCSupply, 'linewidth', lw(i), ...
    %     'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itE/S');

    stairs(ax(3),df.time, df.root_growth_rate./df.rootCSupply, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itG_{R}/S');
    stairs(ax(4),df.time, df.root_exu./df.rootCSupply, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itE/S');
end

set(ax(1:2), 'Ylim',[0, 0.9])
set(ax(3), 'Ylim',[0, 0.6]);set(ax(4), 'Ylim',[0, 0.3])
set(ax(5:6), 'Ylim',[0, 650])
set(ax(7:8), 'Ylim',[0, 250])

set(ax(1:3), 'Xticklabel',[])
set(ax(5:7), 'Xticklabel',[])

xlabel(ax(4),'time [day]');
ylabel(ax(1),'{\itG_{L} / A_{net}} [-]')
ylabel(ax(2),'{\itS / A_{net}} [-]')
ylabel(ax(3),'{\itG_{R} / S} [-]')
ylabel(ax(4),'{\itE / S} [-]')

ylabel(ax(5),'\int{\it G_{L}} [gC m^{-2}]')
ylabel(ax(6),'\int{\it S} [gC m^{-2}]')
ylabel(ax(7),'\int{\it G_{R}} [gC m^{-2}]')
ylabel(ax(8),'\int{\it E} [gC m^{-2}]')
% lh=legend(ax(4), scenario);
% lh.Title.String="Model scenarios";lh.Location="northeast";
% lh.FontSize=12;lh.NumColumns=3;lh.Box='on';


strs=["A","C","E","G","B","D","F","H"];
for i =1:length(ax)
    set(ax(i), 'LineWidth', 0.5, 'FontSize',13, 'Box','on')
    ax(i).YLabel.FontSize=16;
    ax(i).XLabel.FontSize=16;
    grid(ax(i),'on');
    ttl = title(ax(i),"("+strs(i)+")",'FontWeight','normal');
    ttl.Units = 'Normalize';
    ttl.FontSize=16;
    ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left';
end
ax(8).XAxis.FontSize=14;

t.TileSpacing='loose';
t.Padding='compact';
exportgraphics(gcf, "figs/Figure2.png", Resolution=600)
print(gcf, 'figs/Figure2.svg', '-dsvg');

%%

fig = figure;fig.Position=[224   100   1000   800];
fig.Color='w';
t=tiledlayout(3,3);
ax(1) = nexttile([1,2]);
ax(2) = nexttile([1,2]);
ax(3) = nexttile([1,2]);
ax(4) = nexttile();
ax(5) = nexttile();
ax(6) = nexttile();
for i=1:6
    hold(ax(i),'on');
end
color=copper(3);

yvar = ["rootCSupply","root_growth_rate","root_exu"];


temp=[];
j=1
for i=1:3
    df = df_t(strcmp(df_t.scenario,scenario(i)), :);
    temp =[temp,trapz(df.time, df{:,yvar(j)})/trapz(df.time, df{:,'Anet'})];
end
b=bar(ax(3+j), categorical(scenario), temp);
b.FaceColor = 'flat';
b.CData = color;
b.FaceAlpha=0.75;
b.EdgeColor="flat";


for j=2:3
    temp=[];
    for i=1:3
        df = df_t(strcmp(df_t.scenario,scenario(i)), :);
        temp =[temp,trapz(df.time, df{:,yvar(j)})/trapz(df.time, df{:,'rootCSupply'})];
    end
    b=bar(ax(3+j), categorical(scenario), temp);
    b.FaceColor = 'flat';
    b.CData = color;
    b.FaceAlpha=0.75;
    b.EdgeColor="flat";
end

scenario = string(ax(6).XTickLabel);

lstyle = ["-","-","-"];
lw = [1,1,1]*2;

for i =1:3
    df = df_t(strcmp(df_t.scenario,scenario(i)), :);
    stairs(ax(1), df.time, df.rootCSupply./df.Anet, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itS/A_{net}');
    stairs(ax(2),df.time, df.root_growth_rate./df.rootCSupply, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itG_{R}/S');
    stairs(ax(3),df.time, df.root_exu./df.rootCSupply, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:),'DisplayName', '\itE/S');
end

set(ax(1), 'Ylim',[0, 0.9])
set(ax(2), 'Ylim',[0, 0.6]);
set(ax(3), 'Ylim',[0, 0.3])
set(ax(5:6), 'Ylim',[0, 0.4])
% set(ax(7:8), 'Ylim',[0, 250])

set(ax(1:2), 'Xticklabel',[])
set(ax(4:5), 'Xticklabel',[])

xlabel(ax(3),'time [day]');
ylabel(ax(1),'{\itS / A_{net}} [-]')
ylabel(ax(2),'{\itG_{R} / S} [-]')
ylabel(ax(3),'{\itE / S} [-]')

ylabel(ax(4),'\int{\it S} / \int{\it A_{net}} [-]')
ylabel(ax(5),'\int{\it G_{R}} / \int{\it S} [-]')
ylabel(ax(6),'\int{\it E} / \int{\it S} [-]')
% lh=legend(ax(4), scenario);
% lh.Title.String="Model scenarios";lh.Location="northeast";
% lh.FontSize=12;lh.NumColumns=3;lh.Box='on';


strs=["A","C","E","B","D","F"];
for i =1:length(ax)
    set(ax(i), 'LineWidth', 0.5, 'FontSize',13, 'Box','on')
    ax(i).YLabel.FontSize=16;
    ax(i).XLabel.FontSize=16;
    grid(ax(i),'on');
    ttl = title(ax(i),"("+strs(i)+")",'FontWeight','normal');
    ttl.Units = 'Normalize';
    ttl.FontSize=16;
    ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left';
end
ax(6).XAxis.FontSize=14;

t.TileSpacing='loose';
t.Padding='compact';
exportgraphics(gcf, "figs/Figure2.png", Resolution=600)
print(gcf, 'figs/Figure2.svg', '-dsvg');

%% Figure2_SI 
fig = figure;fig.Position=[224   100   900   900];
fig.Color='w';
% [ha, pos] = tight_subplot(Nh, Nw, gap, marg_h, marg_w)
[ax, pos] = tight_subplot(5,3, [.02,.085],[.05 .015],[0.1 .02]);
for i=1:15
    hold(ax(i),'on');
end
lstyle = ["-","-","-"];
lw = [1,1,1]*2;
ylabel(ax(1),'leaf C [gC m^{-2}]')
ylabel(ax(2),'root C [gC m^{-2}]')
ylabel(ax(3),'exudate C [gC m^{-2}]')
ylabel(ax(4),'SOM C [gC m^{-2}]')
ylabel(ax(5),'mic C [gC m^{-2}]')
ylabel(ax(6),'min. N [gN m^{-2}]')
ylabel(ax(7),["net photosyn. rate","{\itA_{net}} [gC m^{-2} d^{-1}]"])
ylabel(ax(8),["root C supply rate","{\itS} [gC m^{-2} d^{-1}]"])
ylabel(ax(9),["leaf growth rate","{\itG_{L}} [gC m^{-2} d^{-1}]"])
ylabel(ax(10),["root growth rate","{\itG_{R}} [gC m^{-2} d^{-1}]"])
ylabel(ax(11),["root exu. rate","{\itE} [gC m^{-2} d^{-1}]"])
ylabel(ax(12),["tot. root resp. rate","[gC m^{-2} d^{-1}]"])
ylabel(ax(13),["root N uptake rate","{\itU_N} [gN m^{-2} d^{-1}]"])
ylabel(ax(14),["leaf N demand","{\it p_N} [gN m^{-2} d^{-1}]"])
ylabel(ax(15),["U_N/U_{N, pot} [-]"])

color=copper(3);
for i =1:3
    df = df_t(strcmp(df_t.scenario,scenario(i)), :);
    stairs(ax(1), df.time, df.leafC, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(2),df.time, df.rootC, 'linewidth', lw(i), ...
        'LineStyle' ,lstyle(i),"Color",color(i,:));

    stairs(ax(3),df.time, df.exuC, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(4),df.time, df.SOMC, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(5),df.time, df.micC, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(6),df.time, df.inorgN, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(7),df.time, df.Anet, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));
    
    stairs(ax(8),df.time, df.rootCSupply, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));
    
    stairs(ax(9),df.time, df.leaf_growth_rate, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(10),df.time, df.root_growth_rate, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(11),df.time, df.root_exu, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(12),df.time, df.root_resp+df.root_maintenance_resp, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(13),df.time, df.root_N_uptake, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(14),df.time, df.leaf_N_uptake, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));

    stairs(ax(15),df.time, df.rootN_uptake_norm, 'linewidth', lw(i), ...
        'LineStyle',lstyle(i),  "Color",color(i,:));
end

% set(ax([1:4,6]), 'Ylim',[0, inf])
set(ax(15), 'Ylim',[0, 1])
set(ax(1:12), 'Xticklabel',[])
xlabel(ax([13:15]),'time [d]');

lh=legend(ax(4), scenario);
lh.Title.String="{Model scenarios}";lh.Location="southwest";
lh.FontSize=9;lh.NumColumns=1;lh.Box='on';

strs='ABCDEFGHIJKLMNOPQRST';
for i =1:length(ax)
    set(ax(i), 'LineWidth', 0.5, 'FontSize',10.5, 'Box','on')
%     ax(i).YLabel.FontSize=12;
%     ax(i).XLabel.FontSize=12;
    grid(ax(i),'on');
%     ttl = title(ax(i),"("+strs(i)+")",'FontWeight','normal',FontSize=10);
%     ttl.Units = 'Normalize';
%     ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
%     ttl.HorizontalAlignment = 'center';
end


exportgraphics(gcf, "figs/Figure2_SI.png", Resolution=300)
print(gcf, 'figs/Figure2_SI.svg', '-dsvg');











