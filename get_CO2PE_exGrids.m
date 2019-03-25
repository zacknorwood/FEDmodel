function [ CO2F_El, NREF_El, CO2F_DH, NREF_DH, marginalCost_DH, CO2F_PV, NREF_PV, CO2F_Boiler1, NREF_Boiler1, CO2F_Boiler2, NREF_Boiler2 ] = get_CO2PE_exGrids(opt_marg_factors, sim_start, data_read_stop, data_length)
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
marginalCost_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016-2017 20190313.xlsx',1,strcat('K',num2str(sim_start+1),':K',num2str(data_read_stop+1)));
if (length(marginalCost_DH)<data_length) || (any(isnan(marginalCost_DH),'all'))
    error('Error: input file does not have complete data for simulation length');
end

if (opt_marg_factors) %If the opt_MarginalEmissions is set to 1 emissions are based on the marginal production unit/mix.
    %% Marginal CO2 and NRE factors of the external grid
    %Import marginal CO2 and PE factors
    prodMix_El=xlsread('Input_dispatch_model\electricityMap - Marginal mix updated v2 - SE - 2016 - 2017.xlsx',1,strcat('B',num2str(sim_start+1),':M',num2str(data_read_stop+1)));
    if (length(prodMix_El)<data_length) || (any(isnan(prodMix_El),'all'))
        error('Error: input file does not have complete data for simulation length');
    end
    
    % Calculate the weighted CO2/NRE factors with the electric production mix.
    % Note: Hydro discharge is calculated as the weighted marginal CO2/NRE of the
    % at the time of charging according to Electricity Maps algorithm. Charging is assumed to
    % have zero CO2/NRE effect, and round cycle efficieny is assumed to be 100%.
    CO2F_El = sum(prodMix_El(:,1:length(CO2intensityProdMix_El)) .* CO2intensityProdMix_El, 2);
    NREF_El = sum(prodMix_El(:,1:length(NREintensityProdMix_El)) .* NREintensityProdMix_El, 2);
    
    %Get Marginal units DH
    marginalUnits_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016-2017 20190313.xlsx',1,strcat('C',num2str(sim_start+1),':J',num2str(data_read_stop+1)));
    if (length(marginalUnits_DH)<data_length) || (any(isnan(marginalUnits_DH),'all'))
        error('Error: input file does not have complete data for simulation length');
    end
    % Calculate the weighted CO2/NRE factors with the marginal district heating units.
    % For the times that the heatpump is on the margin, the production
    % factors are then calculated as the marginal electric mix divided by the COP of the heat pump (Rya).
    CO2F_DH = marginalUnits_DH(:,1:size(marginalUnits_DH,2)-1) * CO2intensityProdMix_Heat' + marginalUnits_DH(:,size(marginalUnits_DH,2)) .* CO2F_El./COP_HP_DH;
    NREF_DH = marginalUnits_DH(:,1:size(marginalUnits_DH,2)-1) * NREintensityProdMix_Heat' + marginalUnits_DH(:,size(marginalUnits_DH,2)) .* NREF_El./COP_HP_DH;
    
else
    error('Average emissions/price option is not currently implemented, set opt_marg_factors to 1');
end

end



