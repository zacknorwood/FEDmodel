********************************************************************************
*----------------------------Define equations-----------------------------------
********************************************************************************
equation
           eq_VKA11     heating generation of VKA1
           eq_VKA12     cooling generation of VKA1
           eq_VKA13     maximum electricity usage by VKA1
           eq_VKA41     heating generation of VKA4
           eq_VKA42     cooling generation of VKA4
           eq_VKA43     maximum electricity usage by VKA4

           eq_h_Pana1            Eqauation related to Panna1 heat production
           eq_h_Panna1_dispatch  Equation determining when Panna1 is dispatchable

           eq_h_RGK1           Eqauation related to flue gas heat production
           eq_h_RGK1_dispatch  Equation determining when flue gas is dispatchable

           eq_AbsC1     for determining capacity of AR
           eq_AbsC2     relates cooling from AR

           eq_RM1       Refrigerator equation
           eq_RM2       Refrigerator equation

           eq_RMMC1     MC2 Refrigerator equation - heating
           eq_RMMC2     MC2 Refrigerator equation - cooling
           eq_RMMC3     MC2 investment constraint

           eq_ACC1      Refrigerator equation
           eq_ACC2      Refrigerator equation
           eq_ACC3      Temperature limit of Ambient Air Cooler

           eq_existPV   Production from existing PV install

           eq1_AbsCInv  Production equation-AbsChiller investment
           eq2_AbsCInv  Investment capacity-AbsChiller investment

           eq1_P2                production equation for P2
           eq2_P2                investment equation for P2
           eq_h_Panna2_research  P2 production constraint during research

           eq1_TURB     production equation for turbine-gen
           eq2_TURB     energy consumption equation for turbine-gen
           eq3_TURB     investment equation for turbine-gen

           eq_HP1       heat production from HP
           eq_HP2       cooling production from HP
           eq_HP3       for determining capacity of HP

           eq_TESen1    initial energy content of the TES
           eq_TESen2    energy content of the TES at hour h
           eq_TESen3    for determining the capacity of TES
           eq_TESdis    discharging rate of the TES
           eq_TESch     charging rate of the TES
           eq_TESinv    investment decision for TES

           eq_BTES_Sch   charging rate of shallow part the building
           eq_BTES_Sdis  discharging rate of shallow part the building
           eq_BTES_Sen1  initial energy content of shallow part of the building
           eq_BTES_Sen2  energy content of shallow part of the building at hour h
           eq_BTES_Den1  initial energy content of deep part of the building
           eq_BTES_Den2  energy content of deep part of the building at hour h
           eq_BS_BD      energy flow between the shallow and deep part of the building

           eq_BAC         investment decision equation for Building Advanced Control
           eq_BAC_savings hourly heat saved by BAC investment for each building

           eq_BES1       intial energy in the Battery
           eq_BES2       energy in the Battery at hour h
           eq_BES3       maximum energy in the Battery
           eq_BES_ch     maximum charging limit
           eq_BES_dis    maximum discharign limit

           eq_PV            electricity generated by PV
           eq_PV_cap_roof   capacity of installed PV on roofs
           eq_PV_cap_facade capacity of installed PV on facades

           eq_RMInv1     cooling production from RMInv
           eq_RMInv2     capacity determination of RMInv

           eq_hbalance1  AbsC uses heat either from GE's DH grid or Panna1
           eq_hbalance2  maximum heating export from AH system
           eq_hbalance3  heating supply-demand balance excluding AH buildings
           eq_hbalance4  heating supply-demand balance excluding nonAH buildings

           eq_dhn_constraint District heating network transfer limit

           eq_cbalance   Balance equation cooling

           eq_ebalance3  supply demand balance equation from AH
           eq_ebalance4  electrical import equation to nonAH

           eq_PE         Hourly PE use in the FED system
           eq_totPE      Total PE use in the FED system
           eq_CO2        FED CO2 emission

           eq_max_exG maximum monthly peak demand
           eq_PTexG   monthly power tariff

           eq_mean_DH daily mean power DH
           eq_PT_DH   power tariff DH

           eq_fix_cost_existing total fixed cost for existing units
           eq_fix_cost_new      total fixed cost for new units
           eq_var_cost_existing total variable cost for existing units
           eq_var_cost_new      total variable cost for new units
           eq_Ainv_cost  total annualized investment cost
           eq_invCost    with aim to minimize investment cost
           eq_totCost    with aim to minimize total cost including fuel and O&M
           eq_CO2_tot    with aim to minimize total FED CO2 emission
           eq_peak_CO2   with aim to to reduce CO2 peak

           eq_obj        Objective function
