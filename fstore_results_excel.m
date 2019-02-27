function [to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2] = fstore_results_excel(Results,to_excel_el, to_excel_heat, to_excel_cool, to_excel_co2, sim_start, sim_stop, t);
% This function extract the first hour of the scheduled dispatch and put it
% into an array that can be exported to excel for analysis 

tic

t_step=t-sim_start+1;   %Start putting the value at row 1

%% ELECTRICITY DATA
% (1,2) is for taking the value from the first hour (of the 10 hour
% dispatch) and column 2 is for the power/cost
if Results(t).dispatch.model_status(1)~= 1 && Results(t).dispatch.model_status(1)~= 6  
to_excel_co2(t_step,7)=Results(t).dispatch.model_status(1);
else
to_excel_el(t_step,1)=t;
to_excel_el(t_step,2)=Results(t).dispatch.el_TURB(1,2); 
to_excel_el(t_step,4)=Results(t).dispatch.el_PV(1,2); 
to_excel_el(t_step,6)=Results(t).dispatch.el_imp_AH(1,2);
to_excel_el(t_step,8)=-Results(t).dispatch.el_AbsC(1,2);
to_excel_el(t_step,10)=-Results(t).dispatch.el_VKA1(1,2);
to_excel_el(t_step,12)=-Results(t).dispatch.el_VKA4(1,2);
to_excel_el(t_step,14)=-Results(t).dispatch.el_HP(1,2);
%to_excel_el(t_step,16)=-Results(t).dispatch.el_AAC(1,2);
to_excel_el(t_step,18)=-Results(t).dispatch.el_RM(1,2);

to_excel_el(t_step,20)=Results(t).dispatch.el_slack(1,2);
to_excel_el(t_step,22)=Results(t).dispatch.el_slack_var(1,2);
to_excel_el(t_step,24)=Results(t).dispatch.BES_en(find(Results(t).dispatch.BES_en(:,2)==33,1),3); 
% find the energy storage at node/BID 33 and the first value(e.g. first hour), column 3 is for the energy/power level.
to_excel_el(t_step,25)=-Results(t).dispatch.BES_ch(find(Results(t).dispatch.BES_ch(:,2)==33,1),3);
to_excel_el(t_step,26)=Results(t).dispatch.BES_dis(find(Results(t).dispatch.BES_dis(:,2)==33,1),3);
to_excel_el(t_step,27)=Results(t).dispatch.BFCh_en(find(Results(t).dispatch.BFCh_en(:,2)==20,1),3);
to_excel_el(t_step,28)=-Results(t).dispatch.BFCh_ch(find(Results(t).dispatch.BFCh_ch(:,2)==20,1),3);
to_excel_el(t_step,29)=Results(t).dispatch.BFCh_dis(find(Results(t).dispatch.BFCh_dis(:,2)==20,1),3);


to_excel_el(t_step,30)=Results(t).dispatch.el_imp_nonAH(1,2);
to_excel_el(t_step,31)=-Results(t).dispatch.elec_demand(1,2);


to_excel_el(t_step,3)=Results(t).dispatch.vc_el_TURB(1,2);
to_excel_el(t_step,5)=Results(t).dispatch.vc_el_new_PV(1,2); %This is
%always 0
to_excel_el(t_step,7)=Results(t).dispatch.vc_el_imp_AH(1,2);

to_excel_el(t_step,9)=Results(t).dispatch.vc_el_absC(1,2);
%VKA1
%VKA2
%HP
%RM
%sup_unit.uels = {'PV', 'HP', 'BES', 'TES', 'SO', 'BAC', 'RMMC', 'P1', 'P2', 'TURB', 'AbsC', 'AbsCInv', 'AAC', 'RM', 'exG', 'DH', 'CHP', 'RMInv', 'RGK1'}
%data.utot_cost = gdx2mat(gdxData,'utot_cost',sup_unit.uels,h_sim.uels) 
%A=if(b>C;b,c)

%HEATING DATA
to_excel_heat(t_step,1)=t; 
to_excel_heat(t_step,2)=Results(t).dispatch.h_Boiler1(1,2); 
to_excel_heat(t_step,4)=Results(t).dispatch.h_Boiler2(1,2); 
to_excel_heat(t_step,6)=Results(t).dispatch.h_RGK1(1,2);
to_excel_heat(t_step,8)=Results(t).dispatch.h_VKA1(1,2);
to_excel_heat(t_step,10)=Results(t).dispatch.h_VKA4(1,2);
to_excel_heat(t_step,12)=Results(t).dispatch.h_HP(1,2);
to_excel_heat(t_step,14)=-Results(t).dispatch.h_exp_AH(1,2);
to_excel_heat(t_step,16)=Results(t).dispatch.h_imp_AH(1,2);
to_excel_heat(t_step,18)=Results(t).dispatch.H_Boiler2T(1,2);
to_excel_heat(t_step,20)=Results(t).dispatch.h_TURB(1,2)*0.75;
to_excel_heat(t_step,22)=-Results(t).dispatch.h_AbsC(1,2);
to_excel_heat(t_step,24)=sum(Results(t).dispatch.h_BAC_savings(find(Results(t).dispatch.h_BAC_savings(:,1)==1),3));

