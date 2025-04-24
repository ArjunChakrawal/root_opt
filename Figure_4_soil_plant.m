
clear all;
clc
close all

%% varying soil properties: CNleaf and init_inorgN
terminal_time=120;
df_soilCN_inorgN_leafCN= struct();
init_inorgN = [10, 20];
CNSOM = [5,10,15,20,25,30]';CNSOM = (5:2.5:30)';

numtstep=50;
CNleaf = [15,30];
[params, state_init]=params_base_condition();

for k =1:length(CNleaf)
    for j= 1:length(init_inorgN)
        for i=1:length(CNSOM)
            params.CNleaf_opt= CNleaf(k);
            state_init.inorgN=init_inorgN(j);
            state_init.SOMN = state_init.SOMC / CNSOM(i); % gN/m2
            [df, sol,~,~] = solve_ocp(terminal_time, state_init, params,numtstep, []);
            fieldName = sprintf('df_CNleaf_%1.0f_Ni_%1.2f_SOMCN_%1.0f',CNleaf(k),init_inorgN(j),CNSOM(i));
            fieldName = strrep(fieldName, '.', '_');
            df_soilCN_inorgN_leafCN.(fieldName) = df;
%             Lines  = readlines('out.txt');
%             exit_msg = Lines(32)
%             fig=plotting(df,params,exit_msg);
%             exportgraphics(fig, "figs/soil_property/"+fieldName+".png", Resolution=300)
%             close all
        end
    end
end
save('df_soilCN_inorgN_leafCN.mat', 'df_soilCN_inorgN_leafCN')

%%
load('df_soilCN_inorgN_leafCN.mat', 'df_soilCN_inorgN_leafCN')

title_font=12;
fig=figure;fig.Color='w';
fig.Position=[40,60,800,650];
[ax, ~] = tight_subplot(2,2, [.075 .1],[.1 .075],[0.1 .02]);
root_col=[198, 140, 83]/255;
exuflux_col = [45, 89, 134]/255;
supply_col = [1 1 1]*0.3;
leaf_col = [129, 182, 34]/255;

title(ax(1),"(A) Low min. N",'FontWeight','normal',FontSize=title_font);
title(ax(2),"(B) Low min. N",'FontWeight','normal',FontSize=title_font);
title(ax(3),"(C) High min. N",'FontWeight','normal',FontSize=title_font);
title(ax(4),"(D) High min. N",'FontWeight','normal',FontSize=title_font);

text(ax(2),-0.15, 0.25+0.4, 'or \int{\itG_{R}} / \int{\itS}', 'Units', 'normalized', ...
    'Color', root_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);
text(ax(2), -0.15, 0.25, '{\it\intE/\intS} [-]', 'Units', 'normalized', ...
    'Color', exuflux_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);

text(ax(4),-0.15, 0.25+0.4, 'or \int{\itG_{R}} / \int{\itS}', 'Units', 'normalized', ...
    'Color', root_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);
text(ax(4), -0.15, 0.25, '{\it\intE/\intS} [-]', 'Units', 'normalized', ...
    'Color', exuflux_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);


text(ax(1),-0.15, 0.25+0.5, 'or \int{\itS} / \int{\itA_{net}}', 'Units', 'normalized', ...
    'Color', supply_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);
text(ax(1), -0.15, 0.25, '{\it\intG_{L}/\intA_{net}} [-]', 'Units', 'normalized', ...
    'Color', leaf_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);

text(ax(3),-0.15, 0.25+0.5, 'or \int{\itS} / \int{\itA_{net}}', 'Units', 'normalized', ...
    'Color', supply_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);
