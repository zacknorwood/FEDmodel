function [ area_roof,area_facades, BTES_param ] = fread_static_properties()
%This function reads static properties of model input parameters

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

