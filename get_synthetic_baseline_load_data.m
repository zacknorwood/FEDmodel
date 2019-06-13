function [el_demand, h_demand, c_demand] = get_synthetic_baseline_load_data(start_datetime, end_datetime, time_resolution)
% get_synthetic_baseline_load_data - Retrieves load data for synthetic
% baseline using in-function specified load files.

%outputArg1 = inputArg1;
%outputArg2 = inputArg2;

if nargin==2
    time_resolution = 'hourly';
elseif nargin==0
    warning('No start_datetime or end_datetime specified, using 2019-01-01 00:00 and 2019-03-31 23:00 respectively with a 1 hour step size')
    start_datetime = datetime(2019,1,1,0,0,0);
    end_datetime = datetime(2019,03,31,23,0,0);
    time_resolution = 'hourly';
end
%% Input data folder & file names
measurements_data_folder = 'Input_dispatch_model\synthetic_baseline_data\measurement_data\';
ann_data_folder = 'Input_dispatch_model\synthetic_baseline_data\ann_data\';

h_export_file = 'Värme export till GBG O0007008_fj_201_v1_2018-10-01_2019-06-04.xls';
h_import_file = 'Värme import från GBG O0007008_fj_103_v1_2018-10-01_2019-06-04.xls';
boiler_1_file = 'Värme panna 1 O0007008_fj_101_v1_2018-10-01_2019-06-04.xls';
vka_1_file = 'Värme VKA1 O0007008_fj_001_v1_2018-10-01_2019-06-04.xls';
vka_2_file = 'Värme VKA2 O0007008_fj_104_v1_2018-10-01_2019-06-04.xls';
vka_4_file = 'Värme VKA4 O0007008_fj_002_v1_2018-10-01_2019-06-04.xls';
fgc_file = 'Värme rökgaskondensor panna 1.xlsx';

%% Create series of simulation steps
%simulation_steps = start_datetime:hours(step_hours):end_datetime;

%% Electricity demand reading and calculation



%% Heat demand reading and calculation
% Heat load = 
% Total production
% - Measured demand active buildings
% + Calculated demand active buildings

    function output = read_xls(file_path, time_resolution)
        output = readtable(file_path, 'ReadVariableNames',true);
        output.Date = datetime(output.Tidpunkt, 'format', 'yyyy-MM-dd HH:mm:ss');
        
        output = removevars(output, {'Tidpunkt', 'x_ndratAv', 'Status', 'Norm_'});
        output.V_rde = strrep(output.V_rde, " ", "");
        output.V_rde = strrep(output.V_rde, ",", ".");
        output.V_rde = str2double(output.V_rde);
        
        output = table2timetable(output);
        output = sortrows(output);
        
        output = retime(output, time_resolution, 'previous')
    end

% Read files
h_export = read_xls(strcat(measurements_data_folder , h_export_file), time_resolution);
h_import = read_xls(strcat(measurements_data_folder , h_import_file), time_resolution);
boiler_1_production = read_xls(strcat(measurements_data_folder , boiler_1_file), time_resolution);
vka_1_production = read_xls(strcat(measurements_data_folder , vka_1_file), time_resolution);
vka_2_production = read_xls(strcat(measurements_data_folder , vka_2_file), time_resolution);
vka_4_production = read_xls(strcat(measurements_data_folder , vka_4_file), time_resolution);

% fgc_file on different format requiring separate file reading
fgc_production = readtable(strcat(measurements_data_folder , fgc_file), 'ReadVariableNames',true, 'Range','A3:B4454');
fgc_times = table2cell(fgc_production(:,1));
fgc_date = datetime(fgc_times,'InputFormat','yyyy-MM-dd HH', 'format', 'yyyy-MM-dd HH:mm:ss');
fgc_production.Date = fgc_date;
clearvars fgc_date fgc_times
fgc_production = removevars(fgc_production, {'Var1'});
fgc_production = table2timetable(fgc_production);
fgc_production = retime(fgc_production, time_resolution, 'previous');
% Calculate net load

%% Cooling demand reading and calculation


end

