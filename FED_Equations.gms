********************************************************************************
*----------------------------Define equations-----------------------------------
********************************************************************************
equation

           eq_VKA11     heating generatin of VKA1
           eq_VKA12     cooling generation of VKA1
           eq_VKA13     maximum electricity usage by VKA1
           eq_VKA41     heating generation of VKA4
           eq_VKA42     cooling generation of VKA4
           eq_VKA43     maximum electricity usage by VKA4

           eq1_h_Pana1            Eqauation related to Panna1 heat production
           eq2_h_Pana1         ramp constraint set to 1MW
           eq3_h_Pana1         ramp constraint set to 1MW
           eq4_h_Pana1         ramp constraint set to 1MW
           eq5_h_Pana1         ramp constraint set to 1MW
           eq6_h_Pana1         fixed panna1 for synth baseline
           eq_h_Panna1_dispatch  Equation determining when Panna1 is dispatchable

           eq_h_RGK11           Eqauation related to flue gas heat production
           eq_h_RGK12          Fixed FGC for synthetic baseline
           eq_h_RGK1_dispatch  Equation determining when flue gas is dispatchable

           eq_AbsC1     for determining capacity of AR
           eq_AbsC2     relates cooling from AR

           eq_RM1       Refrigerator equation
           eq_RM2       Refrigerator equation

           eq_ACC1      Refrigerator equation
           eq_ACC2      Refrigerator equation
           eq_ACC3      Temperature limit of Ambient Air Cooler

           eq_existPV   Production from existing PV install
           eq_existPV_active Active power production of existing PVs
           eq_existPV_reactive1 Reactive power limit of existing PVs
           eq_existPV_reactive2 Reactive power limit of existing PVs
           eq_existPV_reactive3 Reactive power limit of existing PVs
           eq_existPV_reactive4 Reactive power limit of existing PVs

           eq_RMMC1     MC2 Refrigerator equation - heating
           eq_RMMC2     MC2 Refrigerator equation - cooling
           eq_RMMC3     MC2 investment constraint

           eq_CWB_en_init        Cold Water Basin initial charge state
           eq_CWB_en             Cold Water Basin charge equation

           eq1_AbsCInv  Production equation-AbsChiller investment
           eq2_AbsCInv  Investment capacity-AbsChiller investment

           eq1_P2                production equation for P2
           eq2_P2                investment equation for P2
           eq_h_Panna2_research  P2 production constraint during research

           eq1_TURB     production equation for turbine-gen
           eq2_TURB     energy consumption equation for turbine-gen
           eq3_TURB     investment equation for turbine-gen
           eq4_TURB     active-reactive power limits of turbine
           eq5_TURB     active-reactive power limits of turbine
           eq6_TURB     active-reactive power limits of turbin
           eq7_TURB     active-reactive power limits of turbin

           eq_HP1       heat production from HP
           eq_HP2       cooling production from HP
           eq_HP3       for determining capacity of HP

           eq_TESen0    initial energy content of the TES
           eq_TESen1    initial energy content of the TES
           eq_TESen2    energy content of the TES at hour h
           eq_TESen3    for determining the capacity of TES
           eq_TESdis    discharging rate of the TES
           eq_TESch     charging rate of the TES
           eq_TESinv    investment decision for TES

           eq_BTES_Sch   charging rate of shallow part the building
           eq_BTES_Sdis  discharging rate of shallow part the building
           eq_BTES_Sen0  initial energy content of shallow part of the building
           eq_BTES_Sen1  initial energy content of shallow part of the building
           eq_BTES_Sen2  energy content of shallow part of the building at hour h
           eq_BTES_Den0  initial energy content of deep part of the building
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
           eq_BES_reac1  equation 1 for reactive power of BES
           eq_BES_reac2  equation 2 for reactive power of BES
           eq_BES_reac3  equation 3 for reactive power of BES
           eq_BES_reac4  equation 4 for reactive power of BES
           eq_BES_reac5  equation 5 for reactive power of BES
           eq_BES_reac6  equation 6 for reactive power of BES
           eq_BES_reac7  equation 7 for reactive power of BES
           eq_BES_reac8  equation 8 for reactive power of BES

           eq_BFCh1       intial energy in the Battery Fast charge
           eq_BFCh2       energy in the Battery Fast Charge at hour h
           eq_BFCh3       maximum energy in the Battery Fast Charge
           eq_BFCh_ch     maximum charging limit
           eq_BFCh_dis    maximum discharign limit
           eq_BFCh_reac1  equation 1 for reactive power of BFCh
           eq_BFCh_reac2  equation 2 for reactive power of BFCh
           eq_BFCh_reac3  equation 3 for reactive power of BFCh
           eq_BFCh_reac4  equation 4 for reactive power of BFCh
           eq_BFCh_reac5  equation 5 for reactive power of BFCh
           eq_BFCh_reac6  equation 6 for reactive power of BFCh
           eq_BFCh_reac7  equation 7 for reactive power of BFCh
           eq_BFCh_reac8  equation 8 for reactive power of BFCh

           eq_PV            electricity generated by PV
           eq_PV_cap_roof   capacity of installed PV on roofs
           eq_PV_cap_facade capacity of installed PV on facades
           eq_PV_active_roof active power generated by PV
           eq_PV_reactive1  Reactive power limit of Pvs
           eq_PV_reactive2  Reactive power limit of Pvs
           eq_PV_reactive3  Reactive power limit of Pvs
           eq_PV_reactive4  Reactive power limit of Pvs

           eq_RMInv1     cooling production from RMInv
           eq_RMInv2     capacity determination of RMInv


           eq_hbalance1  maximum heating export from AH system
           eq_hbalance2  heating supply-demand balance excluding AH buildings
           eq_hbalance3  heating supply-demand balance excluding nonAH buildings

           eq_dhn_constraint District heating network transfer limit
           eq_dh_node_flows Summing of flows in district heating network
           eq_dcn_constraint District cooling network transfer limit
           eq_DC_node_flows Summing of flows in district cooling network


           eq_cbalance   Balance equation cooling

           eq_ebalance3  supply demand balance equation from AH
           eq_ebalance4  electrical import equation to nonAH
           eq_dcpowerflow1  active power balance equation
           eq_dcpowerflow2  reactive power balance equation
           eq_dcpowerflow3  line limits equations
           eq_dcpowerflow4  line limits equations
           eq_dcpowerflow5  line limits equations
           eq_dcpowerflow6  line limits equations
           eq_dcpowerflow7  line limits equations
           eq_dcpowerflow8  line limits equations
           eq_dcpowerflow9  line limits equations
           eq_dcpowerflow10  line limits equations
           eq_dcpowerflow11  slack angle constraint
           eq_dcpowerflow12  slack voltage constraint

           eq_PE         Hourly average PE use in the FED system
           eq_PE_ma      Hourly marginal PE use in the FED system
           eq_totPE      Total average PE use in the FED system
           eq_totPE_ma   Total marginal PE use in the FED system
           eq_CO2        FED CO2 average emission
           eq_CO2_ma     FED CO2 marginal emission

           eq_max_exG1 maximum monthly peak demand
           eq_max_exG2 maximum monthly peak demand
           eq_PTexG   monthly power tariff

           eq_mean_DH daily mean power DH
           eq_PT_DH   power tariff DH

           eq_fix_cost_existing total fixed cost for existing units
           eq1_fix_cost_DH      equation adding fixed cost for DH (4000SEK if import 0 otherwise)
           eq2_fix_cost_DH      equation adding fixed cost for DH (4000SEK if import 0 otherwise)
           eq3_fix_cost_DH      equation adding fixed cost for DH (4000SEK if import 0 otherwise)
           eq4_fix_cost_DH      equation adding fixed cost for DH (4000SEK if import 0 otherwise)

           eq_fix_cost_new      total fixed cost for new units
           eq_var_cost_existing total variable cost for existing units
           eq_var_cost_new      total variable cost for new units
           eq_Ainv_cost  total annualized investment cost
           eq_invCost    with aim to minimize investment cost
           eq_totCost    with aim to minimize total cost including fuel and O&M
           eq_CO2_TOT    with aim to minimize total FED aver. CO2 emission
           eq_CO2_TOT_ma with aim to minimize total FED marginal CO2 emission
           eq_peak_CO2   with aim to to reduce CO2 peak

           eq_obj        Objective function
