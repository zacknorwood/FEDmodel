%If CAFH data is in hourly values the code below aggregates it to hourly
%values
%Create hourly values for Chalmers fastigheter data

%Change to the dataset you are intersted in below.
data_m = [friskiskyla.val_diff];
missing_m = [friskiskyla.miss_idx];

%First index 
start_idx = 2;

% Set ending index so it ends on data for a full hour.
end_idx  = 34327;


%Checks so data end on full hour (based on that data has 10 min res)
while mod((end_idx-(start_idx-1)),6) ~= 0 
    
      error('Wrong index')
%     end_idx = end_idx -1;
end


%Extract data
data_use = data_m(start_idx:end_idx);

miss_use = missing_m(start_idx:end_idx);

%Reshape and sum up data for each hour (if other then 10 min data this
%needs to be changed)
data_use = reshape(data_use,6,length(data_use)/6)';

miss_use = reshape(miss_use,6,length(miss_use)/6)';

data_sum = sum(data_use,2);

miss_sum = sum(miss_use,2);

%If a missing data point is part of the summed data for an hour mark that
%data point as missing.
miss_sum(miss_sum>1) = 1;

kb_friskis = data_sum';

kb_friskis_tot_idx = miss_sum';