%% Initialize the simulator
clc;       %clear texts in command window
%clear;     %clear data in workspace
close all; %close all figures

%% Assigning buildings ID to the buildings in the FED system

%Building IDs
profile on
tic

%Building IDs used to identify buildings in the FED system
B_ID.name='B_ID';
% B_ID.uels={'O3060132=Kemi', 'O3060101=Vassa1', 'O3060102_3=Vassa2-3', 'Vassa4-15=O3060104_15', 'O0007043=Phus','O0007017=Bibliotek',...
%            'SSPA', 'O0007006=NyaMatte', 'Studentbostader', 'O0007008=Kraftcentral','O0007888=Lokalkontor',...
%            'Karhus_CFAB', 'O0007019=CAdministration', 'O0007040=GamlaMatte', 'O0007014=Gibraltar_herrgard',...
%            'O0007022=HA', 'O0007025=HB', 'O0007012=Elkraftteknik', 'O0007021=HC', 'O0007028=Maskinteknik','O0007001=Fysik_Origo',...
%            'O3060133=MC2', 'O0007024=Edit', 'O0007005=Polymerteknologi', 'O0013001=Keramforskning','O0011001=Fysik_Soliden',...
%            'O0007018=Idelara', 'O3060137=CTP', 'Karhuset', 'O3060138=JSP','O0007023=VOV1', 'O0007026=Arkitektur', 'O0007027=VOV2',...
%            'Karhus_studenter', 'Chabo'};
B_ID.uels={'O3060132', 'O3060101', 'O3060102_3', 'O3060104_15', 'O0007043','O0007017',...
           'SSPA', 'O0007006', 'Studentbostader', 'O0007008','O0007888',...
           'Karhus_CFAB', 'O0007019', 'O0007040', 'O0007014',...
           'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
           'O3060133', 'O0007024', 'O0007005', 'O0013001','O0011001',...
           'O0007018', 'O3060137', 'Karhuset', 'O3060138','O0007023', 'O0007026', 'O0007027',...
           'Karhus_studenter', 'Chabo','ITGYMNASIET'}; 

%Subset of the buildings in the FED system connected to AH's(Akadamiska Hus) electrical distribution system       
B_ID_AH_el.name='i_AH_el';
B_ID_AH_el.uels={'O3060132', 'O0007043', 'O0007017',...
                 'O0007006', 'Studentbostader', 'O0007008', 'O0007888',...
                 'Karhus_CFAB', 'O0007019', 'O0007040', 'O0007014',...
                 'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028', 'O0007001',...
                 'O3060133', 'O0007024', 'O0007005', 'O0013001', 'O0011001',...
                 'O0007018', 'O0007023', 'O0007026', 'O0007027',...
                 'Karhus_studenter'};

%Subset of the buildings in the FED system not connected AH's el distribution system; hence the el demnds of these buldings are supplied from GE's external grid          
B_ID_nonAH_el.name='i_nonAH_el'; 
B_ID_nonAH_el.uels={'O3060101', 'O3060102_3', 'O3060104_15',...
                    'SSPA',...
                    'O3060137', 'Karhuset', 'O3060138',...
                    'Chabo'};

%Subset of the buildings in the FED system which are connected to AH's local heat distribution network                
B_ID_AH_h.name='i_AH_h';
B_ID_AH_h.uels={'O3060132', 'O0007043','O0007017',...
                'SSPA', 'O0007006', 'Studentbostader', 'O0007008','O0007888',...
                'Karhus_CFAB', 'O0007019', 'O0007040',...
                'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
                'O3060133', 'O0007024', 'O0007005', 'O0013001','O0011001',...
                'O0007018','O0007023', 'O0007026', 'O0007027',...
                'Karhus_studenter'};
            
%Subset of buildings in the FED system not connected to AH's local heat distribution network, buildings heat demand is hence supplied from GE's external DH system 
B_ID_nonAH_h.name='i_nonAH_h';
B_ID_nonAH_h.uels={'O3060101', 'O3060102_3', 'O3060104_15',...
                   'O0007014',...
                   'O3060137', 'Karhuset', 'O3060138',...
                   'Chabo'};

