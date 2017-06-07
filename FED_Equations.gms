******************************************************************************
*----------------------------Define equations--------------------------------
******************************************************************************

equation
           eq_HP        for determining capacity of HP
           eq_AC1       for determining capacity of AR
           eq_AC2       for determining capacity of AR
           eq_R1        Refrigerator equation
           eq_R2        Refrigerator equation
           eq_CHP       for determining the capacity of CHP

           eq_TESen1       initial energy content of the TES
           eq_TESen2       energy content of the TES at hour h
           eq_TESen3       for determining the capacity of TES
           eq_TESdis       discharging rate of the TES
           eq_TESch        charging rate of the TES

           eq_BTES_Sch      charging rate of shallow part the building
           eq_BTES_Sdis     discharging rate of shallow part the building
           eq_BTES_Sen1     initial energy content of shallow part of the building
           eq_BTES_Sen2     energy content of shallow part of the building at hour h
           eq_BTES_Sloss    loss of the shallow part of the building at hour h [8-17]

           eq_BTES_Den1     initial energy content of deep part of the building
           eq_BTES_Den2     energy content of deep part of the building at hour h
           eq_BTES_Dloss    loss of the deep part of the building at hour h

           eq_BS_BD         energy flow between the shallow and deep part of the building

           eq_BES1          intial energy in the Battery
           eq_BES2          energy in the Battery at hour h
           eq_BES3          maximum energy in the Battery
           eq_BES_ch        maximum charging limit
           eq_BES_dis       maximum discharign limit

           eq_hbalance     heating supply-demand balance
           eq_cbalance     Balance equation cooling
           eq_ebalance     electrical supply-demand balance
           eq_htrans       transmission of heat is one direction is negative of transmission in other direction
           eq_etrans       transmission of heat is one direction is negative of transmission in other direction

           eq_totCost      with aim to minimize total cost
;

*-----------------------------------------------------------------------------
*--------------------------Define equations-----------------------------------
*-----------------------------------------------------------------------------
********** HP equations **************
eq_HP(h)..
             P_HP(h) =l= HP_cap;

********** AC (Absorbtion Chiller) equations **************
eq_AC1(h)..
             C_AC(h) =e= AC_COP*H_AC(h);
eq_AC2(h)..
             C_AC(h) =l= AC_cap;

********** Refregerator equations **************
eq_R1(h)..
             C_R(h) =e= R_COP*el_R(h);
eq_R2(h)..
             C_R(h) =l= R_cap;

*********** CHP equations *************
eq_CHP(h)..
             P_CHP(h) =l= CHP_cap;
*P_CHP_heat(i,h) =l= capa_CHP_heat(i);
*P_CHP_elect(i,h) =l= capa_CHP_elect(i);
*P_CHP_heat(i,h)=P_CHP*(1/alpha)*eta_CHP

********** TES equations *************
eq_TESen1(h,i)$(ord(h) eq 1)..
             TES_en('H1') =e= TES_cap;
eq_TESen2(h)$(ord(h) gt 1)..
             TES_en(h) =e= TES_en(h-1)+TES_ch(h)-TES_dis(h);
eq_TESen3(h)..
             TES_en(h) =l= TES_cap;
eq_TESch(h)..
             TES_ch(h) =l= TES_ch_max(h);
eq_TESdis(h)..
             TES_dis(h) =l= TES_dis_max(h);

*------------------BTES equations (Building srorage)---------------------
eq_BTES_Sen1(h,i) $ (ord(h) eq 1)..
         BTES_Sen(h,i) =e= BTES_Sen_int(i);
eq_BTES_Sch(h,i)..
         BTES_Sch(h,i) =l= BTES_Sch_max(h,i);
eq_BTES_Sdis(h,i)..
         BTES_Sdis(h,i) =l= BTES_Sdis_max(h,i);
eq_BTES_Sloss(h,i)$ (ord(h) gt 1)..
         BTES_Sloss(h,i) =e= BTES_Sen(h-1,i)*BTES_kSloss(h-1,i);
