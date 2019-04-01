clc
clear all
% Initial run
opt_RunGAMSModel=1;
opt_marg_factors=1;
synth_baseline=0;
IPCC_factors=1; %Change to the new factors for CO2 and PE
for IPCC_factors=[1]
for i=1:6
    
copyfile('result_temp_bkup.xlsx', 'result_temp.xlsx')
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
        min_totPE=1;
        min_totCO2=0;
    end
    if i==4
        min_totCost_0=0;
        min_totCost=0;
        min_totPE=0;
        min_totCO2=1;
    end
    if i==5
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0;
        min_totCO2=0.01;
    end
    if i==6
        min_totCost_0=0;
        min_totCost=1;
        min_totPE=0.59;
        min_totCO2=.01;
    end
    
% Run FED model
[to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2, Results]=FED_MAT_MAIN(opt_RunGAMSModel, opt_marg_factors, min_totCost_0, min_totCost, min_totPE, min_totCO2, synth_baseline);


% Save result files
filename=['Results_20190328_BAU=' num2str(min_totCost_0) '_MTC=' num2str(min_totCost) '_MCO2=' num2str(min_totCO2) '_MPE=' num2str(min_totPE) '_IPCC=' num2str(IPCC_factors) '_time=' num2str(length(Results)) 'h'];
save(filename,'Results')
filenamexls=[filename '.xlsx'];
copyfile('result_temp.xlsx', filenamexls)

end
end