%% Here, CO2 emission and PE use of the FED system are calculated

%% Calculate CO2 emission factor and PE use factor of the external grids 

get_CO2PE_exGrids;
%% FED Electricty demand

sheet=3;
xlRange = 'B2:AE8761';
el_demand_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_el_Demand.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
el_demand_2016(isnan(el_demand_2016))=0;
AH_el_demand=el_demand_2016(:,1:24);
nonAH_el_demand=el_demand_2016(:,25:30);
el_demand_tot=sum(el_demand_2016,2);
%% FED heat demand

sheet=3;
xlRange = 'B2:AE8761';
heat_demand_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_heat_Demand.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
heat_demand_2016(isnan(heat_demand_2016))=0;
AH_heat_demand=heat_demand_2016(:,1:24);
nonAH_heat_demand=heat_demand_2016(:,25:30);
heat_demand_tot=sum(heat_demand_2016,2);
%temp=heat_demand_tot+heat_Exmport_2016-heat_Import_2016;
%% FED cooling demand

sheet=2;
xlRange = 'B2:AE8761';
cooling_demand_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_cooling_Demand.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
cooling_demand_2016_temp=1000*xlsread('Input_data_FED_SIMULATOR\FED_cooling_Demand.xlsx',1,xlRange);

cooling_demand_2016(isnan(cooling_demand_2016))=0;
cooling_demand_tot=sum(cooling_demand_2016,2);
AH_cooling_demand=cooling_demand_2016(:,1:24);
% nonAH_cooling=cooling_demand_2016(:,25:30);
%% FED Base: electricity import

sheet=2;
xlRange = 'C2:C8761';
el_Import_2016_AH=xlsread('Input_data_FED_SIMULATOR\FED_Base_El.xlsx',sheet,xlRange);  %electricity imported to the FED system 2016 kWh
el_Import_2016=el_Import_2016_AH + sum(nonAH_el_demand,2);           %(assumed) electricty import to the FED system including non-AH buiödings
%% FED Local el generation

%Solar PV
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
%% Local Cooling generation

%Absrobtion chiller
sheet=1;
xlRange = 'C5:C8764';     
q0_AbsC=1000*xlsread('Input_data_FED_SIMULATOR\abs o frikyla Existing sammanst data_KY.xlsx',sheet,xlRange);
%q0_AbsC=round(q0_AbsC,2);
c0_AbsC=q0_AbsC*COP_AbsC;

%Ambient Air Cooler
sheet=1;
xlRange = 'P5:P8764';     
c0_AAC=1000*xlsread('Input_data_FED_SIMULATOR\abs o frikyla Existing sammanst data_KY.xlsx',sheet,xlRange);   
e0_AAC=c0_AAC/COP_AAC;
%% Total electricty supply

el_tot_2016=el_Import_2016 + el_pv + 0*el_chp_2016;
%% FED  Base: heat import and export

sheet=2;
xlRange = 'C5:C8764';
heat_Import_2016_AH=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange);  %heat imported to the FED system 2016 kWh
heat_Import_2016=heat_Import_2016_AH+sum(nonAH_heat_demand,2);                                  %(assumed) heat import including non-AH heat demands

sheet=2;
xlRange = 'D5:D8764';
heat_Exmport_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %Heat exported to the Göteborg DH system 2016 kWh
%% FED Local heat generation

sheet=4;
xlRange = 'B4:B8763';
tb_heat_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
tb_heat_2016(isnan(tb_heat_2016))=0;

sheet=4;
xlRange = 'C4:C8763';
fgc_heat_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
fgc_heat_2016(isnan(fgc_heat_2016))=0;
q_P1=tb_heat_2016+fgc_heat_2016;         %total heat production

fuel_P1=tb_heat_2016/P1_eff + fgc_heat_2016/P1_eff;   %estimated fuel consumption