;

*-------------------------------------------------------------------------------
*--------------------------Define equations-------------------------------------
*-------------------------------------------------------------------------------

***************For Existing units***********************************************
*-----------------VKA4 equations------------------------------------------------
eq_VKA11(h)..
        H_VKA1(h) =l= VKA1_H_COP*el_VKA1(h);
eq_VKA12(h)..
        C_VKA1(h) =l= VKA1_C_COP*el_VKA1(h);
eq_VKA13(h)..
        el_VKA1(h) =l= VKA1_el_cap;

*-----------------VKA4 equations------------------------------------------------
eq_VKA41(h)..
        H_VKA4(h) =l= VKA4_H_COP*el_VKA4(h);
eq_VKA42(h)..
        C_VKA4(h) =l= VKA4_C_COP*el_VKA4(h);
eq_VKA43(h)..
        el_VKA4(h) =l= VKA4_el_cap;

*------------------Panna1 equation(when dispachable)----------------------------
eq_h_Pana1(h)..
        h_Pana1(h)=l=Panna1_cap;

eq_h_Panna1_dispatch(h)$(P1P2_dispatchable(h)=0)..
        h_Pana1(h) =e= qB1(h);

eq_h_RGK1(h)..
        h_RGK1(h)$(P1P2_dispatchable(h)=1)=l=h_Pana1(h)/6;

eq_h_RGK1_dispatch(h)$(P1P2_dispatchable(h)=0)..
        h_RGK1(h) =e= qF1(h);

*-----------AbsC (Absorption Chiller) equations  (Heat => cooling )-------------
eq_AbsC1(h)..
             c_AbsC(h) =e= AbsC_COP*h_AbsC(h);
*AbsC_eff;
eq_AbsC2(h)..
             c_AbsC(h) =l= AbsC_cap;

*----------Refrigerator Machine equations (electricity => cooling)--------------
eq_RM1(h)..
             c_RM(h) =e= RM_COP*el_RM(h);
eq_RM2(h)..
             c_RM(h) =l= RM_cap;

********** Ambient Air Cooling Machine equations (electricity => cooling)-------
eq_ACC1(h)..
             c_AAC(h) =e= AAC_COP*e_AAC(h);
eq_ACC2(h)..
             c_AAC(h) =l= AAC_cap;

eq_ACC3(h)$(tout(h)>AAC_TempLim)..
             c_AAC(h)=l= 0;

*----------------Equations for existing PV--------------------------------------
eq_existPV(h)..
             e_existPV(h) =e= eta_Inverter * (sum(BID, exist_PV_cap_roof(BID) * PV_power_roof(h,BID))
                                              + sum(BID, exist_PV_cap_facade(BID) * PV_power_facade(h,BID)));

*****************For new investment optons--------------------------------------
*----------MC2 Heat pump equations (electricity => heating + cooling)-----------
eq_RMMC1(h)..
         h_RMMC(h) =e= RMCC_H_COP * e_RMMC(h);
eq_RMMC2(h)..
         c_RMMC(h) =e= RMCC_C_COP * e_RMMC(h);
eq_RMMC3(h)..
         c_RMMC(h) =l= RMMC_inv * RMMC_cap;

*----------------Absorption Chiller Investment----------------------------------
eq1_AbsCInv(h)..
             c_AbsCInv(h) =e= AbsCInv_COP*h_AbsCInv(h);
*AbsC_eff;
eq2_AbsCInv(h)..
             c_AbsCInv(h) =l= AbsCInv_cap;

*----------------Panna 2 equations ---------------------------------------------
eq1_P2(h)..
         h_P2(h) =e= fuel_P2(h) * P2_eff;
eq2_P2(h)..
         h_P2(h) =l= B_P2 * P2_cap;

eq_h_Panna2_research(h)$(P1P2_dispatchable(h)=0)..
         h_P2(h) =e= B_P2 * P2_reseach_prod;