;

*-------------------------------------------------------------------------------
*--------------------------Define equations-------------------------------------
*-------------------------------------------------------------------------------

***************For Existing units***********************************************
*-----------------VKA1 equations------------------------------------------------
eq_VKA11(h)..
        H_VKA1(h) =e= VKA1_H_COP*el_VKA1(h);
eq_VKA12(h)..
        C_VKA1(h) =e= VKA1_C_COP*el_VKA1(h);
eq_VKA13(h)..
        el_VKA1(h) =l= VKA1_el_cap;

*-----------------VKA4 equations------------------------------------------------
eq_VKA41(h)..
        H_VKA4(h) =e= VKA4_H_COP*el_VKA4(h);
eq_VKA42(h)..
        C_VKA4(h) =e= VKA4_C_COP*el_VKA4(h);
eq_VKA43(h)..
        el_VKA4(h) =l= VKA4_el_cap;

*------------------Panna1 equation(when dispachable)----------------------------
eq1_h_Pana1(h)..
        h_Pana1(h)=l=Panna1_cap;

eq2_h_Pana1(h)$(ord(h) gt 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0)..
        h_Pana1(h-1)- h_Pana1(h)=g=-1000;

eq3_h_Pana1(h)$(ord(h) gt 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0)..
        h_Pana1(h-1)- h_Pana1(h)=l=1000;

eq4_h_Pana1(h)$(ord(h) eq 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0)..
             Pana1_prev_disp- h_Pana1(h)=l=1000;

eq5_h_Pana1(h)$(ord(h) eq 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0)..
             Pana1_prev_disp- h_Pana1(h)=g=-1000;

