function [el_demand, h_demand, c_demand,...
    h_Boiler1_0, h_FlueGasCondenser1_0,...
    el_VKA1_0, el_VKA4_0, c_AbsC_0,...
    el_price,...
    el_certificate, tout,...
    irradiance_measured_facades,irradiance_measured_roof, c_DC_slack, el_exG_slack,h_DH_slack, h_exp_AH_measured, h_imp_AH_measured] = fread_measurements(sim_start, data_read_stop, data_length)

%This function is used to read measurment between the indicated indices

MWhtokWh = 1000; %Conversion factor MWh to kWh
COP_VKA1 = 3; %COP value used for calculating historical heat generation
COP_VKA4 = 3; %COP value used for calculating historical heat generation
c_COP_VKA1 = 1.8; %COP value used for calculating historical heat generation
c_COP_VKA4 = 1.8; %COP value used for calculating historical heat generation

demand_range=strcat('B',int2str(sim_start+1),':AJ',int2str(data_read_stop+1));
%Measured electricity demand in kW
% New command for Matlab 2019a
% el_demand = readmatrix('Input_dispatch_model\measured_demand.xlsx','Sheet',1,'Range',demand_range,'MissingRule','error');
el_demand=xlsread('Input_dispatch_model\measured_demand.xlsx',1,demand_range);
if (length(el_demand)<data_length) || (any(isnan(el_demand),'all'))
    warning('Error: input file does not have complete data for simulation length');
end
el_demand(isnan(el_demand))=0;

%Measured heat demand in kW
h_demand=xlsread('Input_dispatch_model\measured_demand.xlsx',2,demand_range);
if (length(h_demand)<data_length) || (any(isnan(h_demand),'all'))
    warning('Error: input file does not have complete data for simulation length');
end
h_demand(isnan(h_demand))=0;

%Measured cooling demand in kW
c_demand=xlsread('Input_dispatch_model\measured_demand.xlsx',3,demand_range);
if (length(c_demand)<data_length) || (any(isnan(c_demand),'all'))
    warning('Error: input file does not have complete data for simulation length');
end
c_demand(isnan(c_demand))=0; 

% set nonAH building demand to 0;
% this option should be taken as input from inital set up, also the BID
% could be implemented more elegant -DS
% el_exG_slack below relies on el_demand representing only AH buildings -AK
NonAH_excluded=1;
if NonAH_excluded==1
NonAH_el_BID=[2,3,4,7,28,29,30,35];
el_demand(:,NonAH_el_BID)=0;

NonAH_h_BID=[2,3,4,5,15,28,30,35];
h_demand(:,NonAH_h_BID)=0;

NonAH_c_BID=[2,3,4,5,7,9,14,15,24,28,30,35];
c_demand(:,NonAH_c_BID)=0;
end


