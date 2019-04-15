*-------------------------------------------------------------------------------
*---------------------FED MAIN SIMULATOR----------------------------------------
*-------------------------------------------------------------------------------

$onUElList
$Include FED_Initialize
$Include FED_Variables
$Include FED_Equations
*CASE WITH HP TES MICRO-CHP AND EXCHANGE WITHIN BUILDINGS**************
option reslim = 500000;
* Default 0.10 , +- 10% from optimal
option optcr = 0.001;
*// Set the max resource usage
OPTION PROFILE = 3;
*// Maximum number of threads to use is one less (-1) than the number of processor cores.
OPTION threads =-1;
*// To present the resource usage
*option workmem=1024;

model total
/
ALL
/;

SOLVE total using MIP minimizing obj;

display B_BAC.l, h_BAC_savings.l;

parameter
h_demand_nonAH_sum  total demand for non AH buildings
;

h_demand_nonAH_sum(h) = sum(BID_nonAH_h, h_demand_nonAH(h,BID_nonAH_h));

**********************Total operation cost of AH system *********************

**********************FED operation of the AHsystem*****************************
**********Calculated operation cost of the FED system****************
Parameters
         tot_operation_cost_AH    Total operation cost of the AH system
         tot_var_cost_AH(h)       Total variable of cost of the AH system
         tot_fixed_cost           Total fixed of cost of the AH system
         fix_cost_existing_AH     Fixed cost of existibg generating units in the AH system
         fix_cost_new_AH          Fixed cost of new generating units in the AH system
         sim_PT_exG               Peak tariff of external el grid for the simulation period
;


fix_cost_existing_AH = sum(sup_unit,fix_cost(sup_unit)*cap_sup_unit(sup_unit));
************BIDs associated to AH buildings need to be filtered here************

* Currently considering all investments as AH investments -DS
fix_cost_new_AH = fix_cost_new.l;

sim_PT_exG = max_PT_exG.l;

* The export costs from space heating need to be implemented in a way that doesn't require an ordered set for m.  Or else m needs to be redefined so it is always ordered so the "ord" operator can be used.

tot_var_cost_AH(h)= var_cost_existing_AH.l(h)+var_cost_new_AH.l(h);
tot_fixed_cost=fix_cost_existing_AH + fix_cost_new_AH;

************AH PE use and CO2 emission*************************************
Parameters
    AH_PE(h)     AH PE use
    AH_PE_tot    AH total PE average
;




*-----------------AH average and margional PE use-------------------------------
AH_PE(h)= ( el_imp_AH.l(h)-el_exp_AH.l(h))*NREF_El(h)
            + el_PV.l(h)*NREF_PV
            + (h_AbsC.l(h)+h_imp_AH.l(h)-h_exp_AH.l(h)*DH_heating_season(h))*NREF_DH(h) + ((h_Boiler1.l(h)+h_FlueGasCondenser1.l(h))/B1_eff)*NREF_Boiler1
                     + fuel_Boiler2.l(h)*NREF_Boiler2;

AH_PE_tot=sum(h,AH_PE(h));


********************Output data from GAMS to MATLAB*********************
parameter
          model_status  Model status
          AH_el_imp_tot Total imported electricity to AH
          AH_el_exp_tot Total exported electricity to AH
          AH_h_imp_tot  Total imported heat to AH
          AH_h_exp_tot  Total exported heat to AH
          cool_demand(h)       Total cooling demand
          heat_demand(h)       Total heat demand
          elec_demand(h)       Total elec. demand
          B_Heating_cost(h,BID)             heating cost of every buildings
          B_Electricity_cost(h,BID_AH_el)   electricity cost of every AH building
          B_Cooling_cost(h,BID_AH_c)        cooling cost of every AH buildings

;

model_status=total.modelstat;
AH_el_imp_tot=sum(h,el_imp_AH.l(h));
AH_el_exp_tot=sum(h,el_exp_AH.l(h));
AH_h_imp_tot=sum(h,h_imp_AH.l(h));
AH_h_exp_tot=sum(h,h_exp_AH.l(h));

