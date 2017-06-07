******************************************************************************
*----------------------------Define equations--------------------------------
******************************************************************************
equation
           total_cost      with aim to minimize total cost
*           indoor_temp1    indoor temperature as a function of outdoor temperature and power input
           capacity_HP     for determining capacity of HP
           capacity_CHP    for determining the capacity of CHP
           capacity_TES    for determining the capacity of TES
           heating         heating supply-demand balance
           cooling         Balance equation cooling
           electrical      electrical supply-demand balance
           Energy_TES      Amount of energy contained in TES at any instant
           Energy1_TES     Amount of energy at first and last hour is same
           trans1          transmission of heat is one direction is negative of transmission in other direction
           discharge       instantaneous discharge of building
           charge          instantaneous charge of the building
*heating_DR      Set heat demand for case without DR
           BS_ch_lim
           BS_dis_lim
           BS_init
           BD_init
           losses_from_BS
           losses_from_BD
           energy_BS
           energy_BD
           energy_between_BS_BD
;

*-----------------------------------------------------------------------------
*--------------------------Define equations-----------------------------------
*-----------------------------------------------------------------------------

**************** Objective function ***********************
total_cost..
        TC =e= sum((i,h), P_DH(h,i)*fp('WOOD')+P_elec(h,i)*el_price(h)+P_CHP(h,i)*fp('WOOD'))
               + sum(i,switch_HP*HP_cap(i)*50+switch_CHP*CHP_cap(i)*100+switch_TES*TES_cap(i)*50);
******* Demand supply balance for heating *******
heating(h,i)..
        heat_demand(h,i) =e= P_DH(h,i) + P_HP(h,i)*switch_HP + (TES_dis_eff*TES_out(h,i)-TES_in(h,i)/TES_chr_eff)*switch_TES +
                             P_CHP(h,i)/((1+CHP_el_heat)*CHP_eff)*switch_CHP + sum(j,heat_trans(h,i,j))*switch_trans +
                             BS_out(h,i) - BS_in(h,i);

*heat_demand_DR(i,h) =e= P_DH(i,h)+P_HP(i,h)*switch_HP+(dis*P_dis_TES(i,h)-P_chr_TES(i,h)/chr)*switch_TES+P_CHP(i,h)/((1+alpha)*eta)*switch_CHP+sum(p,trans_heat(i,j,h)*q(n))*switch_trans;
*demand_DR(i,h) =e= P_DH(i,h)+P_HP(i,h)+(dis*P_dis_TES(i,h)-P_chr_TES(i,h)/chr)*switch_TES+P_CHP(i,h)/((1+alpha)*eta)*switch_CHP+sum(p,trans(i,j,h)*q(n));

*heating_DR(i,h)..
*heat_demand_DR(i,h) =e= heat_demand(i,h)$(switch_DR ne 1);

******* Demand supply balance for cooling *******
cooling(h,i)..
         cooling_demand(h,i) =e= P_DC(h,i);

******* Demand supply balance for electricity *******
electrical(h)..
        sum(i,el_demand(h,i)) =e= sum(i,P_elec(h,i) + switch_CHP*CHP_el_heat*P_CHP(h,i)/((1+CHP_el_heat)*CHP_eff) -
                                    switch_HP*P_HP(h,i)/HP_COP);

*electrical(i,h)..
*elec_demand(i,h) =e= P_elec(i,h) +
*                     switch_CHP*alpha*P_CHP(i,h)/((1+alpha)*eta) -
*                     switch_HP*P_HP(i,h)/COP +
*                     sum(j, trans_elec(i,j,h)*q(h))*switch_trans;

**** Building flexibility/indoor temperature ***********
*indoor_temp1(i,h)$(ord(h) ne card(h))..
*        T_in(i,h+1) =l= (temp(h+1)+(DR_heat_demand(i,h)+0.9*elec_demand(i,h))*p_data(i,'t_r')-
*                        (temp(h+1)+(DR_heat_demand(i,h)+0.9*elec_demand(i,h))*p_data(i,'t_r')-
*                        T_in(i,h))*exp(-1/(p_data(i,'t_r')*p_data(i,'t_c'))))$(switch_DR eq 1)+
*                        21$(switch_DR ne 1);

*------------------------------------------------------------------------------*
*------------------Storage constraints/Demand Response(DR)---------------------*
*------------------------------------------------------------------------------*

BS_ch_lim(h,i)..
         BS_in(h,i) =l= BTES_model(i,'BS_ch_cap1');

BS_dis_lim(h,i)..
         BS_out(h,i) =l= BTES_model(i,'BS_dis_cap1');

BS_init(h,i) $ (ord(h) eq 1)..
         BS_en(h,i) =e= BS_en_int(i);

BD_init(h,i) $ (ord(h) eq 1)..
         BD_en(h,i) =e= BD_en_int(i);

losses_from_BS(h,i) $ (ord(h) gt 1)..
         losses_BS(h,i) =e= BS_en(h-1,i)*BTES_model(i,'k_BS_loss1');

losses_from_BD(h,i) $ (ord(h) gt 1)..
         losses_BD(h,i) =e= BD_en(h-1,i)*BTES_model(i,'K_BD_loss');

energy_BS(h,i) $ (ord(h) gt 1)..
         BS_en(h,i) =e= BS_en(h-1,i) - BS_out(h,i)/BS_disch_eff + BS_in(h,i)*BS_ch_eff - link_BS_BD(h,i) - losses_BS(h,i);

energy_BD(h,i) $ (ord(h) gt 1)..
         BD_en(h,i) =e= BD_en(h-1,i) + link_BS_BD(h,i) - losses_BD(h,i);

energy_between_BS_BD(h,i)..
         link_BS_BD(h,i) =e= ( BS_en(h,i)/BTES_model(i,'BS_cap') - BD_en(h,i)/BTES_model(i,'BD_cap') ) * BTES_model(i,'K_BS_BD');

*trans2(i,j,h)..
*trans_elec(i,j,h) =e= -trans_elec(j,i,h);

*******What is this for?
*trans3(i,h)..
*r(i,h)=e=sum(j, trans_heat(i,j,h));
*trans4(i,h)..
*s(i,h)=e=sum(j, trans_elec(i,j,h));


********** TES equations *************
Energy_TES(h,i)$(ord(h) ne card(h))..
             TES_en(h+1,i) =e= TES_en(h,i)+TES_in(h+1,i)-TES_out(h+1,i);

Energy1_TES(h,i)$(ord(h) eq card(h))..
             TES_en('H1',i) =e= TES_en(h,i);

discharge(h,i)..
             TES_out(h,i) =l= TES_max_dis_rate*TES_en(h,i);

charge(h,i)..
             TES_in(h,i) =l= TES_max_chr_rate*TES_en(h,i);

capacity_TES(h,i)..
             TES_en(h,i) =l= TES_cap(i);

******** Transmission equations******
trans1(h,i,j)$(heat_trans_capa(i,j) ne 0)..
         heat_trans(h,i,j) =e= -heat_trans(h,j,i);

********** HP equations **************
* P_HP is the heat output from the HP
capacity_HP(h,i)..
             P_HP(h,i) =l= HP_cap(i);

*********** CHP equations *************
* Output to objective P_chp, P_chp
* Input Efficiency CHP, heat/electricity share alpha

capacity_CHP(h,i)..
             P_CHP(h,i) =l= CHP_cap(i);
*P_CHP_heat(i,h) =l= capa_CHP_heat(i);
*P_CHP_elect(i,h) =l= capa_CHP_elect(i);
*P_CHP_heat(i,h)=P_CHP*(1/alpha)*eta_CHP
