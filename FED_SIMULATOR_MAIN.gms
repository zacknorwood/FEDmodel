*------------------------------------------------------------------------------
*---------------------FED MAIN SIMULATOR--------------------------------------
*------------------------------------------------------------------------------

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
*
*read model.sav
*conflict

parameter
invCost_PV      investment cost of PV
invCost_BEV     investment cost of battery storage
invCost_TES     investment cost of thermal energy storage
invCost_BITES   investment cost of building inertia thermal energy storage
invCost_BAC     investment cost of building advanced control
invCost_HP      investment cost of heat pump
invCost_RMMC    investment cost of connecting MC2 RM
invCost_AbsCInv investment cost of absorption cooler
invCost_P2      investment cost of P2
invCost_TURB    investment cost of turbine
total_cap_PV_roof   total capacity in kW
total_cap_PV_facade total capacity in kW
h_demand_nonAH_sum  total demand for non AH buildings
;

invCost_HP = sw_HP*HP_cap.l*cost_inv_opt('HP');
invCost_PV = sw_PV*sum(BID, sw_PV*PV_cap_roof.l(BID)*cost_inv_opt('PV')) + sw_PV*sum(BID, sw_PV*PV_cap_facade.l(BID)*cost_inv_opt('PV')) ;
invCost_BEV = sw_BES*BES_cap.l*cost_inv_opt('BES');
invCost_TES = sw_TES*(TES_cap.l*TES_vr_cost + TES_inv.l * TES_fx_cost);
invCost_BITES = sw_BTES*cost_inv_opt('BTES')*sum(i,B_BITES.l(i));
invCost_BAC = sw_BAC*cost_inv_opt('BAC')*sum(i,B_BAC.l(i));
invCost_RMMC = sw_RMMC*cost_inv_opt('RMMC')*RMMC_inv.l;
invCost_P2 = sw_P2 * B_P2.l * cost_inv_opt('P2');
invCost_TURB = sw_TURB * B_TURB.l * cost_inv_opt('TURB');
invCost_AbsCInv = sw_AbsCInv * (AbsCInv_cap.l * cost_inv_opt('AbsCInv'));
h_demand_nonAH_sum(h) = sum(i_nonAH_h, h_demand_nonAH(h,i_nonAH_h));
*total_cap_PV_roof=sum(BID, PV_cap_roof.l(BID));
*total_cap_PV_facade=sum(BID, PV_cap_facade.l(BID));

********************Output data from GAMS to MATLAB*********************
*execute_unload %matout%;
parameter
*FED_PE_ft(h)  Primary energy as a function of time
          model_status  Model status
          fuel_P1(h)  Fuel input to P1
;
*FED_PE_ft(h)=(e_imp_AH.l(h)-e_exp_AH.l(h) + e_imp_nonAH.l(h))*PEF_exG(h)
*             + e0_PV(h)*PEF_PV + sw_PV*e_PV.l(h)*PEF_PV
*             + (h_imp_AH.l(h)-h_exp_AH.l(h) + h_imp_nonAH.l(h))*PEF_DH(h) + fuel_P1(h)*PEF_P1 + fuel_P2.l(h)*PEF_P1;
*
fuel_P1(h)=h_Pana1.l(h)/P1_eff;
model_status=total.modelstat;

execute_unload 'GtoM' min_totCost0, min_totCost, min_totPE, min_totCO2, min_peakCO2,
                      el_demand, h_demand, c_demand, c_demand_AH,
                      e_imp_AH, e_exp_AH, e_imp_nonAH,
                      h_imp_AH, h_exp_AH, h_imp_nonAH,
                      C_DC,
                      h_demand_nonAH, h_demand, h_demand_nonAH_sum
                      el_price, h_price, tout,
                       BTES_model,
                      FED_PE, FED_CO2, CO2F_PV, PEF_PV, CO2F_P1, PEF_P1, CO2F_P2, PEF_P2, CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,
                      h_Pana1, qB1, qF1, fuel_P1, P1_eff,
                      H_VKA1, C_VKA1, el_VKA1,
                      H_VKA4, C_VKA4, el_VKA4,
                      B_P2, invCost_P2, fuel_P2, h_P2, H_P2T, B_TURB, invCost_TURB, e_TURB, h_TURB, P2_eff, TURB_eff,
                      h_AbsC, c_AbsC, h_AbsCInv, c_AbsCInv, AbsCInv_cap, invCost_AbsCInv,
                      e_RM, c_RM, e_RMMC, c_RMMC, RMMC_inv, invCost_RMMC,
                      e_AAC, c_AAC,
                      h_HP, e_HP, c_HP, HP_cap, invCost_HP,
                      TES_ch, TES_dis, TES_en, TES_cap, TES_inv, invCost_TES, TES_dis_eff, TES_chr_eff,
                      BTES_Sch, BTES_Sdis, BTES_Sen, BTES_Den, BTES_Sloss, BTES_Dloss, link_BS_BD,  BTES_dis_eff, BTES_chr_eff, B_BITES, invCost_BITES, BTES_model,
                      h_BAC_savings, B_BAC, invCost_BAC, BAC_savings_period,
                      area_facade_max, area_roof_max, exist_PV_cap_roof, exist_PV_cap_facade, e_existPV, e_PV, PV_cap_roof,PV_cap_facade, invCost_PV,
                      BES_en, BES_ch, BES_dis, BES_cap, invCost_BEV, BES_dis_eff, BES_ch_eff,
                      PT_exG, PT_DH, invCost,
                      fix_cost, utot_cost, price, fuel_cost, var_cost, en_tax, cost_inv_opt, lifT_inv_opt,
                      fix_cost_existing, fix_cost_new, var_cost_existing, var_cost_new,
                      DH_export_season, P1P2_dispatchable, p1_dispach, h_P1, inv_lim
                      model_status;

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

