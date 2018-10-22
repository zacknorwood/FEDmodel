function [P1P2_disp,DH_exp_season, BAC_sav_period,area_roof,area_facades, BTES_param ] = fread_static_properties()
%This function reads static properties of model input parameters

%P1P2 dispatchability, DH export period and BAC saving period need to be
%re-formulated
%P1P2 dispatchability***********This could be replaced with a code****
sheet=1;
xlRange = 'C2:C17545';
P1P2_disp=xlsread('Input_dispatch_model\P1P2_dispatchable.xlsx',sheet,xlRange);
P1P2_disp(isnan(P1P2_disp))=0;

%DH export season
sheet=1;
xlRange = 'C2:C17545';
DH_exp_season=xlsread('Input_dispatch_model\DH_export_season.xlsx',sheet,xlRange);
    
%BAC_savings_period
sheet=1;
xlRange = 'C2:C17545';
BAC_sav_period=xlsread('Input_dispatch_model\BAC_parameters.xlsx',sheet,xlRange);

%Irradiance data
irradiance_area_range='A2:AI2';
BITES_par_range='B2:AJ10';

%Solar PV area***************************TO BE FIXED
sheet=2;
xlRange = irradiance_area_range;
area_roof=xlsread('Input_dispatch_model\irradianceRoofs.xlsx',sheet,xlRange);
area_roof(isnan(area_roof))=0;

sheet=2;
xlRange = irradiance_area_range;
area_Facades=xlsread('Input_dispatch_model\irradianceFacades.xlsx',sheet,xlRange);
area_facades(isnan(area_Facades))=0;

%BTES parameters
sheet=2;
xlRange = BITES_par_range;
BTES_param=xlsread('Input_dispatch_model\UFO_TES.xlsx',sheet,xlRange);
BTES_param(isnan(BTES_param))=0;
end