*----------------Refurb turbine equations --------------------------------------
eq1_TURB(h)..
         e_TURB(h) =e= TURB_eff * h_TURB(h);

eq2_TURB(h)..
         H_P2T(h) =l= h_P2(h) - h_TURB(h);

eq3_TURB(h)..
         e_TURB(h) =l= B_TURB * TURB_cap;

*----------------HP equations --------------------------------------------------
eq_HP1(h)..
             h_HP(h) =e= HP_H_COP*e_HP(h);
eq_HP2(h)..
             c_HP(h) =l= HP_C_COP*e_HP(h);
eq_HP3(h)..
             h_HP(h) =l= HP_cap;

*------------------TES equations------------------------------------------------
eq_TESen1(h,i)$(ord(h) eq 1)..
             TES_en(h) =e= 0;
*sw_TES*TES_cap*TES_density;

eq_TESen2(h)$(ord(h) gt 1)..
             TES_en(h) =e= TES_hourly_loss_fac*(TES_en(h-1)+TES_ch(h)-TES_dis(h));
eq_TESen3(h)..
             TES_en(h) =l= TES_cap * TES_density;
eq_TESch(h)..
             TES_ch(h) =l= TES_inv * TES_ch_max;
eq_TESdis(h)..
             TES_dis(h) =l= TES_inv * TES_dis_max;
eq_TESinv(h)..
             TES_cap =l= TES_inv * TES_max_cap;
*eq_TESmininv $(sw_TES eq 1)..
*             TES_cap =G= sw_TES*TES_inv * 100;

*------------------BTES equations (Building srorage)----------------------------
eq_BTES_Sen1(h,i) $ (ord(h) eq 1)..
         BTES_Sen(h,i) =e= 0;
* sw_BTES*BTES_Sen_int(i);
eq_BTES_Sch(h,i) ..
         BTES_Sch(h,i) =l= B_BITES(i)*BTES_Sch_max(h,i);
eq_BTES_Sdis(h,i)..
         BTES_Sdis(h,i) =l= B_BITES(i)*BTES_Sdis_max(h,i);
eq_BTES_Sen2(h,i) $ (ord(h) gt 1)..
         BTES_Sen(h,i) =e= (BTES_kSloss(i)*BTES_Sen(h-1,i) - BTES_Sdis(h,i)/BTES_Sdis_eff
                           + BTES_Sch(h,i)*BTES_Sch_eff - link_BS_BD(h,i));
eq_BTES_Den1(h,i) $ (ord(h) eq 1)..
         BTES_Den(h,i) =e= 0;
* sw_BTES*BTES_Den_int(i);
eq_BTES_Den2(h,i) $ (ord(h) gt 1)..
         BTES_Den(h,i) =e= (BTES_kDloss(i)*BTES_Den(h-1,i) + link_BS_BD(h,i));
eq_BS_BD(h,i) $ (BTES_model('BTES_Scap',i) ne 0)..
         link_BS_BD(h,i) =e= ((BTES_Sen(h,i)/BTES_model('BTES_Scap',i)
                              - BTES_Den(h,i)/BTES_model('BTES_Dcap',i))*BTES_model('K_BS_BD',i));

*-----------------BAC constraints-----------------------------------------------
eq_BAC(i)..
         B_BAC(i) =l= B_BITES(i);

eq_BAC_savings(h,i)..
         h_BAC_savings(h,i) =l= BAC_savings_period(h)*B_BAC(i)*BAC_savings_factor*h_demand(h,i);

*-----------------Battery constraints-------------------------------------------
eq_BES1(h) $ (ord(h) eq 1)..
             BES_en(h)=e= 0;
*sw_BES*BES_cap;
eq_BES2(h)$(ord(h) gt 1)..
             BES_en(h)=e=(BES_en(h-1)+BES_ch(h)-BES_dis(h));
eq_BES3(h) ..
             BES_en(h)=l=BES_cap;
eq_BES_ch(h) ..
*Assuming 1C charging
             BES_ch(h)=l=(BES_cap-BES_en(h));
eq_BES_dis(h)..
*Assuming 1C discharging
             BES_dis(h)=l=BES_en(h);

