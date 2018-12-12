*-------------------------------------------------------------------------------
*---------------------FED MAIN SIMULATOR----------------------------------------
*-------------------------------------------------------------------------------

$Include FED_Initialize
$Include FED_Variables
$Include FED_Equations
*CASE WITH HP TES MICRO-CHP AND EXCHANGE WITHIN BUILDINGS**************
option reslim = 500000;
* Default 0.10 , +- 10% from optimal
option optcr = 0.001;
*// Set the max resource usage
OPTION PROFILE = 3;
OPTION threads =-2;
*// To present the resource usage
*option workmem=1024;

model total
/
ALL
/;

SOLVE total using MIP minimizing obj;

parameter
invCost_PV      investment cost of PV
invCost_BEV     investment cost of battery storage
invCost_TES     investment cost of thermal energy storage
invCost_BITES   investment cost of building inertia thermal energy storage
invCost_BAC     investment cost of building advanced control
invCost_HP      investment cost of heat pump
invCost_RMMC    investment cost of connecting MC2 RM
invCost_AbsCInv     investment cost of absorption cooler
invCost_P2          investment cost of P2
invCost_TURB        investment cost of turbine
invCost_RMInv       investment cost of RMInv
total_cap_PV_roof   total capacity in kW
total_cap_PV_facade total capacity in kW
h_demand_nonAH_sum  total demand for non AH buildings
;

invCost_HP = HP_cap.l*cost_inv_opt('HP');
invCost_PV = sum(BID, PV_cap_roof.l(BID)*cost_inv_opt('PV')) + sum(BID, PV_cap_facade.l(BID)*cost_inv_opt('PV'));
invCost_BEV = sum(i,BES_cap.l(i)*cost_inv_opt('BES'));
invCost_TES = (TES_cap.l*TES_vr_cost + TES_inv.l * TES_fx_cost);
invCost_BITES = cost_inv_opt('BTES')*sum(i,B_BITES.l(i));
invCost_BAC = cost_inv_opt('BAC')*sum(i,B_BAC.l(i));
invCost_RMMC = cost_inv_opt('RMMC')*RMMC_inv.l;
invCost_P2 = B_P2.l * cost_inv_opt('P2');
invCost_TURB = B_TURB.l * cost_inv_opt('TURB');
invCost_AbsCInv = (AbsCInv_cap.l * cost_inv_opt('AbsCInv'));
invCost_RMInv = RMInv_cap.l*cost_inv_opt('RMInv');
h_demand_nonAH_sum(h) = sum(i_nonAH_h, h_demand_nonAH(h,i_nonAH_h));
*total_cap_PV_roof=sum(BID, PV_cap_roof.l(BID));
*total_cap_PV_facade=sum(BID, PV_cap_facade.l(BID));

**********************Total operation cost of AH system *********************

**********************FED operation of the AHsystem*****************************
**********Calculated operation cost of the FED system****************
Parameters
*         tot_operation_cost_AH    Total operation cost of the AH system
         tot_var_cost_AH(h)       Total variable of cost of the AH system
         tot_fixed_cost           Total fixed of cost of the AH system
         fix_cost_existing_AH     Fixed cost of existibg generating units in the AH system
         fix_cost_new_AH          Fixed cost of new generating units in the AH system
         var_cost_existing_AH(h)  Variable cost of existing generating units in AH system
         var_cost_new_AH(h)       Variable cost of new generating units in AH system
         sim_PT_exG               Peak tariff of external el grid for the simulation period
;


fix_cost_existing_AH = sum(sup_unit,fix_cost(sup_unit)*cap_sup_unit(sup_unit));
************BIDs associated to AH buildings need to be filtered here************
fix_cost_new_AH = (sum(BID, PV_cap_roof.l(BID) + PV_cap_facade.l(BID)))*fix_cost('PV')
                  + HP_cap.l*fix_cost('HP')
                  + sum(i,BES_cap.l(i)*fix_cost('BES'))
                  + TES_cap.l*fix_cost('TES')
                  + RMInv_cap.l*fix_cost('RMInv')
                  + fix_cost('BTES')*sum(i,B_BITES.l(i))
                  + B_P2.l * fix_cost('P2')
                  + B_TURB.l * fix_cost('TURB')
                  + AbsCInv_cap.l*fix_cost('AbsCInv');

sim_PT_exG = max_PT_exG.l;

