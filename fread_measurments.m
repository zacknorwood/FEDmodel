function [e_demand_measured, h_demand_measured,c_demand_measured,...
          h_B1_measured,h_F1_measured,...
          el_VKA1_measured,el_VKA4_measured,el_AAC_measured, h_AbsC_measured,...
          e_price_measured,...
          el_certificate,h_price_measured,tout_measured,...
          irradiance_measured_facades,irradiance_measured_roof, DC_slack, el_slack,DH_slack, h_exp_AH_measured, h_imp_AH_measured] = fread_measurments(t_init, t_len)
%This function is used to read measurment between the indicated indices

demand_range=strcat('B',int2str(t_init),':AJ',int2str(t_len+t_init-1));
gen_range=strcat('B',int2str(2+t_init),':B',int2str(2+t_len+t_init-1)); 
price_ramge=strcat('B',int2str(t_init),':B',int2str(t_len+t_init-1));
tout_ramge=strcat('B',int2str(t_init),':B',int2str(t_len+t_init-1));%'B2:B100';
irradiance_range=strcat('B',int2str(t_init),':BU',int2str(t_len+t_init-1));
el_slack_range=strcat('F',int2str(2+t_init),':F',int2str(2+t_len+t_init-1));
h_slack_range=strcat('O',int2str(2+t_init),':O',int2str(2+t_len+t_init-1));
dc_slack_range=strcat('N',int2str(2+t_init),':N',int2str(2+t_len+t_init-1));

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
h_B1_measured=xlsread('Input_dispatch_model\Boiler1 2016-2017.xls',sheet,xlRange)*1000;
h_B1_measured(isnan(h_B1_measured))=0;
    
%Measured HEAT GENERATION FROM FLUE GAS CONDENCER (F1)
sheet=4;
xlRange = gen_range;
h_F1_measured=xlsread('Input_dispatch_model\Boiler1 2016-2017.xls',sheet,xlRange)*1000;
h_F1_measured(isnan(h_F1_measured))=0;

%Measured el input for VKA1
sheet=2;
xlRange = strcat('C',int2str(2+t_init),':C',int2str(2+t_len+t_init-1));
h_VKA1_measured=xlsread('Input_dispatch_model\varmepump VKA1.xls',sheet,xlRange);
h_VKA1_measured(isnan(h_VKA1_measured))=0;
el_VKA1_measured=h_VKA1_measured/3;

%Measured el input for VKA4
sheet=2;
xlRange = strcat('C',int2str(2+t_init),':C',int2str(2+t_len+t_init-1));
h_VKA4_measured=xlsread('Input_dispatch_model\varmepump VKA4.xls',sheet,xlRange);
h_VKA4_measured(isnan(h_VKA4_measured))=0;
el_VKA4_measured=h_VKA4_measured/3;

%Measured el input for AAC
sheet=2;
xlRange = strcat('C',int2str(t_init),':C',int2str(t_len+t_init-1));
c_AAC_measured=xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',sheet,xlRange)*1000;
c_AAC_measured(isnan(c_AAC_measured))=0;
el_AAC_measured=c_AAC_measured/10;

%Measured heat input for AbsC
sheet=2;
xlRange = strcat('D',int2str(t_init),':D',int2str(t_len+t_init-1));
c_AbsC_measured=xlsread('Input_dispatch_model\abs o frikyla 2016-2017.xlsx',sheet,xlRange)*1000;
c_AbsC_measured(isnan(c_AbsC_measured))=0;
h_AbsC_measured=c_AbsC_measured/0.5;

    
%Measured el price in NordPool in SEK/kWh
sheet=2;
xlRange = price_ramge;
e_price_measured=xlsread('Input_dispatch_model\measured_el_price.xlsx',sheet,xlRange);
e_price_measured(isnan(e_price_measured))=0;
    
%Measured el certificate in SEK/kWh
sheet=2;
xlRange = price_ramge;
el_certificate=xlsread('Input_dispatch_model\el_certificate.xlsx',sheet,xlRange);
el_certificate(isnan(el_certificate))=0;
    
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

%el exgG slack bus data
sheet=1;
xlRange = el_slack_range;
el_slack=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',sheet,xlRange);
el_slack(isnan(el_slack))=0;

%District heating slack bus data
sheet=2;
xlRange = h_slack_range;
DH_slack=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',sheet,xlRange);
DH_slack(isnan(DH_slack))=0;

%District cooling slack bus data
sheet=3;
xlRange = dc_slack_range;
DC_slack=xlsread('Input_dispatch_model\supply_demand_balance.xlsx',sheet,xlRange);
DC_slack(isnan(DC_slack))=0;

irradiance_measured_roof=xlsread('Input_dispatch_model\Irradiance_Arrays 20181119.xlsx',1,'A2:L17500');
irradiance_measured_facades=xlsread('Input_dispatch_model\Irradiance_Arrays 20181119.xlsx',1,'M2:M17500');

%Historical import/export AH
sheet=2;
xlRange = strcat('C',int2str(3+t_init),':C',int2str(3+t_len+t_init-1));
h_imp_AH_measured=xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',sheet,xlRange)*1000;

sheet=2;
xlRange = strcat('D',int2str(3+t_init),':D',int2str(3+t_len+t_init-1));
h_exp_AH_measured=xlsread('Input_dispatch_model\AH_h_import_exp.xlsx',sheet,xlRange)*1000;
end

