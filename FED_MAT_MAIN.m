%% Initialize the simulator

tic        %simulation start time counter
clc;       %clear texts in command window
clear;     %clear data in workspace
close all; %close all figures

%% LOAD MAIN INPUT DATA IN GAMS MAINLY FROM MEASUREMENT

RE_LOAD_INPUT=1;
demand_range='B2:AJ100';
gen_range='B4:B102';
price_ramge='B2:B100';
tout_ramge='B2:B100';
irradiance_range='B2:AJ100';
irradiance_area_range='A2:AI2';
BITES_par_range='B2:AJ10';
%P1P2 dispatchability, DH export period and BAC saving period need to be
%re-formulated
while RE_LOAD_INPUT==1
    %Measured electricity demand in kW
    sheet=1;
    xlRange = demand_range;
    e_demand_measured=xlsread('Input_dispatch_model\measured_demand.xlsx',sheet,xlRange);
    e_demand_measured(isnan(e_demand_measured))=0;
    
    %Measured heat demand in kW
    sheet=2;
    xlRange = demand_range;
    h_demand_measured=xlsread('Input_dispatch_model\measured_demand.xlsx',sheet,xlRange);
    h_demand_measured(isnan(h_demand_measured))=0;
    
    %Measured cooling demand in kW
    sheet=3;
    xlRange = demand_range;
    c_demand_measured=xlsread('Input_dispatch_model\measured_demand.xlsx',sheet,xlRange);
    c_demand_measured(isnan(c_demand_measured))=0;
    
    %Measured HEAT GENERATION FROM THERMAL BOILER (B1)
    sheet=3;
    xlRange = gen_range;
    h_B1_measured=xlsread('Input_dispatch_model\Panna1 2016-2017.xls',sheet,xlRange);
    h_B1_measured(isnan(h_B1_measured))=0;
    
    %Measured HEAT GENERATION FROM FLUE GAS CONDENCER (F1)
    sheet=4;
    xlRange = gen_range;
    h_F1_measured=xlsread('Input_dispatch_model\Panna1 2016-2017.xls',sheet,xlRange);
    h_F1_measured(isnan(h_F1_measured))=0;
    
    %Measured el price in NordPool in SEK/kWh
    sheet=2;
    xlRange = price_ramge;
    e_price_measured=xlsread('Input_dispatch_model\measured_el_price.xlsx',sheet,xlRange);
    e_price_measured(isnan(e_price_measured))=0;
    
    %Measured el cirtificate in SEK/kWh
    sheet=2;
    xlRange = price_ramge;
    el_cirtificate=xlsread('Input_dispatch_model\el_cirtificate.xlsx',sheet,xlRange);
    el_cirtificate(isnan(el_cirtificate))=0;
    
    %Measured heat price in GE's system in SEK/kWh
    sheet=2;
    xlRange = price_ramge;
    h_price_measured=xlsread('Input_dispatch_model\measured_h_price.xlsx',sheet,xlRange);
    h_price_measured(isnan(h_price_measured))=0;
    
    %Measured outdoor temprature
    sheet=2;
    xlRange = tout_ramge;
    tout_measured=xlsread('Input_dispatch_model\measured_tout.xlsx',sheet,xlRange);
    tout_measured(isnan(tout_measured))=0;
    
    %Measured solar irradiamce**************TO BE FIXED
    sheet=1;
    xlRange = irradiance_range;
    irradiance_measured=xlsread('Input_dispatch_model\measured_irradiance.xlsx',sheet,xlRange);
    irradiance_measured(isnan(irradiance_measured))=0;
    
    %Solar PV area***************************TO BE FIXED
    sheet=2;
    xlRange = irradiance_area_range;
    area=xlsread('Input_dispatch_model\measured_irradiance.xlsx',sheet,xlRange);
    area(isnan(area))=0;
    
    %BTES parameters
    sheet=2;
    xlRange = BITES_par_range;
    BTES_param=xlsread('Input_dispatch_model\UFO_TES.xlsx',sheet,xlRange);
    BTES_param(isnan(BTES_param))=0;
    
    %P1P2 dispatchability***********This could be replaced with a code****
    sheet=1;
    xlRange = 'C2:C100';
    P1P2_disp=xlsread('Input_dispatch_model\P1P2_dispatchable.xlsx',sheet,xlRange);
    P1P2_disp(isnan(P1P2_disp))=0;
    
    %DH export season
    sheet=1;
    xlRange = 'C2:C100';
    DH_exp_season=xlsread('Input_dispatch_model\DH_export_season.xlsx',sheet,xlRange);
    
    %BAC_savings_period
    sheet=1;
    xlRange = 'C2:C100';
    BAC_sav_period=xlsread('Input_dispatch_model\BAC_parameters.xlsx',sheet,xlRange);
    
    %system 'gams FED_GENERATE_GDX_FILE lo=3';
    break;