var_cost_existing_AH(h) =      e_imp_AH.l(h)*utot_cost('exG',h)
                               -e_exp_AH.l(h)*el_sell_price(h)
                               + (h_imp_AH.l(h))*utot_cost('DH',h)
                               - sum(m,(h_exp_AH.l(h)*DH_export_season(h)*0.3*HoM(h,m))$((ord(m) <= 3) or (ord(m) >=12)))
                               + h_Pana1.l(h)*utot_cost('P1',h)
                               + H_VKA1.l(h)*utot_cost('HP',h)
                               + H_VKA4.l(h)*utot_cost('HP',h)
                               + c_AbsC.l(h)*utot_cost('AbsC',h)
                               + c_RM.l(h)*utot_cost('RM',h)
                               + c_RMMC.l(h)*utot_cost('RM',h)
                               + c_AAC.l(h)*utot_cost('AAC',h)
                               + e_existPV.l(h)*utot_cost('PV',h)
                               + sum(m,(h_AbsC.l(h)*0.15*HoM(h,m))$((ord(m) >=4) and (ord(m) <=10)))
                               + sum(m,(h_AbsC.l(h)*0.7*HoM(h,m))$((ord(m) =11)))
                               + sum(m,(h_AbsC.l(h)*HoM(h,m))$((ord(m) <=3) or (ord(m) >=12)));

var_cost_new_AH(h)   =     e_PV.l(h)*utot_cost('PV',h)
                           + h_HP.l(h)*utot_cost('HP',h)
                           + c_RMInv.l(h)*utot_cost('RMInv',h)
                           + sum(i,BES_dis.l(h,i)*utot_cost('BES',h))
                           + TES_dis.l(h)*utot_cost('TES',h)
                           + sum(i,BTES_Sch.l(h,i)*utot_cost('BTES',h))
                           + h_P2.l(h)*utot_cost('P2',h)
                           + e_TURB.l(h)*utot_cost('TURB',h)
                           + c_AbsCInv.l(h)*utot_cost('AbsCInv',h);

tot_var_cost_AH(h)= var_cost_existing_AH(h)+var_cost_new_AH(h);
tot_fixed_cost=fix_cost_existing_AH + fix_cost_new_AH;
*tot_operation_cost_AH=tot_var_cost_AH + tot_fixed_cost;


**********************************************************
parameter
vc_e_imp
vc_e_exp
vc_h_imp
vc_h_exp
vc_h_P1
vc_h_VKA1
vc_h_VKA4
vc_c_absC
vc_c_RM
vc_c_RMMC
vc_c_AAC
vc_e_PV
vc_c_absC
vc_e_PV
vc_e_new_PV
vc_h_HP
vc_h_ABSC
vc_e_PT
vc_c_RM
vc_c_new_RM
vc_e_BES
vc_h_TES
vc_h_BTES
vc_h_P2
vc_e_TURB
vc_tot;


vc_e_imp = sum(h,e_imp_AH.l(h)*utot_cost('exG',h));
vc_e_exp = sum(h,e_exp_AH.l(h)*el_sell_price(h));
vc_h_imp = sum(h,(h_imp_AH.l(h))*utot_cost('DH',h));
vc_h_exp = sum(h,sum(m,(h_exp_AH.l(h)*DH_export_season(h)*0.3*HoM(h,m))$((ord(m) <= 3) or (ord(m) >=12))));
vc_h_P1 = sum(h,h_Pana1.l(h)*utot_cost('P1',h));
vc_h_VKA1= sum(h,H_VKA1.l(h)*utot_cost('HP',h));
vc_h_VKA4= sum(h,H_VKA4.l(h)*utot_cost('HP',h));
vc_h_ABSC= sum(h,sum(m,(h_AbsC.l(h)*0.15*HoM(h,m))$((ord(m) >=4) and (ord(m) <=10))) + sum(m,(h_AbsC.l(h)*0.7*HoM(h,m))$((ord(m) =11))) + sum(m,(h_AbsC.l(h)*HoM(h,m))$((ord(m) <=3) or (ord(m) >=12))));
vc_c_absC= sum(h,c_AbsC.l(h)*utot_cost('AbsC',h));
vc_c_RM  = sum(h,c_RM.l(h)*utot_cost('RM',h));
vc_c_RMMC= sum(h,c_RMMC.l(h)*utot_cost('RM',h));
vc_c_AAC = sum(h,c_AAC.l(h)*utot_cost('AAC',h));
vc_e_PV  = sum(h,e_existPV.l(h)*utot_cost('PV',h));
vc_c_absC = sum(h,sum(m,(h_AbsC.l(h)*0.15*HoM(h,m))$((ord(m) >=4) and (ord(m) <=10)))
          + sum(m,(h_AbsC.l(h)*0.7*HoM(h,m))$((ord(m) =11)))
          + sum(m,(h_AbsC.l(h)*HoM(h,m))$((ord(m) <=3) or (ord(m) >=12))));