text(ax(3), -0.15, 0.25, '{\it\intG_{L}/\intA_{net}} [-]', 'Units', 'normalized', ...
    'Color', leaf_col, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', Rotation=90, FontSize=title_font);

final_tbl=table();
w=1;
numstr =["(A)","(B)","(C)","(D)"];
ls = ["--","-"];msw=6;lw=1.5;

axgrid= [ax(1),ax(2);ax(3),ax(4)];
for i=1:2
    for j=1:2
        hold(axgrid(i,j),'on')
    end
end


for j= 1:length(init_inorgN)
    for k =1:length(CNleaf)
        Cpartition=[];
        for i=1:length(CNSOM)
            fieldName = sprintf('df_CNleaf_%1.0f_Ni_%1.2f_SOMCN_%1.0f',CNleaf(k),init_inorgN(j),CNSOM(i));
            fieldName = strrep(fieldName, '.', '_');
            df=df_soilCN_inorgN_leafCN.(fieldName);
            S_by_Anet = trapz(df.time,df.rootCSupply)/trapz(df.time,df.Anet);
            Gleaf_by_Anet = trapz(df.time,df.leaf_growth_rate)/trapz(df.time,df.Anet);
            Groot_by_Anet = trapz(df.time,df.root_growth_rate)/trapz(df.time,df.Anet);
            exu_by_Anet = trapz(df.time,df.root_exu)/trapz(df.time,df.Anet);

            Groot_by_S = trapz(df.time,df.root_growth_rate)/trapz(df.time,df.rootCSupply);
            exu_by_S = trapz(df.time,df.root_exu)/trapz(df.time,df.rootCSupply);
            Cpartition = [Cpartition;[S_by_Anet,Gleaf_by_Anet,Groot_by_Anet, exu_by_Anet, Groot_by_S,   exu_by_S]];
        end
        tbl = array2table(Cpartition, "VariableNames",["S_by_Anet","Gleaf_by_Anet","Groot_by_Anet","exu_by_Anet","Gr_S","E_S"]);
        tbl.CNSOM=CNSOM;
        tbl.init_inorgN = repmat(init_inorgN(j), height(tbl), 1);
        tbl.CNleaf = repmat(CNleaf(k), height(tbl), 1);

        final_tbl=[final_tbl;tbl];

        plot(axgrid(j,1),tbl.CNSOM, tbl.S_by_Anet,LineStyle=ls(k),Marker='o', ...
            MarkerSize=msw, LineWidth=1.75, Color=supply_col);
        plot(axgrid(j,1),tbl.CNSOM, tbl.Gleaf_by_Anet,LineStyle=ls(k),Marker='o', ...
            MarkerSize=msw, LineWidth=1.75, Color=leaf_col);
        %             plot(ax(1),tbl.CNSOM, tbl.Groot_by_Anet,LineStyle=ls(k),Marker='o', ...
        %                 MarkerSize=msw, LineWidth=1.75, Color=root_col);
        %             plot(ax(1),tbl.CNSOM, tbl.exu_by_Anet,LineStyle=ls(k),Marker='o', ...
        %                 MarkerSize=msw, LineWidth=1.75, Color=exuflux_col);

        plot(axgrid(j,2),tbl.CNSOM, tbl.Gr_S,LineStyle=ls(k),Marker='o', ...
            MarkerSize=msw, LineWidth=1.75, Color=root_col);
        plot(axgrid(j,2),tbl.CNSOM, tbl.E_S,LineStyle=ls(k),Marker='o', ...
            MarkerSize=msw, LineWidth=1.75, Color=exuflux_col);

        %             tsrt = numstr(w)+" "+CNleaf_Str(k)+" and "+init_inorgN_Str(j)
        %             title(ax(w),tsrt,'FontWeight','normal',FontSize=title_font);
    end
end


% axis styling----------------------------

ax2 = axes;
ax2.Position = ax(1).Position;
p = [1,2];
for jj = 1:2
    p(jj) = plot(ax2, nan, nan, ls{jj}, 'LineWidth', 2, 'Color','k');
    hold(ax2, 'on')
end
hl = legend(ax2, p,  {'low leaf C:N','high leaf C:N'});
hl.FontSize = 11;hl.Location="southwest";
hl.Box = 'on';h1.Title.String="line color";
hl.Color='w';hl.LineWidth=0.5;
ax2.Visible = 'off';


% set(ax, 'Ylim',[0,0.4])
set(ax([1,3]), 'Ylim',[0,0.9])
set(ax([2,4]), 'Ylim',[0,0.4])


set(ax(1:2), 'Xticklabel',[])
% set(ax([2,4]), 'Yticklabel',[])

xlabel(ax(3:4),"SOM C:N ratio");

for i =1:length(ax)
    set(ax(i), 'LineWidth', 0.5, 'FontSize', 11, 'Box','on')
    ax(i).YLabel.FontSize=13;
    ax(i).XLabel.FontSize=13;
    ax(i).Title.FontSize=13;
    grid(ax(i),'on');
end

exportgraphics(gcf, "figs/Figure4.png", Resolution=600)
print(gcf, 'figs/Figure4.svg', '-dsvg');
