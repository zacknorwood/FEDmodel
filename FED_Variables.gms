*******************************************************************************
*---------------------Declare variables and equations--------------------------
*******************************************************************************

variable
TC                   total cost
T_in(h,i)            indoor room temperature
DR_heat_demand(h,i)  demand response of the building
;

****** setting indoor temperature limits *****
T_in.up(h,i) = 24;
T_in.lo(h,i) = 19;
T_in.fx('H1','1')=21;


*P_chr_TES.up(i,h)=20;
*P_dis_TES.up(i,h)=20;


********* Limits on heat_demand DR ************
DR_heat_demand.fx(h,i)=heat_demand(h,i)$(switch_DR ne 1);

*------------------El related------------------------------------------------
variable
P_elec(h,i)          electrical power input from grid
cost_el(h,i)         price of electrical energy
elec_trans(h,i,j)    actual electricity transmission from 'i' to 'j' at any instant h
elec_s(h,i)          sum of electricity transmission at any instant n
;
P_elec.fx(h,i)=0;
P_elec.up(h,'1')=1000000;
*P_elec.lo('1',n)=-10000;

elec_trans.up(h,i,j)=elec_trans_capa(i,j)*10000;
elec_trans.lo(h,i,j)= -elec_trans_capa(i,j)*10000;

*------------------DH related------------------------------------------------
variable
P_DH(h,i)            heat power input from grid
heat_trans(h,i,j)    actual heat transmission from 'i' to 'j' at any instant h
heat_s(h,i)          sum of heat transmission at any instant n
;
P_DH.fx(h,i)=0;
P_DH.up(h,'1')=10000000000000;
*P_DH.lo('1',n)=-10000;

heat_trans.up(h,i,j)=heat_trans_capa(i,j)*10000;
heat_trans.lo(h,i,j)= -heat_trans_capa(i,j)*10000;

*------------------DC related------------------------------------------------
variable
P_DC(h,i)            cooling from district cooling system
;
P_DC.fx(h,i)=0;

*------------------TES related------------------------------------------------
positive variable
TES_in(h,i)         Input to the TES-chargin the TES
TES_out(h,i)        Output from the TES-discharging the TES
TES_en(h,i)         energy content of TES at any instant
TES_cap(i)           maximum value of charge for a building
;
TES_cap.up(i)=1000;
*capa_TES.up('1')=100;

*------------------BES (Building energy storage) related-----------------------
positive variable
BS_in(h,i)
BS_out(h,i)
BS_en(h,i)
BD_en(h,i)
losses_BS(h,i)
losses_BD(h,i)
;
variable
link_BS_BD(h,i)
;

*------------------CHP related------------------------------------------------
positive variable
P_CHP(h,i)          power available in CHP
CHP_cap(i)           maximum capacity of CHP plant
;
CHP_cap.fx(i)=600;
*capa_chp.fx('1')=600;
P_CHP.up(h,i)=600;
P_CHP.lo(h,i)=0;

*------------------HP related------------------------------------------------
positive variable
P_HP(h,i)           power available in HP
HP_cap(i)            capacity of HP
;
*capa_hp.fx(i)=0;
*capa_hp.fx('1')=600;
HP_cap.up(i)=1000;
*capa_hp.up('1')=100;
