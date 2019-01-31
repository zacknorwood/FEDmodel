function [] = FED_MAT_MAIN(opt_RunGAMSModel, opt_marg_factors, min_totCost_0, min_totCost, min_totPE, min_totCO2, synth_baseline)
% optimization options
% min_totCost_0: option for base case simulation of the FED system where historical data of the generating units are used and the external connection is kept as a slack (for balancing)
% min_totCost:  %weighting factor for total cost to use in the minimization function
% min_totPE:    %weighting factor for PE to use in the minimization function
% min_totCO2:   %weighting factor CO2 emissions to use in the minimization function

profile on  %to monitor time used to run different parts of model code
tic
delete GtoM.gdx
delete MtoG.gdx

%% Assigning buildings ID to the buildings in the FED system

%Building IDs used to identify buildings in the FED system
BID.name='BID';
BID.uels={'O3060132', 'O3060101', 'O3060102_3', 'O3060104_15', 'O0007043','O0007017',...
    'SSPA', 'O0007006', 'Studentbostader', 'O0007008','O0007888',...
    'Karhus_CFAB', 'O0007019', 'O0007040', 'O0007014',...
    'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
    'O3060133', 'O0007024', 'O0007005', 'O0013001','O0011001',...
    'O0007018', 'O3060137', 'Karhuset', 'O3060138','O0007023', 'O0007026', 'O0007027',...
    'Karhus_studenter', 'Chabo'};

%Subset of the buildings in the FED system connected to AH's(Akadamiska Hus) electrical distribution system
BID_AH_el.name='BID_AH_el';
BID_AH_el.uels={'O3060132', 'O0007043', 'O0007017',...
    'O0007006', 'Studentbostader', 'O0007008', 'O0007888',...
    'Karhus_CFAB', 'O0007019', 'O0007040', 'O0007014',...
    'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028', 'O0007001',...
    'O3060133', 'O0007024', 'O0007005', 'O0013001', 'O0011001',...
    'O0007018', 'O0007023', 'O0007026', 'O0007027',...
    'Karhus_studenter'};

%Subset of the buildings in the FED system not connected AH's el distribution system; hence the el demnds of these buldings are supplied from GE's external grid
BID_nonAH_el.name='BID_nonAH_el';
BID_nonAH_el.uels={'O3060101', 'O3060102_3', 'O3060104_15',...
    'SSPA',...
    'O3060137', 'Karhuset', 'O3060138',...
    'Chabo'};

%Subset of the buildings in the FED system which are connected to AH's local heat distribution network
BID_AH_h.name='BID_AH_h';
BID_AH_h.uels={'O3060132', 'O0007043','O0007017',...
    'SSPA', 'O0007006', 'Studentbostader', 'O0007008','O0007888',...
    'Karhus_CFAB', 'O0007019', 'O0007040',...
    'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
    'O3060133', 'O0007024', 'O0007005', 'O0013001','O0011001',...
    'O0007018','O0007023', 'O0007026', 'O0007027',...
    'Karhus_studenter'};

%Subset of buildings in the FED system not connected to AH's local heat distribution network, buildings heat demand is hence supplied from GE's external DH system
BID_nonAH_h.name='BID_nonAH_h';
BID_nonAH_h.uels={'O3060101', 'O3060102_3', 'O3060104_15',...
    'O0007014',...
    'O3060137', 'Karhuset', 'O3060138',...
    'Chabo'};

%Subset of buildings in the FED system connected to AH's local cooling distribution network
BID_AH_c.name='BID_AH_c';
BID_AH_c.uels={'O3060132', 'O0007043','O0007017',...
    'O0007006', 'O0007008','O0007888',...
    'Karhus_CFAB', 'O0007019',...
    'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
    'O3060133', 'O0007024', 'O0013001','O0011001',...
    'O0007018','O0007023', 'O0007026', 'O0007027',...
    'Karhus_studenter'};

%Subset of buildings in the FED system not connected to AH's local cooling distribution network; buildings cooling demand is hence supplied from local cooling generation
BID_nonAH_c.name='BID_nonAH_c';
BID_nonAH_c.uels={'O3060101', 'O3060102_3', 'O3060104_15',...
    'SSPA','Studentbostader',...
    'O0007040', 'O0007014',...
    'O0007005',...
    'O3060137', 'Karhuset', 'O3060138',...
    'Chabo'};

%Subset of buildings in the FED system which are not considered for thermal energy storage
BID_nonBTES.name='BID_nonBTES';
BID_nonBTES.uels={'O0007043',...
    'SSPA', 'Studentbostader', 'Karhus_CFAB',...
    'O0007014',...
    'O0007005',...
    'O0007018','O3060137', 'Karhuset', 'O3060138',...
    'Karhus_studenter'};