eq_BTES_Sen2(h,i) $ (ord(h) gt 1)..
         BTES_Sen(h,i) =e= BTES_Sen(h-1,i) - BTES_Sdis(h,i)/BTES_Sdisch_eff
                           + BTES_Sch(h,i)*BTES_Sch_eff - link_BS_BD(h,i) - BTES_Sloss(h,i);

eq_BTES_Den1(h,i) $ (ord(h) eq 1)..
         BTES_Den(h,i) =e= BTES_Den_int(i);
eq_BTES_Dloss(h,i) $ (ord(h) gt 1)..
         BTES_Dloss(h,i) =e= BTES_Den(h-1,i)*BTES_kDloss(h-1,i);
eq_BTES_Den2(h,i) $ (ord(h) gt 1)..
         BTES_Den(h,i) =e= BTES_Den(h-1,i) + link_BS_BD(h,i) - BTES_Dloss(h,i);

eq_BS_BD(h,i)..
         link_BS_BD(h,i) =e= (BTES_Sen(h,i)/BTES_model(i,'BTES_Scap')
                              - BTES_Den(h,i)/BTES_model(i,'BTES_Dcap'))*BTES_model(i,'K_BS_BD');

**************Battery constraints*****************
eq_BES1(h) $ (ord(h) eq 1)..
             BES_en(h)=e=BES_cap*sw_BES;
eq_BES2(h)$(ord(h) gt 1)..
             BES_en(h)=e=(BES_en(h-1)+BES_ch(h)-BES_dis(h))*sw_BES;
eq_BES3(h)..
             BES_en(h)=l=BES_cap*sw_BES;
eq_BES_ch(h)..
             BES_ch(h)=l=BES_ch_max;
eq_BES_dis(h)..
             BES_dis(h)=l=BES_dis_max;

******* Demand supply balance for heating *******
eq_hbalance(h)..
             sum(i,heat_demand(h,i)) =e=sum(i,P_DH(h,i)) + (sum(i,BTES_Sdis(h,i))-sum(i,BTES_Sch(h,i)))*sw_BTES
                                        + P_HP(h)*sw_HP + (TES_dis_eff*TES_dis(h)-TES_ch(h)/TES_chr_eff)*sw_TES
                                        + P_CHP(h)/((1+CHP_el_heat)*CHP_eff)*sw_CHP - C_AC(h)*sw_AC;

*sum(i,heat_demand(h,i)-P_DH(h,i)-(BTES_Sdis(h,i) - BTES_Sch(h,i))-sum(j,heat_trans(h,i,j))*sw_trans) =e=
*                             P_HP(h)*sw_HP + (TES_dis_eff*TES_dis(h)-TES_ch(h)/TES_chr_eff)*sw_TES +
*                            P_CHP(h)/((1+CHP_el_heat)*CHP_eff)*sw_CHP -P_AR(h);

***** Demand supply balance for cooling *******
eq_cbalance(h)..
         sum(i,cooling_demand(h,i))=e=sum(i,P_DC(h,i)) + C_AC(h) + C_R(h);

******* Demand supply balance for electricity *******
eq_ebalance(h)..
        sum(i,el_demand(h,i)) =e= sum(i,P_el(h,i)) + sw_CHP*CHP_el_heat*P_CHP(h)/((1+CHP_el_heat)*CHP_eff)
                                  -sw_HP*P_HP(h)/HP_COP + BES_dis(h)-BES_ch(h) - el_R(h)*sw_R;

******** Transmission equations******
eq_htrans(h,i,j)$(heat_trans_capa(i,j) ne 0)..
         heat_trans(h,i,j) =e= -heat_trans(h,j,i);

******** Transmission equations******
eq_etrans(h,i,j)$(el_trans_capa(i,j) ne 0)..
         el_trans(h,i,j) =e= -el_trans(h,j,i);

**************** Objective function ***********************
eq_totCost..
         TC =e= sum((h,i),P_DH(h,i)*fp('WOOD')+P_el(h,i)*el_price(h))+sum(h,P_CHP(h)*fp('WOOD'))
                +(sw_HP*HP_cap*50+sw_AC*AC_cap*50)+(+sw_CHP*CHP_cap*100+sw_TES*TES_cap*50+BES_cap*BES_cost);