end

%% FXED INVESTMENT OPTIONS
%Option to set if any investments are to be fixed
opt_fx_inv=1;
temp_opt_fx_inv = struct('name','opt_fx_inv','type','parameter','form','full','val',opt_fx_inv);

%Option for RMMC investment
opt_fx_inv_RMMC=1;  %Set to 1 if the investment in MC2 cooling connection is made
temp_opt_fx_inv_RMMC = struct('name','opt_fx_inv_RMMC','type','parameter','form','full','val',opt_fx_inv_RMMC);

%Option for new AbsChiller investment
opt_fx_inv_AbsCInv=1;
temp_opt_fx_inv_AbsCInv = struct('name','opt_fx_inv_AbsCInv','type','parameter','form','full','val',opt_fx_inv_AbsCInv);
opt_fx_inv_AbsCInv_cap=0;
temp_opt_fx_inv_AbsCInv_cap = struct('name','opt_fx_inv_AbsCInv_cap','type','parameter','form','full','val',opt_fx_inv_AbsCInv_cap);

%Option for P2 investment
opt_fx_inv_P2=1;
temp_opt_fx_inv_P2 = struct('name','opt_fx_inv_P2','type','parameter','form','full','val',opt_fx_inv_P2);

%Option for Turbine investment
opt_fx_inv_TURB=1;
temp_opt_fx_inv_TURB = struct('name','opt_fx_inv_TURB','type','parameter','form','full','val',opt_fx_inv_TURB);

%Option for new HP investment
opt_fx_inv_HP=1;
temp_opt_fx_inv_HP = struct('name','opt_fx_inv_HP','type','parameter','form','full','val',opt_fx_inv_HP);
opt_fx_inv_HP_cap=800;
temp_opt_fx_inv_HP_cap = struct('name','opt_fx_inv_HP_cap','type','parameter','form','full','val',opt_fx_inv_HP_cap);

%Option for new HP investment
opt_fx_inv_RMInv=1;
temp_opt_fx_inv_RMInv = struct('name','opt_fx_inv_RMInv','type','parameter','form','full','val',opt_fx_inv_RMInv);
opt_fx_inv_RMInv_cap=0;
temp_opt_fx_inv_RMInv_cap = struct('name','opt_fx_inv_RMInv_cap','type','parameter','form','full','val',opt_fx_inv_RMInv_cap);

%Option for TES investment
opt_fx_inv_TES=1;
temp_opt_fx_inv_TES = struct('name','opt_fx_inv_TES','type','parameter','form','full','val',opt_fx_inv_TES);
opt_fx_inv_TES_cap=0;
temp_opt_fx_inv_TES_cap = struct('name','opt_fx_inv_TES_cap','type','parameter','form','full','val',opt_fx_inv_TES_cap);

%Option for BES investment
opt_fx_inv_BES=1;
temp_opt_fx_inv_BES = struct('name','opt_fx_inv_BES','type','parameter','form','full','val',opt_fx_inv_BES);
opt_fx_inv_BES_cap=200;
temp_opt_fx_inv_BES_cap = struct('name','opt_fx_inv_BES_cap','type','parameter','form','full','val',opt_fx_inv_BES_cap);

