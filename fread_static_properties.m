function [P1P2_dispatch, DH_export_season, DH_heating_season, BAC_savings_period, area_roofs, area_facades, BTES_param] = fread_static_properties(sim_start, sim_stop)
%This function reads static properties of model input parameters

xlRange = strcat('C',num2str(sim_start+1),':C',num2str(sim_stop+1));
%P1P2 dispatchability, DH export period and BAC saving period need to be
%re-formulated
%P1P2 dispatchability***********This could be replaced with code****
P1P2_dispatch = xlsread('Input_dispatch_model\P1P2_dispatchable.xlsx', 1, xlRange);
if length(P1P2_dispatch)<(sim_stop-sim_start), warning('Length of P1P2_dispatch differ'), end    

%DH export season
DH_export_season = xlsread('Input_dispatch_model\DH_export_season.xlsx', 1, xlRange);
if length(DH_export_season)<(sim_stop-sim_start), warning('Length of DH_export_season differ'), end    

%DH heating season
DH_heating_season = xlsread('Input_dispatch_model\DH_heating_season.xlsx', 1, xlRange);
if length(DH_heating_season)<(sim_stop-sim_start), warning('Length of DH_heating_season differ'), end    

%BAC_savings_period
BAC_savings_period = xlsread('Input_dispatch_model\BAC_parameters.xlsx', 1, xlRange);
if length(BAC_savings_period)<(sim_stop-sim_start), warning('Length of BAC_savings_period differ'), end    

%Irradiance data
irradiance_area_range = 'A2:AI2';

%Solar PV area***************************TO BE FIXED
area_roofs=xlsread('Input_dispatch_model\irradianceRoofs.xlsx', 2, irradiance_area_range);
%area_roof(isnan(area_roof))=0;

area_facades=xlsread('Input_dispatch_model\irradianceFacades.xlsx', 2, irradiance_area_range);
%area_facades(isnan(area_Facades))=0;

%BTES parameters
BTES_param=xlsread('Input_dispatch_model\UFO_TES.xlsx',2,'B2:AJ10');
BTES_param(isnan(BTES_param)) = 0;
end

