%% Here, CO2 emission and PE use of the FED system are calculated

%% Calculate CO2 emission factor and PE use factor of the external grids 

get_CO2PE_exGrids;
%% FED Electricty demand

sheet=3;
xlRange = 'B2:AE8761';
el_demand_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_el_Demand.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
el_demand_2016(isnan(el_demand_2016))=0;
nonAH_el=el_demand_2016(:,24:30);
el_demand_tot=sum(el_demand_2016,2);
%% FED heat demand

sheet=3;
xlRange = 'B2:AE8761';
heat_demand_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_heat_Demand.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
heat_demand_2016(isnan(heat_demand_2016))=0;
nonAH_heat=heat_demand_2016(:,24:30);
heat_demand_tot=sum(heat_demand_2016,2);
%temp=heat_demand_tot+heat_Exmport_2016-heat_Import_2016;
%% FED cooling demand

sheet=2;
xlRange = 'B2:AE8761';
cooling_demand_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_cooling_Demand.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
cooling_demand_2016(isnan(cooling_demand_2016))=0;
cooling_demand_tot=sum(cooling_demand_2016,2);
%% FED Base: electricity import

sheet=2;
xlRange = 'C2:C8761';
el_Import_2016=xlsread('Input_data_FED_SIMULATOR\FED_Base_El.xlsx',sheet,xlRange);  %electricity imported to the FED system 2016 kWh
el_Import_2016=el_Import_2016 + sum(nonAH_el,2);           %(assumed) electricty import to the FED system including non-AH buiödings
%% FED Local el generation

pv_cap=60;
sheet=3;
xlRange = 'C2:C8761';     %45^o
nIrad_2016=xlsread('Input_data_FED_SIMULATOR\pv_data.xlsx',sheet,xlRange);    %electricity demand in the FED system, 2016 kWh
el_pv=pv_cap*nIrad_2016;

sheet=4;
xlRange = 'D2:D8761';
el_chp_2016=xlsread('Input_data_FED_SIMULATOR\FED_Base_El.xlsx',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
q_chp_2016=el_chp_2016/0.6;
p_chp_2016=(q_chp_2016+q_chp_2016)/0.95;
%% Total electricty supply

el_tot_2016=el_Import_2016 + el_pv + 0*el_chp_2016;
%% FED  Base: heat import and export

sheet=2;
xlRange = 'C5:C8764';
heat_Import_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange);  %heat imported to the FED system 2016 kWh
heat_Import_2016=heat_Import_2016+sum(nonAH_heat,2);                %(assumed) heat import including non-AH heat demands

sheet=2;
xlRange = 'D5:D8764';
heat_Exmport_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %Heat exported to the Göteborg DH system 2016 kWh
%% FED Local heat generation

sheet=4;
xlRange = 'B4:B8763';
tb_heat_2016=xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
tb_heat_2016(isnan(tb_heat_2016))=0;

sheet=4;
xlRange = 'C4:C8763';
fgc_heat_2016=xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
fgc_heat_2016(isnan(fgc_heat_2016))=0;
q_P1=tb_heat_2016+fgc_heat_2016;         %total heat production

tb_eff=0.9;  %assumed efficiency of the boiler, can be modified
fgc_eff=0.4; %assumed efficiency of the fuel gas condencer, can be modified
P1=tb_heat_2016/tb_eff + fgc_heat_2016/fgc_eff;   %estimated fuel consumption
%% Calculate the CO2 and PE of FED

% Calculate FED CO2 emission
%the existing CHP unit is assumed to be out of survice
FED_CO2=el_Import_2016.*el_exGCO2F + el_pv.*CO2F_PV...
        + heat_Import_2016.*DH_CO2F + P1*CO2F_P1;
FED_CO2(isnan(FED_CO2))=0;

% Calculate FED PE use
%the existing CHP unit is assumed to be out of survice
FED_PE=el_Import_2016.*el_exGPEF + el_pv.*PEF_PV ...
      + heat_Import_2016.*DH_PEF + P1*PEF_P1;
FED_PE(isnan(FED_PE))=0;
