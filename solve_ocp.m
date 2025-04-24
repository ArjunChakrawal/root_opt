function [df, sol, litter, ocp] = solve_ocp(terminal_time, state_init, params, num_tstep, tdf)
% Model implementation
% Create the Yop system
sys = YopSystem( ...
    'states', 9, ...
    'controls', 2, ...
    'model', @(t, x, u)plant_soil_microbe(t, x, u, params) ...
    );
% Symbolic variables
time = sys.t;
litter = sys.y.litter;
x=sys.x;
u=sys.u;
% Formulate optimal control problem
ocp = YopOcp();
ocp.max({timeIntegral(litter.leaf_growth_rate)});
% ocp.max({timeIntegral(litter.Ccost_of_Nacq)});

% new_exu_constraint = ((litter.root_maintenance_resp+litter.root_exu)/(params.cue_R-params.min_frac_root_growth))/litter.Anet;
ocp.st( ...
    'systems', sys, ...
    ... % state bounds
    {0, '<=', litter.leafC}, ...
    {0, '<=', litter.rootC}, ...
    {0, '<=', litter.exuC}, ...
    {0, '<=', litter.SOMC}, ...
    {0, '<=', litter.micC}, ...
    ...%     {0, '<=', litter.leafN}, ...
    {0, '<=', litter.rootN}, ...
    {0, '<=', litter.SOMN}, ...
    {0, '<=', litter.micN}, ...
    {0.01, '<=', litter.inorgN}, ...
    ... % control bounds
    {0, '<=', litter.CNM,'<=',20}, ...
    {0, '<=', litter.leaf_growth_rate}, ...
    {0, '<=', litter.root_exu}, ...
    {0, '<=', litter.rootCSupply}, ...
    {params.min_exudation, '<=', litter.root_exu_norm, '<=', 1}, ...
    {0, '<=', litter.rootN_uptake_norm, '<=', 1}, ...
    ...%{0.2, '<=', litter.S_norm, '<=', 0.8}, ...
    {params.min_frac_leaf_growth, '<=', litter.frac_leaf_growth}, ...
    {params.min_frac_root_growth, '<=', litter.frac_root_growth}, ...
    {0.99-params.min_frac_root_growth,'>=', litter.new_exu_constraint},...
    ... % Initial conditions
    {0, '==', t_0(time)}, ...
    {state_init.leafC, '==', t_0(litter.leafC)}, ...
    {state_init.rootC, '==', t_0(litter.rootC)}, ...
    {state_init.exuC, '==', t_0(litter.exuC)}, ...
    {state_init.SOMC, '==', t_0(litter.SOMC)}, ...
    {state_init.micC, '==', t_0(litter.micC)}, ...
    ...%     {state_init.leafN, '==', t_0(litter.leafN)}, ...
    {state_init.rootN, '==', t_0(litter.rootN)}, ...
    {state_init.SOMN, '==', t_0(litter.SOMN)}, ...
    {state_init.micN, '==', t_0(litter.micN)}, ...
    {state_init.inorgN, '==', t_0(litter.inorgN)}, ...
    ... % Terminal conditions
    {terminal_time, '==', t_f(time)} ...
    );



% Solving the OCP
if(~isempty(tdf))
    state = tdf{:,["leafC", "rootC", "exuC", "SOMC","micC","rootN","SOMN","micN","inorgN", "rootCSupply","root_exu"]};
    state_t = tdf.time;
    new_t = linspace(0,terminal_time, num_tstep+1);
    new_state =  interp1(state_t, state, new_t, "pchip")';
    sz =size(new_state);
    new_state = new_state+new_state.*rand(sz)*0.1;
    InitialGuess = [new_t; new_state];
    w0 = YopInitialGuess(...
        'signals', [time; x; u], ...
        'signalValues', InitialGuess ...
        );
    tic
    sol = ocp.solve( ... %     'initialGuess', initialGuess, ...
        'controlIntervals', num_tstep, ...
        ...%'collocationPoints', 'radau', ... %
        'collocationPoints', 'legendre', ... %
        'polynomialDegree', 5, ...
        'initialGuess', w0,...
        'ipopt', struct('max_iter', 2000, "print_level", 3, "max_cpu_time", 500) ...
        );toc
else
    tic

    sol = ocp.solve( ... %     'initialGuess', initialGuess, ...
        'controlIntervals', num_tstep, ...
        ...% 'collocationPoints', 'radau', ... %
        'collocationPoints', 'legendre', ... %
        'polynomialDegree', 3, ...
        'ipopt', struct('max_iter', 2000, "print_level",3, "max_cpu_time", 500,...
        'tol',1e-6,'warm_start_init_point', 'yes','output_file','out.txt') ...
        );
    toc