eq6_h_Pana1(h)$(ord(h) eq 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 1)..
            h_Pana1(h)=e= Panna1(h);

eq_h_Panna1_dispatch(h)$(P1P2_dispatchable(h)=0)..
        h_Pana1(h) =e= qB1(h);

eq_h_RGK11(h)$(P1P2_dispatchable(h)=1 and synth_baseline eq 0)..
        h_RGK1(h)=l=h_Pana1(h)/6;

eq_h_RGK12(h)$(P1P2_dispatchable(h)=1 and synth_baseline eq 1)..
        h_RGK1(h)=e=FGC(h);

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

*----------Cold Water Basin equations (cold storage)----------------------------
eq_CWB_en_init(h)$(ord(h) eq 1)..
         CWB_en(h) =e= CWB_en_init;
eq_CWB_en(h)$(ord(h) gt 1)..
         CWB_en(h) =e= CWB_en(h-1)+CWB_ch(h)-CWB_dis(h);


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
eq_existPV_active(h,BID)..
             e_existPV_act(h,BID)=e= eta_Inverter*(exist_PV_cap_roof(BID)*PV_power_roof(h,BID)+
                                                  exist_PV_cap_facade(BID)*PV_power_facade(h,BID));

eq_existPV_reactive1(h,BID)..e_existPV_reac(h,BID)=l=tan(arccos(0.8))*e_existPV_act(h,BID);
eq_existPV_reactive2(h,BID)..e_existPV_reac(h,BID)=g=-tan(arccos(0.8))*e_existPV_act(h,BID);
eq_existPV_reactive3(h,BID)..-0.58*e_existPV_reac(h,BID)+e_existPV_act(h,BID)=l=1.15*exist_PV_cap_roof(BID)+exist_PV_cap_facade(BID);
eq_existPV_reactive4(h,BID)..0.58*e_existPV_reac(h,BID)+e_existPV_act(h,BID)=l=1.15*exist_PV_cap_roof(BID)+exist_PV_cap_facade(BID);
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

eq4_TURB(h)..e_TURB_reac(h)=l=0.4843*e_TURB(h);
eq5_TURB(h)..e_TURB_reac(h)=g=-0.4843*e_TURB(h);
eq6_TURB(h)..-0.58*e_TURB_reac(h)+e_TURB(h)=l=1.15*TURB_cap;
eq7_TURB(h)..+0.58*e_TURB_reac(h)+e_TURB(h)=l=1.15*TURB_cap;

*----------------HP equations --------------------------------------------------
eq_HP1(h)..
             h_HP(h) =e= HP_H_COP*e_HP(h);
eq_HP2(h)..
             c_HP(h) =l= HP_C_COP*e_HP(h);
eq_HP3(h)..
             h_HP(h) =l= HP_cap;

*------------------TES equations------------------------------------------------
eq_TESen0(h,i)$(ord(h) eq 1)..
             TES_en(h) =e= TES_hourly_loss_fac*(TES_en(h-1)+TES_ch(h)-TES_dis(h));

eq_TESen1(h,i)$(ord(h) eq 1)..
             TES_en(h) =e= opt_fx_inv_TES_init;
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
eq_BTES_Sen0(h,i) $ (ord(h) eq 1)..
         BTES_Sen(h,i) =e= (BTES_kSloss(i)*BTES_Sen(h-1,i) - BTES_Sdis(h,i)/BTES_Sdis_eff
                           + BTES_Sch(h,i)*BTES_Sch_eff - link_BS_BD(h,i));
eq_BTES_Sen1(h,i) $ (ord(h) eq 1)..
         BTES_Sen(h,i) =e= opt_fx_inv_BTES_S_init$(ord(i) eq 1);
* sw_BTES*BTES_Sen_int(i);
eq_BTES_Sch(h,i) ..
         BTES_Sch(h,i) =l= B_BITES(i)*BTES_Sch_max(h,i);
eq_BTES_Sdis(h,i)..
         BTES_Sdis(h,i) =l= B_BITES(i)*BTES_Sdis_max(h,i);
eq_BTES_Sen2(h,i) $ (ord(h) gt 1)..
         BTES_Sen(h,i) =e= (BTES_kSloss(i)*BTES_Sen(h-1,i) - BTES_Sdis(h,i)/BTES_Sdis_eff
                           + BTES_Sch(h,i)*BTES_Sch_eff - link_BS_BD(h,i));
eq_BTES_Den1(h,i) $ (ord(h) eq 1)..
         BTES_Den(h,i) =e= opt_fx_inv_BTES_D_init$(ord(i) eq 1);
* sw_BTES*BTES_Den_int(i);
eq_BTES_Den0(h,i) $ (ord(h) eq 1)..
         BTES_Den(h,i) =e= (BTES_kDloss(i)*BTES_Den(h-1,i) + link_BS_BD(h,i));
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
eq_BES1(h,j) $ (ord(h) eq 1)..
             BES_en(h,j)=e= opt_fx_inv_BES_init;
