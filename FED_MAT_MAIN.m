function [to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2, Results] = FED_MAT_MAIN(opt_RunGAMSModel, opt_marg_factors, GE_factors, min_totCost_0, min_totCost, min_totPE, min_totCO2, synth_baseline)
% optimization options
% min_totCost_0: option for base case simulation of the FED system where historical data of the generating units are used and the external connection is kept as a slack (for balancing)
% min_totCost:  weighting factor for total cost to use in the minimization function
% min_totPE:    weighting factor for NRE to use in the minimization function
% min_totCO2:   weighting factor for CO2 emissions to use in the minimization function

delete GtoM.gdx
delete MtoG.gdx

%Starts GAMS link to matlab so that the rgdx/wgdx interface works.
system 'gams';

%% SIMULATION START AND STOP TIME
% All excel files needs to start from 1/1 of the simulation year or changes
% 

%Sim start time
sim_start_y = 2019;
sim_start_m = 8;
sim_start_d = 19;
sim_start_h = 1;

%Sim stop time

sim_stop_y = 2019;
sim_stop_m = 8;
sim_stop_d = 31;
sim_stop_h = 24;

%Get month and hours of simulation
[HoS, ~] = fget_time_vector(sim_start_y,sim_stop_y);

sim_start = HoS(sim_start_y,sim_start_m,sim_start_d,sim_start_h);
sim_stop = HoS(sim_stop_y,sim_stop_m,sim_stop_d,sim_stop_h);

%sim_start=6480;
%sim_stop=sim_start+47;

% In synthetic baseline the forecast horizon should be zero, and 10 hours
% otherwise in FED operation. However currently the result read script does
% not work for forecast horizon below 2.
if (synth_baseline==1)    
    forecast_horizon = 2;
else
    forecast_horizon = 10;
end


% data_read_stop is the last index of data needed for the simulation.
% sim_length is the total length of data needed for the simulation.
% Note there must always be at least as many extra hours of data
% (beyond sim_start to sim_stop) to include the hours of the
% forecast_horizon, thus data_read_stop is longer than sim_stop by the
% forecast_horizon.
data_read_stop = sim_stop + forecast_horizon;

% Cooling season start stop
DC_cooling_season_full = zeros(data_read_stop,1);
no_imp_h_season_full = zeros(data_read_stop,1);
DH_heating_season_full = ones(data_read_stop,1);
DH_heating_season_P2_full = ones(data_read_stop,1);

cooling_year = sim_start_y;
while cooling_year <=sim_stop_y
    % Main cooling season between April and end october
    cooling_season_start = HoS(cooling_year,4,1,1);
    cooling_season_end = HoS(cooling_year,10,31,24);
    % no heat import from GE between 15/5 to 15/9
    no_h_imp_season_start = HoS(cooling_year,5,15,1);
    no_h_imp_season_end = HoS(cooling_year,9,15,24);
    
    % Time when no Heat export are allowed 1/11 to 31/3 note that we set
    % this to zero during the non export season
    DH_heating_season_start = HoS(cooling_year,10,31,24);
    DH_heating_season_stop = HoS(cooling_year,4,1,1);
    
    DC_cooling_season_full(cooling_season_start:cooling_season_end) = 1;
    no_imp_h_season_full(no_h_imp_season_start:no_h_imp_season_end) = 1;
    DH_heating_season_full(DH_heating_season_stop:DH_heating_season_start) = 0;
    
    DH_heating_season_P2_start = HoS(cooling_year,9,30,24);
    DH_heating_season_P2_stop = HoS(cooling_year,5,1,1);
    DH_heating_season_P2_full(DH_heating_season_P2_stop:DH_heating_season_P2_start) = 0;
    
    cooling_year = cooling_year + 1;
end

% BAC_savings_period_full
BAC_savings_period_full = zeros(data_read_stop,1);
current_year = sim_start_y;
while current_year <= sim_stop_y
    year_start = HoS(current_year,1,1,1);
    BAC_savings_end =  HoS(current_year,4,1,1);
    BAC_savings_start = HoS(current_year,10,1,1);
    year_end = HoS(current_year,12,31,24);
    
    BAC_savings_period_full(year_start:BAC_savings_end) = 1;
    BAC_savings_period_full(BAC_savings_start:year_end) = 1;
    
    current_year = current_year +1;
end
% P1 and P2 dispatchability
% Get a series of ordinary working days


%P1P2_dispatchable_test = zeros(sim_stop,1);
%current_year = sim_start_y
%while current_year <= sim_stop_y


%end

% DATA INDICES FOR INPUT DATA
% data_read_stop is the last index of data needed for the simulation.
% sim_length is the total length of data needed for the simulation.
% Note there must always be at least as many extra hours of data
% (beyond sim_start to sim_stop) to include the hours of the
% forecast_horizon, thus data_read_stop is longer than sim_stop by the
% forecast_horizon.
% Note also that GE production data only goes to February 28, 2016... so a full 2 year run
% is not possible. The max data length currently is 10200 hours from 2016-01-01
% 00:00 to 2017-02-28 23:00, but one year from 2016-03-01 to 2017-02-28 is
% preferred for data completeness/correctness. Still there is heat pump
% data missing as well as building data missing even in this period.

sim_length = sim_stop - sim_start + 1;
data_length = data_read_stop - sim_start + 1;

% Initialize Results cell array
%Results=cell(data_length,1);

%% Assigning buildings ID to the buildings in the FED system and BIDs to the location of investments

BES_BID_uels = {'O0007027', 'O0007028'}; %Buildings with Battery Energy Storage systems Note: Refers to bus 28, Refers to Bus 5; %
CWB_BID_uels = {'O0007027'}; %Buildings with Cold Water Basin OBS: DS is this correct? Refers to bus 28