end

df = array2table(sol.signal(time)', 'VariableNames', {'time'});
litter_cell = struct2cell(litter);
fields = fieldnames(litter);
for i = 1:length(fields)
    varName = fields{i}; % Get the current variable name
    df.(varName) = sol.signal(litter_cell{i})'; % Assign the corresponding values to the new column
end
df.CNE = ones(height(df),1)*params.CNE;

    function [dx, y] = plant_soil_microbe(t, state, u, params)

        % Define the state variables
        fCL = state(1);
        fCR = state(2);
        fCE = state(3);
        fSOMC = state(4);
        fCM = state(5);

        %         fNL = state(6);
        fNL= fCL/params.CNleaf_opt;
        fNR = state(6);
        fNSOM = state(7);
        fNM = state(8);
        fNinorg = state(9);

        % Calculate root exudation
        root_exu = u(1);
        rootCSupply = u(2);

        % Calculate various ratios
        CNR = fCR / fNR;
        CNM = fCM / fNM;
        CNSOM = fSOMC / fNSOM;
        CNleaf = fCL / fNL;

        % Calculate C assimilation rate A
        A = fNL*(1- fNL/params.KNL) * (params.a - params.b * fCL);

        % Calculate root C supply in C limited conditions
%         max_rootCSupply = params.R70 * params.Vmax_rootCsupply * fCL * fCR;

        % Calculate leaf respiration
        leaf_resp = (1 - params.e_L) * A;

        % Calculate root exudation
        max_root_exu = params.Vmax_exu_production * fCR;

        % Calculate root turnover
        root_turnover = params.tau_root * fCR;

        % Calculate exudate uptake
        exu_uptake = (params.Vmax_ex * fCE * fCM) / (params.KM_ex + fCM + fCE);

        % Calculate SOM uptake
        SOM_uptake = (params.Vmax_SOM * fSOMC * fCM) / (params.KM_SOM + fCM + fSOMC);

        % Calculate microbial turnover
        micro_turnover = params.tau_mic * fCM;

        % Calculate microbial respiration
        micro_resp = (1 - params.cue_M) * (exu_uptake + SOM_uptake);

        % Calculate potential root N uptake
        potential_root_N_uptake = (params.Vmax_IN_to_root *fNR* fNinorg) / (params.KM_IN_to_root + fNinorg);

        % Calculate root respiration
        root_resp = (1 - params.cue_R) * rootCSupply;
        root_maintenance_resp = params.r_m * fCR;
        % Calculate PN
        leaf_N_uptake = (A - leaf_resp - rootCSupply) / params.CNleaf_opt;

        % Calculate phiC
        phiC = SOM_uptake / CNSOM + exu_uptake / params.CNE - ...
            params.cue_M * (exu_uptake + SOM_uptake) / CNM;

        % Calculate inorganic N input to microbial pool
        IN_inorg_to_mic = params.Vmax_IN_to_mic * fNinorg / (params.KM_IN_to_mic + fNinorg);

        % Calculate N leaching
        Nleaching = params.leaching_rate * fNinorg;

        Nmin = if_else(phiC > 0, phiC, 0); % if phiC is + then mineralization, if - then no mineralization

        % If phiC is -ve then immobilization, if +ve then no immobilization
        % If -phiC<In, then N is assimilated from Inorganic pool but no N limited
        % condition, thus Imm = -phiC. If -phiC>In, then N limited condition then Imm = In
        Imm = if_else(phiC > 0, 0, if_else(-phiC > IN_inorg_to_mic, IN_inorg_to_mic, -phiC));

        phiN = Nmin - Imm;

        Net_leafC_assimilation = A - leaf_resp ;
        leaf_growth_rate = Net_leafC_assimilation - rootCSupply;
        frac_Anet_allocated_toleaf_growth = leaf_growth_rate/Net_leafC_assimilation;

        Net_rootC_assimilation =rootCSupply - root_resp ;
        root_growth_rate = Net_rootC_assimilation - root_exu -root_maintenance_resp;
        root_CUE = Net_rootC_assimilation/rootCSupply;
        frac_S_allocated_to_root_growth = root_growth_rate/rootCSupply;

        root_N_uptake = root_growth_rate / params.CNroot_opt + leaf_N_uptake + root_exu / params.CNE;

        dleafCdt = leaf_growth_rate;
        drootCdt = root_growth_rate - root_turnover;
        dexuCdt = root_exu - exu_uptake;
        dSOMCdt = -SOM_uptake + micro_turnover + root_turnover;
        dmicCdt = exu_uptake + SOM_uptake - micro_resp - micro_turnover;

        %         dleafNt = leaf_N_uptake;
        drootNdt = root_N_uptake - root_exu / params.CNE - root_turnover / params.CNroot_opt - leaf_N_uptake;
        dSOMNdt = -SOM_uptake / CNSOM + micro_turnover / CNM + root_turnover / params.CNroot_opt;
        dmicNdt = exu_uptake / params.CNE + SOM_uptake / CNSOM - micro_turnover / CNM - phiN;
        dInorgNdt = 0 + phiN - root_N_uptake - Nleaching;

        %         dx = [dleafCdt; drootCdt; dexuCdt; dSOMCdt; dmicCdt; ...
        %             dleafNt; drootNdt; dSOMNdt; dmicNdt; dInorgNdt];
        dx = [dleafCdt; drootCdt; dexuCdt; dSOMCdt; dmicCdt; ...
            drootNdt; dSOMNdt; dmicNdt; dInorgNdt];

        y.litter.leafC = fCL;
        y.litter.rootC = fCR;
        y.litter.exuC = fCE;
        y.litter.SOMC = fSOMC;
        y.litter.micC = fCM;

        y.litter.leafN = fNL;
        y.litter.rootN = fNR;
        y.litter.Nexu = fCE / params.CNE;
        y.litter.SOMN = fNSOM;
        y.litter.micN = fNM;
        y.litter.inorgN = fNinorg;

        y.litter.root_exu_norm = root_exu / max_root_exu;
        y.litter.S_norm = rootCSupply / Net_leafC_assimilation;
        y.litter.frac_leaf_growth = frac_Anet_allocated_toleaf_growth;

        y.litter.root_CUE = root_CUE;
        y.litter.frac_root_growth = frac_S_allocated_to_root_growth;


        % other outputs
        y.litter.CNR = CNR;
        y.litter.CNM = CNM;
        y.litter.CNSOM = CNSOM;
        y.litter.CNleaf = CNleaf;

        y.litter.dleafCdt = dleafCdt;
        y.litter.drootCdt = drootCdt;
        y.litter.dexuCdt = dexuCdt;
        y.litter.dSOMCdt = dSOMCdt;
        y.litter.dmicCrodt = dmicCdt;

        %         y.litter.dleafNt = dleafNt;
        y.litter.drootNdt = drootNdt;
        y.litter.dNExudt = dexuCdt / params.CNE;
        y.litter.dNSOMdt = dSOMNdt;
        y.litter.dNmicrodt = dmicNdt;
        y.litter.dInorgnNdt = dInorgNdt;

        y.litter.A = A;
        y.litter.rootCSupply = rootCSupply;
        y.litter.leaf_resp = leaf_resp;
        y.litter.root_exu = root_exu;
        y.litter.root_resp = root_resp;
        y.litter.exu_uptake = exu_uptake;
        y.litter.SOM_uptake = SOM_uptake;
        y.litter.micro_resp = micro_resp;
        y.litter.root_N_uptake = root_N_uptake;
        y.litter.leaf_N_uptake = leaf_N_uptake;
        y.litter.phiN = phiN;
        y.litter.Imm = Imm;
        y.litter.Nmin = Nmin;
        y.litter.Nleaching = Nleaching;
        y.litter.IN_inorg = IN_inorg_to_mic;
        y.litter.micro_turnover = micro_turnover;
        y.litter.root_turnover = root_turnover;
        y.litter.rootN_uptake_norm = root_N_uptake / potential_root_N_uptake;

        y.litter.root_growth_rate = root_growth_rate;
        y.litter.leaf_growth_rate = leaf_growth_rate;
        y.litter.mic_growth_rate = exu_uptake + SOM_uptake - micro_resp;
        %         y.litter.CNleaf_ratebased = dleafCdt / dleafNt;
        y.litter.Net_rootC_assimilation = Net_rootC_assimilation;
        y.litter.Net_leafC_assimilation = Net_leafC_assimilation;

        y.litter.root_maintenance_resp = root_maintenance_resp;

        y.litter.Ccost_of_Nacq = leaf_N_uptake/rootCSupply;
        Anet = A-leaf_resp;
        y.litter.Anet = Anet;
        y.litter.new_exu_constraint = ((root_maintenance_resp+root_exu)/(params.cue_R-params.min_frac_root_growth))/Anet;


    end

end

%%