*sw_BES*BES_cap;
eq_BES2(h,j)$(ord(h) gt 1)..
             BES_en(h,j)=e=(BES_en(h-1,j)+BES_ch(h,j)-BES_dis(h,j));
eq_BES3(h,j) ..
             BES_en(h,j)=l=BES_cap(j);
eq_BES_ch(h,j) ..
*Assuming 1C charging
             BES_ch(h,j)=l=(BES_cap(j)-BES_en(h,j));
eq_BES_dis(h,j)..
*Assuming 1C discharging
             BES_dis(h,j)=l=BES_en(h,j);

eq_BES_reac1(h,j)..BES_reac(h,j)=l=opt_fx_inv_BES_maxP(j);
eq_BES_reac2(h,j)..BES_reac(h,j)=g=-opt_fx_inv_BES_maxP(j);
eq_BES_reac3(h,j)..-BES_ch(h,j)+BES_dis(h,j)=g=-opt_fx_inv_BES_maxP(j);
eq_BES_reac4(h,j)..-BES_ch(h,j)+BES_dis(h,j)=l=opt_fx_inv_BES_maxP(j);
eq_BES_reac5(h,j)..-0.58*BES_reac(h,j)-BES_ch(h,j)+BES_dis(h,j)=l=1.15*opt_fx_inv_BES_maxP(j);
eq_BES_reac6(h,j)..-0.58*BES_reac(h,j)-BES_ch(h,j)+BES_dis(h,j)=g=-1.15*opt_fx_inv_BES_maxP(j);
eq_BES_reac7(h,j)..0.58*BES_reac(h,j)-BES_ch(h,j)+BES_dis(h,j)=l=1.15*opt_fx_inv_BES_maxP(j);
eq_BES_reac8(h,j)..0.58*BES_reac(h,j)-BES_ch(h,j)+BES_dis(h,j)=g=-1.15*opt_fx_inv_BES_maxP(j);
*-----------------Battery Fast Charge constraints-------------------------------------------
eq_BFCh1(h,j) $ (ord(h) eq 1)..
             BFCh_en(h,j)=e= opt_fx_inv_BFCh_init;
*sw_BES*BES_cap;
eq_BFCh2(h,j)$(ord(h) gt 1)..
             BFCh_en(h,j)=e=(BFCh_en(h-1,j)+BFCh_ch(h,j)-BFCh_dis(h,j));
eq_BFCh3(h,j) ..
             BFCh_en(h,j)=l=BFCh_cap(j);
eq_BFCh_ch(h,j) ..
*Assuming 1C charging
             BFCh_ch(h,j)=l=(BFCh_cap(j)-BFCh_en(h,j));
eq_BFCh_dis(h,j)..
*Assuming 1C discharging
             BFCh_dis(h,j)=l=BFCh_en(h,j);

eq_BFCh_reac1(h,j)..BFCh_reac(h,j)=l=opt_fx_inv_BFCh_maxP(j);
eq_BFCh_reac2(h,j)..BFCh_reac(h,j)=g=-opt_fx_inv_BFCh_maxP(j);
eq_BFCh_reac3(h,j)..BFCh_ch(h,j)+BFCh_dis(h,j)=g=-opt_fx_inv_BFCh_maxP(j);
eq_BFCh_reac4(h,j)..BFCh_ch(h,j)+BFCh_dis(h,j)=l=opt_fx_inv_BFCh_maxP(j);
eq_BFCh_reac5(h,j)..-0.58*BFCh_reac(h,j)+BFCh_ch(h,j)+BFCh_dis(h,j)=l=1.15*opt_fx_inv_BFCh_maxP(j);
eq_BFCh_reac6(h,j)..-0.58*BFCh_reac(h,j)+BFCh_ch(h,j)+BFCh_dis(h,j)=g=-1.15*opt_fx_inv_BFCh_maxP(j);
eq_BFCh_reac7(h,j)..0.58*BFCh_reac(h,j)+BFCh_ch(h,j)+BFCh_dis(h,j)=l=1.15*opt_fx_inv_BFCh_maxP(j);
eq_BFCh_reac8(h,j)..0.58*BFCh_reac(h,j)+BFCh_ch(h,j)+BFCh_dis(h,j)=g=-1.15*opt_fx_inv_BFCh_maxP(j);
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
             e_PV(h) =e= eta_Inverter * (sum(PV_BID_roof_Inv, PV_roof_cap_Inv(PV_BID_roof_Inv) * PV_power_roof(h,PV_BID_roof_Inv))
                                              + sum(PV_BID_facade_Inv, PV_facade_cap_Inv(PV_BID_facade_Inv) * PV_power_facade(h,PV_BID_facade_Inv)));
eq_PV_cap_roof(BID)..
             PV_cap_roof(BID) =l= area_roof_max(BID)*PV_cap_density;

eq_PV_cap_facade(BID)..
             PV_cap_facade(BID) =l= area_facade_max(BID)*PV_cap_density;
eq_PV_active_roof(h,r)..
             e_PV_act_roof(h,r)=e=eta_Inverter*PV_roof_cap_Inv(r) * PV_power_roof(h,r);

