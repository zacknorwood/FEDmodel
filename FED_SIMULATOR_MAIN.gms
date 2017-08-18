*------------------------------------------------------------------------------
*---------------------FED MAIN SIMULATOR--------------------------------------
*------------------------------------------------------------------------------

$Include FED_Initialize
$Include FED_Variables
$Include FED_Equations

*CASE WITH HP TES MICRO-CHP AND EXCHANGE WITHIN BUILDINGS**************

option reslim = 500000;
*// Set the max resource usage
OPTION PROFILE=3;
OPTION threads = -2;
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
invCost_HP      investment cost of heat pump
invCost_RMMC    investment cost of connecting MC2 RM
invCost_AbsCInv investment cost of absorption cooler
invCost_P2      investment cost of P2
invCost_TURB    investment cost of turbine
total_cap_PV_roof   total capacity in kW
total_cap_PV_facade total capacity in kW
;

invCost_HP = sw_HP*HP_cap.l*cost_inv_opt('HP');
invCost_PV = sw_PV*sum(BID, sw_PV*PV_cap_roof.l(BID)*cost_inv_opt('PV')) + sw_PV*sum(BID, sw_PV*PV_cap_facade.l(BID)*cost_inv_opt('PV')) ;
invCost_BEV = sw_BES*BES_cap.l*cost_inv_opt('BES');
invCost_TES = sw_TES*(TES_cap.l*TES_vr_cost + TES_inv.l * TES_fx_cost);
invCost_BITES = sw_BTES*cost_inv_opt('BTES')*sum(i,B_BITES.l(i));
invCost_RMMC = sw_RMMC*cost_inv_opt('RMMC')*RMMC_inv.l;
invCost_P2 = sw_P2 * B_P2.l * cost_inv_opt('P2');
invCost_TURB = sw_TURB * B_TURB.l * cost_inv_opt('TURB');
invCost_AbsCInv = sw_AbsCInv * (AbsCInv_cap.l * cost_inv_opt('AbsCInv'));
*total_cap_PV_roof=sum(BID, PV_cap_roof.l(BID));
*total_cap_PV_facade=sum(BID, PV_cap_facade.l(BID));

********************Output data from GAMS to MATLAB*********************
*execute_unload %matout%;
parameter FED_PE_ft(h)  Primary energy as a function of time
;
FED_PE_ft(h)=e_exG.l(h)*PEF_exG(h)
             + e0_PV(h)*PEF_PV + sw_PV*e_PV.l(h)*PEF_PV
             + q_DH.l(h)*PEF_DH(h) + fuel_P1(h)*PEF_P1 + fuel_P2.l(h)*PEF_P1;


execute_unload 'GtoM' el_demand0, q_demand0, k_demand0, k_demand_AH, el_price0, q_price0, tout0, area_facade_max, area_roof_max, nPV_el0, BTES_model0

                      FED_PE0, FED_CO20, CO2F_PV, PEF_PV, CO2F_P1, PEF_P1, CO2F_P2, PEF_P2, CO2F_exG, PEF_exG, CO2F_DH, PEF_DH,
                      q_p1_TB, q_p1_FGC, fuel_P1, P1_eff,
                      H_VKA1, C_VKA1, el_VKA1,
                      H_VKA4, C_VKA4, el_VKA4,
                      B_P2, invCost_P2, fuel_P2, q_P2, H_P2T, B_TURB, invCost_TURB, e_TURB, q_TURB, P2_eff, TURB_eff,
                      q_AbsC, k_AbsC, q_AbsCInv, k_AbsCInv, AbsCInv_cap, invCost_AbsCInv,
                      e_RM, k_RM, e_RMMC, k_RMMC, RMMC_inv, invCost_RMMC,
                      e_AAC, k_AAC,
                      q_HP, e_HP, c_HP, HP_cap, invCost_HP,
                      TES_ch, TES_dis, TES_en, TES_cap, TES_inv, invCost_TES, TES_dis_eff, TES_chr_eff,
                      BTES_Sch, BTES_Sdis, BTES_Sen, BTES_Den, BTES_Sloss, BTES_Dloss, link_BS_BD,  BTES_dis_eff, BTES_chr_eff, B_BITES, invCost_BITES, BTES_model,
                      e0_PV, e_PV, PV_cap_roof,PV_cap_facade, invCost_PV,
                      BES_en, BES_ch, BES_dis, BES_cap, invCost_BEV, BES_dis_eff, BES_ch_eff,
                      FED_PE,
                      FED_CO2,
                      e_exG,
                      q_DH,
                      PT_exG, PT_DH, invCost,
                      fix_cost, utot_cost, price, fuel_cost, var_cost, en_tax, cost_inv_opt, lifT_inv_opt;

execute_unload 'h' h;
execute_unload 'BID' BID;
execute_unload 'i' i;
execute_unload 'i_AH' i_AH;
execute_unload 'i_nonAH' i_nonAH;
execute_unload 'i_nonBITES' i_nonBITES;
execute_unload 'm' m;
execute_unload 'd' d;
execute_unload 'sup_unit' sup_unit;
execute_unload 'inv_opt' inv_opt;
execute_unload 'coefs' coefs;
execute_unload 'BTES_properties' BTES_properties;