*-----------------Solar PV equations--------------------------------------------
** Original Matlab Code (P is per WattPeak of Solar PV)
*P(index)=
*Gekv(index).*(1 + coef(1).*log(Gekv(index))
*+ coef(2).*log(Gekv(index)).^2
*+ coef(3).*Tekv(index)
*+ coef(4).*Tekv(index).*log(Gekv(index))
*+ coef(5).*Tekv(index).*log(Gekv(index)).^2
*+ coef(6).*Tekv(index).^2);
eq_PV(h)..
             e_PV(h) =e= eta_Inverter * (sum(BID, PV_cap_roof(BID) * PV_power_roof(h,BID))
                                              + sum(BID, PV_cap_facade(BID) * PV_power_facade(h,BID)));
eq_PV_cap_roof(BID)..
             PV_cap_roof(BID) =l= area_roof_max(BID)*PV_cap_density;

eq_PV_cap_facade(BID)..
             PV_cap_facade(BID) =l= area_facade_max(BID)*PV_cap_density;

*-----------------Refrigeration machine investment equations--------------------
eq_RMInv1(h)..
             c_RMInv(h) =e= RMInv_COP*e_RMInv(h);
eq_RMInv2(h)..
             c_RMInv(h) =l= RMInv_cap;

**************************Demand Supply constraints*****************************
*---------------- Demand supply balance for heating ----------------------------
eq_hbalance1(h)..
             h_imp_AH(h) - h_exp_AH(h) + h_Pana1(h) =g= h_AbsC(h);
eq_hbalance2(h)..
             h_exp_AH(h) =l= h_Pana1(h);
eq_hbalance3(h)..
             sum(i,h_demand(h,i)) =l=h_imp_AH(h) + h_imp_nonAH(h) - h_exp_AH(h)  + h_Pana1(h) + h_RGK1(h) + H_VKA1(h)
                                     + H_VKA4(h) - h_AbsC(h) + H_P2T(h) + 0.75*h_TURB(h) + h_RMMC(h)
                                     + h_HP(h)
                                     + (TES_dis_eff*TES_dis(h)-TES_ch(h)/TES_chr_eff)
                                     + (sum(i,BTES_Sdis(h,i))*BTES_dis_eff - sum(i,BTES_Sch(h,i))/BTES_chr_eff)
                                     + (sum(i,h_BAC_savings(h,i)))
                                     - h_AbsCInv(h);
eq_hbalance4(h)..
             h_imp_nonAH(h)=e=sum(i_nonAH_h,h_demand_nonAH(h,i_nonAH_h))
                       - (sum(i_nonAH_h,BTES_Sdis(h,i_nonAH_h))*BTES_dis_eff-sum(i_nonAH_h,BTES_Sch(h,i_nonAH_h))/BTES_chr_eff);

*---------------District heating network constraints----------------------------
$ontext
       Node Fysik is infeasible (reavealed from temp_slack values).
       Should be fixed by doing:
       1) Need to add all production units to the equation
         a) replace 'H_VKA4(h) with the hourly sum of all production in the Fysik node
       2) Need to add all charging/discharging of heat storage to equation
*$(not DH_node_transfer_limits(h, DH_Node_ID) = NA)..
$offtext
eq_dhn_constraint(h, DH_Node_ID)..
         DH_node_transfer_limits(h, DH_Node_ID)*1000 + temp_slack(h, DH_Node_ID)  =g= sum( i, h_demand(h, i)$DHNodeToB_ID(DH_Node_ID, i) )
                 - (h_RMMC(h)) $(sameas(DH_Node_ID, 'Fysik'))
                 - (H_VKA4(h) + H_VKA1(h) + h_Pana1(h) + h_RGK1(h) + h_AbsC(h) + h_AbsCInv(h) + H_P2T(h) + 0.75*h_TURB(h) + h_HP(h) + TES_dis(h) - TES_ch(h) + h_imp_AH(h) - h_exp_AH(h)) $(sameas(DH_Node_ID, 'Maskin'))
;
*                 - () $(sameas(DH_Node_ID, 'Bibliotek'))
*                 - () $(sameas(DH_Node_ID, 'EDIT'))
*                 - () $(sameas(DH_Node_ID, 'VoV'))
*                 - () $(sameas(DH_Node_ID, 'Eklanda'));


