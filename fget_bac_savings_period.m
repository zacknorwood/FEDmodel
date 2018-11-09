function BAC_savings_factor = fget_bac_savings_period(times)
% The function assumes that mod(time, 24) represents the time of day, 
% i.e. mod(135, 24) = 15 translates to 15:00
% This assumption is from time representation in tout_2016-2017.xlsx
% Savings period before May (starts in hour 2905) and after September (ends
% in hour 6576)
savings_before = 2905;
savings_after = 6576;
% day_starts at 08:00
% day ends at 20:00
BAC_savings_factor =  struct('name', 'BAC_savings_factor', 'type', 'parameter', 'form', 'full');
BAC_savings_factor.val = zeros(length(times.uels, 1));

for hour = 1:length(times.uels)
   if hour >= savings_after || hour < savings_before
       % BAC savings period. "||" is matlab OR operator. 
       time_of_day = mod(hour-known_seven_am, 24);
       if time_of_day >= 8 && time_of_day < 20
           BAC_savings_factor.val(hour) = BAC_daytime_savings;
       else
           BAC_savings_factor.val(hour) = BAC_nighttime_savings;
       end
   else
       BAC_savings_factor.val(hour) = 0;
   end
    
end