vc_e_PT=sum(h,sum(m,PT_exG.l(m)*HoM(h,m)));


********** NEW INVESTMENT

vc_e_new_PV  = sum(h,e_PV.l(h)*utot_cost('PV',h));
vc_h_HP  = sum(h,h_HP.l(h)*utot_cost('HP',h));
vc_c_new_RM  = sum(h,c_RMInv.l(h)*utot_cost('RMInv',h));
vc_e_BES = sum(h,sum(i,BES_dis.l(h,i)*utot_cost('BES',h)));
vc_h_TES = sum(h,TES_dis.l(h)*utot_cost('TES',h));
vc_h_BTES= sum(h,sum(i,BTES_Sch.l(h,i)*utot_cost('BTES',h)));
vc_h_P2  = sum(h,h_P2.l(h)*utot_cost('P2',h));
vc_e_TURB= sum(h,e_TURB.l(h)*utot_cost('TURB',h));
*vc_e_PV                           + c_AbsCInv.l(h)*utot_cost('AbsCInv',h);
vc_tot = sum(h, tot_var_cost_AH(h));



************AH PE use and CO2 emission*************************************
Parameters
          AH_PE(h)     AH PE use
          MA_AH_PE(h)  AH margional PE use
          AH_CO2(h)    AH average CO2 emission
          MA_AH_CO2(h) AH margional CO2 emission
MA_AH_PE_tot   AH total PE marginal
AH_PE_tot      AH total PE average
MA_AH_CO2_tot  AH total CO2 marginal
AH_CO2_tot     AH total CO2 average
MA_AH_CO2_peak AH peak CO2 marginal
AH_CO2_peak    AH peak CO2 average
;

*-----------------AH average and margional PE use-------------------------------
AH_PE(h)= ( e_imp_AH.l(h)-e_exp_AH.l(h))*PEF_exG(h)
            + e_existPV.l(h)*PEF_PV + e_PV.l(h)*PEF_PV
            + (h_AbsC.l(h)+h_imp_AH.l(h)-h_exp_AH.l(h)*DH_export_season(h))*PEF_DH(h) + ((h_Pana1.l(h)+h_RGK1.l(h))/P1_eff)*PEF_P1
                     + fuel_P2.l(h)*PEF_P2;

MA_AH_PE(h)= (e_imp_AH.l(h)-e_exp_AH.l(h))*MA_PEF_exG(h)
              + e_existPV.l(h)*PEF_PV + e_PV.l(h)*PEF_PV
              + (h_AbsC.l(h)+h_imp_AH.l(h)-h_exp_AH.l(h)*DH_export_season(h))*MA_PEF_DH(h) + ((h_Pana1.l(h)+h_RGK1.l(h))/P1_eff)*PEF_P1
              + fuel_P2.l(h)*PEF_P2;

AH_PE_tot=sum(h,AH_PE(h));
MA_AH_PE_tot= sum(h,MA_AH_PE(h));


*---------------AH average and margional CO2 emission---------------------------
AH_CO2(h) = (e_imp_AH.l(h)-e_exp_AH.l(h))*CO2F_exG(h)
             + e_existPV.l(h)*CO2F_PV + e_PV.l(h)*CO2F_PV
             + (h_AbsC.l(h)+h_imp_AH.l(h)-h_exp_AH.l(h)*DH_export_season(h))*CO2F_DH(h) + ((h_Pana1.l(h)+h_RGK1.l(h))/P1_eff)*CO2F_P1
             + fuel_P2.l(h) * CO2F_P2;

MA_AH_CO2(h) = (e_imp_AH.l(h)-e_exp_AH.l(h))*MA_CO2F_exG(h)
                + e_existPV.l(h)*CO2F_PV + e_PV.l(h)*CO2F_PV
                + (h_AbsC.l(h)+h_imp_AH.l(h)-h_exp_AH.l(h)*DH_export_season(h))*MA_CO2F_DH(h) + ((h_Pana1.l(h)+h_RGK1.l(h))/P1_eff)*CO2F_P1
                + fuel_P2.l(h) * CO2F_P2;
