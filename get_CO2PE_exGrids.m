function [ CO2F_El, PE_El, CO2F_DH, PE_DH, marginalCost_DH, CO2F_PV, PE_PV, CO2F_Boiler1, PE_Boiler1, CO2F_Boiler2, PE_Boiler2 ] = get_CO2PE_exGrids(opt_marg_factors, GE_factors, sim_start, data_read_stop, data_length, synth_baseline)
%% Here, the CO2 factor and Primary Energy factor of the external grids are calculated
% The external grid production mix data read in is from the district
% heating system (Göteborg Energi) and the Swedish electrical grid (Tomorrow / tmrow.com)

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH system (Rya)

%CO2 (Carbon Dioxide equivalent) and NRPE (Non-renewable Primary Energy) factors of the external electricity generation and district heating system
%Values based on IPCC / electricitymap.org / IINAS

% El order: [biomass coal gas hydro nuclear oil solar wind geothermal unknown hydro-discharge hydro-charge]
CO2intensityProdMix_El = [230 820 490 24 12 782 45 11 38 362 46 0];
PEintensityProdMix_El = [0.09 2.44 1.93 0.01 3.27 2.74 0.23 0.03 0.02 2.06 0.02 0];

% Heat order: [Biomass-HOB Biomass-CHP BioGas-HOB Gas-CHP Oil-HOB RefineryHeat WasteIncineration-CHP]
CO2intensityProdMix_Heat = [79 46 79 183 339 43 59];
PEintensityProdMix_Heat = [0.03 0.02 1.18 0.72 1.19 0.15 0.08];

% Changes the CO2 and PE factors for District Heating when running with the
% GE Industry Case flag
if(GE_factors)
    %CO2 and PE factors of the District Heating system in the Göteborg
    %Energi Industry Case
    %Values based on Göteborg Energi from Värmemarknadskommitten
    % Heat order: [Biomass-HOB Biomass-CHP BioGas-HOB Gas-CHP Oil-HOB RefineryHeat WasteIncineration-CHP]
    CO2intensityProdMix_Heat = [21 8 14 142 395 0 113];
    PEintensityProdMix_Heat = [0.13 0.02 0.18 0.62 1.5 0 0.03];
end

%CO2 and PE factors for local generation units
%CO2 and PE emissions intensity factors for solar PV
CO2F_PV = struct('name','CO2F_PV','type','parameter','val',CO2intensityProdMix_El(7));
PE_PV = struct('name','PE_PV','type','parameter','val',PEintensityProdMix_El(7));

%CO2 and PE emissions intensity factors for boiler 1. Depends on the type
%of fuel used(assume biomass now). Note that the Biomass-HOB factor is used for
%Boiler 1. This factor should be applied to the output of Boiler 1 before heat goes to the turbine.
CO2F_Boiler1 = struct('name','CO2F_Boiler1','type','parameter','val',CO2intensityProdMix_Heat(1));
PE_Boiler1 = struct('name','PE_Boiler1','type','parameter','val',PEintensityProdMix_Heat(1));

%CO2 and PE emissions intensity factors for boiler 2. Depends on the type
%of fuel used (assume biomass now).
CO2F_Boiler2 = struct('name','CO2F_Boiler2','type','parameter','val',CO2intensityProdMix_Heat(1));
PE_Boiler2 = struct('name','PE_Boiler2','type','parameter','val',PEintensityProdMix_Heat(1));

%Get Marginal cost DH (SEK / kWh)
marginalCost_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016-2017 20190313.xlsx',1,strcat('K',num2str(sim_start+1),':K',num2str(data_read_stop+1)));
if (length(marginalCost_DH)<data_length) || (any(isnan(marginalCost_DH),'all'))
    error('Error: input file does not have complete data for simulation length');
end

if (opt_marg_factors) %If the opt_MarginalEmissions is set to 1 emissions are based on the marginal production unit/mix.
    %% Marginal CO2 and NRE factors of the external grid
    %Import marginal CO2 and PE factors
    if synth_baseline == 1
        prodMix_El=xlsread('Input_dispatch_model\electricityMap - Marginal mix SE 2019 August.xlsx',1,strcat('B',num2str(sim_start+1),':M',num2str(data_read_stop+1)));
    else
        prodMix_El=xlsread('Input_dispatch_model\electricityMap - Marginal mix updated v2 - SE - 2016 - 2017.xlsx',1,strcat('B',num2str(sim_start+1),':M',num2str(data_read_stop+1)));
    end
        
    if (length(prodMix_El)<data_length) || (any(isnan(prodMix_El),'all'))
        error('Error: input file does not have complete data for simulation length');
    end
    
    % Calculate the weighted CO2/PE factors with the electric production mix.
    % Note: Hydro discharge is calculated as the weighted marginal CO2/PE
    % of the grid at the time of charging according to Electricity Maps
    % algorithm. Charging is assumed to have zero CO2/PE effect, and round
    % cycle efficiency is assumed to be 100%.
    CO2F_El = sum(prodMix_El(:,1:length(CO2intensityProdMix_El)) .* CO2intensityProdMix_El, 2);
    PE_El = sum(prodMix_El(:,1:length(PEintensityProdMix_El)) .* PEintensityProdMix_El, 2);
    
    %Get Marginal units DH
    
if synth_baseline == 1   
    marginalUnits_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2019 August.xlsx',1,strcat('C',num2str(sim_start+1),':J',num2str(data_read_stop+1)));
else
    marginalUnits_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016-2017 20190313.xlsx',1,strcat('C',num2str(sim_start+1),':J',num2str(data_read_stop+1)));
end

    if (length(marginalUnits_DH)<data_length) || (any(isnan(marginalUnits_DH),'all'))
        error('Error: input file does not have complete data for simulation length');
    end
    % Calculate the weighted CO2/PE factors with the marginal district heating units.
    % For the times that the heatpump is on the margin, the production
    % factors are then calculated as the marginal electric mix divided by the COP of the heat pump (Rya).
    CO2F_DH = marginalUnits_DH(:,1:size(marginalUnits_DH,2)-1) * CO2intensityProdMix_Heat' + marginalUnits_DH(:,size(marginalUnits_DH,2)) .* CO2F_El./COP_HP_DH;
    PE_DH = marginalUnits_DH(:,1:size(marginalUnits_DH,2)-1) * PEintensityProdMix_Heat' + marginalUnits_DH(:,size(marginalUnits_DH,2)) .* PE_El./COP_HP_DH;
   
else
    error('Average emissions/price option is not currently implemented, set opt_marg_factors to 1');
end

end
