% Script for clearing up data from Chalmers fastigheter
% The imported CAFH data can be imported as is through matlabs data
% importer.

% Get the relavant data, here you must replace the names for the 
log_data = friskiskyla.FJKHM_E_60135_001_CNT;

clear data_miss_idx val_diff
for i = 1:length(log_data)
    
    %First value can not be compared to previous values so set as missing
    if i == 1
        
        data_miss_idx(i) = 1;
        
        val_diff = 0;
        
    else
        
        % If logged data is a NaN set as missing data
        if isnan(log_data(i)) 
            
            data_miss_idx(i) = 1;
            
            val_diff(i) = 0;
            
        else
            
            % If previous logged data is a NaN set as missing data (since
            % no delta energy use can be calculated)
            if isnan(log_data(i-1))
            
                val_diff(i) = 0;
                
                data_miss_idx(i) = 1;
            
            %Otherwise calculate the diffrence between logged values to get consumption for the hour.    
            else
                
                val_diff(i) = log_data(i) - log_data(i-1);
        
                data_miss_idx(i) = 0;
                        
            end
            
        end
        
    end
end

friskiskyla.val_diff  = val_diff';

friskiskyla.miss_idx = data_miss_idx';




        
        
            