eq_PV_reactive1(h,r)..e_PV_reac_roof(h,r)=l=tan(arccos(PV_inverter_PF_Inv(r)))*e_PV_act_roof(h,r);
eq_PV_reactive2(h,r)..e_PV_reac_roof(h,r)=g=-tan(arccos(PV_inverter_PF_Inv(r)))*e_PV_act_roof(h,r);
eq_PV_reactive3(h,r)..-0.58*e_PV_reac_roof(h,r)+e_PV_act_roof(h,r)=l=1.15*PV_roof_cap_Inv(r);
eq_PV_reactive4(h,r)..0.58*e_PV_reac_roof(h,r)+e_PV_act_roof(h,r)=l=1.15*PV_roof_cap_Inv(r);
*-----------------Refrigeration machine investment equations--------------------
eq_RMInv1(h)..
             c_RMInv(h) =e= RMInv_COP*e_RMInv(h);
eq_RMInv2(h)..
             c_RMInv(h) =l= RMInv_cap;

**************************Network constraints***********************************
*---------------District heating network constraints----------------------------

eq_dhn_constraint(h, DH_Node_ID)..
         DH_node_transfer_limits(h, DH_Node_ID) =g= sum(i, h_demand(h, i)$DHNodeToB_ID(DH_Node_ID, i))
                 - (h_RMMC(h)) $(sameas(DH_Node_ID, 'Fysik'))
                 - (H_VKA4(h) + H_VKA1(h) + h_Pana1(h) + h_RGK1(h) + h_AbsC(h)
                 + h_AbsCInv(h) + H_P2T(h) + 0.75*h_TURB(h) + h_HP(h) + TES_dis(h)
                 - TES_ch(h) + h_imp_AH(h) - h_exp_AH(h)) $(sameas(DH_Node_ID, 'Maskin'))
                 + sum(DHNodeToB_ID(DH_Node_ID, i), BTES_Sch(h,i))
                 - sum(DHNodeToB_ID(DH_Node_ID, i), BTES_Sdis(h,i))
                 - sum(DHNodeToB_ID(DH_Node_ID, i), h_BAC_savings(h,i))

                 + sum(DHNodeToB_ID('Eklanda', i), BTES_Sch(h,i))$(sameas(DH_Node_ID, 'VoV'))
                 - sum(DHNodeToB_ID('Eklanda', i), BTES_Sdis(h,i))$(sameas(DH_Node_ID, 'VoV'))
                 - sum(DHNodeToB_ID('Eklanda', i), h_BAC_savings(h,i))$(sameas(DH_Node_ID, 'VoV'))
                 + sum(i, h_demand(h, i)$DHNodeToB_ID('Eklanda', i))$(sameas(DH_Node_ID, 'VoV'))
;
eq_dh_node_flows(h, DH_Node_ID)..
         DH_node_flows(h, DH_Node_ID) =e= sum(i, h_demand(h, i)$DHNodeToB_ID(DH_Node_ID, i))
                 - (h_RMMC(h)) $(sameas(DH_Node_ID, 'Fysik'))
                 - (H_VKA4(h) + H_VKA1(h) + h_Pana1(h) + h_RGK1(h) + h_AbsC(h)
                 + h_AbsCInv(h) + H_P2T(h) + 0.75*h_TURB(h) + h_HP(h) + TES_dis(h)
                 - TES_ch(h) + h_imp_AH(h) - h_exp_AH(h)) $(sameas(DH_Node_ID, 'Maskin'))
                 + sum(DHNodeToB_ID(DH_Node_ID, i), BTES_Sch(h,i))
                 - sum(DHNodeToB_ID(DH_Node_ID, i), BTES_Sdis(h,i))
                 - sum(DHNodeToB_ID(DH_Node_ID, i), h_BAC_savings(h,i))

                 + sum(DHNodeToB_ID('Eklanda', i), BTES_Sch(h,i))$(sameas(DH_Node_ID, 'VoV'))
                 - sum(DHNodeToB_ID('Eklanda', i), BTES_Sdis(h,i))$(sameas(DH_Node_ID, 'VoV'))
                 - sum(DHNodeToB_ID('Eklanda', i), h_BAC_savings(h,i))$(sameas(DH_Node_ID, 'VoV'))
                 + sum(i, h_demand(h, i)$DHNodeToB_ID('Eklanda', i))$(sameas(DH_Node_ID, 'VoV'))
;


eq_dcn_constraint(h, DC_Node_ID)..
         DC_node_transfer_limits(h, DC_Node_ID) =g= sum(i, c_demand(h,i)$DCNodeToB_ID(DC_Node_ID, i))
                 - (c_RMMC(h)) $(sameas(DC_Node_ID, 'Fysik'))
                 - (C_VKA1(h))$(sameas(DC_Node_ID, 'Maskin'))
                 + sum(i, c_demand(h,i)$DCNodeToB_ID('EDIT', i))$(sameas(DC_Node_ID, 'Maskin'))
                 + (CWB_ch(h)/CWB_chr_eff - CWB_dis_eff*CWB_dis(h))$(sameas(DC_Node_ID, 'Maskin'))