gen_range=strcat('B',int2str(sim_start+3),':B',int2str(data_read_stop+3));
%Measured HEAT GENERATION FROM THERMAL BOILER (B1) converted to kWh
h_Boiler1_0=xlsread('Input_dispatch_model\Boiler1 2016-2017.xls',3,gen_range)*MWhtokWh;
if (length(h_Boiler1_0)<data_length) || (any(isnan(h_Boiler1_0),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%h_Boiler1_0(isnan(h_Boiler1_0))=0;

%Measured HEAT GENERATION FROM FLUE GAS CONDENSER (F1) converted to kWh
h_FlueGasCondenser1_0=xlsread('Input_dispatch_model\Boiler1 2016-2017.xls',4,gen_range)*MWhtokWh;
if (length(h_FlueGasCondenser1_0)<data_length) || (any(isnan(h_FlueGasCondenser1_0),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%h_FlueGasCondenser1_0(isnan(h_FlueGasCondenser1_0))=0;

%Measured el input for VKA1
el_VKA1_0=xlsread('Input_dispatch_model\varmepump VKA1.xls',2,gen_range);
if (length(el_VKA1_0)<data_length) || (any(isnan(el_VKA1_0),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%el_VKA1_0(isnan(el_VKA1_0))=0;
%el_VKA1_measured=h_VKA1_measured/3; Removed by AK, previously h_VKA1 (col C) was
%read and divided by COP to get approximate electricity use

%Measured el input for VKA4
el_VKA4_0=xlsread('Input_dispatch_model\varmepump VKA4.xls',2,gen_range);
if (length(el_VKA4_0)<data_length) || (any(isnan(el_VKA4_0),'all'))
    warning('Error: input file does not have complete data for simulation length');
end
el_VKA4_0(isnan(el_VKA4_0))=0;

%el_VKA4_measured=h_VKA4_measured/3; Removed by AK, previously h_VKA4 (col C) was
%read and divided by COP to get approximate electricity use

%Measured el input for AAC converted to kWh
%c_AAC_0=xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',2,strcat('C',int2str(sim_start+1),':C',int2str(sim_stop+1)))*MWhtokWh;
%c_AAC_0(isnan(c_AAC_0))=0;
%el_AAC_0=c_AAC_0/10;

%Measured heat input for AbsC converted to kWh
c_AbsC_0=xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',2,strcat('D',int2str(sim_start+1),':D',int2str(data_read_stop+1)))*MWhtokWh;
if (length(c_AbsC_0)<data_length) || (any(isnan(c_AbsC_0),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%c_AbsC_0(isnan(c_AbsC_0))=0;

% Shouldn't this be calculated in the GAMS code based on the COP of the AbsC? - ZN
%h_AbsC_0=c_AbsC_0/0.5;

price_range=strcat('B',int2str(sim_start+1),':B',int2str(data_read_stop+1));
%Measured el price in NordPool in SEK/kWh
el_price=xlsread('Input_dispatch_model\measured_el_price.xlsx',2,price_range);
if (length(el_price)<data_length) || (any(isnan(el_price),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%el_price(isnan(el_price))=0;

%Measured el certificate in SEK/kWh
el_certificate=xlsread('Input_dispatch_model\el_certificate.xlsx',2,price_range);
if (length(el_certificate)<data_length) || (any(isnan(el_certificate),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%el_certificate(isnan(el_certificate))=0;

%Measured heat price in GE's system in SEK/kWh
%h_price=xlsread('Input_dispatch_model\measured_h_price.xlsx',2,price_range);
%h_price(isnan(h_price))=0;

%Measured outdoor temprature
tout=xlsread('Input_dispatch_model\measured_tout.xlsx',2,price_range);
if (length(tout)<data_length) || (any(isnan(tout),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%tout(isnan(tout))=0;



%Irradiance on roof and facade solar PV arrays
irradiance_measured_roof=xlsread('Input_dispatch_model\Irradiance_Arrays 20181119.xlsx',1,strcat('A',int2str(sim_start+1),':L',int2str(data_read_stop+1)));
if (length(irradiance_measured_roof)<data_length) || (any(isnan(irradiance_measured_roof),'all'))
    error('Error: input file does not have complete data for simulation length');
end

irradiance_measured_facades=xlsread('Input_dispatch_model\Irradiance_Arrays 20181119.xlsx',1,strcat('M',int2str(sim_start+1),':M',int2str(data_read_stop+1)));
if (length(irradiance_measured_facades)<data_length) || (any(isnan(irradiance_measured_facades),'all'))
    error('Error: input file does not have complete data for simulation length');
end

%Historical import/export AH
h_imp_AH_measured=xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',2,strcat('C',int2str(sim_start+4),':C',int2str(data_read_stop+4)))*MWhtokWh;
if (length(h_imp_AH_measured)<data_length) || (any(isnan(h_imp_AH_measured),'all'))
    error('Error: input file does not have complete data for simulation length');
end

h_exp_AH_measured=xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',2,strcat('D',int2str(sim_start+4),':D',int2str(data_read_stop+4)))*MWhtokWh;
if (length(h_exp_AH_measured)<data_length) || (any(isnan(h_exp_AH_measured),'all'))
    error('Error: input file does not have complete data for simulation length');
end    
    
h_DH_slack1=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',2,strcat('P',int2str(sim_start+1),':P',int2str(data_read_stop+1)));
if (length(h_DH_slack1)<data_length) || (any(isnan(h_DH_slack1),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%h_DH_slack(isnan(h_DH_slack))=0;

%District heating slack bus data
net_h_prod = h_imp_AH_measured - h_exp_AH_measured + h_Boiler1_0 + h_FlueGasCondenser1_0 + el_VKA1_0*COP_VKA1 + el_VKA4_0*COP_VKA4;
ah_h_demand = sum(h_demand(:,[1,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,31,32,33,34]), 2);
h_DH_slack = ah_h_demand - net_h_prod;
diff_h=h_DH_slack-h_DH_slack1;

%District cooling slack bus data
c_DC_slack1=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',3,strcat('N',int2str(sim_start+1),':N',int2str(data_read_stop+1)));
if (length(c_DC_slack1)<data_length) || (any(isnan(c_DC_slack1),'all'))
    error('Error: input file does not have complete data for simulation length');
%c_DC_slack(isnan(c_DC_slack))=0;
end

%District cooling slack bus data
net_c_prod = c_AbsC_0 + el_VKA1_0*c_COP_VKA1 + el_VKA4_0*c_COP_VKA4;
ah_c_demand = sum(c_demand(:,[1,6,8,10,11,12,13,16,17,18,19,20,21,22,23,25,26,27,29,31,32,33,34]), 2);
c_DC_slack = ah_c_demand - net_c_prod;
diff_c=c_DC_slack-c_DC_slack1;


%el exgG slack bus data
el_exG_slack1=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',1,strcat('F',int2str(sim_start+1),':F',int2str(data_read_stop+1)));
if (length(el_exG_slack1)<data_length) || (any(isnan(el_exG_slack1),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%el_exG_slack(isnan(el_exG_slack))=0;

%electricity imports
e_imp_AH_measured=xlsread('Input_dispatch_model\AH_el_import.xlsx',1,strcat('C',int2str(sim_start+1),':C',int2str(data_read_stop+1)));
if (length(e_imp_AH_measured)<data_length) || (any(isnan(e_imp_AH_measured),'all'))
    error('Error: input file does not have complete data for simulation length');
end

%electricity slack bus data
net_e_prod = e_imp_AH_measured;
ah_e_demand = sum(el_demand(:,:), 2);
el_exG_slack_new = ah_e_demand - net_e_prod;
diff_e=el_exG_slack_new-el_exG_slack1;
el_exG_slack=el_exG_slack1;


end