% AK SHould 'O0007024' be included?
BTES_BAC_BID_uels = {'O0007006', 'O0007012', 'O0007017', 'O0007023', 'O0007026', 'O3060135', 'O3060133'}; %Buildings with Advanced Control (BAC) system
BTES_PS_BID_uels = {'O0011001', 'O0007888'}; % Buildings with Pump Stop (PS) capability
BTES_SO_BID_uels = {'O0007028', 'O0007027', 'O0007024'}; % Buildings with Setpoint Offset (SO) capability, O0007024 (EDIT) included to represent O7:10, and O7:20 which are parts of EDIT

warning('Pump Stop buildings currently running with Setpoint Offset model')
BTES_SO_BID_uels = [BTES_PS_BID_uels, BTES_SO_BID_uels]; % Temporary: Combine PS into SO until PS is implemented properly.

%Building IDs used to identify buildings in the FED system
% DO NOT CHANGE THE ORDER OF THESE! The order is tied to the reading of
% measurements in fread_measurements which relies on this order of
% buildings in the input file
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
BID_AH_h.uels={'O3060132', 'O0007017',...
    'SSPA', 'O0007006', 'Studentbostader', 'O0007008','O0007888',...
    'Karhus_CFAB', 'O0007019', 'O0007040',...
    'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
    'O3060133', 'O0007024', 'O0007005', 'O0013001','O0011001',...
    'O0007018','Karhuset','O0007023', 'O0007026', 'O0007027',...
    'Karhus_studenter'};

%Subset of buildings in the FED system not connected to AH's local heat distribution network, buildings heat demand is hence supplied from GE's external DH system
BID_nonAH_h.name='BID_nonAH_h';
BID_nonAH_h.uels={'O3060101', 'O0007043','O3060102_3', 'O3060104_15',...
    'O0007014',...
    'O3060137', 'O3060138',...
    'Chabo'};

%Subset of buildings in the FED system connected to AH's local cooling distribution network
BID_AH_c.name='BID_AH_c';
BID_AH_c.uels={'O3060132', 'O0007017',...
    'O0007006', 'O0007008','O0007888',...
    'Karhus_CFAB', 'O0007019',...
    'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
    'O3060133', 'O0007024', 'O0013001','O0011001',...
    'O0007018','O0007023', 'O0007026', 'O0007027',...
    'Karhuset', 'Karhus_studenter'};

%Subset of buildings in the FED system not connected to AH's local cooling distribution network; buildings cooling demand is hence supplied from local cooling generation
BID_nonAH_c.name='BID_nonAH_c';
BID_nonAH_c.uels={'O3060101','O0007043', 'O3060102_3', 'O3060104_15',...
    'SSPA','Studentbostader',...
    'O0007040', 'O0007014',...
    'O0007005',...
    'O3060137', 'O3060138',...
    'Chabo'};

%Subset of buildings in the FED system which are not considered for thermal energy storage
% AK Check if these are used
BID_nonBTES.name='BID_nonBTES';
BID_nonBTES.uels={'O0007043',...
    'SSPA', 'Studentbostader', 'Karhus_CFAB',...
    'O0007014',...
    'O0007005',...
    'O0007018','O3060137', 'Karhuset', 'O3060138',...
    'Karhus_studenter'};
%% %%%%%
% for i=1:length(BID.uels)
%     AH_el(i)=sum(double(strcmp(BID.uels(i),BID_AH_el.uels)));
%     AH_h(i)=sum(double(strcmp(BID.uels(i),BID_AH_h.uels)));
%     AH_c(i)=sum(double(strcmp(BID.uels(i),BID_AH_c.uels)));
%     
%     nonAH_el(i)=sum(double(strcmp(BID.uels(i),BID_nonAH_el.uels)));
%     nonAH_h(i)=sum(double(strcmp(BID.uels(i),BID_nonAH_h.uels)));
%     nonAH_c(i)=sum(double(strcmp(BID.uels(i),BID_nonAH_c.uels)));
% end
%% IDs used to name the buses or nodes in the local electrical distribution system
%OBS: proper maping need to be established between the nodes in the el distribution system and the building IDs

BusID.name='BusID';
BusID.uels=num2cell(1:41);

%% *****IDs for solar irradiance data
%OBS: These IDs, which represent where the solar PVs are located, could be modified so they are mapped to Building IDs and/or the electrical
%nodes in the local el distribution system. Currently they are numbered
%based on the file "solceller lista pï¿½ anlï¿½ggningar.xlsx" which is from the 3d shading model

PVID.name='PVID';
PVID.uels=num2cell(1:99);

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

%% ********LOAD EXCEL DATA - FIXED MODEL INPUT DATA and variable input data************
%Read static properties of the model
% AK Removed BAC_savings_period as this is calculated above
[P1P2_dispatchable_full, ~, BTES_model, BES_min_SoC] = fread_static_properties(sim_start,data_read_stop,data_length);
%Read variable/measured input data
if synth_baseline == 0
    [el_demand_full, h_demand_full, c_demand_full,h_Boiler1_0_full,...
        h_FlueGasCondenser1_0_full, el_VKA1_0_full, el_VKA4_0_full,...
        c_AbsC_0_full, el_price_full, el_certificate_full, tout_full,...
        G_facade_full, G_roof_full, c_DC_slack_full, el_exG_slack_full,...
        h_DH_slack_full, h_exp_AH_hist_full, h_imp_AH_hist_full] = fread_measurements(sim_start,data_read_stop,data_length);
