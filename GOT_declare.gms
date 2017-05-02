*------------------------------------------------------------------------------*
*------------------------Göteborg DISTRICT HEATING SYSTEM----------------------*
*------------------------------------------------------------------------------*

free variables
         z               total system cost
         syst_cost       total system cost for the full - 366 hr period
         link_BS_BD      energy flow between Shallow and Deep TES parts
         cost_heat       cost of only heat production
         el_with_REC     electricity which is too be covered with REC
;

binary variables
         u(hours,prod_unit)              when unit is on u=1 and when unit is off u=0
         gen_on_trans(hours,prod_unit)
;

positive variables
         q_final(hours,prod_unit)        amount of heat produced by all prod units in MWh
         p_chp(hours,chp)                electricity produced by CHP unit

         TES_BS_en(hours)                energy level in the Shallow TES
         TES_BD_en(hours)                energy level in the Deep TES

         TES_BS_in(hours)                charge rate of the Shallow TES
         TES_BS_out(hours)               discharge rate of the Shallow TES

         losses_BS(hours)                hourly losses from Shallow Storage based on time constant
         losses_BD(hours)                hourly losses from Deep Storage based on time constant

         start_up_vec(hours,prod_unit)   initial vector for start up cost
         ramp_up(hours,prod_unit)        ramp up limit for heat production
         ramp_down(hours,prod_unit)      ramp down limit for heat production
         ramp_elup(hours,chp)            ramp up limit for electricity production
         ramp_eldown(hours,chp)          ramp down limit for electricity production

         y(hours,prod_unit)              when unit is off y=1 and when unit is on y=0
         gen_off_trans(hours, prod_unit) off_transition

         energy(hours,chp)
         q_final_CHP(hours,chp)
         total_start_up
;

*bounds for variables and initial values
         u.fx(hours,indust)=1;

         TES_BS_in.up("H1")= 0;
         TES_BS_out.up("H1")= 0;

         TES_BS_en.lo(hours)= 0;
         TES_BS_en.up(hours)= 278;

         TES_BD_en.lo(hours)= 0;
         TES_BD_en.up(hours)= 1758;

         gen_off_trans.l(hours, prod_unit)=0;
         gen_off_trans.up(hours, prod_unit)=1;

equations

         obj
*----heat production----*
         gen_load_constr1         hourly heat balance constraint: heat production and storage discharge are greater or equal than demand in every hour
         heat_gen_const1          heat production does not exceed max limit for each prod_unit in every hour
         heat_gen_const2          heat production does not fall lower than min limit for each prod_unit in every hour
         heat_gen_const3
*         heat_gen_const4
         heat_gen_const5
         el_gen_const_RYA_max
         el_gen_const_RYA_min

*----CHP----*
         alfa_const1              keeps the electricity production within the feasibility region
         alfa_const2
         alfa_const3
         alfa_const4

*----on/off const----*
         on_off_state             prod_unit can not be switched on and switched off at the same time
         on_off_const1            conjunction between variables regulating starts-stops and current state of a prod_unit
         on_off_const2            prod_unit can not start and stop at the same time

         min_on_time              if started   prod_unit can not be stopped until the minimum_on_time is over within the first time period
         min_off_time             if stopped   prod_unit can not be started until the minimum_off_time is over within the first time period

*----ramp const----*
         ramp_up_heat             increase in heat production from hour to hour can not be greater than ramp_up limit
         ramp_down_heat           decrease in heat production from hour to hour can not be greater than ramp_down limit
         ramp_up_eq               when prod_unit is started   ramp_up limit should be equal to min heat production
         ramp_down_eq             when prod_unit is shut off   ramp_down limit should be equal to min heat production

*----storage const----*
*$ontext

         TES_BS_init              shallow TES level at the first hour
         TES_BD_init              deep TES level at the first hour
         energy_TES_BS            shallow TES level in all the consequtive hours varies
         energy_TES_BD            deep TES level in all the consequtive hours varies
         energy_between_BS_BD     energy flow between Shallow and Deep TES parts
         TES_BS_charge_limit      hourly varing TES charging cap
         TES_BS_discharge_limit   hourly varing TES discharging cap

         losses_from_BS           Shallow storage losses
         losses_from_BD           Deep storage losses
*$offtext

*----transient start cost----*
         start_up                 defines start up cost if prod_unit is started
         tot_energy
         q_final_1
         REC_balance
         sum_start
         heat_tot
         cost_tot
;



















$ontext
         alfa_const_RYA1_up
         alfa_const_RYA1_down
         alfa_const_RYA2_up
         alfa_const_RYA2_down
         alfa_const_RYA3_up
         alfa_const_RYA3_down

         RYA2_commit
         RYA3_commit
$offtext


*         ramp_up_el_RYA
*         ramp_down_el_RYA
*         ramp_elup_eq_RYA
*         ramp_eldown_eq_RYA
