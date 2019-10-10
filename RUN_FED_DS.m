clc
clear all
% Initial run
opt_RunGAMSModel=1;
opt_marg_factors=1;
synth_baseline=1;
IPCC_factors=1; %Change to the new factors for CO2 and PE
for IPCC_factors=[1]

for i=2

    
%copyfile('result_temp_bkup.xlsx', 'result_temp.xlsx')
    disp(['Case no ' num2str(i)])
    if i==1
        min_totCost_0=1;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0;
    end
    if i==2
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0;
    end 
    if i==3
        min_totCost_0=0;
        min_totCost=0;
        min_totPE=0;
        min_totCO2=1;
    end
    if i==4
        min_totCost_0=0;
        min_totCost=0;
        min_totPE=1;
        min_totCO2=0;
    end

    if i==5
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.000001;
    end
%     if i==6
%         min_totCost_0=0;
%         min_totCost=1;
%         min_totPE=0.59;
%         min_totCO2=.01;
%     end
    
%     if i==7
%         min_totCost_0=0;
%         min_totCost=0.0001;
%         min_totPE=0;
%         min_totCO2=1;
%     end
     
    if i==6
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.000005;
    end
    if i==7
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.00001;
    end
    if i==8
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.00005;
    end
    
    if i==9
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.0001;
    end
    if i==10
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.0005;
    end
    if i==11
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.001;
    end

    if i==12
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.005;
    end
    if i==13
        min_totCost_0=0;
        min_totCost=0;
        min_totPE=0;
        min_totCO2=0.01;
    end
    if i==14
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.05;
    end
    if i==15
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.1;
    end
    if i==16
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.5;
    end

    
    
% Run FED model
[to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2, Results]=FED_MAT_MAIN(opt_RunGAMSModel, opt_marg_factors, min_totCost_0, min_totCost, min_totPE, min_totCO2, synth_baseline);


% Save result files
result_path = ([cd '\results\' date '\']);
mkdir (result_path);
filename=[result_path 'Results_BAU=' num2str(min_totCost_0) '_MTC=' num2str(min_totCost) '_MCO2=' num2str(min_totCO2) '_MPE=' num2str(min_totPE) '_IPCC=' num2str(IPCC_factors) '_time=' num2str(length(Results)) 'h'];
save(filename,'Results')
filenamexls=[filename '.xlsx'];
copyfile('result_temp.xlsx', filenamexls)

end
end