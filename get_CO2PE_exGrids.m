function [ CO2F_El, NREF_El, CO2F_DH, NREF_DH, marginalCost_DH, CO2F_PV, NREF_PV, CO2F_Boiler1, NREF_Boiler1, CO2F_Boiler2, NREF_Boiler2 ] = get_CO2PE_exGrids(opt_marg_factors, sim_start, sim_stop)
%% Here, the CO2 factor and Energy factor of the external grids are calculated
% The external grid production mix data read in is from the district
% heating system (Göteborg Energi) and the Swedish electrical grid (Tomorrow / tmrow.com)

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH system (Rya)
%CO2 and PE factors of the external electricity generation system
%New values based on IPCC / electricitymap.org
% El order: [biomass coal gas hydro nuclear oil solar wind geothermal unknown hydro-discharge hydro-charge]
CO2intensityProdMix_El = [230 820 490 24 12 782 45 11 38 362 46 0];

% Heat order: [Biomass-HOB Biomass-CHP Gas-HOB Gas-CHP Oil-HOB RefineryHeat WasteIncineration-CHP]
CO2intensityProdMix_Heat = [79 46 299 183 339 191 59];

%Old values based on D7.1.1
%CO2intensityProdMix_El =[230  820  490  24   12   650  22   11   38   700  46 0];

%New values based on NREF - Non-renewable Energy Factors
NREintensityProdMix_El = [0 1 1 0 1 1 0 0 0 1 0 0];

NREintensityProdMix_Heat = [0 0 1 1 1 1 0.08];

%Old values based on D7.1.1. Note we have no primary energy factor for hydro-discharge so assuming the
%same as hydro here.
%PEintensityProdMix_El = [2.99 2.45 1.93 1.01 3.29 2.75 1.25 1.03 1.02 2.47 1.01 0];

%CO2 and PE factors for local generation units
%CO2 and PE emissions intensity factors for solar PV
CO2F_PV = struct('name','CO2F_PV','type','parameter','val',CO2intensityProdMix_El(7));
NREF_PV = struct('name','NREF_PV','type','parameter','val',NREintensityProdMix_El(7));

%CO2 and PE emissions intensity factors for boiler 1. Depends on the type
%of fuel used(assume biomass now). Note that the Biomass-HOB factor is used for
%Boiler 1. This factor should be applied to the output of Boiler 1 before heat goes to the turbine.
CO2F_Boiler1 = struct('name','CO2F_Boiler1','type','parameter','val',CO2intensityProdMix_Heat(1));
NREF_Boiler1 = struct('name','NREF_Boiler1','type','parameter','val',NREintensityProdMix_Heat(1));

%CO2 and PE emissions intensity factors for boiler 2. Depends on the type
%of fuel used (assume biomass now).
CO2F_Boiler2 = struct('name','CO2F_Boiler2','type','parameter','val',CO2intensityProdMix_Heat(1));
NREF_Boiler2 = struct('name','NREF_Boiler2','type','parameter','val',NREintensityProdMix_Heat(1));

%Get Marginal cost DH (SEK / kWh)
marginalCost_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016-2017 20190313.xlsx',1,strcat('K',num2str(sim_start+1),':K',num2str(sim_stop+1)));