*-------------- Demand supply balance for cooling ------------------------------
eq_cbalance(h)..
         sum(i_AH_c,c_demand_AH(h,i_AH_c))=l=C_DC(h) + C_VKA1(h) + C_VKA4(h) +  c_AbsC(h)
                                + c_RM(h) + c_RMMC(h) + c_AAC(h) + c_HP(h) + c_RMInv(h)
                                + c_AbsCInv(h);

*--------------Demand supply balance for electricity ---------------------------
eq_ebalance3(h)..
        sum(i_AH_el,el_demand(h,i_AH_el)) =l= e_imp_AH(h) - e_exp_AH(h) - el_VKA1(h) - el_VKA4(h) - el_RM(h) - e_RMMC(h) - e_AAC(h)
                                 + e_existPV(h) + e_PV(h) - e_HP(h) - e_RMInv(h)
                                 + (BES_dis(h)*BES_dis_eff - BES_ch(h)/BES_ch_eff)
                                 + e_TURB(h);
eq_ebalance4(h)..
        sum(i_nonAH_el,el_demand(h,i_nonAH_el)) =l= e_imp_nonAH(h);

*--------------FED Primary energy use-------------------------------------------
eq_PE(h)..
        FED_PE(h)=e= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*PEF_exG(h)
                     + e_existPV(h)*PEF_PV + e_PV(h)*PEF_PV
                     + (h_imp_AH(h)-h_exp_AH(h)*DH_export_season(h) + h_imp_nonAH(h))*PEF_DH(h) + ((h_Pana1(h)+h_RGK1(h))/P1_eff)*PEF_P1
                     + fuel_P2(h)*PEF_P2;

**********************Total PE use in the FED system****************************
eq_totPE..
         tot_PE=e=sum(h,FED_PE(h));

*---------------FED CO2 emission------------------------------------------------
eq_CO2(h)..
       FED_CO2(h) =e= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*CO2F_exG(h)
                      + e_existPV(h)*CO2F_PV + e_PV(h)*CO2F_PV
                      + (h_imp_AH(h)-h_exp_AH(h)*DH_export_season(h) + h_imp_nonAH(h))*CO2F_DH(h) + ((h_Pana1(h)+h_RGK1(h))/P1_eff)*CO2F_P1
                      + fuel_P2(h) * CO2F_P2;

****************Total CO2 emission in the FED system****************************
eq_CO2_TOT..
         FED_CO2_tot =e= sum(h, FED_CO2(h));

**************** Power tariffs *******************
eq_max_exG(h,m)..
               max_exG(m) =g= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*HoM(h,m);
eq_PTexG(m)..
               PT_exG(m) =e= max_exG(m)*PT_cost('exG');

eq_mean_DH(d)..
              mean_DH(d) =g=   sum(h,(h_imp_AH(h)-h_exp_AH(h) + h_imp_nonAH(h))*HoD(h,d))/24;

eq_PT_DH(d)..
              PT_DH      =g=   mean_DH(d)*PT_cost('DH');

**************** Objective function ***********************
*       sup_unit   supply units /PV, HP, BES, TES, BTES, RMMC, P1, P2, TURB, AbsC, AbsCInv, AAC, RM, exG, DH, CHP/
eq_fix_cost_existing..
         fix_cost_existing =e= sum(sup_unit,fix_cost(sup_unit)*cap_sup_unit(sup_unit));

eq_fix_cost_new..
         fix_cost_new =e=  (sum(BID, PV_cap_roof(BID) + PV_cap_facade(BID)))*fix_cost('PV')
                           + HP_cap*fix_cost('HP')
                           + BES_cap*fix_cost('BES')
                           + TES_cap*fix_cost('TES')
                           + RMInv_cap*fix_cost('RMInv')
                           + fix_cost('BTES')*sum(i,B_BITES(i))
                           + B_P2 * fix_cost('P2')
                           + B_TURB * fix_cost('TURB')
                           + fix_cost('AbsCInv');