%Subset of buildings in the FED system connected to AH's local cooling distribution network               
B_ID_AH_c.name='i_AH_c';
B_ID_AH_c.uels={'O3060132', 'O0007043','O0007017',...
                'O0007006', 'O0007008','O0007888',...
                'Karhus_CFAB', 'O0007019',...
                'O0007022', 'O0007025', 'O0007012', 'O0007021', 'O0007028','O0007001',...
                'O3060133', 'O0007024', 'O0013001','O0011001',...
                'O0007018','O0007023', 'O0007026', 'O0007027',...
                'Karhus_studenter'};
            
%Subset of buildings in the FED system not connected to AH's local cooling distribution network; buildings cooling demand is hence supplied from local cooling generation          
B_ID_nonAH_c.name='i_nonAH_c';
B_ID_nonAH_c.uels={'O3060101', 'O3060102_3', 'O3060104_15',...
                   'SSPA','Studentbostader',...
                   'O0007040', 'O0007014',...
                   'O0007005',...
                   'O3060137', 'Karhuset', 'O3060138',...
                   'Chabo'};
               
%Subset of buildings in the FED system which are not considered for for thermal energy storage  
B_ID_nonBITES.name='i_nonBITES';
B_ID_nonBITES.uels={'O0007043',...
                    'SSPA', 'Studentbostader', 'Karhus_CFAB',...
                    'O0007014',...
                    'O0007005',...
                    'O0007018','O3060137', 'Karhuset', 'O3060138',...
                    'Karhus_studenter'};                
                
%% IDs used to name the buses or nodes in the local electrical distribution system                
%OBS: proper maping need to be established between the nodes in the el distribution system and the building IDs 

Buses_IDs.name='Bus_IDs';
Buses_IDs.uels={'1','2','3','4','5','6','7','8',...
              '9','10','11','12','13','14',...
              '15','16','17','18','19','20','21','22','23','24',...
               '25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41'};

%% *****IDs for solar irradiance data *****TO BE MOdified*****
%OBS: These IDs, which represent where the solar PVs are located, need to be mapped to Building IDs and/or the electrical
%nodes in the local el distribution system

BID.name='BID';
BID_temp=1:70;
BID_temp(71)=75;
BID_temp(72)=76;
BID.uels=num2cell(BID_temp);

%% ********FIXED MODEL INPUT DATA and variable input data************

%P1P2 dispatchability, DH export period and BAC saving period need to be
%re-formulated
%P1P2 dispatchability***********This could be replaced with a code****
sheet=1;
xlRange = 'C2:C17545';
P1P2_disp=xlsread('Input_dispatch_model\P1P2_dispatchable.xlsx',sheet,xlRange);
P1P2_disp(isnan(P1P2_disp))=0;
    
%DH export season
sheet=1;
xlRange = 'C2:C17545';
DH_exp_season=xlsread('Input_dispatch_model\DH_export_season.xlsx',sheet,xlRange);
    
%BAC_savings_period
sheet=1;
xlRange = 'C2:C17545';
BAC_sav_period=xlsread('Input_dispatch_model\BAC_parameters.xlsx',sheet,xlRange);

%Read static properties of the model
[ pv_area_roof,pv_area_facades, BTES_param ] = fread_static_properties();

%Read forecasted values and variable input data
[e_demand_measured, h_demand_measured,c_demand_measured,...
 h_B1_measured,h_F1_measured,e_price_measured,...
 el_cirtificate_m,h_price_measured,tout_measured,...
 irradiance_measured_roof,irradiance_measured_facades] = fread_measurments(2, 17000);
 