% VKA1
sheet=1;
xlRange = 'B4:B8763';
e0_VKA1=xlsread('Input_data_FED_SIMULATOR\värmepump VKA1 historik 1 år.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
e0_VKA1(isnan(e0_VKA1))=0;
        
sheet=1;
xlRange = 'C4:C8763';
q0_VKA1=xlsread('Input_data_FED_SIMULATOR\värmepump VKA1 historik 1 år.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
q0_VKA1(isnan(q0_VKA1))=0;

sheet=1;
xlRange = 'H4:H8763';
c0_VKA1=xlsread('Input_data_FED_SIMULATOR\värmepump VKA1 historik 1 år.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
c0_VKA1(isnan(c0_VKA1))=0;

% VKA4
sheet=1;
xlRange = 'B4:B8763';
e0_VKA4=xlsread('Input_data_FED_SIMULATOR\värmepump VKA4 historik 1 år.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
e0_VKA4(isnan(e0_VKA4))=0;

sheet=1;
xlRange = 'C4:C8763';
q0_VKA4=xlsread('Input_data_FED_SIMULATOR\värmepump VKA4 historik 1 år.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
q0_VKA4(isnan(q0_VKA4))=0;

sheet=1;
xlRange = 'H4:H8763';
c0_VKA4=xlsread('Input_data_FED_SIMULATOR\värmepump VKA4 historik 1 år.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
c0_VKA4(isnan(c0_VKA4))=0;
%% Calculate the CO2 and PE of FED

% Calculate FED CO2 emission
% the existing CHP unit is assumed to be out of survice

% Make sure that the supply and emand balance of the electricity and heat in
% the base case are maintaine
% e_sup=0.87*sum(el_Import_2016)/10^6;
% e_dem=sum(sum(el_demand_2016,2) + e0_VKA1 + e0_VKA4 + e0_AAC - el_pv)/10^6;
% q_sup=0.95*(sum(heat_Import_2016)/10^6 + sum(q_P1)/10^6-4.2);
% q_dem=sum(sum(heat_demand_2016,2) + q0_AbsC -q0_VKA1 - q0_VKA4)/10^6;
el_import=(sum(el_demand_2016,2) + e0_VKA1 + e0_VKA4 + e0_AAC - el_pv);
%q_import_AH=sum(AH_heat_demand,2) + q0_AbsC -q0_VKA1 - q0_VKA4 - q_P1;
q_import=sum(nonAH_heat_demand,2);
qen_sup=sum(q_import)+sum(q_P1) + sum(q0_VKA1) + sum(q0_VKA4)
qen_demand=sum(sum(AH_heat_demand,2)) + sum(sum(nonAH_heat_demand,2))+sum(q0_AbsC)
%%

% q_import_nonAH=sum(nonAH_heat_demand,2);
% q_import=q_import_AH+q_import_nonAH;
% q_import(q_import<0)=0;
%% Calculate the FED PE use and CO2 emission in the base case
% %Using the the source data from KC
% FED_CO20=el_Import_2016.*el_exGCO2F + el_pv.*CO2F_PV...
%         + heat_Import_2016.*DH_CO2F + fuel_P1*CO2F_P1;
% FED_CO20(isnan(FED_CO20))=0;
% 
% % Calculate FED PE use
% FED_PE0=el_Import_2016.*el_exGPEF + el_pv.*PEF_PV ...
%       + heat_Import_2016.*DH_PEF + fuel_P1*PEF_P1;
% FED_PE0(isnan(FED_PE0))=0;

% Adjusting the source data from KC to keep supply demand balace
FED_CO20=el_import.*el_exGCO2F + el_pv.*CO2F_PV...
        + q_import.*DH_CO2F + fuel_P1*CO2F_P1;    
FED_CO20(isnan(FED_CO20))=0;

% Calculate FED PE use
FED_PE0=el_import.*el_exGPEF + el_pv.*PEF_PV ...
      + q_import.*DH_PEF + fuel_P1*PEF_P1;
FED_PE0(isnan(FED_PE0))=0;
%%

% AH_el_CO2F = (el_Import_2016_AH.*el_exGCO2F + el_pv.*CO2F_PV)./(el_Import_2016_AH + el_pv);
% AH_el_CO2F(isnan(AH_el_CO2F))=0;
% AH_el_PEF = (el_Import_2016_AH.*el_exGPEF + el_pv.*PEF_PV)./(el_Import_2016_AH + el_pv);
% AH_el_PEF(isnan(AH_el_PEF))=0;
% 
% AH_q_CO2F = (heat_Import_2016_AH.*DH_CO2F + fuel_P1.*CO2F_P1 + q0_VKA1*0 + q0_VKA4*0)./(heat_Import_2016_AH + fuel_P1 + q0_VKA1 + q0_VKA4);
% AH_q_CO2F(isnan(AH_q_CO2F))=0;
% AH_q_PEF = (heat_Import_2016_AH.*DH_PEF + fuel_P1.*PEF_P1 + q0_VKA1*0 + q0_VKA4*0)./(heat_Import_2016_AH + fuel_P1 + q0_VKA1 + q0_VKA4);
% AH_q_PEF(isnan(AH_q_PEF))=0;
% 
% FED_CO20=(sum(AH_el_demand,2) + e0_VKA1 + e0_VKA4 + e0_AAC).*AH_el_CO2F + sum(nonAH_el_demand,2).*el_exGCO2F...
%          + (sum(AH_heat_demand,2)+q0_AbsC).*AH_q_CO2F + sum(nonAH_heat_demand,2).*DH_CO2F;
% 
% FED_PE0=(sum(AH_el_demand,2) + e0_VKA1 + e0_VKA4 + e0_AAC).*AH_el_PEF + sum(nonAH_el_demand,2).*el_exGPEF...
%          + (sum(AH_heat_demand,2)+q0_AbsC).*AH_q_PEF + sum(nonAH_heat_demand,2).*DH_PEF;

% %Calculate FED PE use
% FED_PE0=sum(AH_el,2).*(el_Import_2016_AH.*el_exGPEF + el_pv.*PEF_PV)/(el_Import_2016_AH + el_pv) + ;
% 
% FED_PE0=el_import.*el_exGPEF + el_pv.*PEF_PV ...
%       + q_import.*DH_PEF + fuel_P1*PEF_P1;
% FED_PE0(isnan(FED_PE0))=0;