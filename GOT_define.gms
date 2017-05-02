*------------------------------------------------------------------------------*
*------------------------Göteborg DISTRICT HEATING SYSTEM----------------------*
*------------------------------------------------------------------------------*

*hourly heat balance constraints

         gen_load_constr1(hours)..
         sum(prod_unit,q_final(hours,prod_unit)) + TES_BS_out(hours) - TES_BS_in(hours)  =g= heat_load(hours);

*max and min production constraint for every unit in every hour

         heat_gen_const1(hours,burn)..
         q_final(hours,burn) =L= u(hours,burn) * max_gen_win(burn);

         heat_gen_const2(hours,burn)..
         q_final(hours,burn) =G= u(hours,burn) * min_gen(burn);



         heat_gen_const3(hours_win,'Renova')..
         q_final(hours_win,'Renova') =L= max_gen_win('Renova');

*         heat_gen_const4(hours_sum,'Renova')..
*         q_final(hours_sum,'Renova') =L= max_gen_sum('Renova');

         heat_gen_const5(hours,HP)..
         q_final(hours,HP) =L= max_gen_win(HP);



         el_gen_const_RYA_max(hours,"RYA_CHP")..
         p_chp(hours,"RYA_CHP") =L= u(hours,"RYA_CHP") * max_el("RYA_CHP");

         el_gen_const_RYA_min(hours,"RYA_CHP")..
         p_chp(hours,"RYA_CHP") =G= u(hours,"RYA_CHP") * min_el("RYA_CHP");



*------------------------------------------------------------------------------*
*-------------------------CHP production constraints---------------------------*
*------------------------------------------------------------------------------*

*feasible region for alpha value for wood chips fired Sävenäs CHP

         alfa_const1(hours,'SAV_CHP')..
         p_chp(hours,'SAV_CHP') =e= q_final(hours,'SAV_CHP') * const_alpha('SAV_CHP');

         alfa_const2(hours,'HOG_CHP')..
         p_chp(hours,'HOG_CHP') =e= q_final(hours,'HOG_CHP') * const_alpha('HOG_CHP');



         alfa_const3(hours,"RYA_CHP")..
         ((((P_R2-P_R1)/(Q_R2-Q_R1)) * (q_final(hours,"RYA_CHP")-Q_R1)) + P_R1) =g= p_chp(hours,"RYA_CHP");

         alfa_const4(hours,"RYA_CHP")..
         ((((P_R2-P_R3)/(Q_R2-Q_R3)) * (q_final(hours,"RYA_CHP")-Q_R3)) + P_R3) =l= p_chp(hours,"RYA_CHP");

*------------------------------------------------------------------------------*
*-------------------------------On/off constraints-----------------------------*
*------------------------------------------------------------------------------*

*on and off state constraint
         on_off_state(hours,burn)..
         u(hours,burn)+y(hours,burn) =e= 1;

         on_off_const1(hours,burn)..
         gen_on_trans(hours,burn) - gen_off_trans(hours,burn) =e= u(hours,burn) - u(hours-1,burn);

         on_off_const2(hours,burn)..
         gen_on_trans(hours,burn) + gen_off_trans(hours,burn) =l= 1;


*min on time constraint for two wood pellets fired HOBs
         min_on_time(hours,wood)$(ord(hours) le card(hours))..
         sum(hours2 $ (ord(hours2) ge ord(hours) and ord(hours2) le ord(hours) + min_time(hours,wood)-1), u(hours2,wood)) =G= gen_on_trans(hours,wood) * min_time(hours,wood);

*min off time constarint for wood chips fired Sävenäs CHP
         min_off_time(hours,'SAV_CHP')$(ord(hours) le card(hours))..
         sum(hours2 $ (ord(hours2) ge ord(hours) and ord(hours2) le ord(hours) + min_time(hours,'SAV_CHP')-1), y(hours2,'SAV_CHP')) =G= gen_off_trans(hours,'SAV_CHP') * min_time(hours,'SAV_CHP');



