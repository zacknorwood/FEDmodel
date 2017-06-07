*******************************************************************************
*---------------------Declare variables and equations--------------------------
*******************************************************************************

*------------------HP related------------------------------------------------
positive variable
P_HP(h)           heating power available in HP
HP_cap              capacity of HP
;

*------------------AC(Absorbtion Chiller) related------------------------------------------------
positive variable
H_AC(h)           heat demand for Absorbtion Chiller
C_AC(h)           cooling power available in AR
AC_cap            capacity of AR
;

*------------------Refrigerator related------------------------------------------------
positive variable
el_R(h)          electricity demand for refrigerator
C_R(h)           cooling power available from the refrigerator
R_cap            capacity of refrigerator
;

*------------------CHP related------------------------------------------------
positive variable
P_CHP(h)          power available in CHP
CHP_cap             maximum capacity of CHP plant
;
*CHP_cap.fx(i)=600;
*capa_chp.fx('1')=600;
*P_CHP.up(h,i)=600;
*P_CHP.lo(h,i)=0;

*------------------TES related------------------------------------------------
positive variable
TES_ch(h)         Input to the TES-chargin the TES
TES_dis(h)        Output from the TES-discharging the TES
TES_en(h)         energy content of TES at any instant
TES_cap             Capacity of the TES
;
*TES_cap.up=1000;

*------------------BTES (Building energy storage) related-----------------------
positive variable
BTES_Sch(h,i)
BTES_Sdis(h,i)
BTES_Sen(h,i)
BTES_Den(h,i)
BTES_Sloss(h,i)
BTES_Dloss(h,i)
;
variable
link_BS_BD(h,i)
;

*------------------Demand Response (DR) related-----------------------------
variable DR_heat_demand(h,i)  demand response of the building
;
DR_heat_demand.fx(h,i)=heat_demand(h,i)$(sw_DR ne 1);

*------------------Battery related------------------------------------------
positive variables
BES_en(h)       Energy stored in the battry at time t and building i
BES_ch(h)       Battery charing at time t and building i
BES_dis(h)      Battery discharging at time t and building i
BES_cap        Capacity of the battery at building i
;

*------------------Grid El related---------------------------------------------
variable
P_el(h,i)          electrical power input from grid
el_trans(h,i,j)    actual electricity transmission from 'i' to 'j' at any instant h
;
*P_elec.fx(h,i)=0;
*P_elec.up(h,'1')=1000000;
P_el.lo(h,i)=0;

el_trans.up(h,i,j)=el_trans_capa(i,j)*10000;
el_trans.lo(h,i,j)= -el_trans_capa(i,j)*10000;

*------------------Grid DH related---------------------------------------------
variable
P_DH(h,i)            heat power input from grid
heat_trans(h,i,j)    actual heat transmission from 'i' to 'j' at any instant h
;
*P_DH.fx(h,i)=0;
*P_DH.up(h,'1')=10000000000000;
P_DH.lo(h,i)=0;

heat_trans.up(h,i,j)=heat_trans_capa(i,j)*10000;
heat_trans.lo(h,i,j)= -heat_trans_capa(i,j)*10000;

*------------------Grid DC related---------------------------------------------
variable
P_DC(h,i)             cooling from district cooling system
cooling_trans(h,i,j)  actual cooling transmission from 'i' to 'j' at any instant h
;
P_DC.fx(h,i)=0;
*cooling_trans.fx(h,i,j)=0;


variable
TC                   total cost;
