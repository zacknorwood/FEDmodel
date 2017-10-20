%% Here, the CO2 factor and PE factor of the external grids are calculated
% The external grids consists of the district heating system in G�teborg
% and the electrical grid of Sweden

%% CO2 factor and PE factor of external electricty generation system

sheet = 1;
xlRange = 'C2:L8761';
el_exGrid=xlsread('Input_data_FED_SIMULATOR\SE.xlsx',sheet,xlRange);

%CO2 and PE factors of the externla electricty generation system
%For [B12 (HYDRO)	B14 (NUCLEAR)	B19 (WIND)	B20 (OTHER)]
%These factors could changed when and if needed
%        biomass coal  gas   hydro  nuclear oil  solar wind geothermal unknown(other)
CO2F_el=[230     820   490   24     12      650  45    11   38         700];
PEF_el=[2.99     2.45  1.93  1.01   3.29    2.75 1.25  1.03 1.02       2.47];

%calculate CO2 emmission for the external grid
CO2_temp=0;
PE_temp=0;
for i=1:length(CO2F_el)
    CO2_temp=CO2_temp+el_exGrid(:,i)*CO2F_el(i);
    PE_temp=PE_temp+el_exGrid(:,i)*PEF_el(i);
end
el_exGCO2F=CO2_temp./sum(el_exGrid,2);
el_exGCO2F(isnan(el_exGCO2F))=0;

el_exGPEF=PE_temp./sum(el_exGrid,2);
el_exGPEF(isnan(el_exGPEF))=0;
%% CO2 factor and PE factor of external district heating system

sheet = 2;
xlRange = 'C5:V8764';
%heat_DH=xlsread('Input_data_FED_SIMULATOR\External_Generation.xlsx',sheet,xlRange);
heat_DH=xlsread('Input_data_FED_SIMULATOR\Produktionsdata fj�rrv�rme uppdelad 2016_KY_20170831.xlsx',sheet,xlRange);
heat_DH(isnan(heat_DH))=0;

%CO2 and PE factors for DH
%For the different heat generations units in G�teborg DH
%CO2F_DH=[[72 72 72 248 248 6.7 347 347 347 248 0 0 23 23 344.7 177 0 177 98]];
%PEF_DH=[1.41 1.41 1.41 1.09 1.09 0.76 1.31 1.31 1.31 1.09 0 0 1.39 1.39 2.38 0.78 0 0.78 0.03];
CO2F_DH=[72 72 72 248 248 6.7 347 347 347 248 0 0 23 23 344.7 177 0 177 98 0];
PEF_DH=[1.41 1.41 1.41 1.09 1.09 0.76 1.31 1.31 1.31 1.09 0 0 1.39 1.39 2.38 0.78 0 0.78 0.03 0];

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH

%Calculate CO2 emiision for the DH
temp_heat_DH=heat_DH;
temp_heat_DH(:,15)=heat_DH(:,15)/COP_HP_DH;
DH_CO2F=zeros(length(heat_DH),1);
for i=1:length(heat_DH)
    temp=temp_heat_DH(i,:).*CO2F_DH;
    temp(15)=temp_heat_DH(i,15)*el_exGCO2F(i);     %HP of the DH uses el from exG
    DH_CO2F(i)=sum(temp)./sum(temp_heat_DH(i,:));
end

%Calculate PE use for the DH
DH_PEF=zeros(length(heat_DH),1);
for i=1:length(heat_DH)
    temp=temp_heat_DH(i,:).*PEF_DH;
    temp(15)=temp_heat_DH(i,15)*el_exGPEF(i);    %HP of the DH uses el from exG
    DH_PEF(i)=sum(temp)./sum(temp_heat_DH(i,:));
end
