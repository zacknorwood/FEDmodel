function [e_demand_measured, h_demand_measured,c_demand_measured,...
          h_B1_measured,h_F1_measured,e_price_measured,...
          el_cirtificate,h_price_measured,tout_measured,...
          irradiance_measured_roof,irradiance_measured_facades] = fread_measurments(t_init, t_len)
%This function is used to read mesurment between the indicated indices

demand_range=strcat('B',int2str(2+t_init-t_len),':AJ',int2str(2+t_init-1));
gen_range=strcat('B',int2str(4+t_init-t_len),':B',int2str(4+t_init-1)); 
price_ramge=strcat('B',int2str(2+t_init-t_len),':B',int2str(2+t_init-1));
tout_ramge=strcat('B',int2str(2+t_init-t_len),':B',int2str(2+t_init-1));%'B2:B100';
irradiance_range=strcat('B',int2str(2+t_init-t_len),':BU',int2str(2+t_init-1));

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

%Measured solar irradiance**************TO BE FIXED
sheet=1;
xlRange = irradiance_range;
irradiance_measured_roof=xlsread('Input_dispatch_model\irradianceRoofs.xlsx',sheet,xlRange);
irradiance_measured_roof(isnan(irradiance_measured_roof))=0;

sheet=1;
xlRange = irradiance_range;
irradiance_measured_facades=xlsread('Input_dispatch_model\irradianceFacades.xlsx',sheet,xlRange);
irradiance_measured_facades(isnan(irradiance_measured_facades))=0;
end