cool_demand(h)= sum(BID,c_demand(h,BID));
heat_demand(h)= sum(BID,h_demand(h,BID));
elec_demand(h)= sum(BID,el_demand(h,BID));
B_Heating_cost(h,BID)= abs(eq_hbalance3.M(h))*h_demand(h,BID);
B_Electricity_cost(h,BID_AH_el)=abs(eq_ebalance3.M(h))*el_demand(h,BID_AH_el);
B_Cooling_cost(h,BID_AH_c)=abs(eq_cbalance.M(h))*c_demand_AH(h,BID_AH_c);

*Not used in rolling time horizon - ZN
*max_exG_prev=sum(m, max_exG.l(m));
option gdxuels = full;
execute_unload 'GtoM' min_totCost_0, min_totCost, min_totPE, min_totCO2,
                      el_demand, el_demand_nonAH, h_demand, c_demand, c_demand_AH,
                      el_imp_AH, el_exp_AH, el_imp_nonAH,AH_el_imp_tot, AH_el_exp_tot,
                      h_imp_AH, h_exp_AH, h_imp_nonAH, AH_h_imp_tot, AH_h_exp_tot,
                      h_demand_nonAH, h_demand, h_demand_nonAH_sum
                      el_sell_price, el_price, marginalCost_DH, tout, cool_demand,heat_demand,elec_demand
                      BTES_model,
                      FED_PE, FED_CO2, FED_CO2_tot, CO2F_PV, NREF_PV, CO2F_Boiler1, NREF_Boiler1, CO2F_Boiler2, NREF_Boiler2, CO2F_El, NREF_El, CO2F_DH, NREF_DH,
                      h_Boiler1, h_FlueGasCondenser1, h_Boiler1_0, h_FlueGasCondenser1_0, fuel_Boiler1, B1_eff, tot_PE,
                      h_VKA1, c_VKA1, el_VKA1,
                      h_VKA4, c_VKA4, el_VKA4,
                      B_Boiler2, invCost_Boiler2, fuel_Boiler2, h_Boiler2, H_B2_to_grid, H_from_turb, B_TURB, invCost_TURB, el_TURB, h_TURB, B2_eff, TURB_eff,
                      h_AbsC, c_AbsC, el_AbsC, h_AbsCInv, c_AbsCInv, AbsCInv_cap, invCost_AbsCInv,
                      el_RM, c_RM, el_RMMC, h_RMMC, c_RMMC, RMMC_inv, invCost_RMMC,
*                      el_AAC, c_AAC,
                      h_HP, el_HP, c_HP, HP_cap, invCost_HP,
                      h_DH_slack, h_DH_slack_var, c_DC_slack, c_DC_slack_var, el_slack_var, el_exG_slack
                      TES_ch, TES_dis, TES_en, TES_cap, TES_inv, invCost_TES, TES_dis_eff, TES_chr_eff,
                      BTES_dis_eff, BTES_chr_eff,   BTES_model,
                      SO_Sch, SO_Sdis_to_grid , SO_Sch_from_grid, SO_Sdis, SO_Sen, SO_Den, SO_Sloss, SO_Dloss, SO_link_BS_BD, B_SO,  invCost_SO,
                      BAC_Sch, BAC_Sch_from_grid, BAC_Sdis_to_grid, BAC_Sdis, BAC_Sen, BAC_Den, BAC_Sloss, BAC_Dloss, BAC_link_BS_BD, B_BAC, invCost_BAC, BTES_model,

                      h_BAC_savings, B_BAC, invCost_BAC, BAC_savings_period, BAC_savings_factor,
                      el_PV, PV_cap_roof,PV_cap_facade, invCost_PV,
                      BES_en, BES_ch, BES_dis,BES_dis_to_grid, BES_ch_from_grid, BES_cap, invCost_BES, BES_dis_eff, BES_chr_eff,
                      PT_exG, max_exG, PT_DH, mean_DH, invCost,
                      fix_cost, utot_cost, price, fuel_cost, var_cost, en_tax, cost_inv_opt, lifT_inv_opt,
                      totCost, Ainv_cost, fix_cost_existing, fix_cost_new, var_cost_existing, var_cost_new,
                      AH_PE, AH_CO2, nonAH_CO2,
                      DH_heating_season, P1P2_dispatchable, inv_lim,
                      c_RMInv, el_RMInv, RMInv_cap, invCost_RMInv,
                      model_status,B_Heating_cost,B_Electricity_cost,B_Cooling_cost
                      tot_var_cost_AH, sim_PT_exG,PT_DH, tot_fixed_cost, fix_cost_existing_AH, fix_cost_new_AH, var_cost_existing_AH, var_cost_new_AH,
                      DH_node_flows, DC_node_flows, CWB_en, CWB_dis, CWB_ch,
                      tot_var_cost_AH, model_status;