;

eq_DC_node_flows(h, DC_Node_ID)..
         DC_node_flows(h, DC_Node_ID) =e= sum(i, c_demand(h,i)$DCNodeToB_ID(DC_Node_ID, i))
                 - (c_RMMC(h)) $(sameas(DC_Node_ID, 'Fysik'))
                 - (C_VKA1(h))$(sameas(DC_Node_ID, 'Maskin'))
                 + sum(i, c_demand(h,i)$DCNodeToB_ID('EDIT', i))$(sameas(DC_Node_ID, 'Maskin'))
                 + (CWB_ch(h)/CWB_chr_eff - CWB_dis_eff*CWB_dis(h))$(sameas(DC_Node_ID, 'Maskin'))

;

* - (C_VKA4(h) + c_HP(h) + c_AbsCInv(h)  + c_AbsC(h)  are at KC and thus

**************************Demand Supply constraints*****************************
*---------------- Demand supply balance for heating ----------------------------
eq_hbalance1(h)..
             h_exp_AH(h) =l= h_Pana1(h);
eq_hbalance2(h)..
             sum(i,h_demand(h,i)) =e=h_imp_AH(h) + h_imp_nonAH(h) - h_exp_AH(h)  + h_Pana1(h) + h_RGK1(h) + H_VKA1(h)
                                     + H_VKA4(h) + H_P2T(h) + 0.75*h_TURB(h) + h_RMMC(h)
                                     + h_HP(h)
                                     + (TES_dis_eff*TES_dis(h)-TES_ch(h)/TES_chr_eff)
                                     + (sum(i,BTES_Sdis(h,i))*BTES_dis_eff - sum(i,BTES_Sch(h,i))/BTES_chr_eff)
                                     + (sum(i,h_BAC_savings(h,i)))
                                     - h_AbsCInv(h);
eq_hbalance3(h)..
             h_imp_nonAH(h)=e=sum(i_nonAH_h,h_demand_nonAH(h,i_nonAH_h))
                       - (sum(i_nonAH_h,BTES_Sdis(h,i_nonAH_h))*BTES_dis_eff-sum(i_nonAH_h,BTES_Sch(h,i_nonAH_h))/BTES_chr_eff);

*-------------- Demand supply balance for cooling ------------------------------
eq_cbalance(h)..
         sum(i_AH_c,c_demand_AH(h,i_AH_c))=e=C_DC(h) + C_VKA1(h) + C_VKA4(h) +  c_AbsC(h)
                                + c_RM(h) + c_RMMC(h) + c_AAC(h) + c_HP(h) + c_RMInv(h)
                                + c_AbsCInv(h)
                                + (CWB_dis_eff*CWB_dis(h) - CWB_ch(h)/CWB_chr_eff);

*--------------Demand supply balance for electricity ---------------------------

eq_ebalance3(h)..
        sum(i_AH_el,el_demand(h,i_AH_el)) =l= e_imp_AH(h) - e_exp_AH(h) - el_VKA1(h) - el_VKA4(h) - el_RM(h) - e_RMMC(h) - e_AAC(h)
                                 + e_existPV(h) + e_PV(h) - e_HP(h) - e_RMInv(h)
                                 + sum(j,(BES_dis(h,j)*BES_dis_eff - BES_ch(h,j)/BES_ch_eff)+(BFCh_dis(h,j)*BFCh_dis_eff - BFCh_ch(h,j)/BFCh_ch_eff))
                                 + e_TURB(h);
eq_ebalance4(h)..
        sum(i_nonAH_el,el_demand(h,i_nonAH_el)) =l= e_imp_nonAH(h);

*------------Electrical Network constraints------------*

eq_dcpowerflow1(h,Bus_IDs)..((e_imp_AH(h) - e_exp_AH(h))/Sb)$(ord(Bus_IDs)=13)-((el_VKA1(h) + el_VKA4(h))/Sb)$(ord(Bus_IDs)=20)
            + sum(BID,e_existPV_act(h,BID)$BusToBID(Bus_IDs,BID))/Sb+sum(r,e_PV_act_roof(h,r)$BusToBID(Bus_IDs,r))/Sb+sum(f,(PV_facade_cap_Inv(f)*PV_power_facade(h,f))$BusToBID(Bus_IDs,f))/Sb+
            ((BES_dis(h,Bus_IDs)*BES_dis_eff - BES_ch(h,Bus_IDs)/BES_ch_eff)/Sb)+(e_TURB(h)/Sb)$(ord(Bus_IDs)=16)+
            ((BFCh_dis(h,Bus_IDs)*BFCh_dis_eff - BFCh_ch(h,Bus_IDs)/BFCh_ch_eff)/Sb)-sum(i_AH_el,el_demand(h,i_AH_el)$BusToB_ID(Bus_IDs,i_AH_el))/Sb-((el_RM(h)+e_RMMC(h)+e_AAC(h)+e_HP(h)+e_RMInv(h))/Sb)$(ord(Bus_IDs)=10)
=e=sum(j$((ord(Bus_IDs) ne ord(j)) and (currentlimits(Bus_IDs,j) ne 0)),gij(Bus_IDs,j)*(V(h,Bus_IDs)-V(h,j)))-
sum(j$((ord(Bus_IDs) ne ord(j)) and (currentlimits(Bus_IDs,j) ne 0)),bij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j)));