end
% Kommentera ut freadmeasurements och använd byggnadsID nedanför istället
% för size(h_demand)
if synth_baseline == 1
    start_datetime = datetime(sim_start_y,sim_start_m,sim_start_d,sim_start_h,0,0);
    end_datetime = datetime(sim_stop_y,sim_stop_m,sim_stop_d,sim_stop_h+forecast_horizon,0,0);
    [el_demand_synth, h_demand_synth, c_demand_synth, ann_production, temperature, dh_price, el_price, solar_irradiation] = get_synthetic_baseline_load_data(start_datetime, end_datetime) ;
    
    cooling_size = size(BID_AH_c.uels);
    hours = sim_length+forecast_horizon;
    cooled_buildings = cooling_size(2);
    
    heating_size = size(BID_AH_h.uels);
    heated_buildings = heating_size(2);
    
    electricity_size = size(BID_AH_el.uels);
    electrified_buildings = electricity_size(2);
    
    synth_c_demand_full = zeros(hours,cooled_buildings);
    synth_h_demand_full = zeros(hours,heated_buildings);
    synth_el_demand_full = zeros(hours,electrified_buildings);
    
    for i=1:cooled_buildings
        synth_c_demand_full(:,i) = c_demand_synth.c_net_load_values/cooled_buildings;
    end
    for i=1:heated_buildings
        synth_h_demand_full(:,i) = h_demand_synth.h_net_load_values/heated_buildings;
    end
    for i=1:electrified_buildings
        synth_el_demand_full(:,i) = el_demand_synth.el_net_load_values/electrified_buildings;
    end
    c_demand_full = synth_c_demand_full;
    h_demand_full = synth_h_demand_full;
    el_demand_full = synth_el_demand_full;
    
    % Production units for synthetic baseline
    h_Boiler1_0_full = ann_production.Boiler1_production ;
    disp('WARNING TEMPORARY CORRECTION OF BOILER ANN AT ROW 297 IN FED_MAT_MAIN')
    h_Boiler1_0_full(h_Boiler1_0_full>8000) = 8000;
    h_FlueGasCondenser1_0_full = zeros(hours,1); % Does ANN include FGC data?
    c_AbsC_0_full = ann_production.AbsC_production ;
    
    COP_HP_C = 1.8; % Cooling COP of heat pumps
    HP_cooling_production = (ann_production.Total_cooling_demand - ann_production.AbsC_production);