%% IDs used to name the buses or nodes in the local electrical distribution system
%OBS: proper maping need to be established between the nodes in the el distribution system and the building IDs

BusID.name='BusID';
BusID_temp=1:41;
BusID.uels=num2cell(BusID_temp);

%% *****IDs for solar irradiance data
%OBS: These IDs, which represent where the solar PVs are located, could be modified so they are mapped to Building IDs and/or the electrical
%nodes in the local el distribution system. Currently they are numbered
%based on the file "solceller lista p� anl�ggningar.xlsx" which is from the 3d shading model

PVID.name='PVID';
PVID_temp=1:99;
PVID.uels=num2cell(PVID_temp);

%% District heating network transfer limits - initialize nodes and flow limits
DH_Node_Fysik.name = 'Fysik';
DH_Node_Fysik.uels = {'O0007001', 'O3060132', 'ITGYMNASIET', 'O0007006', 'O3060133', 'O0011001', 'O0007005', 'O0013001'};
DH_Node_Bibliotek.name = 'Bibliotek';
DH_Node_Bibliotek.uels = {'O0007017'};
DH_Node_Maskin.name = 'Maskin';
DH_Node_Maskin.uels = {'O0007028', 'O0007888'};
DH_Node_EDIT.name = 'EDIT';
DH_Node_EDIT.uels = {'O0007012', 'O0007024', 'O0007018', 'O0007022', 'O0007025', 'O0007021', 'SSPA', 'Studentbostader'};
DH_Node_VoV.name = 'VoV';
DH_Node_VoV.uels = {'Karhus_CFAB','Karhus_studenter', 'O0007019', 'O0007023', 'O0007026', 'O0007027'};
DH_Node_Eklanda.name = 'Eklanda';
DH_Node_Eklanda.uels = {'O0007040'};

DH_Nodes.name = {DH_Node_Fysik.name, DH_Node_Bibliotek.name, DH_Node_Maskin.name, DH_Node_EDIT.name, DH_Node_VoV.name, DH_Node_Eklanda.name};
DH_Nodes.maximum_flow = [31, 2, Inf, 13, 55, Inf] .* 1/1000 ; % l/s * m3/l = m3/s which is assumed input by fget_dh_transfer_limits below

DH_Node_ID.name = 'DH_Node_ID';
DH_Node_ID.uels = {DH_Node_Fysik.name, DH_Node_Bibliotek.name, DH_Node_Maskin.name, DH_Node_EDIT.name, DH_Node_VoV.name, DH_Node_Eklanda.name};

%% District cooling network transfer limits - initialize nodes and flow limits
DC_Node_VoV.name = 'VoV';
DC_Node_VoV.uels = {};
DC_Node_Maskin.name = 'Maskin';
DC_Node_Maskin.uels = {};
DC_Node_EDIT.name = 'EDIT';
DC_Node_EDIT.uels = {};
DC_Node_Fysik.name = 'Fysik';
DC_Node_Fysik.uels = {};
DC_Node_Kemi.name = 'Kemi';
DC_Node_Kemi.uels = {};

DC_Nodes.name = {DC_Node_VoV.name, DC_Node_Maskin.name, DC_Node_EDIT.name, DC_Node_Fysik.name, DC_Node_Kemi.name};
DC_Nodes.maximum_flow = [26, 44, 32, 34, 32] .* 1/1000; % % l/s * m3/l = m3/s which is assumed input by fget_dc_transfer_limits below

DC_Node_ID.name = 'DC_Node_ID';
DC_Node_ID.uels = {DC_Node_VoV.name, DC_Node_Maskin.name, DC_Node_EDIT.name, DC_Node_Fysik.name, DC_Node_Kemi.name};

%forecasted solar PV irradiance -roof
Gekv_roof = struct('name','G_roof','type','parameter','form','full');

%forecasted solar PV irradiance -facade
Gekv_facade = struct('name','G_facade','type','parameter','form','full');

% import = struct('name','import','type','parameter','form','full');
% export = struct('name','export','type','parameter','form','full');
% Boiler1 = struct('name','Boiler1','type','parameter','form','full');
% FGC = struct('name','FGC','type','parameter','form','full');

%% ********LOAD EXCEL DATA - FIXED MODEL INPUT DATA and variable input data************
%Read static properties of the model
[P1P2_disp, DH_exp_season,DH_heating_season_full, BAC_sav_period, pv_area_roof, pv_area_facades, BTES_param ] = fread_static_properties();