eq_dcpowerflow2(h,Bus_IDs)..(re_imp_AH(h)/Sb)$(ord(Bus_IDs)=13)-0.2031*sum(i_AH_el,el_demand(h,i_AH_el)$BusToB_ID(Bus_IDs,i_AH_el))/Sb+(e_TURB_reac(h)/Sb)$(ord(Bus_IDs)=16)+
                             (BES_reac(h,Bus_IDs)/Sb)+(BFCh_reac(h,Bus_IDs)/Sb)+sum(BID,e_existPV_reac(h,BID)$BusToBID(Bus_IDs,BID))/Sb+sum(r,e_PV_reac_roof(h,r)$BusToBID(Bus_IDs,r))/Sb
=e=-(bii(Bus_IDs)+sum(j$((ord(Bus_IDs) ne ord(j)) and (currentlimits(Bus_IDs,j) ne 0)),gij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j)))-
sum(j$((ord(Bus_IDs) ne ord(j)) and (currentlimits(Bus_IDs,j) ne 0)),bij(Bus_IDs,j)*(V(h,Bus_IDs)-V(h,j))));

eq_dcpowerflow3(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-bij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=l=currentlimits(Bus_IDs,j)/Ib;

eq_dcpowerflow4(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-bij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=g=-currentlimits(Bus_IDs,j)/Ib;

eq_dcpowerflow5(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-bij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))+0.58*gij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=l=1.15*currentlimits(Bus_IDs,j)/Ib;
eq_dcpowerflow6(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-bij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))+0.58*gij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=g=-1.15*currentlimits(Bus_IDs,j)/Ib;
eq_dcpowerflow7(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-bij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))-0.58*gij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=l=1.15*currentlimits(Bus_IDs,j)/Ib;
eq_dcpowerflow8(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-bij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))-0.58*gij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=g=-1.15*currentlimits(Bus_IDs,j)/Ib;
eq_dcpowerflow9(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-gij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=l=currentlimits(Bus_IDs,j)/Ib;
eq_dcpowerflow10(h,Bus_IDs,j)$(currentlimits(Bus_IDs,j) ne 0)..-gij(Bus_IDs,j)*(delta(h,Bus_IDs)-delta(h,j))=g=-currentlimits(Bus_IDs,j)/Ib;

eq_dcpowerflow11(h)..delta(h,"13")=e=0;
eq_dcpowerflow12(h)..V(h,"13")=e=1;

*-----------------Comments on El Network implementation------------------------*
$ontext
1)el_RM(h),e_RMMC(h),e_AAC(h), e_HP(h),e_RMInv(h) are set to KC
2)inverter of FBch is the same with the pv additional constraints must be added
$offtext
*--------------FED Primary energy use-------------------------------------------
eq_PE(h)..
        FED_PE(h)=e= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*PEF_exG(h)
                     + e_existPV(h)*PEF_PV + e_PV(h)*PEF_PV
                     + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_export_season(h) + h_imp_nonAH(h))*PEF_DH(h) + ((h_Pana1(h)+h_RGK1(h))/P1_eff)*PEF_P1
                     + fuel_P2(h)*PEF_P2;

eq_PE_ma(h)..
        MA_FED_PE(h)=e= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*MA_PEF_exG(h)
                     + e_existPV(h)*PEF_PV + e_PV(h)*PEF_PV
                     + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_export_season(h) + h_imp_nonAH(h))*MA_PEF_DH(h) + ((h_Pana1(h)+h_RGK1(h))/P1_eff)*PEF_P1
                     + fuel_P2(h)*PEF_P2;
**********************Total PE use in the FED system****************************
eq_totPE..
         tot_PE=e=sum(h,FED_PE(h));

eq_totPE_ma..
         MA_tot_PE=e=sum(h,MA_FED_PE(h));

*---------------FED CO2 emission------------------------------------------------
eq_CO2(h)..
       FED_CO2(h) =e= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*CO2F_exG(h)
                      + e_existPV(h)*CO2F_PV + e_PV(h)*CO2F_PV
                      + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_export_season(h) + h_imp_nonAH(h))*CO2F_DH(h) + ((h_Pana1(h)+h_RGK1(h))/P1_eff)*CO2F_P1
                      + fuel_P2(h) * CO2F_P2;

eq_CO2_ma(h)..
       MA_FED_CO2(h) =e= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*MA_CO2F_exG(h)
                      + e_existPV(h)*CO2F_PV + e_PV(h)*CO2F_PV
                      + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_export_season(h) + h_imp_nonAH(h))*MA_CO2F_DH(h) + ((h_Pana1(h)+h_RGK1(h))/P1_eff)*CO2F_P1
                      + fuel_P2(h) * CO2F_P2;