eq_var_cost_existing..
         var_cost_existing =e= sum(h, (e_imp_AH(h) + e_imp_nonAH(h))*utot_cost('exG',h)) + sum(m,PT_exG(m))
                               -sum(h,e_exp_AH(h)*el_sell_price(h))
                               + sum(h,(h_imp_AH(h) + h_imp_nonAH(h))*utot_cost('DH',h))  + PT_DH
                               - sum(h,h_exp_AH(h)*DH_export_season(h)*0.3)
                               + sum(h,h_Pana1(h)*utot_cost('P1',h))
                               + sum(h,H_VKA1(h)*utot_cost('HP',h))
                               + sum(h,H_VKA4(h)*utot_cost('HP',h))
                               + sum(h,c_AbsC(h)*utot_cost('AbsC',h))
                               + sum(h,c_RM(h)*utot_cost('RM',h))
                               + sum(h,c_RMMC(h)*utot_cost('RM',h))
                               + sum(h,c_AAC(h)*utot_cost('AAC',h))
                               + sum(h,e_existPV(h)*utot_cost('PV',h))
                               + sum(DH_Node_ID, sum(h, temp_slack(h, DH_Node_ID)))*10**6;
eq_var_cost_new..
         var_cost_new =e=  sum(h,e_PV(h)*utot_cost('PV',h))
                           + sum(h,h_HP(h)*utot_cost('HP',h))
                           + sum(h,c_RMInv(h)*utot_cost('RMInv',h))
                           + sum(h,BES_dis(h)*utot_cost('BES',h))
                           + sum(h,TES_dis(h)*utot_cost('TES',h))
                           + sum((h,i),BTES_Sch(h,i)*utot_cost('BTES',h))
                           + sum(h,h_P2(h)*utot_cost('P2',h))
                           + sum(h,e_TURB(h)*utot_cost('TURB',h))
                           + sum(h,c_AbsCInv(h)*utot_cost('AbsCInv',h));
eq_Ainv_cost..
          Ainv_cost =e=
                + HP_cap*cost_inv_opt('HP')/lifT_inv_opt('HP')
                + RMInv_cap*cost_inv_opt('RMInv')/lifT_inv_opt('RMInv')
                + (sum(BID, PV_cap_roof(BID) + PV_cap_facade(BID)))*cost_inv_opt('PV')/lifT_inv_opt('PV')
                + BES_cap*cost_inv_opt('BES')/lifT_inv_opt('BES')
                + (TES_cap*TES_vr_cost + TES_inv * TES_fx_cost)/lifT_inv_opt('TES')
                + cost_inv_opt('BTES')*sum(i,B_BITES(i))/lifT_inv_opt('BTES')
                + cost_inv_opt('BAC')*sum(i,B_BAC(i))/lifT_inv_opt('BAC')
                + RMMC_inv*cost_inv_opt('RMMC')/lifT_inv_opt('RMMC')
                + B_P2 * cost_inv_opt('P2')/lifT_inv_opt('P2')
                + B_TURB * cost_inv_opt('TURB')/lifT_inv_opt('TURB')
                + AbsCInv_cap * cost_inv_opt('AbsCInv')/lifT_inv_opt('AbsCInv');
eq_totCost..
         totCost =e= fix_cost_existing + var_cost_existing
                     + fix_cost_new + var_cost_new + Ainv_cost;
****************Total investment cost*******************************************
eq_invCost..
         invCost =e= HP_cap*cost_inv_opt('HP')
                     + RMInv_cap*cost_inv_opt('RMInv')
                     + (sum(BID, PV_cap_roof(BID) + PV_cap_facade(BID)))*cost_inv_opt('PV')
                     + BES_cap*cost_inv_opt('BES')
                     + ((TES_cap*TES_vr_cost + TES_inv * TES_fx_cost))
                     + cost_inv_opt('BTES')*sum(i,B_BITES(i))
                     + cost_inv_opt('BAC')*sum(i,B_BAC(i))
                     + RMMC_inv*cost_inv_opt('RMMC')
                     + B_P2 * cost_inv_opt('P2')
                     + B_TURB * cost_inv_opt('TURB')
                     + AbsCInv_cap * cost_inv_opt('AbsCInv');
eq_peak_CO2(h)..
          peak_CO2=g=FED_CO2(h);

****************Objective function**********************************************
eq_obj..
         obj =e= min_totCost*totCost
                + min_totPE*tot_PE
                + min_totCO2*FED_CO2_tot;
********************************************************************************