%Option for BTES investment
BITES_Inv.name='BITES_Inv';
BITES_Inv.uels={'Bibliotek','NyaMatte','Elkraftteknik','VOV1', 'Arkitektur', 'VOV2'};

%Option for BAC investment
BAC_Inv.name='BAC_Inv';
BAC_Inv.uels={'Bibliotek','NyaMatte','Elkraftteknik','VOV1', 'Arkitektur', 'VOV2'};

%Option for solar PV investment

%% INPUT PE and CO2 FACTORS and Dispatch of local generating units

%CO2 and PE facrors of local generation unists
CO2F_PV=22; %45
temp_CO2F_PV = struct('name','CO2F_PV','type','parameter','val',CO2F_PV);
PEF_PV=0.25;
temp_PEF_PV = struct('name','PEF_PV','type','parameter','val',PEF_PV);

CO2F_P1=12;
temp_CO2F_P1 = struct('name','CO2F_P1','type','parameter','val',CO2F_P1);
PEF_P1=1.33;
temp_PEF_P1 = struct('name','PEF_P1','type','parameter','val',PEF_P1);

CO2F_P2=12;
temp_CO2F_P2 = struct('name','CO2F_P2','type','parameter','val',CO2F_P2);
PEF_P2=1.33;
temp_PEF_P2 = struct('name','PEF_P2','type','parameter','val',PEF_P2);

CO2F_spillvarme=0;       %98
PEF_spillvarme=0.03;     %0.03

COP_AbsC=0.5;
COP_AAC=10;

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH
P1_eff=0.9;          %assumed efficiency of Panna1
P1_eff_temp = struct('name','P1_eff','type','parameter','form','full','val',P1_eff);


pCO2ref=5;    %Choose the percentage the reference CO2 to determine reference CO2 that defined the peal hours
              %[this value can be changed depending on how the CO2 peak is defined]
              
% calculate new values
NEW_data=0;

while NEW_data==1
    get_CO2PE_FED;   %this routine calculates the CO2 and PE factors of the external grid also    
    save('el_exGCO2F','el_exGCO2F');
    save('el_exGPEF','el_exGPEF');
    save('DH_CO2F','DH_CO2F');
    save('DH_PEF','DH_PEF');
        
    FED_CO20=load('Sim_Results\Sim_Results_base\Data\FED_CO2');
    FED_CO20=FED_CO20.FED_CO2;
    FED_PE0=load('Sim_Results\Sim_Results_base\Data\FED_PE');
    FED_PE0=FED_PE0.FED_PE;
    break;
end

%load saved values
while NEW_data==0
    FED_CO20=load('Sim_Results\Sim_Results_base\Data\FED_CO2');
    FED_CO20=FED_CO20.FED_CO2;
    FED_PE0=load('Sim_Results\Sim_Results_base\Data\FED_PE');
    FED_PE0=FED_PE0.FED_PE;

    load el_exGCO2F;
    load el_exGPEF;
    load DH_CO2F;
    load DH_PEF;
    break;
end

%% FED INVESTMENT LIMIT

FED_inv = 68570065;%68570065; %76761000;  %this is projected FED investment cost in SEK
FED_Inv_lim = struct('name','inv_lim','type','parameter','val',FED_inv);

%% SIMULATION OPTIONS

%SIMULATION START AND STOP TIME
%start=1442;
%stop=10202;
forcast_horizon=10;
forcast_start=1;
forcast_end=forcast_start+forcast_horizon-1;
h_sim.name='h';
h_sim.uels=num2cell(forcast_start:forcast_end);

% optimization option
option1=1;    %minimize total cost
option2=0;    %minimize tottal PE use
option3=0;    %minimize total CO2 emission

temp_optn1 = struct('name','min_totCost','type','parameter','form','full','val',option1);
temp_optn2 = struct('name','min_totPE','type','parameter','form','full','val',option2);
temp_optn3 = struct('name','min_totCO2','type','parameter','form','full','val',option3);

