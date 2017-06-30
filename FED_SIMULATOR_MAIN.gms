*------------------------------------------------------------------------------
*---------------------FED MAIN SIMULATOR--------------------------------------
*------------------------------------------------------------------------------
set h Time series
    i  Bus Id
;

$Include FED_Initialize
$Include FED_Variables
$Include FED_Equations

*CASE WITH HP, TES, MICRO-CHP AND EXCHANGE WITHIN BUILDINGS**************

option reslim = 500000;
*// Set the max resource usage
OPTION PROFILE=3;
OPTION threads = -2
*// To present the resource usage
*option workmem=1024;

model total
/
ALL
/;
SOLVE total using MIP minimizing invCost;

parameter
inv_PV      investmet cost on PV
inv_BEV     investmet cost on battery storage
inv_TES     investmet cost on thermal energy storage
inv_BITES   investmet cost on building inertia thermal energy storage
inv_HP      investmet cost on heat pump
inv_RMMC    investment cost on connecting MC2 RM
inv_AbsCInv investment cost for absorption cooler
inv_P2      investment cost for new P2
inv_TURB    investment cost for turbine connected to P2
;
inv_HP=sw_HP*HP_cap.l*Acost_sup_unit('HP')*15;
inv_PV= sw_PV*PV_cap.l*Acost_sup_unit('PV')*30;
inv_BEV=sw_BES*BES_cap.l*Acost_sup_unit('BES')*15;
inv_TES=sw_TES*(TES_cap.l*TES_vr_cost + TES_inv.l * TES_fx_cost);
inv_BITES=sw_BTES**Acost_sup_unit('BTES')*sum(i,B_BITES.l(i))*30;
inv_RMMC=sw_RMMC*Acost_sup_unit('RMMC')*RMMC_inv.l;
inv_AbsCInv = sw_AbsCInv * (B_AbsCInv.l *AbsCInv_fx + AbsCInv_cap.l * Acost_sup_unit('AbsCInv'))
inv_P2 = sw_P2 * B_P2 * Acost_sup_unit('P2')
inv_TURB = sw_TURB * B_TURB * Acost_sup_unit('TURB')
display HP_cap.l, inv_HP, PV_cap.l, inv_PV, BES_cap.l, inv_BEV, TES_cap.l, inv_TES, inv_BITES, inv_RMMC, inv_AbsCInv, inv_P2, inv_TURB invCost.l;

********************Output data from GAMS to MATLAB*********************
*execute_unload %matout%;
parameter FED_PE_ft(h)  Primary energy as a function of time
;
FED_PE_ft(h)=e_exG.l(h)*PEF_exG(h)
             + e0_PV(h)*PEF_loc('PV') + sw_PV*e_PV.l(h)*PEF_loc('PV')
             + q_DH.l(h)*PEF_DH(h) + tb_2016(h)*PEF_loc('TB');

execute_unload 'GtoM' H_VKA1,C_VKA1,el_VKA1,q_P2, H_P2T, e_TURB, q_TURB,
                      H_VKA4,C_VKA4,el_VKA4,q_AbsC,k_AbsC,e_RM,k_RM, e_RMMC, k_RMMC,
                      e_AAC,k_AAC, q_HP,e_HP, c_HP,HP_cap,TES_ch,TES_dis,TES_en,TES_cap,TES_inv,
                      BTES_Sch,BTES_Sdis,BTES_Sen,BTES_Den,BTES_Sloss,BTES_Dloss,
                      link_BS_BD, B_BITES, e_PV,PV_cap,BES_en,BES_ch,BES_dis,BES_cap,
                      FED_PE,FED_PE_ft,FED_CO2, e_exG, q_DH, q_AbsCInv, k_AbsCInv;

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














