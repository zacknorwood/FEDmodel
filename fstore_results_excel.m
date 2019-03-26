function [to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2] = fstore_results_excel(Results,to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2, sim_start, sim_stop, t);
% This function extract the first hour of the scheduled dispatch and put it
% into an array that can be exported to excel for analysis 

tic

%Start putting the values at row t

%% ELECTRICITY DATA
% (1,2) is for taking the value from the first hour (of the 10 hour
% dispatch) and column 2 is for the power/cost
if Results(t).dispatch.model_status(1)~= 1 && Results(t).dispatch.model_status(1)~= 6  
to_excel_co2(t,7)=Results(t).dispatch.model_status(1);
else
to_excel_el(t,1)=t;
to_excel_el(t,2)=Results(t).dispatch.el_TURB(1,2); 
to_excel_el(t,4)=Results(t).dispatch.el_PV(1,2); 
to_excel_el(t,6)=Results(t).dispatch.el_imp_AH(1,2);
to_excel_el(t,8)=-Results(t).dispatch.el_AbsC(1,2);
to_excel_el(t,10)=-Results(t).dispatch.el_VKA1(1,2);
to_excel_el(t,12)=-Results(t).dispatch.el_VKA4(1,2);
to_excel_el(t,14)=-Results(t).dispatch.el_HP(1,2);
to_excel_el(t,16)=-Results(t).dispatch.el_RMMC(1,2);
to_excel_el(t,18)=-Results(t).dispatch.el_RM(1,2);

to_excel_el(t,20)=Results(t).dispatch.el_slack(1,2);
to_excel_el(t,22)=Results(t).dispatch.el_slack_var(1,2);
to_excel_el(t,24)=Results(t).dispatch.BES_en(find(Results(t).dispatch.BES_en(:,2)==33,1),3); 
% find the energy storage at node/BID 33 and the first value(e.g. first hour), column 3 is for the energy/power level.
to_excel_el(t,25)=-Results(t).dispatch.BES_ch(find(Results(t).dispatch.BES_ch(:,2)==33,1),3);
to_excel_el(t,26)=Results(t).dispatch.BES_dis(find(Results(t).dispatch.BES_dis(:,2)==33,1),3);
to_excel_el(t,27)=Results(t).dispatch.BES_dis(find(Results(t).dispatch.BES_dis(:,2)==20,1),3);
to_excel_el(t,28)=-Results(t).dispatch.BES_dis(find(Results(t).dispatch.BES_dis(:,2)==20,1),3);
to_excel_el(t,29)=Results(t).dispatch.BES_dis(find(Results(t).dispatch.BES_dis(:,2)==20,1),3);


to_excel_el(t,30)=Results(t).dispatch.el_imp_nonAH(1,2);
to_excel_el(t,31)=-Results(t).dispatch.elec_demand(1,2);


to_excel_el(t,3)=Results(t).dispatch.vc_el_TURB(1,2);
to_excel_el(t,5)=Results(t).dispatch.vc_el_new_PV(1,2); %This is
%always 0
to_excel_el(t,7)=Results(t).dispatch.vc_el_imp_AH(1,2);

to_excel_el(t,9)=Results(t).dispatch.vc_el_absC(1,2);
%VKA1
%VKA2
%HP
%RM
%sup_unit.uels = {'PV', 'HP', 'BES', 'TES', 'SO', 'BAC', 'RMMC', 'P1', 'P2', 'TURB', 'AbsC', 'AbsCInv', 'AAC', 'RM', 'exG', 'DH', 'CHP', 'RMInv', 'RGK1'}
%data.utot_cost = gdx2mat(gdxData,'utot_cost',sup_unit.uels,h_sim.uels) 
%A=if(b>C;b,c)

%HEATING DATA
to_excel_heat(t,1)=t; 
to_excel_heat(t,2)=Results(t).dispatch.h_Boiler1(1,2); 
to_excel_heat(t,4)=Results(t).dispatch.h_Boiler2(1,2); 
to_excel_heat(t,6)=Results(t).dispatch.h_FlueGasCondenser1(1,2);
to_excel_heat(t,8)=Results(t).dispatch.h_VKA1(1,2);
to_excel_heat(t,10)=Results(t).dispatch.h_VKA4(1,2);
to_excel_heat(t,12)=Results(t).dispatch.h_HP(1,2);
to_excel_heat(t,14)=-Results(t).dispatch.h_exp_AH(1,2);
to_excel_heat(t,16)=Results(t).dispatch.h_imp_AH(1,2);
to_excel_heat(t,18)=Results(t).dispatch.H_B2_to_grid(1,2);
to_excel_heat(t,20)=Results(t).dispatch.H_from_turb(1,2);
to_excel_heat(t,22)=-Results(t).dispatch.h_AbsC(1,2);
to_excel_heat(t,24)=sum(Results(t).dispatch.h_BAC_savings(find(Results(t).dispatch.h_BAC_savings(:,1)==1),3));