%% Building ID's
%Building IDs
B_ID.name='B_ID';
% B_ID.uels={'O3060132', 'O3060101', 'O3060102_3', 'Vassa4-15', 'O0007043','O0007017',...
%            'SSPA', 'O0007006', 'Studentbostader', 'O0007008','O0007888',...
%            'Karhus_CFAB', 'O0007019', 'O0007040', 'O0007014',...
%            'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
%            'O3060133', 'O0007024', 'O0007005', 'O0013001','O0011001',...
%            'O0007018', 'O3060137', 'Karhuset', 'O3060138','O0007023', 'O0007026', 'O0007027',...
%            'Karhus_studenter', 'Chabo'}; 

B_ID.uels={'Kemi', 'Vassa1', 'Vassa2-3', 'Vassa4-15', 'Phus','Bibliotek',...
           'SSPA', 'NyaMatte', 'Studentbostader', 'Kraftcentral','Lokalkontor',...
           'Karhus_CFAB', 'CAdministration', 'GamlaMatte', 'Gibraltar_herrgard',...
           'HA', 'HB', 'Elkraftteknik', 'HC', 'Maskinteknik','Fysik_Origo',...
           'MC2', 'Edit', 'Polymerteknologi', 'Keramforskning','Fysik_Soliden',...
           'Idelara', 'CTP', 'Karhuset', 'JSP','VOV1', 'Arkitektur', 'VOV2',...
           'Karhus_studenter', 'Chabo'}; 

B_ID_AH_el.name='i_AH_el';
B_ID_AH_el.uels={'Kemi', 'Phus, Bibliotek',...
                 'NyaMatte', 'Studentbostader', 'Kraftcentral', 'Lokalkontor',...
                 'Karhus_CFAB', 'CAdministration', 'GamlaMatte', 'Gibraltar_herrgard',...
                 'HA', 'HB', 'Elkraftteknik', 'HC', 'Maskinteknik', 'Fysik_Origo',...
                 'MC2', 'Edit', 'Polymerteknologi', 'Keramforskning', 'Fysik_Soliden',...
                 'Idelara', 'VOV1', 'Arkitektur', 'VOV2',...
                 'Karhus_studenter'};
 
B_ID_nonAH_el.name='i_nonAH_el'; 
B_ID_nonAH_el.uels={'Vassa1', 'Vassa2-3', 'Vassa4-15',...
                    'SSPA',...
                    'CTP', 'Karhuset', 'JSP',...
                    'Chabo'};

B_ID_AH_h.name='i_AH_h';
B_ID_AH_h.uels={'Kemi', 'Phus,Bibliotek',...
                'SSPA', 'NyaMatte', 'Studentbostader', 'Kraftcentral','Lokalkontor',...
                'Karhus_CFAB', 'CAdministration', 'GamlaMatte',...
                'HA', 'HB', 'Elkraftteknik', 'HC', 'Maskinteknik','Fysik_Origo',...
                'MC2', 'Edit', 'Polymerteknologi', 'Keramforskning','Fysik_Soliden',...
                'Idelara','VOV1', 'Arkitektur', 'VOV2',...
                'Karhus_studenter'};

B_ID_nonAH_h.name='i_nonAH_h';
B_ID_nonAH_h.uels={'Vassa1', 'Vassa2-3', 'Vassa4-15',...
                   'Gibraltar_herrgard',...
                   'CTP', 'Karhuset', 'JSP',...
                   'Chabo'};

B_ID_AH_c.name='i_AH_c';
B_ID_AH_c.uels={'Kemi', 'Phus','Bibliotek',...
                'NyaMatte', 'Kraftcentral','Lokalkontor',...
                'Karhus_CFAB', 'CAdministration',...
                'HA', 'HB', 'Elkraftteknik', 'HC', 'Maskinteknik','Fysik_Origo',...
                'MC2', 'Edit', 'Keramforskning','Fysik_Soliden',...
                'Idelara','VOV1', 'Arkitektur', 'VOV2',...
                'Karhus_studenter'};
          
