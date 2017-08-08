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
invCost_AbsCInv = sw_AbsCInv * (B_AbsCInv.l *AbsCInv_fx + AbsCInv_cap.l * cost_inv_opt('AbsCInv'));
*total_cap_PV_roof=sum(BID, PV_cap_roof.l(BID));
*total_cap_PV_facade=sum(BID, PV_cap_facade.l(BID));

********************Output data from GAMS to MATLAB*********************
*execute_unload %matout%;
parameter FED_PE_ft(h)  Primary energy as a function of time
;
FED_PE_ft(h)=e_exG.l(h)*PEF_exG(h)
             + e0_PV(h)*PEF_PV + sw_PV*e_PV.l(h)*PEF_PV
             + q_DH.l(h)*PEF_DH(h) + q_P1(h)*PEF_P1;



execute_unload 'GtoM' H_VKA1, C_VKA1, el_VKA1,
                      H_VKA4, C_VKA4, el_VKA4,
                      B_P2, invCost_P2, q_P2, H_P2T, B_TURB, invCost_TURB, e_TURB, q_TURB,
                      q_AbsC, k_AbsC, q_AbsCInv, k_AbsCInv, AbsCInv_cap, invCost_AbsCInv,
                      e_RM, k_RM, e_RMMC, k_RMMC, RMMC_inv, invCost_RMMC,
                      e_AAC, k_AAC,
                      q_HP, e_HP, c_HP, HP_cap, invCost_HP,
                      TES_ch, TES_dis, TES_en, TES_cap, TES_inv, invCost_TES,
                      BTES_Sch, BTES_Sdis, BTES_Sen, BTES_Den, BTES_Sloss, BTES_Dloss, link_BS_BD, B_BITES, invCost_BITES,
                      e_PV, PV_cap_roof,PV_cap_facade, invCost_PV,
                      BES_en, BES_ch, BES_dis, BES_cap, invCost_BEV,
                      FED_PE, FED_PE_ft,
                      FED_CO2,
                      e_exG,
                      q_DH,
                      PT_exG, PT_DH;

*display k_demand;
*execute_unload "power_grid.gdx" P_DH, P_elec;
*execute_unload "power_technologies.gdx" P_DH, P_HP, P_CHP, TES_out, TES_in;
*execute_unload "indoor_temperature" T_in;


*execute_unload "Demand_2016.gdx" heat_demand, elec_demand;


*execute_unload "ind_temp.gdx" T_in.l;
*execute 'gdxxrw.exe ind_temp.gdx var=T_in.L';

$ontext
file results /results.dat/ ;
put results;
put 'district heating Results'// ;
put  @24, 'P_DH', @48, 'P_HP', @72, 'fuel', @96, 'Ped'
loop((i,h), put n.tl, @24, P_DH.l(i,h):8:4, @48, P_HP.l(i,h):8:4, @72, fuel.l(i,h):8:4, @96, Ped.l(i,h):8:4  /);
$offtext