$ontext

*THIS IS NOT USED AND ARE ONLY KEEPT FOR FUTURE REFERENCE

*********** Marginal Emission ***************
Parameters
        MA_AH_PE(h)  AH margional PE use
        AH_CO2(h)    AH average CO2 emission
        MA_AH_CO2(h) AH margional CO2 emission
        MA_AH_PE_tot   AH total PE marginal
        MA_AH_CO2_tot  AH total CO2 marginal
        AH_CO2_tot     AH total CO2 average
        MA_AH_CO2_peak AH peak CO2 marginal
        AH_CO2_peak    AH peak CO2 average
;

MA_AH_PE(h)= (el_imp_AH.l(h)-el_exp_AH.l(h))*MA_PEF_exG(h)
              + el_PV.l(h)*PEF_PV
              + (h_AbsC.l(h)+h_imp_AH.l(h)-h_exp_AH.l(h)*DH_heating_season(h))*MA_PEF_DH(h) + ((h_Boiler1.l(h)+h_RGK1.l(h))/P1_eff)*PEF_P1
              + fuel_P2.l(h)*PEF_P2;


*MA_AH_PE_tot= sum(h,MA_AH_PE(h));

* MA_AH_CO2(h) = (el_imp_AH.l(h)-el_exp_AH.l(h))*MA_CO2F_exG(h)
*                + el_PV.l(h)*CO2F_PV
*                + (h_AbsC.l(h)+h_imp_AH.l(h)-h_exp_AH.l(h)*DH_heating_season(h))*MA_CO2F_DH(h) + ((h_Boiler1.l(h)+h_RGK1.l(h))/P1_eff)*CO2F_P1
*                + fuel_P2.l(h) * CO2F_P2;

*MA_AH_CO2_tot = sum(h, MA_AH_CO2(h));
*AH_CO2_tot    = sum(h, AH_CO2(h));
*MA_AH_CO2_peak= smax(h, MA_AH_CO2(h));
*AH_CO2_peak   = smax(h, AH_CO2(h));

**********************************************************
parameter
vc_el_imp(h)
vc_el_imp_AH(h)
vc_el_exp(h)
vc_el_absC
vc_h_imp(h)
vc_h_imp_AH(h)
vc_h_exp(h)
vc_h_Boiler1(h)
vc_h_VKA1(h)
vc_h_VKA4(h)
vc_h_ABSC
vc_c_RM(h)
vc_c_RMMC(h)
*vc_c_AAC(h)
*vc_el_PV(h)
vc_c_absC(h)
*vc_el_PV(h)
vc_el_new_PV(h)
vc_h_HP(h)
vc_el_PT(h)
vc_c_RM(h)
vc_c_new_RM(h)
vc_el_BES(h)
vc_h_TES(h)
vc_h_BAC(h)
vc_h_SO(h)
vc_h_Boiler2(h)
vc_el_TURB(h)
vc_tot(h)
vc_h_slack_var(h)
vc_c_slack(h)
vc_el_slack(h)
;