MA_AH_CO2_tot = sum(h, MA_AH_CO2(h));
AH_CO2_tot    = sum(h, AH_CO2(h));
MA_AH_CO2_peak= smax(h, MA_AH_CO2(h));
AH_CO2_peak   = smax(h, AH_CO2(h));
********************Output data from GAMS to MATLAB*********************
*execute_unload %matout%;
parameter
*FED_PE_ft(h)  Primary energy as a function of time
          model_status  Model status
          fuel_P1(h)  Fuel input to P1
          AH_el_imp_tot
          AH_el_exp_tot
          AH_h_imp_tot
          AH_h_exp_tot
          sum_temp_slack(h, DH_Node_ID)
;
*FED_PE_ft(h)=(e_imp_AH.l(h)-e_exp_AH.l(h) + e_imp_nonAH.l(h))*PEF_exG(h)
*             + e0_PV(h)*PEF_PV + sw_PV*e_PV.l(h)*PEF_PV
*             + (h_imp_AH.l(h)-h_exp_AH.l(h) + h_imp_nonAH.l(h))*PEF_DH(h) + fuel_P1(h)*PEF_P1 + fuel_P2.l(h)*PEF_P1;
*
fuel_P1(h)=h_Pana1.l(h)/P1_eff;
model_status=total.modelstat;
AH_el_imp_tot=sum(h,e_imp_AH.l(h));
AH_el_exp_tot=sum(h,e_exp_AH.l(h));
AH_h_imp_tot=sum(h,h_imp_AH.l(h));
AH_h_exp_tot=sum(h,h_exp_AH.l(h));

cool_demand(h)= sum(i,c_demand(h,i));
heat_demand(h)= sum(i,h_demand(h,i));
elec_demand(h)= sum(i,el_demand(h,i));
B_Heating_cost(h,i)= abs(eq_hbalance3.M(h))*h_demand(h,i);
B_Electricity_cost(h,i_AH_el)=abs(eq_ebalance3.M(h))*el_demand(h,i_AH_el);
B_Cooling_cost(h,i_AH_c)=abs(eq_cbalance.M(h))*c_demand_AH(h,i_AH_c);
max_exG_prev=sum(m, max_exG.l(m));
execute_unload 'GtoM' min_totCost_0, min_totCost, min_totPE, min_totCO2,
                      el_demand, el_demand_nonAH, h_demand, c_demand, c_demand_AH,
                      e_imp_AH, e_exp_AH, e_imp_nonAH,AH_el_imp_tot, AH_el_exp_tot,
                      h_imp_AH, h_exp_AH, h_imp_nonAH, AH_h_imp_tot, AH_h_exp_tot,
                      C_DC,
                      h_DH_slack_var,
                      h_demand_nonAH, h_demand, h_demand_nonAH_sum
                      el_sell_price, el_price, h_price, tout, cool_demand,heat_demand,elec_demand
                      BTES_model,
                      FED_PE, MA_FED_PE, FED_CO2,MA_FED_CO2,MA_FED_CO2_tot, FED_CO2_tot, CO2F_PV, PEF_PV, CO2F_P1, PEF_P1, CO2F_P2, PEF_P2, CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,
                      h_Pana1, h_RGK1, qB1, qF1, fuel_P1, P1_eff,tot_PE, MA_tot_PE,
                      H_VKA1, C_VKA1, el_VKA1,
                      H_VKA4, C_VKA4, el_VKA4,
                      B_P2, invCost_P2, fuel_P2, h_P2, H_P2T, B_TURB, invCost_TURB, e_TURB, h_TURB, P2_eff, TURB_eff,
                      h_AbsC, c_AbsC, h_AbsCInv, c_AbsCInv, AbsCInv_cap, invCost_AbsCInv,
                      el_RM, c_RM, e_RMMC, h_RMMC, c_RMMC, RMMC_inv, invCost_RMMC,
                      e_AAC, c_AAC,
                      h_HP, e_HP, c_HP, HP_cap, invCost_HP,
                      TES_ch, TES_dis, TES_en, TES_cap, TES_inv, invCost_TES, TES_dis_eff, TES_chr_eff,
                      BTES_Sch, BTES_Sdis, BTES_Sen, BTES_Den, BTES_Sloss, BTES_Dloss, link_BS_BD,  BTES_dis_eff, BTES_chr_eff, B_BITES, invCost_BITES, BTES_model,
                      h_BAC_savings, B_BAC, invCost_BAC, BAC_savings_period, BAC_savings_factor,
                      area_facade_max, area_roof_max, exist_PV_cap_roof, exist_PV_cap_facade, e_existPV, e_PV, PV_cap_roof,PV_cap_facade, invCost_PV,
                      BES_en, BES_ch, BES_dis, BES_cap, invCost_BEV, BES_dis_eff, BES_ch_eff,
                      PT_exG, max_exG, PT_DH, mean_DH, invCost,
                      fix_cost, utot_cost, price, fuel_cost, var_cost, en_tax, cost_inv_opt, lifT_inv_opt,
                      totCost, Ainv_cost, fix_cost_existing, fix_cost_new, var_cost_existing, var_cost_new,
                      AH_PE, MA_AH_PE, AH_CO2, MA_AH_CO2,
                      DH_export_season, P1P2_dispatchable, inv_lim,
                      c_RMInv, e_RMInv, RMInv_cap, invCost_RMInv,BFCh_en,BFCh_ch,
                      BES_reac,BFCh_reac,BFCh_dis,e_existPV_reac,e_existPV_act,e_TURB_reac,e_PV_reac_roof,e_PV_act_roof,e_TURB_reac,
                      model_status,B_Heating_cost,B_Electricity_cost,B_Cooling_cost,max_exG_prev,
                      tot_var_cost_AH, sim_PT_exG,PT_DH, tot_fixed_cost, fix_cost_existing_AH, fix_cost_new_AH, var_cost_existing_AH, var_cost_new_AH,
                      DH_node_flows, DC_node_flows, CWB_en, CWB_dis, CWB_ch,

                      model_status;