% This must be deleted
export1=xlsread('Input_data_FED_SIMULATOR\AH_h_import_exp.xlsx',2,'D5:D11100')*1000;
import1=xlsread('Input_data_FED_SIMULATOR\AH_h_import_exp.xlsx',2,'C5:C11100')*1000;
Panna1_forecast=load('Panna1_forecast');
Panna1_forecast=abs((Panna1_forecast.Panna1_forecast')*1000);
FGC_forecast=load('FGC_forecast');
FGC_forecast=abs((FGC_forecast.FGC_forecasting'));
%% FIXED MODEL INPUT DATA - FXED INVESTMENT OPTIONS

%Option to choose between marginal and average factors
opt_marg_factors=0;
temp_opt_marg_factors = struct('name','opt_marg_factors','type','parameter','form','full','val',opt_marg_factors);

%Option to set if any investments are to be fixed
opt_fx_inv=1;
temp_opt_fx_inv = struct('name','opt_fx_inv','type','parameter','form','full','val',opt_fx_inv);

%Option for RMMC investment
opt_fx_inv_RMMC=0;  %Set to 1 if the investment in MC2 cooling connection is made
temp_opt_fx_inv_RMMC = struct('name','opt_fx_inv_RMMC','type','parameter','form','full','val',opt_fx_inv_RMMC);

%Option for new AbsChiller investment
opt_fx_inv_AbsCInv=1;
temp_opt_fx_inv_AbsCInv = struct('name','opt_fx_inv_AbsCInv','type','parameter','form','full','val',opt_fx_inv_AbsCInv);
opt_fx_inv_AbsCInv_cap=0;
temp_opt_fx_inv_AbsCInv_cap = struct('name','opt_fx_inv_AbsCInv_cap','type','parameter','form','full','val',opt_fx_inv_AbsCInv_cap);

%Option for P2 investment
opt_fx_inv_P2=0;
temp_opt_fx_inv_P2 = struct('name','opt_fx_inv_P2','type','parameter','form','full','val',opt_fx_inv_P2);

%Option for Turbine investment
opt_fx_inv_TURB=0;
temp_opt_fx_inv_TURB = struct('name','opt_fx_inv_TURB','type','parameter','form','full','val',opt_fx_inv_TURB);

%Option for new HP investment
opt_fx_inv_HP=1;
temp_opt_fx_inv_HP = struct('name','opt_fx_inv_HP','type','parameter','form','full','val',opt_fx_inv_HP);
opt_fx_inv_HP_cap=0;
temp_opt_fx_inv_HP_cap = struct('name','opt_fx_inv_HP_cap','type','parameter','form','full','val',opt_fx_inv_HP_cap);

%Option for new RM investment
opt_fx_inv_RMInv=1;
temp_opt_fx_inv_RMInv = struct('name','opt_fx_inv_RMInv','type','parameter','form','full','val',opt_fx_inv_RMInv);
opt_fx_inv_RMInv_cap=0;
temp_opt_fx_inv_RMInv_cap = struct('name','opt_fx_inv_RMInv_cap','type','parameter','form','full','val',opt_fx_inv_RMInv_cap);

%Option for TES investment
opt_fx_inv_TES=0;
temp_opt_fx_inv_TES = struct('name','opt_fx_inv_TES','type','parameter','form','full','val',opt_fx_inv_TES);
opt_fx_inv_TES_cap=0;
temp_opt_fx_inv_TES_cap = struct('name','opt_fx_inv_TES_cap','type','parameter','form','full','val',opt_fx_inv_TES_cap);

%Option for BES investment
BES_BID_temp=[28]; %OBS: Reffers to bus 28
BES_BID_inv.name='BES_BID_inv';
BES_BID_inv.uels=num2cell(BES_BID_temp);

opt_fx_inv_BES=1;
temp_opt_fx_inv_BES = struct('name','opt_fx_inv_BES','type','parameter','form','full','val',opt_fx_inv_BES);
opt_fx_inv_BES_cap=[0]; %must be set to 200
temp_opt_fx_inv_BES_cap = struct('name','opt_fx_inv_BES_cap','type','parameter','form','full');
temp_opt_fx_inv_BES_cap.val=opt_fx_inv_BES_cap;
temp_opt_fx_inv_BES_cap.uels=BES_BID_inv.uels;

opt_fx_inv_BES_maxP=[0];  %must be set to 100
temp_opt_fx_inv_BES_maxP = struct('name','opt_fx_inv_BES_maxP','type','parameter','form','full');
temp_opt_fx_inv_BES_maxP.val=opt_fx_inv_BES_maxP;
temp_opt_fx_inv_BES_maxP.uels=BES_BID_inv.uels;

%Option for BFCh investment
BFCh_BID_temp=[34]; %OBS: Reffers to Bus 5
BFCh_BID_inv.name='BFCh_BID_inv';
BFCh_BID_inv.uels=num2cell(BFCh_BID_temp);

opt_fx_inv_BFCh=0;
temp_opt_fx_inv_BFCh = struct('name','opt_fx_inv_BFCh','type','parameter','form','full','val',opt_fx_inv_BFCh);
opt_fx_inv_BFCh_cap=[0]; %must be set to 100
temp_opt_fx_inv_BFCh_cap = struct('name','opt_fx_inv_BFCh_cap','type','parameter','form','full');
temp_opt_fx_inv_BFCh_cap.val=opt_fx_inv_BFCh_cap;
temp_opt_fx_inv_BFCh_cap.uels=BFCh_BID_inv.uels;

opt_fx_inv_BFCh_maxP=0; %must be set to 50
temp_opt_fx_inv_BFCh_maxP = struct('name','opt_fx_inv_BFCh_maxP','type','parameter','form','full');
temp_opt_fx_inv_BFCh_maxP.val=opt_fx_inv_BFCh_maxP;
temp_opt_fx_inv_BFCh_maxP.uels=BFCh_BID_inv.uels;

%Option for BTES investment
BITES_Inv.name='BITES_Inv';
BITES_Inv.uels={'Bibliotek','NyaMatte','Elkraftteknik','VOV1', 'Arkitektur', 'VOV2'};

%Option for BAC investment
BAC_Inv.name='BAC_Inv';
BAC_Inv.uels={'Bibliotek','NyaMatte','Elkraftteknik','VOV1', 'Arkitektur', 'VOV2'};

%Option for solar PV investment
area_roof_max = struct('name','area_roof_max','type','parameter');
area_roof_max.uels=BID.uels;
area_roof_max.val=pv_area_roof;

area_facade_max = struct('name','area_facade_max','type','parameter');
area_facade_max.uels=BID.uels;
area_facade_max.val=pv_area_facades;


PV_BID_roof_Inv_temp=[27]; %OBS: This is just a random Building ID, it need to corrected 
PV_BID_roof_Inv.name='PV_BID_roof_Inv';
PV_BID_roof_Inv.uels=num2cell(PV_BID_roof_Inv_temp);

PV_roof_cap_temp=[0];   %OBS: This is just a random PV capacity for the given buildings, it need to corrected
PV_roof_cap_Inv=struct('name','PV_roof_cap_Inv','type','parameter','form','full');
PV_roof_cap_Inv.uels=PV_BID_roof_Inv.uels;
PV_roof_cap_Inv.val=PV_roof_cap_temp';

PV_BID_facade_Inv_temp=[10]; %OBS: This is just a random Building ID, it need to corrected 
PV_BID_facade_Inv.name='PV_BID_facade_Inv';
PV_BID_facade_Inv.uels=num2cell(PV_BID_facade_Inv_temp);

PV_cap_facade_cap_temp=[0];
PV_facade_cap_Inv=struct('name','PV_facade_cap_Inv','type','parameter','form','full');
PV_facade_cap_Inv.uels=PV_BID_facade_Inv.uels;
PV_facade_cap_Inv.val=PV_cap_facade_cap_temp';

PV_PF_inverter_PF_temp=[0.92];
PV_inverter_PF_Inv=struct('name','PV_inverter_PF_Inv','type','parameter','form','full');
PV_inverter_PF_Inv.uels=PV_BID_roof_Inv.uels;
PV_inverter_PF_Inv.val=PV_PF_inverter_PF_temp';

%% FIXED MODEL INPUT DATA - INPUT PE and CO2 FACTORS and Dispatch of local generating units

% calculate new values
Re_calculate_CO2PEF=1;

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

while Re_calculate_CO2PEF==1
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
while Re_calculate_CO2PEF==0
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

%Import marginal CO2 and PE factors, marginal DH cost
DH_cost_ma=xlsread('Input_data_FED_SIMULATOR\Produktionsdata fjärrvärme marginal.xlsx',2,'W5:W17900');
DH_CO2F_ma=xlsread('Input_data_FED_SIMULATOR\Produktionsdata fjärrvärme marginal.xlsx',2,'X5:X17900');
DH_PEF_ma=xlsread('Input_data_FED_SIMULATOR\Produktionsdata fjärrvärme marginal.xlsx',2,'Y5:Y17900');
EL_CO2F_ma=sum(csvread('Input_data_FED_SIMULATOR\electricityMap - Marginal mix - SE - 2016-03-01 - 2017-02-28.csv',1,1).*[230  820   490   24     12  45 700   11  24  24],2);
EL_PEF_ma=sum(csvread('Input_data_FED_SIMULATOR\electricityMap - Marginal mix - SE - 2016-03-01 - 2017-02-28.csv',1,1).*[2.99  2.45  1.93  1.01   3.29  1.25 2.47 1.03 1.01  1.01],2);

%% FIXED MODEL INPUT DATA - FED INVESTMENT LIMIT

FED_inv = 68570065;%68570065; %76761000;  %this is projected FED investment cost in SEK
FED_Inv_lim = struct('name','inv_lim','type','parameter','val',FED_inv);
                
%% Variable inputs to the dispatch model                

h_sim.name='h';
%Define the forcast function here, here forcast is assumed to be the same
%as measurment

%Forcasted el demand
e_demand = struct('name','el_demand','type','parameter','form','full');

%Forcasted heat demand
h_demand = struct('name','h_demand','type','parameter','form','full');

%Forcasted cooling demand
c_demand = struct('name','c_demand','type','parameter','form','full');

%Heat generaion from boiler 1 in the base case
qB1 = struct('name','qB1','type','parameter','form','full');

%Heat generaion from the Flue gas condencer in the base case
qF1 = struct('name','qF1','type','parameter','form','full');

%Forcasted Nprdpool el price
el_price = struct('name','el_price','type','parameter','form','full');

%Forcasted el cirtificate
el_cirtificate = struct('name','el_cirtificate','type','parameter','form','full');

%Forcasted GE's heat price
h_price = struct('name','h_price','type','parameter','form','full');

%Forcasted outdoor temprature
tout = struct('name','tout','type','parameter','form','full');

%Building termal energy storage properties
BTES_properties.name='BTES_properties';
BTES_properties.uels={'BTES_Scap', 'BTES_Dcap', 'BTES_Esig', 'BTES_Sch_hc',...
                      'BTES_Sdis_hc', 'kloss_Sday', 'kloss_Snight', 'kloss_D', 'K_BS_BD'};

%BITES model
BTES_model = struct('name','BTES_model','type','parameter','form','full','val',BTES_param);
BTES_model.uels={BTES_properties.uels,B_ID.uels};

%P1P2 dispatchability
P1P2_dispatchable = struct('name','P1P2_dispatchable','type','parameter','form','full');

%Heat export season
DH_export_season = struct('name','DH_export_season','type','parameter','form','full');

%BAC saving period
BAC_savings_period = struct('name','BAC_savings_period','type','parameter','form','full');

FED_CO2_max = struct('name','CO2_max','type','parameter');
FED_CO2_peakref = struct('name','CO2_peak_ref','type','parameter');
FED_PE_totref = struct('name','PE_tot_ref','type','parameter');
CO2F_exG = struct('name','CO2F_exG','type','parameter','form','full');
PEF_exG = struct('name','PEF_exG','type','parameter','form','full');
MA_CO2F_exG = struct('name','MA_CO2F_exG','type','parameter','form','full');
MA_PEF_exG = struct('name','MA_PEF_exG','type','parameter','form','full');
CO2F_DH = struct('name','CO2F_DH','type','parameter','form','full');
MA_CO2F_DH = struct('name','MA_CO2F_DH','type','parameter','form','full');
PEF_DH = struct('name','PEF_DH','type','parameter','form','full');
MA_PEF_DH = struct('name','MA_PEF_DH','type','parameter','form','full');
MA_Cost_DH = struct('name','MA_Cost_DH','type','parameter','form','full');

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

%Forcasted solar PV irradiance -roof
G_roof = struct('name','G_roof','type','parameter');

%Forcasted solar PV irradiance -facade
G_facade = struct('name','G_facade','type','parameter');

Panna1 = struct('name','Panna1','type','parameter','form','full');
FGC = struct('name','FGC','type','parameter','form','full');
%% SIMULATION OPTIONS
synth_baseline=1; %Option for synthetic baseline 

% optimization option
option1=1;    %minimize total cost
option2=0;    %minimize tottal PE use
option3=0;    %minimize total CO2 emission

temp_synth_baseline = struct('name','synth_baseline','type','parameter','form','full','val',synth_baseline);
temp_optn1 = struct('name','min_totCost','type','parameter','form','full','val',option1);
temp_optn2 = struct('name','min_totPE','type','parameter','form','full','val',option2);
temp_optn3 = struct('name','min_totCO2','type','parameter','form','full','val',option3);

%SIMULATION START AND STOP TIME
sim_start=2000;
sim_stop=2000; 

forcast_horizon=20;
t_len_m=20;
Time(1).point='fixed inputs';
Time(1).value=toc;
for t=sim_start:sim_stop
    %% Variable input data to the dispatch model
    %Read measured data
    tic
    t_init_m=t;  %OBS: t_init_m  should be greater than t_len_m  
    
    
    forcast_start=t;
    forcast_end=forcast_start+forcast_horizon-1;    
    h_sim.uels=num2cell(forcast_start:forcast_end);
    
    %Define the forcast function here, here forcast is assumed to be the same
    %as measurment
    
    %Forcasted solar PV irradiance Roof
    irradiance_roof_forcast=irradiance_measured_roof((t_init_m-1):(t_len_m+t_init_m-2),:);
    G_roof.val = irradiance_roof_forcast;
    G_roof.uels={h_sim.uels,BID.uels};
    
    %Forcasted solar PV irradiance Roof 
    irradiance_facades_forcast=irradiance_measured_facades((t_init_m-1):(t_len_m+t_init_m-2),:);
    G_facade.val = irradiance_facades_forcast;
    G_facade.uels={h_sim.uels,BID.uels};
    
    %Forcasted el demand
    e_demand_forcast=e_demand_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    e_demand.val = e_demand_forcast;
    e_demand.uels={h_sim.uels,B_ID.uels};
    
    %Forcasted heat demand
    h_demand_forcast=h_demand_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    h_demand.val = h_demand_forcast;
    h_demand.uels={h_sim.uels,B_ID.uels};
    
    %Forcasted cooling demand
    c_demand_forcast=c_demand_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    c_demand.val = c_demand_forcast;
    c_demand.uels={h_sim.uels,B_ID.uels};
    
    %Heat generaion from boiler 1 in the base case
    h_B1_forcast=h_B1_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    qB1.val = h_B1_forcast;
    qB1.uels=h_sim.uels;
    
    %Heat generaion from the Flue gas condencer in the base case
    h_F1_forcast=h_F1_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    qF1.val = h_F1_forcast;
    qF1.uels=h_sim.uels;
    
    %Forcasted Nprdpool el price
    el_price_forcast=e_price_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    el_price.val = el_price_forcast;
    el_price.uels=h_sim.uels;
    
    %Forcasted el cirtificate
    el_cirtificate_forcast=el_cirtificate_m((t_init_m-1):(t_len_m+t_init_m-2),:);
    el_cirtificate.val = el_cirtificate_forcast;
    el_cirtificate.uels=h_sim.uels;
    
    %Forcasted GE's heat price
    h_price_forcast=h_price_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    h_price.val = h_price_forcast;
    h_price.uels=h_sim.uels;
    
    %Forcasted outdoor temprature
    tout_forcast=tout_measured((t_init_m-1):(t_len_m+t_init_m-2),:);
    tout.val = tout_forcast;
    tout.uels=h_sim.uels;
    
    %P1P2 dispatchability
    P1P2_dispatchable_temp=P1P2_disp((t_init_m-1):(t_len_m+t_init_m-2),:);
    P1P2_dispatchable.val = P1P2_dispatchable_temp;
    P1P2_dispatchable.uels=h_sim.uels;
    
    %Heat export season
    DH_exp_season_temp=DH_exp_season((t_init_m-1):(t_len_m+t_init_m-2),:);
    DH_export_season.val = DH_exp_season_temp;
    DH_export_season.uels=h_sim.uels;
    
    %BAC saving period
    BAC_sav_period_temp=BAC_sav_period((t_init_m-1):(t_len_m+t_init_m-2),:);
    BAC_savings_period.val = BAC_sav_period_temp;
    BAC_savings_period.uels=h_sim.uels;
    
    %District heating network node transfer limits
    DH_Nodes_Transfer_Limits=fget_dh_transfer_limits(DH_Nodes, h_sim, tout);
    
    %District cooling network node transfer limits
    DC_Nodes_Transfer_Limits = fget_dc_transfer_limits(DC_Nodes, h_sim);
    
    %Maximum CO2 emission in the base case

   % FED_CO201=FED_CO20((t_init_m-1):(t_len_m+t_init_m-2),:);
    %FED_CO2_max.val = max(FED_CO201);
    
    %Reference peak CO2 emission in the base case
   % data=sort(FED_CO20,'descend');
    %duration= 0 : 100/(length(FED_CO20)-1) : 100;
    %x=find(duration<=pCO2ref);
    %CO2ref=data(length(x)); %CO2 reference
    %FED_CO2_peakref.val = CO2ref;
    
    %Total PE use in the FED system in the base case
    %FED_PE01=FED_PE0((t_init_m-1):(t_len_m+t_init_m-2),:);
    %FED_PE_totref.val = sum(FED_PE01);
    
    %CO2 factors of the external el grid (AVERAGE AND MARGINAL)
    el_exGCO2F1=el_exGCO2F((t_init_m-1):(t_len_m+t_init_m-2),:);
    CO2F_exG.val = el_exGCO2F1;
    CO2F_exG.uels=h_sim.uels;
    el_exGCO2F1=EL_CO2F_ma((t_init_m-1-1441):(t_len_m+t_init_m-2-1441),:);
    MA_CO2F_exG.val = el_exGCO2F1;
    MA_CO2F_exG.uels=h_sim.uels;
    
    %PE factors of the external el grid (AVERAGE AND MARGINAL)
    el_exGPEF1=el_exGPEF((t_init_m-1):(t_len_m+t_init_m-2),:);
    PEF_exG.val = el_exGPEF1;
    PEF_exG.uels=h_sim.uels;
    el_exGPEF1=EL_PEF_ma((t_init_m-1-1441):(t_len_m+t_init_m-2-1441),:);
    MA_PEF_exG.val = el_exGPEF1;
    MA_PEF_exG.uels=h_sim.uels;
    
    %CO2 factors of the external DH grid (AVERAGE AND MARGINAL) & marginal
    %DH cost
    DH_cost=DH_cost_ma((t_init_m-1):(t_len_m+t_init_m-2),:);
    MA_Cost_DH.val = DH_cost;
    MA_Cost_DH.uels=h_sim.uels;
    DH_CO2F1=DH_CO2F((t_init_m-1):(t_len_m+t_init_m-2),:);
    CO2F_DH.val = DH_CO2F1;
    CO2F_DH.uels=h_sim.uels;
    DH_CO2F1=DH_CO2F_ma((t_init_m-1):(t_len_m+t_init_m-2),:);
    MA_CO2F_DH.val = DH_CO2F1;
    MA_CO2F_DH.uels=h_sim.uels;

    %PE factors of the external DH grid(AVERAGE AND MARGINAL)
    DH_PEF1=DH_PEF((t_init_m-1):(t_len_m+t_init_m-2),:);
    PEF_DH.val = DH_PEF1;
    PEF_DH.uels=h_sim.uels;
    DH_PEF1=DH_PEF_ma((t_init_m-1):(t_len_m+t_init_m-2),:);
    MA_PEF_DH.val = DH_PEF1;
    MA_PEF_DH.uels=h_sim.uels;
    
    Panna1.val = Panna1_forecast((t_init_m-26):(t_len_m+t_init_m-27),:);
    Panna1.uels=h_sim.uels; 
    FGC.val = FGC_forecast((t_init_m-26):(t_len_m+t_init_m-27),:);
    FGC.uels=h_sim.uels; 

    %Initial SoC of different storage systems (1=BTES_D, 2=BTES_S, 3=TES, 4=BFCh, 5=BES)
    if (isinteger((t-sim_start)/720) || (t==sim_start))
         max_exG_prev=0;
    else
        [x, max_exG_prev]=readGtoM(t);
    end
    if t==sim_start
        Initial(1:6)=0;
    else
    [Initial, x]=readGtoM(t);
    end
    Pana1_prev_disp=Initial(6);
    temp_Pana1_prev_disp = struct('name','Pana1_prev_disp','type','parameter','form','full','val',Pana1_prev_disp);
    
    temp_max_exG_prev = struct('name','max_exG_prev','type','parameter','form','full','val',max_exG_prev);
    
    opt_fx_inv_BES_init=Initial(5);
    temp_opt_fx_inv_BES_init = struct('name','opt_fx_inv_BES_init','type','parameter','form','full','val',opt_fx_inv_BES_init);
    
    opt_fx_inv_BFCh_init=Initial(4);
    temp_opt_fx_inv_BFCh_init = struct('name','opt_fx_inv_BFCh_init','type','parameter','form','full','val',opt_fx_inv_BFCh_init);

    opt_fx_inv_TES_init=Initial(3);
    temp_opt_fx_inv_TES_init = struct('name','opt_fx_inv_TES_init','type','parameter','form','full','val',opt_fx_inv_TES_init);

    opt_fx_inv_BTES_S_init=Initial(2);
    temp_opt_fx_inv_BTES_S_init = struct('name','opt_fx_inv_BTES_S_init','type','parameter','form','full','val',opt_fx_inv_BTES_S_init);
 
    opt_fx_inv_BTES_D_init=Initial(1);
    temp_opt_fx_inv_BTES_D_init = struct('name','opt_fx_inv_BTES_D_init','type','parameter','form','full','val',opt_fx_inv_BTES_D_init);
    

    %% RUN GAMS model

wgdx('MtoG.gdx', temp_opt_fx_inv,temp_opt_fx_inv_RMMC,...
     temp_opt_fx_inv_AbsCInv,temp_opt_fx_inv_AbsCInv_cap,...
     temp_opt_fx_inv_P2,temp_opt_fx_inv_TURB,temp_opt_fx_inv_HP, temp_opt_fx_inv_HP_cap,...
     temp_opt_fx_inv_RMInv, temp_opt_fx_inv_RMInv_cap,...
     temp_opt_fx_inv_TES, temp_opt_fx_inv_TES_cap,temp_opt_marg_factors, ...
     temp_opt_fx_inv_BES, temp_opt_fx_inv_BES_cap, h_sim,BITES_Inv,BAC_Inv,...
     CO2F_exG, PEF_exG, MA_CO2F_DH, CO2F_DH, MA_PEF_DH, PEF_DH,...
     temp_CO2F_PV, temp_PEF_PV, temp_CO2F_P1, temp_PEF_P1, temp_CO2F_P2, temp_PEF_P2,...
     B_ID,B_ID_AH_el,B_ID_nonAH_el,B_ID_AH_h,B_ID_nonAH_h,B_ID_AH_c,B_ID_nonAH_c,B_ID_nonBITES,BID,...
     e_demand,h_demand,c_demand,qB1,qF1,el_price,el_cirtificate,h_price,tout,...     
     BTES_properties,BTES_model,P1P2_dispatchable,DH_export_season,BAC_savings_period,...
     PV_BID_roof_Inv,PV_roof_cap_Inv,PV_BID_facade_Inv,PV_facade_cap_Inv,...
     temp_optn1, temp_optn2, temp_optn3, temp_synth_baseline, FED_Inv_lim,Buses_IDs,temp_opt_fx_inv_BFCh, temp_opt_fx_inv_BFCh_cap,...
     temp_opt_fx_inv_BES_maxP,temp_opt_fx_inv_BFCh_maxP,PV_inverter_PF_Inv,temp_opt_fx_inv_BTES_D_init,temp_opt_fx_inv_BTES_S_init,...
     temp_opt_fx_inv_TES_init,temp_opt_fx_inv_BFCh_init,temp_opt_fx_inv_BES_init,Panna1,FGC,temp_Pana1_prev_disp,...
     MA_PEF_exG,MA_CO2F_exG,temp_max_exG_prev,MA_Cost_DH,...
     DH_Node_ID, DH_Nodes_Transfer_Limits,...
     DC_Node_ID, DC_Nodes_Transfer_Limits);

 
%wgdx('MtoG_pv.gdx',G_facade,area_roof_max,area_facade_max);
Time(2).point='Wgdx and Inputs';
Time(2).value=toc;
tic
 RUN_GAMS_MODEL = 1;
 while RUN_GAMS_MODEL==1
     system 'C:\GAMS\win64\24.9\gams FED_SIMULATOR_MAIN lo=3';
     %system 'C:\GAMS\win64\24.9\gams FED_SIMULATOR_MAIN lo=3';
     break;
 end
 
 %% Store the results from each iteration
 
Results(t).dispatch = fstore_results(h_sim,B_ID,BTES_properties,Buses_IDs);
Time(3).point='Gams running and storing';
Time(3).value=toc;
end

 %% Post processing results 
 
 %use the 'plot_results.m' script to plot desired results
%%
Time(4).point='Total';
total=profile('info');
total=total.FunctionTable.TotalTime;
Time(4).value=total(1);
excel_results(sim_start,sim_stop,Results,Time);