*------------------------------------------------------------------------------*
*----------------------------Ramp up/down constraints--------------------------*
*------------------------------------------------------------------------------*

         ramp_up_heat(hours,ramp)$ (ord(hours) gt 1)..
         q_final(hours,ramp) =l= q_final(hours-1,ramp) + ramp_up(hours,ramp);

         ramp_down_heat(hours,ramp)$ (ord(hours) gt 1)..
         q_final(hours,ramp) =g= q_final(hours-1,ramp) - ramp_down(hours,ramp);

         ramp_up_eq(hours,ramp)..
         ramp_up(hours,ramp) =e= min_gen(ramp)*gen_on_trans(hours,ramp) + u(hours-1,ramp)*ramp_heat_par(ramp);

         ramp_down_eq(hours,ramp)..
         ramp_down(hours,ramp) =e= min_gen(ramp)*gen_off_trans(hours,ramp) + u(hours,ramp)*ramp_heat_par(ramp);


*------------------------------------------------------------------------------*
*------------------------------Storage constraints----------------------------*
*------------------------------------------------------------------------------*

*$ontext
         TES_BS_charge_limit(hours)..
         TES_BS_in(hours) =l= TES_BS_max_charge(hours);

         TES_BS_discharge_limit(hours)..
         TES_BS_out(hours) =l= TES_BS_max_discharge(hours);


         TES_BS_init(hours) $ (ord(hours) eq 1)..
         TES_BS_en(hours) =e= TES_BS_en_int;

         TES_BD_init(hours) $ (ord(hours) eq 1)..
         TES_BD_en(hours) =e= TES_BD_en_int;


         losses_from_BS(hours) $ (ord(hours) gt 1)..
         losses_BS(hours) =e= TES_BS_en(hours-1)*(1-exp(-1/time_const_BS));

         losses_from_BD(hours) $ (ord(hours) gt 1)..
         losses_BD(hours) =e= TES_BD_en(hours-1)*(1-exp(-1/time_const_BD));


         energy_TES_BS(hours) $ (ord(hours) gt 1)..
         TES_BS_en(hours) =e= TES_BS_en(hours-1) - TES_BS_out(hours)/disch_eff + TES_BS_in(hours)*ch_eff - link_BS_BD(hours) - losses_BS(hours);


         energy_TES_BD(hours) $ (ord(hours) gt 1)..
         TES_BD_en(hours) =e= TES_BD_en(hours-1) + link_BS_BD(hours) - losses_BD(hours);


         energy_between_BS_BD(hours)..
         link_BS_BD(hours) =e= ( TES_BS_en(hours)/TES_BS_cap - TES_BD_en(hours)/TES_BD_cap ) * BS_BD_coef;


*------------------------------------------------------------------------------*
*------------------------------Transient costs---------------------------------*
*------------------------------------------------------------------------------*