to_excel_heat(t_step,26)=Results(t).dispatch.h_slack(1,2);
to_excel_heat(t_step,28)=Results(t).dispatch.h_slack_var(1,2);
to_excel_heat(t_step,30)=sum(Results(t).dispatch.BAC_Sen(find(Results(t).dispatch.BAC_Sen(:,1)==1),3));
to_excel_heat(t_step,31)=-sum(Results(t).dispatch.BAC_Sch(find(Results(t).dispatch.BAC_Sch(:,1)==1),3));
to_excel_heat(t_step,32)=sum(Results(t).dispatch.BAC_Sdis(find(Results(t).dispatch.BAC_Sdis(:,1)==1),3));
to_excel_heat(t_step,33)=sum(Results(t).dispatch.BAC_Den(find(Results(t).dispatch.BAC_Den(:,1)==1),3));


% AK Add BTES_SO output as well
to_excel_heat(t_step,34)=sum(Results(t).dispatch.SO_Sen(find(Results(t).dispatch.SO_Sen(:,1)==1),3));
to_excel_heat(t_step,35)=-sum(Results(t).dispatch.SO_Sch(find(Results(t).dispatch.SO_Sch(:,1)==1),3));
to_excel_heat(t_step,36)=sum(Results(t).dispatch.SO_Sdis(find(Results(t).dispatch.SO_Sdis(:,1)==1),3));
to_excel_heat(t_step,37)=sum(Results(t).dispatch.SO_Den(find(Results(t).dispatch.SO_Den(:,1)==1),3));

to_excel_heat(t_step,38)=Results(t).dispatch.h_imp_nonAH(1,2);
to_excel_heat(t_step,39)=-Results(t).dispatch.heat_demand(1,2);


%Variable cost for heating
to_excel_heat(t_step,3)=Results(t).dispatch.vc_h_Boiler1(1,2);
to_excel_heat(t_step,5)=Results(t).dispatch.vc_h_Boiler2(1,2);
%RKG
to_excel_heat(t_step,9)=Results(t).dispatch.vc_h_VKA1(1,2);
to_excel_heat(t_step,11)=Results(t).dispatch.vc_h_VKA4(1,2);
to_excel_heat(t_step,13)=Results(t).dispatch.vc_h_HP(1,2);
to_excel_heat(t_step,15)=Results(t).dispatch.vc_h_exp(1,2);
to_excel_heat(t_step,17)=Results(t).dispatch.vc_h_imp_AH(1,2);
%Boiler2T
%h_turb
to_excel_heat(t_step,23)=Results(t).dispatch.vc_h_absC(1,2);
to_excel_heat(t_step,25)=Results(t).dispatch.vc_h_BAC(1,2);
%slack
to_excel_heat(t_step,29)=Results(t).dispatch.vc_h_slack_var(1,2);




% COOLING DATA
to_excel_cool(t_step,1)=t; 
to_excel_cool(t_step,2)=Results(t).dispatch.c_VKA1(1,2);
to_excel_cool(t_step,4)=Results(t).dispatch.c_VKA4(1,2);
to_excel_cool(t_step,6)=Results(t).dispatch.c_HP(1,2);
to_excel_cool(t_step,8)=Results(t).dispatch.c_slack(1,2);
to_excel_cool(t_step,10)=Results(t).dispatch.c_AbsC(1,2);
%to_excel_cool(t_step,12)=Results(t).dispatch.c_AAC(1,2);
to_excel_cool(t_step,14)=Results(t).dispatch.c_RM(1,2); 
to_excel_cool(t_step,16)=Results(t).dispatch.c_RMMC(1,2); 
to_excel_cool(t_step,18)=Results(t).dispatch.CWB_en(1,2); 
to_excel_cool(t_step,19)=-Results(t).dispatch.CWB_ch(1,2); 
to_excel_cool(t_step,20)=Results(t).dispatch.CWB_dis(1,2); 
to_excel_cool(t_step,23)=-Results(t).dispatch.cool_demand(1,2); 

%VKA1
%VKA4
%HP
to_excel_cool(t_step,9)=Results(t).dispatch.vc_c_slack(1,2);
to_excel_cool(t_step,11)=Results(t).dispatch.vc_c_absC(1,2);
%AAC
to_excel_cool(t_step,15)=Results(t).dispatch.vc_c_RM(1,2);
to_excel_cool(t_step,17)=Results(t).dispatch.vc_c_RMMC(1,2);
%CWB

% to_excel_heat(t_step,2)=Results(t).dispatch.vc_h_imp(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_el_BES(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_h_TES(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_c_new_RM(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_h_BAC(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_h_SO(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_el_PT(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_tot(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.tot_var_cost_AH(1,2);
% to_excel_heat(t_step,2)=Results(t).dispatch.vc_el_slack(1,2);



to_excel_co2(t_step,1)=t;
to_excel_co2(t_step,2)=Results(t).dispatch.FED_PE(1,2);
to_excel_co2(t_step,3)=Results(t).dispatch.FED_CO2(1,2);
to_excel_co2(t_step,4)=Results(t).dispatch.AH_PE(1,2);
to_excel_co2(t_step,5)=Results(t).dispatch.AH_CO2(1,2);
to_excel_co2(t_step,6)=Results(t).dispatch.vc_tot_AH(1,2);
to_excel_co2(t_step,7)=Results(t).dispatch.model_status(1);
end
toc

end