to_excel_heat(t,26)=Results(t).dispatch.h_slack(1,2);
to_excel_heat(t,28)=Results(t).dispatch.h_slack_var(1,2);
to_excel_heat(t,29)=Results(t).dispatch.h_RMMC(1,2);
to_excel_heat(t,30)=sum(Results(t).dispatch.BAC_Sen(find(Results(t).dispatch.BAC_Sen(:,1)==1),3));
to_excel_heat(t,31)=-sum(Results(t).dispatch.BAC_Sch(find(Results(t).dispatch.BAC_Sch(:,1)==1),3));
to_excel_heat(t,32)=sum(Results(t).dispatch.BAC_Sdis(find(Results(t).dispatch.BAC_Sdis(:,1)==1),3));
to_excel_heat(t,33)=sum(Results(t).dispatch.BAC_Den(find(Results(t).dispatch.BAC_Den(:,1)==1),3));


to_excel_heat(t,34)=sum(Results(t).dispatch.SO_Sen(find(Results(t).dispatch.SO_Sen(:,1)==1),3));
to_excel_heat(t,35)=-sum(Results(t).dispatch.SO_Sch(find(Results(t).dispatch.SO_Sch(:,1)==1),3));
to_excel_heat(t,36)=sum(Results(t).dispatch.SO_Sdis(find(Results(t).dispatch.SO_Sdis(:,1)==1),3));
to_excel_heat(t,37)=sum(Results(t).dispatch.SO_Den(find(Results(t).dispatch.SO_Den(:,1)==1),3));


to_excel_heat(t,38)=Results(t).dispatch.h_imp_nonAH(1,2);
to_excel_heat(t,39)=-Results(t).dispatch.heat_demand(1,2);


%Variable cost for heating
to_excel_heat(t,3)=Results(t).dispatch.vc_h_Boiler1(1,2);
to_excel_heat(t,5)=Results(t).dispatch.vc_h_Boiler2(1,2);
%RKG
to_excel_heat(t,9)=Results(t).dispatch.vc_h_VKA1(1,2);
to_excel_heat(t,11)=Results(t).dispatch.vc_h_VKA4(1,2);
to_excel_heat(t,13)=Results(t).dispatch.vc_h_HP(1,2);
to_excel_heat(t,15)=Results(t).dispatch.vc_h_exp(1,2);
to_excel_heat(t,17)=Results(t).dispatch.vc_h_imp_AH(1,2);
%Boiler2T
%h_turb
to_excel_heat(t,23)=Results(t).dispatch.vc_h_absC(1,2);
to_excel_heat(t,25)=Results(t).dispatch.vc_h_BAC(1,2);
%slack
%to_excel_heat(t,29)=Results(t).dispatch.vc_h_slack_var(1,2);




% COOLING DATA
to_excel_cool(t,1)=t; 
to_excel_cool(t,2)=Results(t).dispatch.c_VKA1(1,2);
to_excel_cool(t,4)=Results(t).dispatch.c_VKA4(1,2);
to_excel_cool(t,6)=Results(t).dispatch.c_HP(1,2);
to_excel_cool(t,8)=Results(t).dispatch.c_slack(1,2);
to_excel_cool(t,10)=Results(t).dispatch.c_AbsC(1,2);
%to_excel_cool(t,12)=Results(t).dispatch.c_AAC(1,2);
to_excel_cool(t,14)=Results(t).dispatch.c_RM(1,2); 
to_excel_cool(t,16)=Results(t).dispatch.c_RMMC(1,2); 
to_excel_cool(t,18)=Results(t).dispatch.CWB_en(1,2); 
to_excel_cool(t,19)=-Results(t).dispatch.CWB_ch(1,2); 
to_excel_cool(t,20)=Results(t).dispatch.CWB_dis(1,2); 
to_excel_cool(t,23)=-Results(t).dispatch.cool_demand(1,2); 

%VKA1
%VKA4
%HP
to_excel_cool(t,9)=Results(t).dispatch.vc_c_slack(1,2);
to_excel_cool(t,11)=Results(t).dispatch.vc_c_absC(1,2);
%AAC
to_excel_cool(t,15)=Results(t).dispatch.vc_c_RM(1,2);
to_excel_cool(t,17)=Results(t).dispatch.vc_c_RMMC(1,2);
%CWB

% to_excel_heat(t,2)=Results(t).dispatch.vc_h_imp(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_el_BES(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_h_TES(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_c_new_RM(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_h_BAC(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_h_SO(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_el_PT(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_tot(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.tot_var_cost_AH(1,2);
% to_excel_heat(t,2)=Results(t).dispatch.vc_el_slack(1,2);



to_excel_co2(t,1)=t;
to_excel_co2(t,2)=Results(t).dispatch.FED_PE(1,2);
to_excel_co2(t,3)=Results(t).dispatch.FED_CO2(1,2);
to_excel_co2(t,4)=Results(t).dispatch.AH_PE(1,2);
to_excel_co2(t,5)=Results(t).dispatch.AH_CO2(1,2);
to_excel_co2(t,6)=Results(t).dispatch.vc_tot_AH(1,2);
to_excel_co2(t,7)=Results(t).dispatch.model_status(1);
end
toc

end