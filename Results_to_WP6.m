Total_invest=Results(1993).dispatch.invCost_AbsCInv+Results(1993).dispatch.invCost_BAC+Results(1993).dispatch.invCost_BITES+...
    Results(1993).dispatch.invCost_HP+Results(1993).dispatch.invCost_P2+Results(1993).dispatch.invCost_RMMC+...
    Results(1993).dispatch.invCost_TES+Results(1993).dispatch.invCost_TURB


Results(1993).dispatch.invCost_AbsCInv
Results(1993).dispatch.invCost_BAC
Results(1993).dispatch.invCost_BITES
    Results(1993).dispatch.invCost_HP
    Results(1993).dispatch.invCost_P2
    Results(1993).dispatch.invCost_RMMC
    Results(1993).dispatch.invCost_TES
    Results(1993).dispatch.invCost_TURB

    
%%
%folder='C:\Users\davste\Dropbox\WP 4.1 Model, Results, and Data\Summary of base case analysis\Simulation results\mintotCost\BAU\with marginal price'
for i=1:6
    if i==1
Case='BAU_ma';
end
if i==2
Case='BAU_seas';
end
if i==3
end
Case='no_inv_ma';
if i==4
end
Case='no_inv_seas';
if i==5
end
Case='BITES_inv_ma';
if i==6
Case='opt_inv_ma';
end

load (['results\Results_' Case])
display(['CASE ' Case])

display (['Annualized investment Cost = ,' num2str(Results(1993).dispatch.Ainv_cost) ', SEK'])
display (['Variable Cost Existing = ,' num2str(sum(Results(1993).dispatch.tot_var_cost_AH(:,2))) ', SEK'])
display (['Variable Cost New= ,' num2str(Results(1993).dispatch.var_cost_new) ', SEK'])
if i == 5 || i ==6
    display (['Variable Cost Total= ,' num2str(Results(1993).dispatch.var_cost_new+sum(Results(1993).dispatch.tot_var_cost_AH(:,2))) ' SEK'])
end
display (['Total electricity import = ,' num2str(Results(1993).dispatch.AH_el_imp_tot) ', kWh'])
display (['Total electricity export = ,' num2str(Results(1993).dispatch.AH_el_exp_tot) ', kWh'])

display (['Total heat import = ,' num2str(Results(1993).dispatch.AH_h_imp_tot) ', kWh'])
display (['Total heat export = ,' num2str(Results(1993).dispatch.AH_h_exp_tot) ', kWh'])

display (['Total cooling import = ,' num2str(sum(Results(1993).dispatch.c_AbsC(:,2))) ', kWh'])
display (['Total cooling export = ,0, kWh'])


display (['Total CO2 emission (Marginal) = ,' num2str(sum(Results(1993).dispatch.MA_AH_CO2(:,2)))])
display (['Total CO2 emission (Average)  = ,' num2str(sum(Results(1993).dispatch.AH_CO2(:,2)))])

display (['Peak CO2 emission (Marginal) = ,' num2str(max(Results(1993).dispatch.MA_AH_CO2(:,2)))])
display (['Peak CO2 emission (Average)  = ,' num2str(max(Results(1993).dispatch.AH_CO2(:,2)))])

display ' ';
end

%%
figure
plot(Results(1993).dispatch.MA_AH_CO2(:,2))
hold on
plot(Results(1993).dispatch.AH_CO2(:,2))

