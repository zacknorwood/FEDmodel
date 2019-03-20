function [el_demand, h_demand, c_demand,...
          h_Boiler1_0, h_FlueGasCondenser1_0,...
          el_VKA1_0, el_VKA4_0, el_AAC_0, h_AbsC_0,...
          el_price,...
          el_certificate,h_price,tout_measured,...
          irradiance_measured_facades,irradiance_measured_roof, c_DC_slack, el_exG_slack,h_DH_slack, h_exp_AH_measured, h_imp_AH_measured] = fread_measurements(sim_start, sim_stop)

%This function is used to read measurment between the indicated indices

MWhtokWh = 1000; %Conversion factor MWh to kWh

demand_range=strcat('B',int2str(sim_start+1),':AJ',int2str(sim_stop+1));
%Measured electricity demand in kW
el_demand=xlsread('Input_dispatch_model\measured_demand.xlsx',1,demand_range);
el_demand(isnan(el_demand))=0;
if length(el_demand)<(sim_stop-sim_start), warning('Length of el_demand differ'), end
    
%Measured heat demand in kW
h_demand=xlsread('Input_dispatch_model\measured_demand.xlsx',2,demand_range);
h_demand(isnan(h_demand))=0;
if length(h_demand)<(sim_stop-sim_start), warning('Length of h_demand differ'), end    
%Measured cooling demand in kW
c_demand=xlsread('Input_dispatch_model\measured_demand.xlsx',3,demand_range);
c_demand(isnan(c_demand))=0;
if length(c_demand)<(sim_stop-sim_start), warning('Length of c_demand differ'), end  

gen_range=strcat('B',int2str(sim_start+3),':B',int2str(sim_stop+3)); 
%Measured HEAT GENERATION FROM THERMAL BOILER (B1) converted to kWh
h_Boiler1_0=xlsread('Input_dispatch_model\Boiler1 2016-2017.xls',3,gen_range)*MWhtokWh;
if length(h_Boiler1_0)<(sim_stop-sim_start), warning('Length of h_boiler1 differ'), end  
    
%Measured HEAT GENERATION FROM FLUE GAS CONDENSER (F1) converted to kWh
h_FlueGasCondenser1_0=xlsread('Input_dispatch_model\Boiler1 2016-2017.xls',4,gen_range)*MWhtokWh;
if length(h_FlueGasCondenser1_0)<(sim_stop-sim_start), warning('Length of h_FlueGasCondenser1_0 differ'), end  

%Measured el input for VKA1
el_VKA1_0=xlsread('Input_dispatch_model\varmepump VKA1.xls',2,gen_range);
if length(el_VKA1_0)<(sim_stop-sim_start), warning('Length of VKA1 differ'), end    
%el_VKA1_measured=h_VKA1_measured/3; Removed by AK, previously h_VKA1 (col C) was
%read and divided by COP to get approximate electricity use

%Measured el input for VKA4
el_VKA4_0=xlsread('Input_dispatch_model\varmepump VKA4.xls',2,gen_range);
if length(el_VKA4_0)<(sim_stop-sim_start), warning('Length of VKA4 differ'), end    
%el_VKA4_measured=h_VKA4_measured/3; Removed by AK, previously h_VKA4 (col C) was
%read and divided by COP to get approximate electricity use

%Measured el input for AAC converted to kWh
c_AAC_0=xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',2,strcat('C',int2str(sim_start+1),':C',int2str(sim_stop+1)))*MWhtokWh;
el_AAC_0=c_AAC_0/10;
if length(el_AAC_0)<(sim_stop-sim_start), warning('Length of AAC differ'), end    

%Measured heat input for AbsC converted to kWh
c_AbsC_0=xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',2,strcat('D',int2str(sim_start+1),':D',int2str(sim_stop+1)))*MWhtokWh;
if length(c_AbsC_0)<(sim_stop-sim_start), warning('Length of ABS_C differ'), end    

% Shouldn't this be calculated in the GAMS code based on the COP of the AbsC? - ZN
h_AbsC_0=c_AbsC_0/0.5;

price_range=strcat('B',int2str(sim_start+1),':B',int2str(sim_stop+1));
%Measured el price in NordPool in SEK/kWh
el_price=xlsread('Input_dispatch_model\measured_el_price.xlsx',2,price_range);
if length(el_price)<(sim_stop-sim_start), warning('Length of el_price differ'), end    
    
%Measured el certificate in SEK/kWh
el_certificate=xlsread('Input_dispatch_model\el_certificate.xlsx',2,price_range);
if length(el_certificate)<(sim_stop-sim_start), warning('Length of el_certificate differ'), end    
    
%Measured heat price in GE's system in SEK/kWh
h_price=xlsread('Input_dispatch_model\measured_h_price.xlsx',2,price_range);
if length(h_price)<(sim_stop-sim_start), warning('Length of h_price differ'), end    
    
%Measured outdoor temprature
tout_measured=xlsread('Input_dispatch_model\measured_tout.xlsx',2,price_range);
if length(tout_measured)<(sim_stop-sim_start), warning('Length of tout_measured differ'), end    

%el exgG slack bus data
el_exG_slack=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',1,strcat('F',int2str(sim_start+1),':F',int2str(sim_stop+1)));
if length(el_exG_slack)<(sim_stop-sim_start), warning('Length of el_exG_slack differ'), end    

%District heating slack bus data
h_DH_slack=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',2,strcat('P',int2str(sim_start+1),':P',int2str(sim_stop+1)));
if length(h_DH_slack)<(sim_stop-sim_start), warning('Length of h_DH_slack differ'), end    

%District cooling slack bus data
c_DC_slack=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',3,strcat('N',int2str(sim_start+1),':N',int2str(sim_stop+1)));
if length(c_DC_slack)<(sim_stop-sim_start), warning('Length of c_DC_slack differ'), end    

%Irradiance on roofs and facades
irradiance_measured_roof=xlsread('Input_dispatch_model\Irradiance_Arrays 20181119.xlsx',1,strcat('A',int2str(sim_start+1),':L',int2str(sim_stop+1)));
if length(irradiance_measured_roof)<(sim_stop-sim_start), warning('Length of irradiance_measured_roof differ'), end    
irradiance_measured_facades=xlsread('Input_dispatch_model\Irradiance_Arrays 20181119.xlsx',1,strcat('M',int2str(sim_start+1),':M',int2str(sim_stop+1)));
if length(irradiance_measured_facades)<(sim_stop-sim_start), warning('Length of irradiance_measured_facades differ'), end    

%Historical import/export AH
h_imp_AH_measured=xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',2,strcat('C',int2str(sim_start+4),':C',int2str(sim_stop+4)))*MWhtokWh;
if length(h_imp_AH_measured)<(sim_stop-sim_start), warning('Length of h_imp_AH_measured differ'), end    
h_exp_AH_measured=xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',2,strcat('D',int2str(sim_start+4),':D',int2str(sim_stop+4)))*MWhtokWh;
if length(h_exp_AH_measured)<(sim_stop-sim_start), warning('Length of h_exp_AH_measured differ'), end    
end

