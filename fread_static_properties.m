function [P1P2_dispatch, DH_heating_season, BAC_savings_period, BTES_model, BES_min_SoC] = fread_static_properties(sim_start, data_read_stop, data_length)
%This function reads static properties of model input parameters

% Set the minimum state of charge for the batteries.
BES_min_SoC = 0.20;

xlRange = strcat('C',num2str(sim_start+1),':C',num2str(data_read_stop+1));
%P1P2 dispatchability, DH export period and BAC saving period need to be
%re-formulated
%P1P2 dispatchability***********This could be replaced with code****
P1P2_dispatch = xlsread('Input_dispatch_model\P1P2_dispatchable.xlsx', 1, xlRange);

if (length(P1P2_dispatch)<data_length) || (any(isnan(P1P2_dispatch),'all'))
    error('Error: input file does not have complete data for simulation length');
end
%P1P2_dispatch(isnan(P1P2_dispatch))=0;

%DH export season -This is replaced by DH_heating_season -DS
%DH_export_season = xlsread('Input_dispatch_model\DH_export_season.xlsx', 1, xlRange);
%if (length(DH_export_season)<data_length) || (any(isnan(DH_export_season),'all'))
%    error('Error: input file does not have complete data for simulation length');
%end

%DH heating season
DH_heating_season = xlsread('Input_dispatch_model\DH_heating_season.xlsx', 1, xlRange);
if (length(DH_heating_season)<data_length) || (any(isnan(DH_heating_season),'all'))
    error('Error: input file does not have complete data for simulation length');
end

%BAC_savings_period
BAC_savings_period = xlsread('Input_dispatch_model\BAC_parameters.xlsx', 1, xlRange);
if (length(BAC_savings_period)<data_length) || (any(isnan(BAC_savings_period),'all'))
    error('Error: input file does not have complete data for simulation length');
end

%Irradiance data
%irradiance_area_range = 'A2:AI2';

%Solar PV area***************************TO BE FIXED
%area_roofs=xlsread('Input_dispatch_model\irradianceRoofs.xlsx', 2, irradiance_area_range);
%area_roof(isnan(area_roof))=0;

%area_facades=xlsread('Input_dispatch_model\irradianceFacades.xlsx', 2, irradiance_area_range);
%area_facades(isnan(area_Facades))=0;

%BTES parameters
BTES_model=xlsread('Input_dispatch_model\UFO_TES.xlsx',2,'B2:AJ10');
if (any(isnan(BTES_model),'all'))
    warning('Error: input file does not have complete data for simulation length');
end
BTES_model(isnan(BTES_model)) = 0;
end