execute_unload 'WP6' model_status, Ainv_cost, vc_e_imp,vc_e_exp,vc_h_imp,vc_h_exp,vc_h_P1,vc_h_VKA1,vc_h_VKA4,vc_c_absC,vc_c_RM,vc_c_RMMC,vc_c_AAC,vc_e_PV,vc_c_absC,vc_e_PV,
                vc_h_HP , vc_c_RM, vc_e_BES,vc_h_TES,vc_e_new_PV, vc_c_new_RM, vc_h_BTES, vc_h_ABSC, vc_h_P2,vc_e_TURB, vc_e_PT, vc_tot, tot_var_cost_AH, el_slack_var

                MA_AH_CO2,AH_CO2, MA_AH_CO2_tot, AH_CO2_tot, MA_AH_CO2_peak, AH_CO2_peak, MA_AH_PE_tot, AH_PE_tot

                h_Pana1, h_RGK1, h_VKA1, h_VKA4, H_P2T, h_TURB, h_RMMC, h_DH_slack, h_DH_slack_var, h_exp_AH, h_imp_AH, h_imp_AH_hist
*h_AbsCInv
                C_DC, c_DC_slack, C_VKA1, C_VKA4,  c_AbsC, c_RM, c_RMMC, c_AAC, c_HP,
*c_RMInv, c_AbsCInv
*(CWB_dis_eff*CWB_dis(h) - CWB_ch(h)/CWB_chr_eff);
                e_imp_AH, e_imp_nonAH, el_exG_slack, e_exp_AH, el_VKA1, el_VKA4, el_RM, e_RMMC, e_AAC, e_PV, e_HP, e_RMInv, e_turb
*sum(i,(BES_dis(h,i)*BES_dis_eff - BES_ch(h,i)/BES_ch_eff)+(BFCh_dis(h,i)*BFCh_dis_eff - BFCh_ch(h,i)/BFCh_ch_eff))
                cool_demand, heat_demand, elec_demand
;


*execute '=gdx2xls MtoG.gdx';
*execute '=gdx2xls GtoM.gdx';
execute '=gdx2xls WP6.gdx';

execute_unload 'h' h;
execute_unload 'BID' BID;
execute_unload 'i' i;
execute_unload 'i_AH_el' i_AH_el;
execute_unload 'i_nonAH_el' i_nonAH_el;
execute_unload 'i_AH_h' i_AH_h;
execute_unload 'i_nonAH_h' i_nonAH_h;
execute_unload 'i_AH_c' i_AH_c;
execute_unload 'i_nonAH_c' i_nonAH_c;
execute_unload 'i_nonBITES' i_nonBITES;
execute_unload 'm' m;
execute_unload 'd' d;
execute_unload 'sup_unit' sup_unit;
execute_unload 'inv_opt' inv_opt;
execute_unload 'coefs' coefs;

execute_unload 'BTES_properties' BTES_properties;

execute_unload 'BTES_properties' BTES_properties
execute_unload 'temp_slack', sum_temp_slack;