%    el_VKA1_0_full = 0.5 * (HP_cooling_production ./ COP_HP_C);
%    el_VKA4_0_full = 0.5 * (HP_cooling_production ./ COP_HP_C);
%DS - put all on VKA1
    el_VKA1_0_full = 1 * (HP_cooling_production ./ COP_HP_C);
    el_VKA4_0_full = 0 * (HP_cooling_production ./ COP_HP_C);
    
    %el_factors dh_factors
    %DS - This should be taken from Input file
    %    CO2F_El_full = el_factors.co2ei;
    %    PE_El_full = el_factors.pef;
    %    CO2F_DH_full = dh_factors.co2ei;
    %    PE_DH_full = dh_factors.pef;
    
    % Ambient temperature
    tout_full = temperature.Value;
    el_price_full = el_price.Value;
    el_certificate_full = zeros(hours,1); % OK TO BE ZERO
    %   marginalCost_DH_full = dh_price.Value;
    
    %DS - For PR4 real measurement data is used, right now the irradiance is set to zero in "get_synthetic_base....".
    % Solar irradiation
    G_roof_full = zeros(hours,12); % NEEDED - USE TO CALCULATE NEW ELECTRICITY DEMAND (Total production + New PV Arrays (general data felmarginal typ 30%
    for i=1:12
        G_roof_full(:,i) = solar_irradiation.Value;
    end
    G_facade_full = solar_irradiation.Value;
    
    %DS - Unclear function for me?!
    disp('SETTING h_exp_AH_hist and h_imp_AH_hist TO ZEROS ONLY USED IF min_tot_cost_0 = 1')
    h_exp_AH_hist_full = zeros(hours,1); % Should be ignored in GAMS
    h_imp_AH_hist_full = zeros(hours,1); % Should be ignored in GAMS
    
    %    NREF_El_full = zeros(hours,1); % SKIP THIS - USE ONLY PE AND CO2
    %    NREF_DH_full = zeros(hours,1); % SKIP THIS - USE ONLY PE AND CO2
    %    NREF_El_full(:,1) = 1;
    %    NREF_DH_full(:,1) = 1;
    
    el_exG_slack_full = zeros(hours,1); % Should be zero as production == demand
    h_DH_slack_full = zeros(hours,1); % Should be zero as production == demand
    c_DC_slack_full = zeros(hours,1); % Should be zero as production == demand
    
end
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

%% INPUT NRPE, CO2 FACTORS and DH Prices
[CO2F_El_full, PE_El_full, CO2F_DH_full, PE_DH_full, marginalCost_DH_full, CO2F_PV, PE_PV, CO2F_Boiler1, PE_Boiler1, CO2F_Boiler2, PE_Boiler2] = get_CO2PE_exGrids(opt_marg_factors,GE_factors,sim_start,data_read_stop,data_length);

%DS - take price from get synth baseline instead
if synth_baseline==1
    marginalCost_DH_full=dh_price.Value;
end
%DS - Set synth baseline to 0 for report 4.4.1
%synth_baseline=0;
%% Initialize FED INVESTMENT OPTIONS
% If min_totCost_O=1, i.e. base case simulation, then all investment options
% will be set to 0.

%FED investment limit
%68570065; %76761000;  %this is projected FED investment cost in SEK
FED_Inv_lim = struct('name','inv_lim','type','parameter','val',68570065);

%Option to set if investments in BITES, BAC, PV and BES are to be fixed
%This is not used, it is set individually!!!
opt_fx_inv = struct('name','opt_fx_inv','type','parameter','form','full','val',1);

%Option for RMMC investment
%0=no investment, 1=fixed investment, -1=variable of optimization
% For FED run =1
opt_fx_inv_RMMC = struct('name','opt_fx_inv_RMMC','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-synth_baseline));

%Option for new AbsChiller investment
%>=0-XX=fixed investment with capacity 0 or XX, -1=variable of optimization
opt_fx_inv_AbsCInv_cap = struct('name','opt_fx_inv_AbsCInv_cap','type','parameter','form','full','val',0*(1-min_totCost_0)*(1-synth_baseline));

%Option for P2 investment
%0=no investment, 1=fixed investment, -1=variable of optimization
opt_fx_inv_Boiler2 = struct('name','opt_fx_inv_Boiler2','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-synth_baseline));

%Option for Turbine investment
%0=no investment, 1=fixed investment, -1=variable of optimization
opt_fx_inv_TURB = struct('name','opt_fx_inv_TURB','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-synth_baseline));

%Option for new HP investment
%>=0 =fixed investment, -1=variable of optimization; 630 kw is heating capacity of the HP invested in
opt_fx_inv_HP_cap = struct('name','opt_fx_inv_HP_cap','type','parameter','form','full','val',630*(1-min_totCost_0)*(1-synth_baseline));
% minimum heat output from HP during wintermode in kW heat
opt_fx_inv_HP_min= struct('name','opt_fx_inv_HP_min','type','parameter','form','full','val',100*(1-min_totCost_0)*(1-synth_baseline));

%Option for new RM investment
%>=0 =fixed investment, -1=variable of optimization
opt_fx_inv_RMInv_cap = struct('name','opt_fx_inv_RMInv_cap','type','parameter','form','full','val',0*(1-min_totCost_0)*(1-synth_baseline));

%Option for TES investment
%>=0 =fixed investment, -1=variable of optimization
opt_fx_inv_TES_cap = struct('name','opt_fx_inv_TES_cap','type','parameter','form','full','val',0*(1-min_totCost_0)*(1-synth_baseline));

%Option for BFCh investment  % Why is this battery investment separate?-ZN
%opt_fx_inv_BFCh = struct('name','opt_fx_inv_BFCh','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-NO_inv));
%must be set to 100
%opt_fx_inv_BFCh_cap = struct('name','opt_fx_inv_BFCh_cap','type','parameter','form','full','val',100*(1-min_totCost_0)*(1-NO_inv));
%opt_fx_inv_BFCh_cap.uels={'O0007028'}; %OBS: Refers to Bus 5
%must be set to 50
%opt_fx_inv_BFCh_maxP = struct('name','opt_fx_inv_BFCh_maxP','type','parameter','form','full','val',50*(1-min_totCost_0)*(1-NO_inv));
%opt_fx_inv_BFCh_maxP.uels=opt_fx_inv_BFCh_cap.uels;

opt_fx_inv_BAC = struct('name','opt_fx_inv_BAC','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-synth_baseline));
opt_fx_inv_SO = struct('name','opt_fx_inv_SO','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-synth_baseline));

%Option for Cold water basin
%opt_fx_inv_CWB = struct('name','opt_fx_inv_CWB','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-synth_baseline));
%opt_fx_inv_CWB_cap = struct('name','opt_fx_inv_CWB_cap','type','parameter','form','full','val',814*(1-min_totCost_0)*(1-synth_baseline));
%DS - Set to zero for comp.
opt_fx_inv_CWB = struct('name','opt_fx_inv_CWB','type','parameter','form','full','val',1*(1-min_totCost_0)*(synth_baseline));
opt_fx_inv_CWB_cap = struct('name','opt_fx_inv_CWB_cap','type','parameter','form','full','val',814*(1-min_totCost_0)*(synth_baseline));

opt_fx_inv_CWB_cap.uels = CWB_BID_uels;

opt_fx_inv_CWB_ch_max = struct('name','opt_fx_inv_CWB_ch_max','type','parameter','form','full','val',203.5*(1-min_totCost_0)*(1-synth_baseline));
opt_fx_inv_CWB_ch_max.uels= CWB_BID_uels;
opt_fx_inv_CWB_dis_max = struct('name','opt_fx_inv_CWB_dis_max','type','parameter','form','full','val',35*(1-min_totCost_0)*(1-synth_baseline));
opt_fx_inv_CWB_dis_max.uels=opt_fx_inv_CWB_cap.uels;

%Option for BES investment
opt_fx_inv_BES = struct('name','opt_fx_inv_BES','type','parameter','form','full','val',1*(1-min_totCost_0)*(1-synth_baseline));
opt_fx_inv_BES_cap = struct('name','opt_fx_inv_BES_cap','type','parameter','form','full','val',[200 100]*(1-min_totCost_0)*(1-synth_baseline));
opt_fx_inv_BES_cap.uels = BES_BID_uels;
opt_fx_inv_BES_maxP = struct('name','opt_fx_inv_BES_maxP','type','parameter','form','full','val',[100 50]*(1-min_totCost_0)*(1-synth_baseline));
opt_fx_inv_BES_maxP.uels = BES_BID_uels;
BES_min_SoC = struct('name','BES_min_SoC','type','parameter','form','full','val',BES_min_SoC);


%DS - Set to zero for comp.
opt_fx_inv_BES_cap = struct('name','opt_fx_inv_BES_cap','type','parameter','form','full','val',[200 100]*(1-min_totCost_0)*(synth_baseline));

BTES_BAC_Inv.name = 'BTES_BAC_Inv';
BTES_BAC_Inv.uels = BTES_BAC_BID_uels;


BTES_SO_Inv.name = 'BTES_SO_Inv';
BTES_SO_Inv.uels = BTES_SO_BID_uels;
% Maximum charging/discharging power available for building setpoint
% offsets according to power charts attatched to Building agent
% descriptions. Calculated assuming 10ï¿½C offset available.
BTES_SO_max_power = struct('name', 'BTES_SO_max_power', 'type', 'parameter', 'form', 'full');
BTES_SO_max_power.uels = BTES_SO_BID_uels;
BTES_SO_max_power.val = [45, 20, 90, 76, 11]; % kWh/h, Requires ordering of BTES_SO_UELS to be O11:01, O7:888, O7:28, O7, 27, O7:24

%Building thermal energy storage properties
BTES_properties=struct('name','BTES_properties','type','set','form','full');
BTES_properties.uels={'BTES_Scap', 'BTES_Dcap', 'BTES_Esig', 'BTES_Sch_hc',...
    'BTES_Sdis_hc', 'kloss_Sday', 'kloss_Snight', 'kloss_D', 'K_BS_BD'};

%BTES model
BTES_model = struct('name','BTES_model','type','parameter','form','full','val',BTES_model);
BTES_model.uels={BTES_properties.uels,BID.uels};

%Adjust O7:24 in BTES model
BTES_SO_EDIT_Correction_Factor = 0.19; % Correction factor for O7:10, O7:20 as they are only part of O7:24, used below for correcting BTES_model
O724_index = find(strcmp(BTES_model.uels{1,2}, 'O0007024'));
Scap_index = find(strcmp(BTES_model.uels{1,1}, 'BTES_Scap'));
Dcap_index = find(strcmp(BTES_model.uels{1,1}, 'BTES_Dcap'));

BTES_model.val(Scap_index, O724_index) = BTES_model.val(Scap_index, O724_index) * BTES_SO_EDIT_Correction_Factor;
BTES_model.val(Dcap_index, O724_index) = BTES_model.val(Dcap_index, O724_index) * BTES_SO_EDIT_Correction_Factor;

%Investments in PVs
%=1 = fixed investment, 0=no investments (neither existing!!!) -1=variable of optimization

%DS - set to zero
%opt_fx_inv_PV = struct('name','opt_fx_inv_PV','type','parameter','form','full','val',1);
opt_fx_inv_PV = struct('name','opt_fx_inv_PV','type','parameter','form','full','val',0);

%Placement of roof PVs (Existing)
PVID_roof_existing=[2 11]; %Refers to ID in "solceller lista pï¿½ anlï¿½ggningar.xlsx" as well as the 3d shading model

%Placement of roof PVs (Investments)
PVID_roof_investments=[0 1 3 4 5 6 7 8 9 10] ;  %Refers to ID in "solceller lista pï¿½ anlï¿½ggningar.xlsx" as well as the 3d shading model

%Merge all roof PVIDs and create struct for GAMS
PVID_roof.name='PVID_roof';
PVID_roof.uels=num2cell(horzcat(PVID_roof_existing,PVID_roof_investments));

%Capacity of roof PVs (Existing)
%PV_roof_cap_temp1=[50 42];   %OBS:According to document 'ProjektmÃÂ¶te nr 22 samordning  WP4-WP8 samt WP5'
PV_roof_cap_existing=[48 40]; % According to "solceller lista pï¿½ anlï¿½ggningar.xlsx" (updated from AH and CF 2018-12)

%Capacity of roof PVs (Investments)
%Note that these need to be set to zero if running the base case without PV investments.
%PV_roof_cap_temp2=[0 0 0 0 0 0 0 0 0 0]; %[33 116 115 35 102 32 64 57 57 113]   %OBS:According to document 'ProjektmÃÂ¶te nr 22 samordning  WP4-WP8 samt WP5 and pdf solceller'
PV_roof_cap_investments=[36.54 125.37 116.235 53.55 106.785 37.485 66.15 0 40.32 100.485]*(1-min_totCost_0)*(1-synth_baseline); % According to solceller lista pï¿½ anlï¿½ggningar.xlsx (updated from AH and CF 2018-12) AWL has been removed from
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

%% CHECK SIMULATION OPTIONS
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
% Store array to be exported to excel sheet
% INITIALIZE output array
to_excel_el(1:sim_stop-sim_start,1:31)=0;
to_excel_heat(1:sim_stop-sim_start,1:39)=0;
to_excel_cool(1:sim_stop-sim_start,1:23)=0;
to_excel_co2(1:sim_stop-sim_start,1:14)=0;

%Results=zeros(1,length(sim_length));

for t=1:sim_length
    %% Variable input data to the dispatch model
    %Structures are created to send to GAMS which contain subsets of the
    %previously read Matlab data. This creates a rolling time horizon over
    %which the model optimized on every step for X time steps ahead, where
    %X is the forecast_horizon.
    disp(['Time step' num2str(t) ' of ' num2str(sim_length)])
    forecast_end=t+forecast_horizon-1;
    
    % hours in simulation
    h = struct('name','h','type','set','form','full');
    h.uels=num2cell(t:forecast_end);
    
    %Define the forecast functions... forecast is assumed to be the same
    %as measurment.
    
    %forecasted solar PV irradiance Roof
    G_roof = struct('name','G_roof','type','parameter','form','full','val',G_roof_full(t:forecast_end,:));
    G_roof.uels={h.uels,PVID_roof.uels};
    
    %forecasted solar PV irradiance Roof
    G_facade = struct('name','G_facade','type','parameter','form','full','val',G_facade_full(t:forecast_end,:));
    G_facade.uels={h.uels,PVID_facade.uels};
    
    %forecasted el demand
    el_demand = struct('name','el_demand','type','parameter','form','full','val',el_demand_full(t:forecast_end,:));
    el_demand.uels={h.uels,BID.uels};
    
    %forecasted heat demand
    h_demand = struct('name','h_demand','type','parameter','form','full','val',h_demand_full(t:forecast_end,:));
    h_demand.uels={h.uels,BID.uels};
    
    %forecasted cooling demand
    c_demand = struct('name','c_demand','type','parameter','form','full','val',c_demand_full(t:forecast_end,:));
    %c_demand.uels={h.uels,BID.uels};
    % Warning!  Changed for PR4 to BID_AH_c.uels from BID.uels, work
    % around!
    c_demand.uels={h.uels,BID_AH_c.uels};
    
    %Historical heat export
    h_exp_AH_hist = struct('name','h_exp_AH_hist','type','parameter','form','full','val',h_exp_AH_hist_full(t:forecast_end,:));
    h_exp_AH_hist.uels=h.uels;
    
    %Historical heat import
    h_imp_AH_hist = struct('name','h_imp_AH_hist','type','parameter','form','full','val',h_imp_AH_hist_full(t:forecast_end,:));
    h_imp_AH_hist.uels=h.uels;
    
    %Heat generation from boiler 1 in the base case
    h_Boiler1_0 = struct('name','h_Boiler1_0','type','parameter','form','full','val',h_Boiler1_0_full(t:forecast_end,:));
    h_Boiler1_0.uels=h.uels;
    
    %Heat generation from the flue gas condenser in the base case
    h_FlueGasCondenser1_0 = struct('name','h_FlueGasCondenser1_0','type','parameter','form','full','val',h_FlueGasCondenser1_0_full(t:forecast_end,:));
    h_FlueGasCondenser1_0.uels=h.uels;
    
    %el used by VKA1 in the base case
    el_VKA1_0 = struct('name','el_VKA1_0','type','parameter','form','full','val',el_VKA1_0_full(t:forecast_end,:));
    el_VKA1_0.uels=h.uels;
    
    %el used by VKA4 in the base case
    el_VKA4_0 = struct('name','el_VKA4_0','type','parameter','form','full','val',el_VKA4_0_full(t:forecast_end,:));
    el_VKA4_0.uels=h.uels;
    
    %el used by AAC in the base case
    %el_AAC_0.val=el_AAC_measured(t:forecast_end,:);
    %el_AAC_0.uels=h.uels;
    
    %h used by ABC in the base case
    c_AbsC_0 = struct('name','c_AbsC_0','type','parameter','form','full','val',c_AbsC_0_full(t:forecast_end,:));
    c_AbsC_0.uels=h.uels;
    
    %forecasted Nordpool el price
    el_price = struct('name','el_price','type','parameter','form','full','val',el_price_full(t:forecast_end,:));
    el_price.uels=h.uels;
    
    %forecasted el certificate
    el_certificate = struct('name','el_certificate','type','parameter','form','full','val',el_certificate_full(t:forecast_end,:));
    el_certificate.uels=h.uels;
    
    %forecasted GE's heat price
    %h_price = struct('name','h_price','type','parameter','form','full','val',h_price_full(t:forecast_end,:));
    %h_price.uels=h.uels;
    
    %forecasted outdoor temperature
    tout = struct('name','tout','type','parameter','form','full','val',tout_full(t:forecast_end,:));
    tout.uels=h.uels;
    
    %P1P2 dispatchability
    P1P2_dispatchable = struct('name','P1P2_dispatchable','type','parameter','form','full','val',P1P2_dispatchable_full(t:forecast_end,:));
    P1P2_dispatchable.uels=h.uels;
    
    %Heat export season - Replaced by DH_heating_season -DS
    %DH_export_season = struct('name','DH_export_season','type','parameter','form','full','val',DH_export_season_full(t+sim_start-1:forecast_end+sim_start-1,:));
    %DH_export_season.uels=h.uels;
    
    %DH heating season
    DH_heating_season = struct('name','DH_heating_season','type','parameter','form','full','val',DH_heating_season_full(t+sim_start-1:forecast_end+sim_start-1,:));
    DH_heating_season.uels=h.uels;
    
    %DH heating season P2
    DH_heating_season_P2 = struct('name','DH_heating_season_P2','type','parameter','form','full','val',DH_heating_season_P2_full(t+sim_start-1:forecast_end+sim_start-1,:));
    DH_heating_season_P2.uels=h.uels;
    
    %BAC saving period
    BAC_savings_period = struct('name','BAC_savings_period','type','parameter','form','full','val',BAC_savings_period_full(t+sim_start-1:forecast_end+sim_start-1,:));
    BAC_savings_period.uels=h.uels;
    
    DC_cooling_season = struct('name','DC_cooling_season','type','parameter','form','full','val',DC_cooling_season_full(t+sim_start-1:forecast_end+sim_start-1,:));
    DC_cooling_season.uels = h.uels;
    
    no_imp_h_season = struct('name','no_imp_h_season','type','parameter','form','full','val',no_imp_h_season_full(t+sim_start-1:forecast_end+sim_start-1,:));
    no_imp_h_season.uels = h.uels;
    
    %Calculation of BAC savings factors
    BAC_savings_factor = fget_bac_savings_factor(h);
    BAC_savings_factor.uels=h.uels;
    %District heating network node transfer limits
    DH_Nodes_Transfer_Limits=fget_dh_transfer_limits(DH_Nodes, h, tout);
    
    %District cooling network node transfer limits
    DC_Nodes_Transfer_Limits = fget_dc_transfer_limits(DC_Nodes, h);
    
    %CO2 factors of the external el grid
    CO2F_El = struct('name','CO2F_El','type','parameter','form','full','val',CO2F_El_full(t:forecast_end,:));
    CO2F_El.uels=h.uels;
    
    %NRE factors of the external el grid
    %     NREF_El = struct('name','NREF_El','type','parameter','form','full','val',NREF_El_full(t:forecast_end,:));
    %     NREF_El.uels=h.uels;
    
    %PE factors of the external el grid
    PE_El = struct('name','PE_El','type','parameter','form','full','val',PE_El_full(t:forecast_end,:));
    PE_El.uels=h.uels;
    
    %CO2 factors of the external DH grid (AVERAGE AND MARGINAL) & marginal
    %DH cost
    marginalCost_DH = struct('name','marginalCost_DH','type','parameter','form','full','val',marginalCost_DH_full(t:forecast_end,:));
    marginalCost_DH.uels=h.uels;
    
    CO2F_DH = struct('name','CO2F_DH','type','parameter','form','full','val',CO2F_DH_full(t:forecast_end,:));
    CO2F_DH.uels=h.uels;
    
    %NRE factors of the external DH grid
    %     NREF_DH = struct('name','NREF_DH','type','parameter','form','full','val',NREF_DH_full(t:forecast_end,:));
    %     NREF_DH.uels=h.uels;
    
    %PE factors of the external DH grid
    PE_DH = struct('name','PE_DH','type','parameter','form','full','val',PE_DH_full(t:forecast_end,:));
    PE_DH.uels=h.uels;
    
    %el exG slack bus data
    el_exG_slack = struct('name','el_exG_slack','type','parameter','form','full','val',el_exG_slack_full(t:forecast_end,:));
    el_exG_slack.uels=h.uels;
    
    %District heating slack bus data
    h_DH_slack = struct('name','h_DH_slack','type','parameter','form','full','val',h_DH_slack_full(t:forecast_end,:));
    h_DH_slack.uels=h.uels;
    
    %District cooling slack bus data
    c_DC_slack = struct('name','c_DC_slack','type','parameter','form','full','val',c_DC_slack_full(t:forecast_end,:));
    c_DC_slack.uels=h.uels;
    
    if t==1
        % Set initial state of BAC Buildings to empty
        opt_fx_inv_BTES_BAC_D_init = struct('name','opt_fx_inv_BTES_BAC_D_init','type','parameter','form','full','val',zeros(1,length(BTES_BAC_BID_uels)));
        opt_fx_inv_BTES_BAC_S_init = struct('name','opt_fx_inv_BTES_BAC_S_init','type','parameter','form','full','val',zeros(1,length(BTES_BAC_BID_uels)));
        
        % Set initial state of SO Buildings to empty
        opt_fx_inv_BTES_SO_D_init = struct('name','opt_fx_inv_BTES_SO_D_init','type','parameter','form','full','val',zeros(1,length(BTES_SO_BID_uels)));
        opt_fx_inv_BTES_SO_S_init = struct('name','opt_fx_inv_BTES_SO_S_init','type','parameter','form','full','val',zeros(1,length(BTES_SO_BID_uels)));
        
        % Set inital state of PS Buildings
        % AK How to implement?
        %opt_fx_inv_BTES_PS_init = struct('name','opt_fx_inv_BTES_PS_init','type','parameter','form','full','val',zeros(1,length(BTES_PS_uels)));
        %opt_fx_inv_BTES_PS_init.uels = {num2cell(t), BTES_PS_uels};
        
        % Set initial SoC for Cold water basin and battery energy storage to be passed from Matlab to GAMS
        opt_fx_inv_CWB_init = struct('name','opt_fx_inv_CWB_init','type','parameter','form','full','val',0);
        opt_fx_inv_BES_init = struct('name','opt_fx_inv_BES_init','type','parameter','form','full','val',BES_min_SoC.val.*opt_fx_inv_BES_cap.val);
        %opt_fx_inv_BFCh_init = struct('name','opt_fx_inv_BFCh_init','type','parameter','form','full','val',ones(1,length(BFCh_BID_uels))*0.20*opt_fx_inv_BFCh_cap.val);
        Boiler1_prev_disp = struct('name','Boiler1_prev_disp','type','parameter','form','full','val',0);
        Boiler2_prev_disp = struct('name','Boiler2_prev_disp','type','parameter','form','full','val',0);
        
    else
        % The initial conditions for t-1 are read in from ReadGtoM.
        % Note only the .value fields of the rgdx GAMS structures are passed in here.
        [CWB_init, BTES_BAC_D_init, BTES_BAC_S_init, BTES_SO_S_init, BTES_SO_D_init, BES_init, Boiler1_init, Boiler2_init] = readGtoM(t-1, BTES_BAC_BID_uels, BTES_SO_BID_uels, BES_BID_uels);
        
        % Here the values are restructured to be written to GAMS. Note that
        % the BTES structures need to have uels to specify what buildings,
        % but that the others are simple non-indexed parameters(hence no
        % uels).
        opt_fx_inv_BTES_BAC_D_init = struct('name','opt_fx_inv_BTES_BAC_D_init','type','parameter','form','full','val',BTES_BAC_D_init);
        opt_fx_inv_BTES_BAC_S_init = struct('name','opt_fx_inv_BTES_BAC_S_init','type','parameter','form','full','val',BTES_BAC_S_init);
        opt_fx_inv_BTES_SO_D_init = struct('name','opt_fx_inv_BTES_SO_D_init','type','parameter','form','full','val',BTES_SO_D_init);
        opt_fx_inv_BTES_SO_S_init = struct('name','opt_fx_inv_BTES_SO_S_init','type','parameter','form','full','val',BTES_SO_S_init);
        
        % AK implement PS
        %opt_fx_inv_BTES_PS_init = struct('name','opt_fx_inv_BTES_PS_init','type','parameter','form','full','val',BTES_PS_init);
        %opt_fx_inv_BTES_PS_init.uels = {num2cell(t), BTES_PS_uels};
        
        opt_fx_inv_CWB_init = struct('name','opt_fx_inv_CWB_init','type','parameter','form','full','val',CWB_init);
        opt_fx_inv_BES_init = struct('name','opt_fx_inv_BES_init','type','parameter','form','full','val',BES_init);
        %opt_fx_inv_BFCh_init = struct('name','opt_fx_inv_BFCh_init','type','parameter','form','full','val',BFCh_init);
        Boiler1_prev_disp = struct('name','Boiler1_prev_disp','type','parameter','form','full','val',Boiler1_init);
        Boiler2_prev_disp = struct('name','Boiler2_prev_disp','type','parameter','form','full','val',Boiler2_init);
    end
    
    % Set uels for state of Charge (SoC) for BAC, BTES, BES, BFCh, and CWB
    opt_fx_inv_BTES_BAC_D_init.uels = {num2cell(t), BTES_BAC_BID_uels};
    opt_fx_inv_BTES_BAC_S_init.uels = {num2cell(t), BTES_BAC_BID_uels};
    opt_fx_inv_BTES_SO_D_init.uels = {num2cell(t), BTES_SO_BID_uels};
    opt_fx_inv_BTES_SO_S_init.uels = {num2cell(t), BTES_SO_BID_uels};
    opt_fx_inv_BES_init.uels = {num2cell(t), BES_BID_uels};
    opt_fx_inv_CWB_init.uels = {num2cell(t), CWB_BID_uels};
    
    %opt_fx_inv_BFCh_init.uels = {num2cell(t), BFCh_BID_uels};
    
    %% Preparing input GDX file (MtoG) and RUN GAMS model
    wgdx('MtoG.gdx', min_totCost_0, min_totCost, min_totPE, min_totCO2, synth_baseline,...
        opt_fx_inv, opt_fx_inv_RMMC, opt_fx_inv_AbsCInv_cap, opt_fx_inv_PV,...
        opt_fx_inv_Boiler2, opt_fx_inv_TURB, opt_fx_inv_HP_cap, opt_fx_inv_HP_min,...
        opt_fx_inv_RMInv_cap, opt_fx_inv_TES_cap, opt_fx_inv_BES,...
        opt_fx_inv_CWB, opt_fx_inv_CWB_cap, opt_fx_inv_CWB_ch_max, opt_fx_inv_CWB_dis_max,...
        opt_fx_inv_BES_cap, opt_fx_inv_BES_maxP, opt_fx_inv_SO, opt_fx_inv_BAC,...
        h, BTES_BAC_Inv, BTES_SO_Inv,...
        CO2F_El, PE_El, CO2F_DH, PE_DH, marginalCost_DH, CO2F_PV, PE_PV,...
        CO2F_Boiler1, PE_Boiler1, CO2F_Boiler2, PE_Boiler2,...
        BID, BID_AH_el, BID_nonAH_el, BID_AH_h, BID_nonAH_h, BID_AH_c, BID_nonAH_c, BID_nonBTES,...
        el_demand, h_demand, c_demand, h_Boiler1_0, h_FlueGasCondenser1_0,...
        el_VKA1_0, el_VKA4_0, c_AbsC_0, G_roof, G_facade,...
        BES_min_SoC, BTES_properties, BTES_model, P1P2_dispatchable, DH_heating_season, DH_heating_season_P2, DC_cooling_season, no_imp_h_season, BAC_savings_period,...
        PVID, PVID_roof, PV_roof_cap, PVID_facade, PV_facade_cap,...
        el_price, el_certificate, tout, BAC_savings_factor, FED_Inv_lim, BusID,...
        opt_fx_inv_BTES_BAC_D_init, opt_fx_inv_BTES_BAC_S_init, opt_fx_inv_BTES_SO_D_init,...
        opt_fx_inv_BTES_SO_S_init, BTES_SO_max_power,...
        opt_fx_inv_BES_init, Boiler1_prev_disp, Boiler2_prev_disp, opt_fx_inv_CWB_init,...
        DH_Node_ID, DH_Nodes_Transfer_Limits, DC_Node_ID, DC_Nodes_Transfer_Limits,...
        el_exG_slack, h_DH_slack, c_DC_slack, h_exp_AH_hist, h_imp_AH_hist);
    
    if opt_RunGAMSModel==1
        system 'gams FED_SIMULATOR_MAIN lo=2';
    end
    %% Store the results from each iteration
    Results(t).dispatch = fstore_results(h,BID,BTES_properties,BusID);
    
    [to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2] = fstore_results_excel(Results,to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2, sim_start, sim_stop, t);
end
%delete  'Input_dispatch_model\result_temp.xlsx';
copyfile('Input_dispatch_model\result_temp_bkup.xlsx', 'result_temp.xlsx'); % to create an output file template with the correct header row

xlswrite('result_temp.xlsx',to_excel_el,'Electricity','A3');
xlswrite('result_temp.xlsx',to_excel_heat,'Heat','A3');
xlswrite('result_temp.xlsx',to_excel_cool,'Cooling','A3');
xlswrite('result_temp.xlsx',to_excel_co2,'CO2_PE','A3');
end
