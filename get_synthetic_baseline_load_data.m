function [el_demand, h_demand, c_demand] = untitled2(inputArg1,inputArg2)
% get_synthetic_baseline_load_data - Retrieves load data for synthetic
% baseline using in-function specified load files.

%outputArg1 = inputArg1;
%outputArg2 = inputArg2;
%% Input data folder & file names
measurements_data_folder = 'Input_dispatch_model\synthetic_baseline_data\measurement_data\';
ann_data_folder = 'Input_dispatch_model\synthetic_baseline_data\ann_data\';

h_export_file = 'Värme export till GBG O0007008_fj_201_v1_2018-10-01_2019-06-04.xls';
h_import_file = 'Värme import från GBG O0007008_fj_103_v1_2018-10-01_2019-06-04.xls';
boiler_1_file = 'Värme panna 1 O0007008_fj_101_v1_2018-10-01_2019-06-04.xls';
fgc_file = 'Värme rökgaskondensor panna 1.xlsx';
vka_1_file = 'Värme VKA1 O0007008_fj_001_v1_2018-10-01_2019-06-04.xls';
vka_2_file = 'Värme VKA2 O0007008_fj_104_v1_2018-10-01_2019-06-04.xls';
vka_4_file = 'Värme VKA4 O0007008_fj_002_v1_2018-10-01_2019-06-04.xls';

%% Electricity demand reading and calculation



%% Heat demand reading and calculation
% Heat load = 
% Total production
% - Measured demand active buildings
% + Calculated demand active buildings

% Total production
h_export = readtable(strcat(measurements_data_folder , h_export_file), 'ReadVariableNames',true)
h_export.Date = datetime(h_export.Tidpunkt, 'format', 'yyyy-MM-dd HH:mm:ss')

%% Cooling demand reading and calculation


end