*Individual cost per production as calculated in model Added eps to avoid error when importing to matlab
vc_el_imp(h) = (el_imp_AH.l(h) + el_imp_nonAH.l(h))*utot_cost('exG',h)+eps;
vc_el_imp_AH(h) = el_imp_AH.l(h)*utot_cost('exG',h)+eps;
vc_el_exp(h) = el_exp_AH.l(h)*el_sell_price(h)+eps;
vc_el_absC(h) = el_AbsC.l(h) * utot_cost('exG',h)+eps;
vc_h_imp_AH(h) = (h_imp_AH.l(h))*utot_cost('DH',h)+eps;
vc_h_imp(h) =(h_imp_AH.l(h) + h_imp_nonAH.l(h)) * utot_cost('DH',h)+eps;
vc_h_exp(h) = h_exp_AH.l(h) * utot_cost('DH',h)+eps;
vc_h_Boiler1(h) = h_Boiler1.l(h)*utot_cost('B1',h)+eps;
vc_h_VKA1(h) = h_VKA1.l(h)*utot_cost('HP',h)+eps;
vc_h_VKA4(h) = h_VKA4.l(h)*utot_cost('HP',h)+eps;
vc_h_ABSC(h) =h_AbsC.l(h) * utot_cost('DH',h)+eps;
vc_c_absC(h) = c_AbsC.l(h)*utot_cost('AbsC',h)+eps;
vc_c_RM (h) = c_RM.l(h)*utot_cost('RM',h)+eps;
vc_c_RMMC(h) = c_RMMC.l(h)*utot_cost('RM',h)+eps;
vc_h_slack_var(h) = h_DH_slack_var.l(h) * 1000000000+eps;
vc_c_slack(h) = c_DC_slack_var.l(h) * 1000000000+eps;
vc_el_slack(h) = el_slack_var.l(h) * 1000000000+eps;

*vc_c_AAC(h) = c_AAC.l(h)*utot_cost('AAC',h);
*vc_el_PV(h)  = el_existPV.l(h)*utot_cost('PV',h);
*vc_c_absC(h) = sum(m,(h_AbsC.l(h)*0.15*HoM(h,m))$((ord(m) >=4) and (ord(m) <=10)))
*          + sum(m,(h_AbsC.l(h)*0.7*HoM(h,m))$((ord(m) =11)))
*          + sum(m,(h_AbsC.l(h)*HoM(h,m))$((ord(m) <=3) or (ord(m) >=12)));
vc_el_PT(h)=sum(m,PT_exG.l(m)*HoM(h,m))+eps;

display utot_cost, vc_el_absC, el_AbsC.l;

********** NEW INVESTMENT
* AK Check BAC/SO/BTES Costs
vc_el_new_PV(h)  = el_PV.l(h)*utot_cost('PV',h)+eps;
vc_h_HP(h)  = h_HP.l(h)*utot_cost('HP',h)+eps;
vc_c_new_RM(h)  = c_RMInv.l(h)*utot_cost('RMInv',h)+eps;
vc_el_BES(h) = sum(BID,BES_dis.l(h,BID)*utot_cost('BES',h))+eps;
vc_h_TES(h) = TES_dis.l(h)*utot_cost('TES',h)+eps;
vc_h_BAC(h) = sum(BID,BAC_Sch.l(h,BID)*utot_cost('BAC',h))+eps;
vc_h_SO(h) = sum(BID,SO_Sch.l(h,BID)*utot_cost('SO',h))+eps;
vc_h_Boiler2(h)  = h_Boiler2.l(h)*utot_cost('B2',h)+eps;
vc_el_TURB(h) = el_TURB.l(h)*utot_cost('TURB',h)+eps;
*vc_e_PV                           + c_AbsCInv.l(h)*utot_cost('AbsCInv',h);
*vc_tot = sum(h, tot_var_cost_AH(h));

*To be added to GtoM.gdx
                      vc_el_imp, vc_el_imp_AH,vc_el_exp,vc_el_absC,vc_h_imp,vc_h_imp_AH,vc_h_exp,vc_h_Boiler1,vc_h_VKA1,vc_h_VKA4,vc_c_absC,vc_c_RMMC,
                      vc_h_HP , vc_c_RM, vc_el_BES,vc_h_TES,vc_el_new_PV, vc_c_new_RM, vc_h_BAC, vc_h_SO, vc_h_ABSC, vc_h_Boiler2,vc_el_TURB, vc_el_PT, vc_tot,
                      vc_h_slack_var,vc_c_slack,vc_el_slack,

$offtext