****************Total CO2 emission in the FED system****************************
eq_CO2_TOT..
         FED_CO2_tot =e= sum(h, FED_CO2(h));

eq_CO2_TOT_ma..
         MA_FED_CO2_tot =e= sum(h, MA_FED_CO2(h));
**************** Power tariffs *******************
eq_max_exG1(h,m)..
               max_exG(m) =g= (e_imp_AH(h)-e_exp_AH(h) + e_imp_nonAH(h))*HoM(h,m);

eq_max_exG2(h,m)..
               max_exG(m) =g= max_exG_prev*HoM(h,m);

eq_PTexG(m)..
               PT_exG(m) =e= max_exG(m)*PT_cost('exG');

eq_mean_DH(d)..
              mean_DH(d) =g=   sum(h,(h_imp_AH(h)-h_exp_AH(h) + h_imp_nonAH(h))*HoD(h,d))/10;

eq_PT_DH(d)..
              PT_DH      =g=   mean_DH(d)*PT_cost('DH');

**************** Objective function ***********************
*       sup_unit   supply units /PV, HP, BES, TES, BTES, RMMC, P1, P2, TURB, AbsC, AbsCInv, AAC, RM, exG, DH, CHP/
eq_fix_cost_existing..
         fix_cost_existing =e=sum(sup_unit,fix_cost(sup_unit)*cap_sup_unit(sup_unit));

eq1_fix_cost_DH(h)..h_imp_AH(h)+1000000*y_temp(h)=g=0;
eq2_fix_cost_DH(h)..w(h)+1000000*y_temp(h)=g=166.666;
eq3_fix_cost_DH(h)..w(h)+1000000*(1-y_temp(h))=g=41.666;
eq4_fix_cost_DH(h)..h_imp_AH(h)-(1-y_temp(h))*10000000=l=0;

eq_fix_cost_new..
         fix_cost_new =e=  (sum(BID, PV_cap_roof(BID) + PV_cap_facade(BID)))*fix_cost('PV')
                           + HP_cap*fix_cost('HP')
                           + sum(j,BES_cap(j)*fix_cost('BES'))
                           + TES_cap*fix_cost('TES')
                           + RMInv_cap*fix_cost('RMInv')
                           + fix_cost('BTES')*sum(i,B_BITES(i))
                           + B_P2 * fix_cost('P2')
                           + B_TURB * fix_cost('TURB')
                           + fix_cost('AbsCInv');
eq_var_cost_existing..
         var_cost_existing =e= sum(h, (e_imp_AH(h) + e_imp_nonAH(h))*utot_cost('exG',h))
                               -sum(h,e_exp_AH(h)*el_sell_price(h))
                               + sum(h,(h_imp_AH(h) + h_imp_nonAH(h))*utot_cost('DH',h))
                               - sum(h,sum(m,(h_exp_AH(h)*DH_export_season(h)*0.3*HoM(h,m))$((ord(m) <= 3) or (ord(m) >=12))))
                               + sum(h,h_Pana1(h)*utot_cost('P1',h))
                               + sum(h,H_VKA1(h)*utot_cost('HP',h))
                               + sum(h,H_VKA4(h)*utot_cost('HP',h))
                               + sum(h,c_AbsC(h)*utot_cost('AbsC',h))
                               + sum(h,c_RM(h)*utot_cost('RM',h))
                               + sum(h,c_RMMC(h)*utot_cost('RM',h))
                               + sum(h,c_AAC(h)*utot_cost('AAC',h))
                               + sum(h,e_existPV(h)*utot_cost('PV',h))
                               + sum(h,sum(m,(h_AbsC(h)*0.15*HoM(h,m))$((ord(m) >=4) and (ord(m) <=10))))
                               + sum(h,sum(m,(h_AbsC(h)*0.7*HoM(h,m))$((ord(m) =11))))
                               + sum(h,sum(m,(h_AbsC(h)*HoM(h,m))$((ord(m) <=3) or (ord(m) >=12))));

eq_var_cost_new..
         var_cost_new =e=  sum(h,e_PV(h)*utot_cost('PV',h))
                           + sum(h,h_HP(h)*utot_cost('HP',h))
                           + sum(h,c_RMInv(h)*utot_cost('RMInv',h))
                           + sum((h,j),BES_dis(h,j)*utot_cost('BES',h))
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
                + sum(j,BES_cap(j)*cost_inv_opt('BES')/lifT_inv_opt('BES'))
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
                     + sum(j,BES_cap(j)*cost_inv_opt('BES'))
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
         obj=e= min_totCost*totCost
                + (min_totPE*tot_PE*(1-opt_marg_factors)+min_totPE*MA_tot_PE*opt_marg_factors)
                + (min_totCO2*FED_CO2_tot*(1-opt_marg_factors)+min_totCO2*MA_FED_CO2_tot*opt_marg_factors);

********************************************************************************