start_up(hours,chp)..
         start_up_vec(hours,chp) =e= start_up_cost(chp) * gen_on_trans(hours,chp);

         sum_start..
         total_start_up =e=  sum( (hours_cost,chp),         start_up_vec(hours_cost,chp)  );


         tot_energy(hours,chp)..
         energy(hours,chp) =e= q_final(hours,chp) + p_chp(hours,chp);

         q_final_1(hours,chp)..
         q_final_CHP(hours,chp) =e= q_final(hours,chp);


         REC_balance..
         el_with_REC =e= sum( (hours,chp), p_chp(hours,chp))*0.17 - sum( (hours), p_chp(hours,"SAV_CHP"));



         heat_tot..
         cost_heat =e=     sum( (hours_cost,chp),         energy(hours_cost,chp)   * fuel_cost(chp)            / etta_tot(chp))
                         + sum( (hours_cost,chp),         q_final(hours_cost,chp)  * en_tax(chp)               / etta_tot(chp))
                         + sum( (hours_cost,chp),         p_chp(hours_cost,chp)    * var_cost(chp))

                         + sum( (hours_cost,hob1),        q_final(hours_cost,hob1) * tot_cost(hob1)            /  etta_tot(hob1))

                         + sum( (hours_cost,HP),          q_final(hours_cost,HP)   * (cost_el(hours_cost)+tot_cost(HP)+REC_price*0.17) /  etta_tot(HP))

                         + sum( (hours_cost,chp),         start_up_vec(hours_cost,chp)  );


         cost_tot..
         syst_cost =e=     sum( (hours_cost,chp),         energy(hours_cost,chp)   * fuel_cost(chp)            / etta_tot(chp))
                         + sum( (hours_cost,chp),         q_final(hours_cost,chp)  * en_tax(chp)               / etta_tot(chp))
                         + sum( (hours_cost,chp),         p_chp(hours_cost,chp)    * var_cost(chp))

                         + sum( (hours_cost,hob1),        q_final(hours_cost,hob1) * tot_cost(hob1)            /  etta_tot(hob1))

                         + sum( (hours_cost,HP),          q_final(hours_cost,HP)   * (cost_el(hours_cost)+tot_cost(HP)+REC_price*0.17) /  etta_tot(HP))

                         + sum( (hours_cost,chp),         start_up_vec(hours_cost,chp)  )

                         - sum( (hours_cost,chp),         p_chp(hours_cost,chp)    * cost_el(hours_cost))

                         + (sum( (hours_cost,chp), p_chp(hours_cost,chp))*0.17 - sum( (hours_cost), p_chp(hours_cost,"SAV_CHP"))) * REC_price;


********************************************************************************
***********************O B J E C T I V E    F U N C T I O N ********************
********************************************************************************

         obj..
         z =e=   sum( (hours,chp),         energy(hours,chp)   * fuel_cost(chp)            / etta_tot(chp))
               + sum( (hours,chp),         q_final(hours,chp)  * en_tax(chp)               / etta_tot(chp))
               + sum( (hours,chp),         p_chp(hours,chp)    * var_cost(chp))

               + sum( (hours,hob1),        q_final(hours,hob1) * tot_cost(hob1)            /  etta_tot(hob1))

               + sum( (hours,HP),          q_final(hours,HP)   * (cost_el(hours)+tot_cost(HP)+REC_price*0.17) /  etta_tot(HP))

               + sum( (hours,chp),         start_up_vec(hours,chp)  )

               - sum( (hours,chp),         p_chp(hours,chp)    * cost_el(hours))

               + el_with_REC * REC_price;


$ontext
*start up and shut down cost vectors

         start_up(hours,chp)..
         start_up_vec(hours,chp) =e= start_up_cost(chp) * gen_on_trans(hours,chp);

         sum_start..
         total_start_up =e=  sum( (hours,chp),         start_up_vec(hours,chp)  );

         tot_energy(hours,chp)..
         energy(hours,chp) =e= q_final(hours,chp) + p_chp(hours,chp);

         q_final_1(hours,chp)..
         q_final_CHP(hours,chp) =e= q_final(hours,chp);

         REC_balance..
         el_with_REC =e= sum( (hours,chp), p_chp(hours,chp))*0.17 - sum( (hours), p_chp(hours,"SAV_CHP"));

         heat_tot..
         cost_heat =e=     sum( (hours,chp),         energy(hours,chp)   * fuel_cost(chp)            / etta_tot(chp))
                         + sum( (hours,chp),         q_final(hours,chp)  * en_tax(chp)               / etta_tot(chp))
                         + sum( (hours,chp),         p_chp(hours,chp)    * var_cost(chp))

                         + sum( (hours,hob1),        q_final(hours,hob1) * tot_cost(hob1)            /  etta_tot(hob1))

                         + sum( (hours,HP),          q_final(hours,HP)   * (cost_el(hours)+tot_cost(HP)+REC_price*0.17) /  etta_tot(HP))

                         + sum( (hours,chp),         start_up_vec(hours,chp)  );



