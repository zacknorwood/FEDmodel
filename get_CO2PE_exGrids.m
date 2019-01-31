function [ CO2intensityFinal_El, PEintensityFinal_El, CO2intensityFinal_DH, PEintensityFinal_DH, marginalCost_DH, CO2F_PV, PEF_PV, CO2F_Boiler1, PEF_Boiler1, CO2F_Boiler2, PEF_Boiler2 ] = get_CO2PE_exGrids(opt_marg_factors)
%% Here, the CO2 factor and PE factor of the external grids are calculated
% The external grid production mix data read in is from the district
% heating system (Göteborg Energi) and the Swedish electrical grid (Tomorrow / tmrow.com)

COP_HP_DH=305/90.1;  %Based on Alexanders data, COP of the HP in DH system (Rya)
%CO2 and PE factors of the external electricity generation system
% order: biomass coal gas hydro nuclear oil solar wind geothermal unknown hydro-discharge
% Note that hydro-charge is calculated based on the other factors and hydro-discharge is set to 0 which assumes that round-trip efficiency of pumped hydro is 100%.
CO2intensityProdMix_El =[230  820  490  24   12   650  22   11   38   700  0];
PEintensityProdMix_El = [2.99 2.45 1.93 1.01 3.29 2.75 1.25 1.03 1.02 2.47 0];
numHours=24*366+24*365; % 2 years of hourly data. Note: 2016 was a leap year so 366 days.

%CO2 and PE factors for local generation units
%CO2 and PE emissions intensity factors for solar PV
CO2F_PV = struct('name','CO2F_PV','type','parameter','val',CO2intensityProdMix_El(7));
PEF_PV = struct('name','PEF_PV','type','parameter','val',PEintensityProdMix_El(7));

%CO2 and PE emissions intensity factors for boiler 1. Depends on the type
%of fuel used(assume wood chips now).
CO2F_Boiler1 = struct('name','CO2F_Boiler1','type','parameter','val',12);
PEF_Boiler1 = struct('name','PEF_Boiler1','type','parameter','val',1.33);

%CO2 and PE emissions intensity factors for boiler 2. Depends on the type
%of fuel used (assume pellets now).
CO2F_Boiler2 = struct('name','CO2F_Boiler2','type','parameter','val',23);
PEF_Boiler2 = struct('name','PEF_Boiler2','type','parameter','val',1.39);

if (opt_marg_factors) %If the opt_MarginalEmissions is set to 1 the default is to calculate the marginal emissions.
    %% Marginal CO2 and PE factors of the external grid
    %Import marginal CO2 and PE factors, marginal DH cost
    prodMix=xlsread('Input_dispatch_model\electricityMap - Marginal mix updated v2 - SE - 2016 - 2017.xlsx',1,'B2:M17545');
%     % Set missing data to zero
%     prodMix(isnan(prodMix))=0;
    
    % Calculate the weighted CO2/PE factors with the production mix. 
    % Note: Hydro-charge is calculated as the weighted marginal CO2/PE of the
    % rest of the system at the time of charging. Discharging is assumed to 
    % have zero CO2/PE effect, and round cycle efficieny is assumed to be 100%.
    CO2intensityFinal_El = sum(prodMix(:,1:length(CO2intensityProdMix_El)) .* CO2intensityProdMix_El, 2);
    PEintensityFinal_El = sum(prodMix(:,1:length(PEintensityProdMix_El)) .* PEintensityProdMix_El, 2);
    
    %Get Marginal CO2F and PEF of DH
    CO2intensityFinal_DH=xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016 20181113.xlsx',1,'Y31:Y10230');
    PEintensityFinal_DH=xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016 20181113.xlsx',1,'Z31:Z10230');
    
    %Empty data (nan) in the spreadsheet is for the times that the heatpump is on the
    %margin and the marginal production factors are then calculated based on
    %the COP of the heat pump (Rya) and the marginal electrical consumption.
    CO2intensityFinal_DH(isnan(CO2intensityFinal_DH))=CO2intensityFinal_El(isnan(CO2intensityFinal_DH))/COP_HP_DH;
    PEintensityFinal_DH(isnan(PEintensityFinal_DH))=PEintensityFinal_El(isnan(PEintensityFinal_DH))/COP_HP_DH;
    
else % Warning, this option has not been checked and there are some apparent errors in the factors used! -ZN
    el_exGrid=xlsread('Input_dispatch_model\SE.xlsx',1,'C2:L17520');
    
    % Preinitialze the average factors to all zeros and a series that is 2
    % years long.
    el_exGCO2F=zeros(numHours,1);
    el_exGPEF=zeros(numHours,1);
    CO2intensityFinal_DH=zeros(numHours,1);
    PEintensityFinal_DH=zeros(numHours,1);
    
    %calculate CO2 emissions for the external grid
    CO2_temp=0;
    PE_temp=0;
    for i=1:length(CO2intensityProdMix_El)
        CO2_temp=CO2_temp+el_exGrid(:,i)*CO2intensityProdMix_El(i);
        PE_temp=PE_temp+el_exGrid(:,i)*PEintensityProdMix_El(i);
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
        CO2intensityFinal_DH(i)=sum(temp)./sum(temp_heat_DH(i,:));
    end
    
    %Calculate PE use for the DH
    for i=1:length(heat_DH)
        temp=temp_heat_DH(i,:).*PEF_DH;
        temp(15)=temp_heat_DH(i,15)*el_exGPEF(i);    %HP of the DH uses el from exG
        PEintensityFinal_DH(i)=sum(temp)./sum(temp_heat_DH(i,:));
    end
end

%Get Marginal cost DH, convert to SEK per kWh
marginalCost_DH = xlsread('Input_dispatch_model\Produktionsdata med timpriser och miljodata 2016 20181113.xlsx',1,'X31:X10230')/1000;

end
% for tt=1:length(DH_CO2F_ma)
%     if isnan(DH_CO2F_ma(tt))
%         DH_CO2F_ma(tt)=EL_CO2F_ma(tt)/COP_RYA_VP;
%         DH_PEF_ma(tt)=EL_PEF_ma(tt)/COP_RYA_VP;
%     end
% end

