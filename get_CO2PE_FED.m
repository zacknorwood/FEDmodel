%% Here, CO2 emission and PE use of the FED system are calculated

%% Calculate CO2 emission factor and PE use factor of the external grids 

%% Imported el to the AH system
get_CO2PE_exGrids;
sheet=1;
xlRange = 'C1443:C10203';
el_Import_AH=xlsread('Input_dispatch_model\AH_el_import.xlsx',sheet,xlRange);  %electricity imported to the FED system 2016 kWh
%% AH heat import and export

sheet=2;
xlRange = 'C1447:C10207';
h_Import_AH=1000*xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',sheet,xlRange);  

sheet=2;
xlRange = 'D1447:D10207';
h_Exmport_AH=1000*xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',sheet,xlRange); 
%% FED Electricty demand

sheet=2;
xlRange = 'B2:AJ17521';
el_demand_2016_2017=xlsread('Input_dispatch_model\FED_el_Demand_new.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
el_demand_2016_2017(isnan(el_demand_2016_2017))=0;
AH_el_demand=el_demand_2016_2017(:,1:24);
nonAH_el_demand=el_demand_2016_2017(:,25:30);
el_demand_tot=sum(el_demand_2016_2017,2);
%% FED heat demand

sheet=2;
xlRange = 'B2:AJ17521';
heat_demand_2016_2017=xlsread('Input_dispatch_model\FED_heat_demand_new.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
heat_demand_2016_2017(isnan(heat_demand_2016_2017))=0;
AH_heat_demand=heat_demand_2016_2017(:,1:24);
nonAH_heat_demand=heat_demand_2016_2017(:,25:30);
heat_demand_tot=sum(heat_demand_2016_2017,2);
%% FED cooling demand

sheet=2;
xlRange = 'B2:AJ17521';
cooling_demand_2016_2017=xlsread('Input_dispatch_model\FED_cooling_Demand_new.xlsx',sheet,xlRange);  %electricity demand in the FED system, 2016 kWh
cooling_demand_2016_2017(isnan(cooling_demand_2016_2017))=0;
cooling_demand_tot=sum(cooling_demand_2016_2017,2);
%% FED Local el generation

%Solar PV
%pv_cap=60;
%sheet=3;
%xlRange = 'C2:C8761';     %45^o
%nIrad_2016=xlsread('Input_data_FED_SIMULATOR\pv_data.xlsx',sheet,xlRange);    %electricity demand in the FED system, 2016 kWh
%el_pv=pv_cap*nIrad_2016;
%% Local Cooling generation

%Ambient Air Cooler
sheet=1;
xlRange = 'Q5:Q17524'; 
c0_AAC=zeros(len,1);
c0_AAC_temp=1000*xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',sheet,xlRange);   
c0_AAC(1:length(c0_AAC_temp))=c0_AAC_temp;
e0_AAC=c0_AAC/COP_AAC;

%Absrobtion chiller
sheet=1;
xlRange = 'N5:N17524'; 
c0_tot=zeros(len,1);
c0_tot_temp=1000*xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',sheet,xlRange);
c0_tot(1:length(c0_tot_temp))=c0_tot_temp;
%q0_AbsC=round(q0_AbsC,2);
c0_AbsC=c0_tot-c0_AAC;
c0_AbsC(c0_AbsC<0)=0;
h0_AbsC=c0_AbsC/COP_AbsC;
%% Total electricty supply

%el_tot_2016=el_Import_2016 + el_pv + 0*el_chp_2016;
%% FED Local heat generation

%sheet=4;
%xlRange = 'B4:B8763';
%tb_heat_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
%tb_heat_2016(isnan(tb_heat_2016))=0;

%sheet=4;
%xlRange = 'C4:C8763';
%fgc_heat_2016=1000*xlsread('Input_data_FED_SIMULATOR\FED_Base_Heat.xlsx',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
%fgc_heat_2016(isnan(fgc_heat_2016))=0;
%q_P1=tb_heat_2016+fgc_heat_2016;         %total heat production

%fuel_P1=tb_heat_2016/P1_eff + fgc_heat_2016/P1_eff;   %estimated fuel consumption

% VKA1
sheet=2;
xlRange = 'B4:B17523';
e0_VKA1=zeros(len,1);
e0_VKA1_temp=xlsread('Input_dispatch_model\varmepump VKA1.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
e0_VKA1(1:length(e0_VKA1_temp),1)=e0_VKA1_temp;
e0_VKA1(isnan(e0_VKA1))=0;
     
% VKA4
sheet=2;
xlRange = 'B4:B17523';
e0_VKA4=zeros(len,1);
e0_VKA4_temp=xlsread('Input_dispatch_model\varmepump VKA4.xls',sheet,xlRange); %electricity demand in the FED system, 2016 kWh
e0_VKA4(1:length(e0_VKA4_temp),1)=e0_VKA4_temp;
e0_VKA4(isnan(e0_VKA4))=0;
%% Calculate the CO2 and PE of FED

return
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