%Read variable/measured input data
[el_demand_measured, h_demand_measured,c_demand_measured,...
    h_B1_measured,h_F1_measured,...
    el_VKA1_measured,el_VKA4_measured,el_AAC_measured, h_AbsC_measured,...
    el_price_measured,...
    el_certificate_m,h_price_measured,tout_measured,...
    irradiance_measured_facades,irradiance_measured_roof,...
    DC_slack, el_slack, DH_slack, h_exp_AH_measured, h_imp_AH_measured] = fread_measurements(2, 17000);

%This must be modified
%     temp=load('Input_dispatch_model\import_export_forecasting');
%     forecast_import=(temp.forecast_import')*1000;
%     forecast_export=(temp.forecast_export')*1000;
%
%     Boiler1_forecast=load('Input_dispatch_model\Boiler1_forecast');
%     Boiler1_forecast=abs((Boiler1_forecast.Boiler1_forecast')*1000);
%     FGC_forecast=load('Input_dispatch_model\FGC_forecast');
%     FGC_forecast=abs((FGC_forecast.FGC_forecasting'));
%
%     %Import ANN data
%     load('Input_dispatch_model\Heating_ANN');
%% INPUT PE and CO2 FACTORS
[CO2intensityFinal_El, PEintensityFinal_El, CO2intensityFinal_DH, PEintensityFinal_DH, marginalCost_DH, CO2F_PV, PEF_PV, CO2F_Boiler1, PEF_Boiler1, CO2F_Boiler2, PEF_Boiler2] = get_CO2PE_exGrids(opt_marg_factors);

%% Initialize FED INVESTMENT OPTIONS

%FED investment limit
%68570065; %76761000;  %this is projected FED investment cost in SEK
FED_Inv_lim = struct('name','inv_lim','type','parameter','val',68570065);

%Option to set if investments in BITES, BAC, PV and BES are to be fixed
opt_fx_inv = struct('name','opt_fx_inv','type','parameter','form','full','val',1);

%Option for RMMC investment
%0=no investment, 1=fixed investment, -1=variable of optimization
opt_fx_inv_RMMC = struct('name','opt_fx_inv_RMMC','type','parameter','form','full','val',0);

%Option for new AbsChiller investment
%>=0=fixed investment, -1=variable of optimization
opt_fx_inv_AbsCInv_cap = struct('name','opt_fx_inv_AbsCInv_cap','type','parameter','form','full','val',0);

%Option for P2 investment
%0=no investment, 1=fixed investment, -1=variable of optimization
opt_fx_inv_Boiler2 = struct('name','opt_fx_inv_Boiler2','type','parameter','form','full','val',1);

%Option for Turbine investment
%0=no investment, 1=fixed investment, -1=variable of optimization
opt_fx_inv_TURB = struct('name','opt_fx_inv_TURB','type','parameter','form','full','val',1);

%Option for new HP investment
%>=0 =fixed investment, -1=variable of optimization; 630 kw is heating capacity of the HP invested in
opt_fx_inv_HP_cap = struct('name','opt_fx_inv_HP_cap','type','parameter','form','full','val',1);

%Option for new RM investment
%>=0 =fixed investment, -1=variable of optimization
opt_fx_inv_RMInv_cap = struct('name','opt_fx_inv_RMInv_cap','type','parameter','form','full','val',0);

%Option for TES investment
%>=0 =fixed investment, -1=variable of optimization
opt_fx_inv_TES_cap = struct('name','opt_fx_inv_TES_cap','type','parameter','form','full','val',0);

%Option for BES investment
opt_fx_inv_BES = struct('name','opt_fx_inv_BES','type','parameter','form','full','val',1);
%must be set to 200
opt_fx_inv_BES_cap = struct('name','opt_fx_inv_BES_cap','type','parameter','form','full','val',200);
opt_fx_inv_BES_cap.uels={'O0007027'}; %OBS: Refers to bus 28
%must be set to 100
opt_fx_inv_BES_maxP = struct('name','opt_fx_inv_BES_maxP','type','parameter','form','full','val',100);
opt_fx_inv_BES_maxP.uels=opt_fx_inv_BES_cap.uels;

%Option for BFCh investment  % Why is this battery investment separate?-ZN
opt_fx_inv_BFCh = struct('name','opt_fx_inv_BFCh','type','parameter','form','full','val',0);
%must be set to 100
opt_fx_inv_BFCh_cap = struct('name','opt_fx_inv_BFCh_cap','type','parameter','form','full','val',100);
opt_fx_inv_BFCh_cap.uels={'O0007028'}; %OBS: Refers to Bus 5
%must be set to 50
opt_fx_inv_BFCh_maxP = struct('name','opt_fx_inv_BFCh_maxP','type','parameter','form','full','val',50);
opt_fx_inv_BFCh_maxP.uels=opt_fx_inv_BFCh_cap.uels;

%Option for BTES investment
opt_fx_inv_BTES = struct('name','opt_fx_inv_BTES','type','parameter','form','full','val',1);
BTES_Inv.name='BTES_Inv';
BTES_Inv.uels= {'O0007017','O0007012','O0007006','O0007023','O0007026','O0007027','O0007888', 'O0007028', 'O0007024', 'O0011001','O3060133'};

%Option for BAC investment
%0 is used when there is no investment, 1 if there is investment
opt_fx_inv_BAC = struct('name','opt_fx_inv_BAC','type','parameter','form','full','val',1);
BAC_Inv.name='BAC_Inv';
BAC_Inv.uels={'O0007017','O0007012','O0007006','O0007023','O0007026', 'O0007027','O3060133'};

%Placement of roof PVs (Existing)
PVID_roof_existing=[2 11]; %Refers to ID in "solceller lista p� anl�ggningar.xlsx" as well as the 3d shading model

%Placement of roof PVs (Investments)
PVID_roof_investments=[0 1 3 4 5 6 7 8 9 10] ;  %Refers to ID in "solceller lista p� anl�ggningar.xlsx" as well as the 3d shading model

%Merge all roof PVIDs and create struct for GAMS
PVID_roof.name='PVID_roof';
PVID_roof.uels=num2cell(horzcat(PVID_roof_existing,PVID_roof_investments));

%Capacity of roof PVs (Existing)
%PV_roof_cap_temp1=[50 42];   %OBS:According to document 'ProjektmÃ¶te nr 22 samordning  WP4-WP8 samt WP5'
PV_roof_cap_existing=[48 40]; % According to "solceller lista p� anl�ggningar.xlsx" (updated from AH and CF 2018-12)

%Capacity of roof PVs (Investments)
%Note that these need to be set to zero if running the base case without PV investments.
%PV_roof_cap_temp2=[0 0 0 0 0 0 0 0 0 0]; %[33 116 115 35 102 32 64 57 57 113]   %OBS:According to document 'ProjektmÃ¶te nr 22 samordning  WP4-WP8 samt WP5 and pdf solceller'
PV_roof_cap_investments=[36.54 125.37 116.235 53.55 106.785 37.485 66.15 0 40.32 100.485]; % According to solceller lista p� anl�ggningar.xlsx (updated from AH and CF 2018-12) AWL has been removed from
%the project plan for FED according to AH hence that capacity being zero.

%Merge all roof PV capacities and create struct for GAMS
PV_roof_cap=struct('name','PV_roof_cap','type','parameter','form','full');
PV_roof_cap.uels=PVID_roof.uels;
PV_roof_cap.val=horzcat(PV_roof_cap_existing,PV_roof_cap_investments);

%Placement of facade PVs (Existing)
%Note that no investments in solar facades are made in FED
PVID_facade_existing=99;
PVID_facade.name='PVID_facade';
PVID_facade.uels=num2cell(PVID_facade_existing);

%Capacity of facade PVs
PV_facade_cap_existing=13.23;
PV_facade_cap=struct('name','PV_facade_cap','type','parameter','form','full');
PV_facade_cap.uels=PVID_facade.uels;
PV_facade_cap.val=PV_facade_cap_existing;


%% Define Variable inputs to the dispatch model

h.name='h';
%Define the forecast function here, here forecast is assumed to be the same
%as measurment

%forecasted el demand
el_demand = struct('name','el_demand','type','parameter','form','full');

%forecasted heat demand
h_demand = struct('name','h_demand','type','parameter','form','full');

%forecasted cooling demand
c_demand = struct('name','c_demand','type','parameter','form','full');

%Heat generation from boiler 1 in the base case
qB1 = struct('name','qB1','type','parameter','form','full');

%Historical heat import/export
h_imp_AH_hist = struct('name','h_imp_AH_hist','type','parameter','form','full');
h_exp_AH_hist = struct('name','h_exp_AH_hist','type','parameter','form','full');

%Heat generaion from the Flue gas condenser in the base case
qF1 = struct('name','qF1','type','parameter','form','full');

%el used by VKA1 in the base case
el_VKA1_0 = struct('name','el_VKA1_0','type','parameter','form','full');

%el used by VKA4 in the base case
el_VKA4_0 = struct('name','el_VKA4_0','type','parameter','form','full');

%el used by AAC in the base case
el_AAC_0 = struct('name','el_AAC_0','type','parameter','form','full');

%heat used by AbsC in the base case
h_AbsC_0 = struct('name','h_AbsC_0','type','parameter','form','full');

%forecasted Nordpool el price
el_price = struct('name','el_price','type','parameter','form','full');

%forecasted el certificate
el_certificate = struct('name','el_certificate','type','parameter','form','full');

%forecasted GE's heat price
h_price = struct('name','h_price','type','parameter','form','full');

%forecasted outdoor temprature
tout = struct('name','tout','type','parameter','form','full');

%Building termal energy storage properties
BTES_properties.name='BTES_properties';
BTES_properties.uels={'BTES_Scap', 'BTES_Dcap', 'BTES_Esig', 'BTES_Sch_hc',...
    'BTES_Sdis_hc', 'kloss_Sday', 'kloss_Snight', 'kloss_D', 'K_BS_BD'};

%BITES model
BTES_model = struct('name','BTES_model','type','parameter','form','full','val',BTES_param);
BTES_model.uels={BTES_properties.uels,BID.uels};

%P1P2 dispatchability
P1P2_dispatchable = struct('name','P1P2_dispatchable','type','parameter','form','full');

%Heat export season
DH_export_season = struct('name','DH_export_season','type','parameter','form','full');

%Heat export season
DH_heating_season = struct('name','DH_heating_season','type','parameter','form','full');

%BAC saving period
BAC_savings_period = struct('name','BAC_savings_period','type','parameter','form','full');

% FED_CO2_max = struct('name','CO2_max','type','parameter');
% FED_CO2_peakref = struct('name','CO2_peak_ref','type','parameter');
% FED_PE_totref = struct('name','PE_tot_ref','type','parameter');

CO2F_exG = struct('name','CO2F_exG','type','parameter','form','full');
PEF_exG = struct('name','PEF_exG','type','parameter','form','full');
%MA_CO2F_exG = struct('name','MA_CO2F_exG','type','parameter','form','full');
%MA_PEF_exG = struct('name','MA_PEF_exG','type','parameter','form','full');
CO2F_DH = struct('name','CO2F_DH','type','parameter','form','full');
%MA_CO2F_DH = struct('name','MA_CO2F_DH','type','parameter','form','full');
PEF_DH = struct('name','PEF_DH','type','parameter','form','full');
%MA_PEF_DH = struct('name','MA_PEF_DH','type','parameter','form','full');
MA_Cost_DH = struct('name','MA_Cost_DH','type','parameter','form','full');

%%el exG slack bus data
el_exG_slack = struct('name','el_exG_slack','type','parameter','form','full');

%%District heating slack bus data
h_DH_slack = struct('name','h_DH_slack','type','parameter','form','full');

%%District cooling slack bus data
c_DC_slack = struct('name','c_DC_slack','type','parameter','form','full');

%% SIMULATION OPTIONS
%Option to choose between marginal and average heat price
%if 0, average emissionand seasonal price is used; if 1 marginal price and emission is used
% opt_marg_factors = struct('name','opt_marg_factors','type','parameter','form','full','val',opt_marg_factors);

% For base case simulation, minimization of total cost is the only option.
if (min_totCost_0 == 1)
    min_totCost=1;
    min_totPE=0;
    min_totCO2=0;
end

min_totCost_0 = struct('name','min_totCost_0','type','parameter','form','full','val',min_totCost_0);
min_totCost = struct('name','min_totCost','type','parameter','form','full','val',min_totCost);
min_totPE = struct('name','min_totPE','type','parameter','form','full','val',min_totPE);
min_totCO2 = struct('name','min_totCO2','type','parameter','form','full','val',min_totCO2);
synth_baseline = struct('name','synth_baseline','type','parameter','form','full','val',synth_baseline);
%%


%SIMULATION START AND STOP TIME
%Sim start time
sim_start_y=2016;
sim_start_m=3;
sim_start_d=1;
sim_start_h=1;

%Sim stop time
sim_stop_y=2016;
sim_stop_m=3;
sim_stop_d=31;
sim_stop_h=24;

%Get month and hours of simulation
[HoS, MoS]=fget_time_vector(sim_start_y,sim_stop_y);

% this_month=sim_start_m;

sim_start=HoS(sim_start_y,sim_start_m,sim_start_d,sim_start_h);
sim_stop=HoS(sim_stop_y,sim_stop_m,sim_stop_d,sim_stop_h);

forecast_horizon=10;

Time(1).point='fixed inputs';
Time(1).value=toc;
for t=sim_start:sim_stop
    %% Variable input data to the dispatch model
    %Read measured data
    tic
    forecast_end=t+forecast_horizon-1;
    h.uels=num2cell(t:forecast_end);
    
    %Define the forecast function here, here forecast is assumed to be the same
    %as measurment
    
    %forecasted solar PV irradiance Roof
    Gekv_roof.val = irradiance_measured_roof(t:forecast_end,:);
    Gekv_roof.uels={h.uels,PVID_roof.uels};
    
    %forecasted solar PV irradiance Roof
    Gekv_facade.val = irradiance_measured_facades(t:forecast_end,:);
    Gekv_facade.uels={h.uels,PVID_facade.uels};
    
    %forecasted el demand
    el_demand.val = el_demand_measured(t:forecast_end,:);
    el_demand.uels={h.uels,BID.uels};
    
    %forecasted heat demand
    h_demand.val = h_demand_measured(t:forecast_end,:);
    h_demand.uels={h.uels,BID.uels};
    
    %     %Sample code using ANN to forecast Edit heat demand
    %     heat_Edit_forecast=zeros(1,10);
    % %     for i=1:t_len_m
    % %
    % % %    heat_Edit_forecast(i)=sim(net_Edit,vertcat(flip(temperature((t_init_m-25+i):(t_init_m-2+i))'),flip(workday_index(15719:15742)'),flip(month_index(15719:15742)'),flip(Timeofday_index(15719:15742)')));
    % %
    % %     end
    %     heat_Edit.val = heat_Edit_forecast;
    %     heat_Edit.uels={h.uels,'O0007024'};
    
    %forecasted cooling demand
    c_demand.val = c_demand_measured(t:forecast_end,:);
    c_demand.uels={h.uels,BID.uels};
    
    %Historical heat export
    h_exp_AH_hist.val = h_exp_AH_measured(t:forecast_end,:);
    h_exp_AH_hist.uels=h.uels;
    
    %Historical heat import
    h_imp_AH_hist.val = h_imp_AH_measured(t:forecast_end,:);
    h_imp_AH_hist.uels=h.uels;
    
    %Heat generation from boiler 1 in the base case
    qB1.val = h_B1_measured(t:forecast_end,:);
    qB1.uels=h.uels;
    
    %Heat generation from the Flue gas condenser in the base case
    qF1.val = h_F1_measured(t:forecast_end,:);
    qF1.uels=h.uels;
    
    %el used by VKA1 in the base case
    el_VKA1_0.val=el_VKA1_measured(t:forecast_end,:);
    el_VKA1_0.uels=h.uels;
    
    %el used by VKA4 in the base case
    el_VKA4_0.val=el_VKA4_measured(t:forecast_end,:);
    el_VKA4_0.uels=h.uels;
    
    %el used by AAC in the base case
    el_AAC_0.val=el_AAC_measured(t:forecast_end,:);
    el_AAC_0.uels=h.uels;
    
    %h used by ABC in the base case
    h_AbsC_0.val=h_AbsC_measured(t:forecast_end,:);
    h_AbsC_0.uels=h.uels;
    
    %forecasted Nordpool el price
    el_price.val = el_price_measured(t:forecast_end,:);
    el_price.uels=h.uels;
    
    %forecasted el certificate
    el_certificate.val = el_certificate_m(t:forecast_end,:);
    el_certificate.uels=h.uels;
    
    %forecasted GE's heat price
    h_price.val = h_price_measured(t:forecast_end,:);
    h_price.uels=h.uels;
    
    %forecasted outdoor temperature
    tout.val = tout_measured(t:forecast_end,:);
    tout.uels=h.uels;
    
    %P1P2 dispatchability
    P1P2_dispatchable.val = P1P2_disp(t:forecast_end,:);
    P1P2_dispatchable.uels=h.uels;
    
    %Heat export season
    DH_export_season.val = DH_exp_season(t:forecast_end,:);
    DH_export_season.uels=h.uels;
    
    %DH heating season
    DH_heating_season.val = DH_heating_season_full(t:forecast_end,:);
    DH_heating_season.uels=h.uels;
    
    %BAC saving period
    BAC_savings_period.val = BAC_sav_period(t:forecast_end,:);
    BAC_savings_period.uels=h.uels;
    
    %Calculation of BAC savings factors
    BAC_savings_factor = fget_bac_savings_factor(h);
    
    %District heating network node transfer limits
    DH_Nodes_Transfer_Limits=fget_dh_transfer_limits(DH_Nodes, h, tout);
    
    %District cooling network node transfer limits
    DC_Nodes_Transfer_Limits = fget_dc_transfer_limits(DC_Nodes, h);
    
    %CO2 factors of the external el grid
    CO2F_exG.val = CO2intensityFinal_El(t:forecast_end,:);
    CO2F_exG.uels=h.uels;
    
    %     el_exGCO2F1=EL_CO2F_ma((t-1441):(forecast_end-1441),:);
    %     MA_CO2F_exG.val = el_exGCO2F1;
    %     MA_CO2F_exG.uels=h.uels;
    
    %PE factors of the external el grid
    PEF_exG.val = PEintensityFinal_El(t:forecast_end,:);
    PEF_exG.uels=h.uels;
    
    %     el_exGPEF1=EL_PEF_ma((t-1441):(forecast_end-1441),:);
    %     MA_PEF_exG.val = el_exGPEF1;
    %     MA_PEF_exG.uels=h.uels;
    
    %CO2 factors of the external DH grid (AVERAGE AND MARGINAL) & marginal
    %DH cost
    MA_Cost_DH.val = marginalCost_DH(t:forecast_end,:);
    MA_Cost_DH.uels=h.uels;
    
    CO2F_DH.val = CO2intensityFinal_DH(t:forecast_end,:);
    CO2F_DH.uels=h.uels;
    
    %     MA_CO2F_DH.val = CO2intensityFinal_DH(t:forecast_end,:);
    %     MA_CO2F_DH.uels=h.uels;
    
    %PE factors of the external DH grid(AVERAGE AND MARGINAL)
    PEF_DH.val = PEintensityFinal_DH(t:forecast_end,:);
    PEF_DH.uels=h.uels;
    
    %     MA_PEF_DH.val = DH_PEF_ma(t:forecast_end,:);
    %     MA_PEF_DH.uels=h.uels;
    
    %     import.val = forecast_import((t-26):(t_len_m+t-27),:);
    %     import.uels=h.uels;
    %
    %     export.val = forecast_export((t-26):(t_len_m+t-27),:);
    %     export.uels=h.uels;
    %
    %     Boiler1.val = Boiler1_forecast((t-26):(t_len_m+t-27),:);
    %     Boiler1.uels=h.uels;
    %
    %     FGC.val = FGC_forecast((t-26):(t_len_m+t-27),:);
    %     FGC.uels=h.uels;
    
    %el exG slack bus data
    el_exG_slack.val=el_slack(t:forecast_end,:);
    el_exG_slack.uels=h.uels;
    
    %District heating slack bus data
    h_DH_slack.val=DH_slack(t:forecast_end,:);
    h_DH_slack.uels=h.uels;
    
    %District cooling slack bus data
    c_DC_slack.val=DC_slack(t:forecast_end,:);
    c_DC_slack.uels=h.uels;
    
    %Initial SoC of storage systems and devices with ramp rate.
    BTES_BID_uels = {'O0007027', 'O0007017', 'O0007012', 'O0007006', 'O0007023', 'O0007026', 'O0007028', 'O0007024'};
    if t==sim_start
        %         BTES_S_init.val=zeros(1,8);
        %         BTES_D_init.val=zeros(1,8);
        %         BES_en.val=0.20*opt_fx_inv_BES_cap.val;
        %         BFCh_en.val=0.20*opt_fx_inv_BFCh_cap.val;
        %         h_Boiler1.val=0;
        %         h_Boiler2.val=0;
        %
        opt_fx_inv_BTES_S_init = struct('name','opt_fx_inv_BTES_S_init','type','parameter','form','full','val',zeros(1,length(BTES_BID_uels)));
        opt_fx_inv_BTES_S_init.uels = {num2cell(t), BTES_BID_uels};
        opt_fx_inv_BTES_D_init = struct('name','opt_fx_inv_BTES_D_init','type','parameter','form','full','val',zeros(1,length(BTES_BID_uels)));
        opt_fx_inv_BTES_D_init.uels = {num2cell(t), BTES_BID_uels};
        
        %This should be fixed and passed from Matlab to GAMS -ZN
        %Initial SoC for energy storage must agree with min_SOC.
        opt_fx_inv_BES_init = struct('name','opt_fx_inv_BES_init','type','parameter','form','full','val',0.20*opt_fx_inv_BES_cap.val);
        %opt_fx_inv_BES_init.uels=opt_fx_inv_BES_cap.uels;
        
        opt_fx_inv_BFCh_init = struct('name','opt_fx_inv_BFCh_init','type','parameter','form','full','val',0.20*opt_fx_inv_BFCh_cap.val);
        %opt_fx_inv_BFCh_init.uels=opt_fx_inv_BFCh_cap.uels;
        
        Boiler1_prev_disp = struct('name','Boiler1_prev_disp','type','parameter','form','full','val',0);
        %Boiler1_prev_disp.uels = h.uels;
        
        Boiler2_prev_disp = struct('name','Boiler2_prev_disp','type','parameter','form','full','val',0);
        %Boiler2_prev_disp.uels = h.uels;
        
    else
        [opt_fx_inv_BTES_D_init, opt_fx_inv_BTES_S_init, opt_fx_inv_BES_init, opt_fx_inv_BFCh_init, Boiler1_prev_disp, Boiler2_prev_disp] = readGtoM(t-1,BTES_BID_uels);
        %         Initial(4)=Initial(4)/opt_fx_inv_BFCh_cap.val;
        %         Initial(5)=Initial(5)/opt_fx_inv_BES_cap.val;
    end
    
    %  opt_fx_inv_TES_init = struct('name','opt_fx_inv_TES_init','type','parameter','form','full','val',Initial(3));
    %opt_fx_inv_BTES_S_init = struct('name','opt_fx_inv_BTES_S_init','type','parameter','form','full','val',Initial(2));
    % Why aren't these the same as BTES_Inv.uels? - ZN
    % BTES_S_init=rmfield(BTES_S_init,'field');
    %     opt_fx_inv_BTES_S_init.name='opt_fx_inv_BTES_S_init';
    %     opt_fx_inv_BTES_S_init.type='parameter';
    %opt_fx_inv_BTES_D_init = struct('name','opt_fx_inv_BTES_D_init','type','parameter','form','full','val',Initial(1));
    %BTES_D_init=rmfield(BTES_D_init,'field');
    %     opt_fx_inv_BTES_D_init.name='opt_fx_inv_BTES_D_init';
    %     opt_fx_inv_BTES_D_init.type='parameter';
    
    %% Preparing input GDX file (MtoG) and RUN GAMS model
    wgdx('MtoG.gdx', opt_fx_inv, opt_fx_inv_RMMC,...
        opt_fx_inv_AbsCInv_cap,...
        opt_fx_inv_Boiler2,opt_fx_inv_TURB,opt_fx_inv_HP_cap,...
        opt_fx_inv_RMInv_cap,...
        opt_fx_inv_TES_cap,...
        opt_fx_inv_BES, opt_fx_inv_BES_cap, h, BTES_Inv, BAC_Inv,...
        CO2F_exG, PEF_exG, CO2F_DH, PEF_DH, MA_Cost_DH,...
        CO2F_PV, PEF_PV, CO2F_Boiler1, PEF_Boiler1, CO2F_Boiler2, PEF_Boiler2,...
        BID,BID_AH_el,BID_nonAH_el,BID_AH_h,BID_nonAH_h,BID_AH_c,BID_nonAH_c,BID_nonBTES,...
        el_demand,h_demand,c_demand,qB1,qF1,...
        el_VKA1_0, el_VKA4_0,el_AAC_0,h_AbsC_0,Gekv_roof,Gekv_facade,...
        BTES_properties,BTES_model,P1P2_dispatchable,DH_export_season,DH_heating_season,BAC_savings_period,...
        PVID,PVID_roof,PV_roof_cap,PVID_facade,PV_facade_cap,...
        el_price,el_certificate,h_price,tout,BAC_savings_factor,...
        min_totCost_0, min_totCost, min_totPE, min_totCO2, synth_baseline, FED_Inv_lim,BusID,opt_fx_inv_BFCh, opt_fx_inv_BFCh_cap,...
        opt_fx_inv_BES_maxP,opt_fx_inv_BFCh_maxP, opt_fx_inv_BTES_D_init, opt_fx_inv_BTES_S_init,...
        opt_fx_inv_BFCh_init,opt_fx_inv_BES_init,Boiler1_prev_disp,Boiler2_prev_disp,...
        DH_Node_ID, DH_Nodes_Transfer_Limits,...
        DC_Node_ID, DC_Nodes_Transfer_Limits, el_exG_slack,h_DH_slack,c_DC_slack,h_exp_AH_hist, h_imp_AH_hist,opt_fx_inv_BTES,opt_fx_inv_BAC);
    
    
    Time(2).point='Wgdx and Inputs';
    Time(2).value=toc;
    tic
    
    if opt_RunGAMSModel==1
        system 'gams FED_SIMULATOR_MAIN lo=3';
    end
    
    %% Store the results from each iteration
    Results(t).dispatch = fstore_results(h,BID,BTES_properties,BusID);
end
Time(3).point='Gams running and storing';
Time(3).value=toc;

%% Post processing results

%use the 'plot_results.m' script to plot desired results
%%
Time(4).point='Total';
total=profile('info');
total=total.FunctionTable.TotalTime;
Time(4).value=total(1);
%excel_results(sim_start,sim_stop,Results,Time);