B_ID_nonAH_c.name='i_nonAH_c';
B_ID_nonAH_c.uels={'Vassa1', 'Vassa2-3', 'Vassa4-15',...
                   'SSPA','Studentbostader',...
                   'GamlaMatte', 'Gibraltar_herrgard',...
                   'Polymerteknologi',...
                   'CTP', 'Karhuset', 'JSP',...
                   'Chabo'};
  
B_ID_nonBITES.name='i_nonBITES';
B_ID_nonBITES.uels={'Phus',...
                    'SSPA', 'Studentbostader', 'Karhus_CFAB',...
                    'Gibraltar_herrgard',...
                    'Polymerteknologi',...
                    'Idelara','CTP', 'Karhuset', 'JSP',...
                    'Karhus_studenter'};
%% INPUT DATA TO THE DISPATCH MODEL


%Define the forcast function here, here forcast is assumed to be the same
%as measurment

%Forcasted el demand
e_demand_forcast=e_demand_measured(forcast_start:forcast_end,:);
e_demand = struct('name','el_demand','type','parameter','form','full','val',e_demand_forcast);
e_demand.uels={h_sim.uels,B_ID.uels};

%Forcasted heat demand
h_demand_forcast=h_demand_measured(forcast_start:forcast_end,:);
h_demand = struct('name','h_demand','type','parameter','form','full','val',h_demand_forcast);
h_demand.uels={h_sim.uels,B_ID.uels};

%Forcasted cooling demand
c_demand_forcast=c_demand_measured(forcast_start:forcast_end,:);
c_demand = struct('name','c_demand','type','parameter','form','full','val',c_demand_forcast);
c_demand.uels={h_sim.uels,B_ID.uels};

%Heat generaion from boiler 1 in the base case
h_B1_forcast=h_B1_measured(forcast_start:forcast_end,:);
qB1 = struct('name','qB1','type','parameter','form','full','val',h_B1_forcast);
qB1.uels=h_sim.uels;

%Heat generaion from the Flue gas condencer in the base case
h_F1_forcast=h_F1_measured(forcast_start:forcast_end,:);
qF1 = struct('name','qF1','type','parameter','form','full','val',h_F1_forcast);
qF1.uels=h_sim.uels;

%Forcasted Nprdpool el price
el_price_forcast=e_price_measured(forcast_start:forcast_end,:);
el_price = struct('name','el_price','type','parameter','form','full','val',el_price_forcast);
el_price.uels=h_sim.uels;

%Forcasted el cirtificate
el_cirtificate_forcast=el_cirtificate(forcast_start:forcast_end,:);
el_cirtificate = struct('name','el_cirtificate','type','parameter','form','full','val',el_cirtificate_forcast);
el_cirtificate.uels=h_sim.uels;

%Forcasted GE's heat price
h_price_forcast=h_price_measured(forcast_start:forcast_end,:);
h_price = struct('name','h_price','type','parameter','form','full','val',h_price_forcast);
h_price.uels=h_sim.uels;

%Forcasted outdoor temprature
tout_forcast=tout_measured(forcast_start:forcast_end,:);
tout = struct('name','tout','type','parameter','form','full','val',tout_forcast);
tout.uels=h_sim.uels;

%Building termal energy storage properties
BTES_properties.name='BTES_properties';
BTES_properties.uels={'BTES_Scap', 'BTES_Dcap', 'BTES_Esig', 'BTES_Sch_hc',...
                      'BTES_Sdis_hc', 'kloss_Sday', 'kloss_Snight', 'kloss_D', 'K_BS_BD'};

%BITES model
BTES_model = struct('name','BTES_model','type','parameter','form','full','val',BTES_param);
BTES_model.uels={BTES_properties.uels,B_ID.uels};

%P1P2 dispatchability
P1P2_dispatchable_temp=P1P2_disp(forcast_start:forcast_end,:);
P1P2_dispatchable = struct('name','P1P2_dispatchable','type','parameter','form','full','val',P1P2_dispatchable_temp);
P1P2_dispatchable.uels=h_sim.uels;