if (opt_marg_factors) %If the opt_MarginalEmissions is set to 1 emissions are based on the marginal production unit/mix.
    %% Marginal CO2 and NRE factors of the external grid
    %Import marginal CO2 and PE factors
    prodMix_El=xlsread('Input_dispatch_model\electricityMap - Marginal mix updated v2 - SE - 2016 - 2017.xlsx',1,strcat('B',num2str(sim_start+1),':M',num2str(sim_stop+1)));
    
    % Calculate the weighted CO2/NRE factors with the electric production mix. 
    % Note: Hydro discharge is calculated as the weighted marginal CO2/NRE of the
    % at the time of charging according to Electricity Maps algorithm. Charging is assumed to 
    % have zero CO2/NRE effect, and round cycle efficieny is assumed to be 100%.
    CO2F_El = sum(prodMix_El(:,1:length(CO2intensityProdMix_El)) .* CO2intensityProdMix_El, 2);
    NREF_El = sum(prodMix_El(:,1:length(NREintensityProdMix_El)) .* NREintensityProdMix_El, 2);
    
    %Get Marginal units DH
    marginalUnits_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016-2017 20190313.xlsx',1,strcat('C',num2str(sim_start+1),':J',num2str(sim_stop+1)));
    
    % Calculate the weighted CO2/NRE factors with the marginal district heating units.
    % For the times that the heatpump is on the margin, the production
    % factors are then calculated as the marginal electric mix divided by the COP of the heat pump (Rya).
    CO2F_DH = marginalUnits_DH(:,1:size(marginalUnits_DH,2)-1) * CO2intensityProdMix_Heat' + marginalUnits_DH(:,size(marginalUnits_DH,2)) .* CO2F_El./COP_HP_DH; 
    NREF_DH = marginalUnits_DH(:,1:size(marginalUnits_DH,2)-1) * NREintensityProdMix_Heat' + marginalUnits_DH(:,size(marginalUnits_DH,2)) .* NREF_El./COP_HP_DH;
    
else % Warning, this option has not been checked and there are some apparent errors in the factors used! amongst other problems -ZN
    el_exGrid=xlsread('Input_dispatch_model\SE.xlsx',1,'C2:L17520');
    
%     % Preinitialze the average factors to all zeros and a series that is 2
%     % years long.
%     el_exGCO2F=zeros(data_length,1);
%     el_exGPEF=zeros(data_length,1);
%     CO2F_DH=zeros(data_length,1);
%     NREF_DH=zeros(data_length,1);
    
    %calculate CO2 emissions for the external grid
    CO2_temp=0;
    PE_temp=0;
    for i=1:length(CO2intensityProdMix_El)
        CO2_temp=CO2_temp+el_exGrid(:,i)*CO2intensityProdMix_El(i);
        PE_temp=PE_temp+el_exGrid(:,i)*NREintensityProdMix_El(i);
    end
    el_exGCO2F(1:length(el_exGrid))=CO2_temp./sum(el_exGrid,2);
    el_exGCO2F(isnan(el_exGCO2F))=0;
    
    el_exGPEF(1:length(el_exGrid))=PE_temp./sum(el_exGrid,2);
    el_exGPEF(isnan(el_exGPEF))=0;
    
    %% CO2 factor and PE factor of external district heating system
    %heat_DH=xlsread('Input_dispatch_model\External_Generation.xlsx',2,'C5:V17524');
    heat_DH=xlsread('Input_dispatch_model\Produktionsdata fjärrvärme uppdelad 2016-2017_KY.xlsx',sheet,xlRange);
    heat_DH(isnan(heat_DH))=0;
    
    % Warning! There's something wrong with these factors.... 344.7 is not a valid
    % factor for instance. Do not run the code with average factors until this
    % is fixed and double checked. I don't know who wrote this. - ZN
    CO2F_DH=[72 72 72 248 248 6.7 347 347 347 248 0 0 23 23 344.7 177 0 177 98 98];
    PEF_DH=[1.41 1.41 1.41 1.09 1.09 0.76 1.31 1.31 1.31 1.09 0 0 1.39 1.39 2.38 0.78 0 0.78 0.03 0.03];
    
    %Calculate CO2 emissions for the DH
    temp_heat_DH=heat_DH;
    temp_heat_DH(:,15)=heat_DH(:,15)/COP_HP_DH;
    for i=1:length(heat_DH)
        temp=temp_heat_DH(i,:).*CO2F_DH;
        temp(15)=temp_heat_DH(i,15)*el_exGCO2F(i);     %HP of the DH uses el from exG
        CO2F_DH(i)=sum(temp)./sum(temp_heat_DH(i,:));
    end
    
    %Calculate PE use for the DH
    for i=1:length(heat_DH)
        temp=temp_heat_DH(i,:).*PEF_DH;
        temp(15)=temp_heat_DH(i,15)*el_exGPEF(i);    %HP of the DH uses el from exG
        NREF_DH(i)=sum(temp)./sum(temp_heat_DH(i,:));
    end
end

end