********************************************************************************
***********************O B J E C T I V E    F U N C T I O N ********************
********************************************************************************

         obj..
         z =e=   sum( (hours,chp),         energy(hours,chp)   * fuel_cost(chp)            / etta_tot(chp))
               + sum( (hours,chp),         q_final(hours,chp)  * en_tax(chp)               / etta_tot(chp))
               + sum( (hours,chp),         p_chp(hours,chp)    * var_cost(chp))

               + sum( (hours,hob1),        q_final(hours,hob1) * tot_cost(hob1)            /  etta_tot(hob1))

               + sum( (hours,HP),          q_final(hours,HP)   * (cost_el(hours)+tot_cost(HP)+REC_price*0.17) /  etta_tot(HP))

               + sum( (hours,chp),         start_up_vec(hours,chp)  )

               - sum( (hours,chp),         p_chp(hours,chp)    * cost_el(hours))

               + el_with_REC * REC_price;






















*feasible region for alpha value for natural gas fired RYA CHP
         alfa_const_RYA1_up(hours,"RYA_CHP1")..
         ((((P_R2-P_R1)/(Q_R2-Q_R1)) * (q_final(hours,"RYA_CHP1")-Q_R1)) + P_R1) =g= p_chp(hours,"RYA_CHP1");

         alfa_const_RYA1_down(hours,"RYA_CHP1")..
         ((((P_R2-P_R3)/(Q_R2-Q_R3)) * (q_final(hours,"RYA_CHP1")-Q_R3)) + P_R3) =l= p_chp(hours,"RYA_CHP1");

         alfa_const_RYA2_up(hours,"RYA_CHP2")..
         ((((P_S2-P_S1)/(Q_S2-Q_S1)) * (q_final(hours,"RYA_CHP2")-Q_S1)) + P_S1) =g= p_chp(hours,"RYA_CHP2");

         alfa_const_RYA2_down(hours,"RYA_CHP2")..
         ((((P_S2-P_S3)/(Q_S2-Q_S3)) * (q_final(hours,"RYA_CHP2")-Q_S3)) + P_S3) =l= p_chp(hours,"RYA_CHP2");

         alfa_const_RYA3_up(hours,"RYA_CHP3")..
         ((((P_H2-P_H1)/(Q_H2-Q_H1)) * (q_final(hours,"RYA_CHP3")-Q_H1)) + P_H1) =g= p_chp(hours,"RYA_CHP3");

         alfa_const_RYA3_down(hours,"RYA_CHP3")..
         ((((P_H2-P_H3)/(Q_H2-Q_H3)) * (q_final(hours,"RYA_CHP3")-Q_H3)) + P_H3) =l= p_chp(hours,"RYA_CHP3");


*constraints, which define the priority of RYA_CHP turbines commitment
         RYA2_commit(hours,"RYA_CHP2")..
         u(hours,"RYA_CHP2") =l= u(hours,"RYA_CHP1");

         RYA3_commit(hours,"RYA_CHP3")..
         u(hours,"RYA_CHP3") =l= u(hours,"RYA_CHP2");
$offtext









$ontext
         ramp_up_el_RYA(hours,chp_RYA)$ (ord(hours) gt 1)..
         p_chp(hours,chp_RYA) =l= (p_chp(hours-1,chp_RYA) + ramp_elup(hours,chp_RYA));

         ramp_down_el_RYA(hours,chp_RYA)$ (ord(hours) gt 1)..
         p_chp(hours,chp_RYA) =g= (p_chp(hours-1,chp_RYA) - ramp_eldown(hours,chp_RYA));

         ramp_elup_eq_RYA(hours,chp_RYA)..
         ramp_elup(hours,chp_RYA) =e= min_el(chp_RYA)*gen_on_trans(hours,chp_RYA) + u(hours-1,chp_RYA)*ramp_el_par(chp_RYA);

         ramp_eldown_eq_RYA(hours,chp_RYA)..
         ramp_eldown(hours,chp_RYA) =e= min_el(chp_RYA)*gen_off_trans(hours,chp_RYA) + u(hours,chp_RYA)*ramp_el_par(chp_RYA);
$offtext