%Heat export season
DH_exp_season_temp=DH_exp_season(forcast_start:forcast_end,:);
DH_export_season = struct('name','DH_export_season','type','parameter','form','full','val',DH_exp_season_temp);
DH_export_season.uels=h_sim.uels;

%BAC saving period
BAC_sav_period_temp=BAC_sav_period(forcast_start:forcast_end,:);
BAC_savings_period = struct('name','BAC_savings_period','type','parameter','form','full','val',BAC_sav_period_temp);
BAC_savings_period.uels=h_sim.uels;

FED_CO20=FED_CO20(forcast_start:forcast_end);
FED_PE0=FED_PE0(forcast_start:forcast_end);
el_exGCO2F=el_exGCO2F(forcast_start:forcast_end);
el_exGPEF=el_exGPEF(forcast_start:forcast_end);
DH_CO2F=DH_CO2F(forcast_start:forcast_end);
DH_PEF=DH_PEF(forcast_start:forcast_end);

data=sort(FED_CO20,'descend'); 
duration= 0 : 100/(length(FED_CO20)-1) : 100;
x=find(duration<=5);
CO2ref=data(length(x)); %CO2 reference
FED_CO2_max = struct('name','CO2_max','type','parameter','val',max(FED_CO20));
FED_CO2_peakref = struct('name','CO2_peak_ref','type','parameter','val',CO2ref);
FED_PE_totref = struct('name','PE_tot_ref','type','parameter','val',sum(FED_PE0));
CO2F_exG = struct('name','CO2F_exG','type','parameter','form','full','val',el_exGCO2F);
CO2F_exG.uels=h_sim.uels;
PEF_exG = struct('name','PEF_exG','type','parameter','form','full','val',el_exGPEF);
PEF_exG.uels=h_sim.uels;
CO2F_DH = struct('name','CO2F_DH','type','parameter','form','full','val',DH_CO2F);
CO2F_DH.uels=h_sim.uels;
PEF_DH = struct('name','PEF_DH','type','parameter','form','full','val',DH_PEF);
PEF_DH.uels=h_sim.uels;

%% RUN GAMS model

wgdx('MtoG.gdx', temp_opt_fx_inv,temp_opt_fx_inv_RMMC,temp_opt_fx_inv_AbsCInv,temp_opt_fx_inv_AbsCInv_cap, temp_opt_fx_inv_P2,temp_opt_fx_inv_TURB,temp_opt_fx_inv_HP, temp_opt_fx_inv_HP_cap,...
     temp_opt_fx_inv_RMInv, temp_opt_fx_inv_RMInv_cap,temp_opt_fx_inv_TES, temp_opt_fx_inv_TES_cap, temp_opt_fx_inv_BES, temp_opt_fx_inv_BES_cap, h_sim,BITES_Inv,BAC_Inv,...
     FED_PE_totref, FED_CO2_max, FED_CO2_peakref,CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,...
     temp_CO2F_PV, temp_PEF_PV, temp_CO2F_P1, temp_PEF_P1, temp_CO2F_P2, temp_PEF_P2,...
     B_ID,B_ID_AH_el,B_ID_nonAH_el,B_ID_AH_h,B_ID_nonAH_h,B_ID_AH_c,B_ID_nonAH_c,B_ID_nonBITES,...
     e_demand,h_demand,c_demand,qB1,qF1,el_price,el_cirtificate,h_price,tout,...
     BTES_properties,BTES_model,P1P2_dispatchable,DH_export_season,BAC_savings_period,...
     temp_optn1, temp_optn2, temp_optn3, FED_Inv_lim);

 RUN_GAMS_MODEL = 1;
 while RUN_GAMS_MODEL==1
     system 'gams FED_SIMULATOR_MAIN lo=3';
     break;
 end
 %% Post processing results 
 
 %use the 'plot_results.m' script to plot desired results
%%

toc