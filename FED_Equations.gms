********************************************************************************
*----------------------------Define equations-----------------------------------
********************************************************************************
equation

*          VKA1 in the model =  summer heat pump (HP_S) in the article
           eq_VKA11     heating generatin of VKA1
           eq_VKA12     cooling generation of VKA1
           eq_VKA13     maximum electricity usage by VKA1

*          VKA4 in the model =  winter heat pump 1 (HP_w1) in the article
           eq_VKA41     heating generation of VKA4
           eq_VKA42     cooling generation of VKA4
           eq_VKA43     maximum electricity usage by VKA4

           eq1_h_Boiler1           Equation related to Boiler1 heat production
           eq2_h_Boiler1           ramp constraint set to 1MW
           eq3_h_Boiler1           ramp constraint set to 1MW
           eq4_h_Boiler1           ramp constraint set to 1MW
           eq5_h_Boiler1           ramp constraint set to 1MW
           eq6_h_Boiler1           fuel use for Boiler1
           eq_h_Boiler1_dispatch  Equation determining when Boiler1 is dispatchable

           eq_h_FlueGasCondenser11            Equation related to flue gas heat production
           eq_h_FlueGasCondenser1_dispatch    Equation determining when flue gas is dispatchable

           eq_AbsC1     for determining capacity of AR
           eq_AbsC2     relates cooling from AR
           eq_AbsC3     Absorption chiller electricity usage
           eq_AbsC4     General lower limit
           eq_AbsC5     Lower limit in exceptional situations where the demand is lower than the general lower limit

*          This unit is only used in emergency need, so the COP has been put to 0.2 to prevent it from dispatching
           eq_RM1       Refrigerator equation
           eq_RM2       Refrigerator equation

*          RMMC in the model =  refrigeration heat pump (HP_R) in the article
           eq_RMMC1     MC2 Refrigerator equation - heating
           eq_RMMC2     MC2 Refrigerator equation - cooling
           eq_RMMC3     MC2 investment constraint
           eq_RMMC4     MC2 Limit heat production to heat demand at MC2

           eq_CWB_en_init        Cold Water Basin initial charge state
           eq_CWB_en             Cold Water Basin charge equation
           eq_CWB_discharge      Cold Water Basin discharges only to M building
           eq_CWB1               Cold Water Basin cant discharge and charge simultaneously
           eq_CWB2               Cold Water Basin cant discharge and charge simultaneously
           eq_CWB3               Cold Water Basin cant discharge and charge simultaneously

           eq1_AbsCInv  Production equation-AbsChiller investment
           eq2_AbsCInv  Investment capacity-AbsChiller investment

*--------- CHP components
           eq1_Boiler2                production equation for B2
           eq2_Boiler2                investment equation for B2
           eq3_Boiler2                maximum ramp up constraint
           eq4_Boiler2                maximum ramp down constraint
           eq5_h_Boiler2              maximum ramp up constraint
           eq6_h_Boiler2              maximum ramp down constraint
           eq_h_Boiler2_research  B2 production constraint during research


           eq1_TURB     production equation for turbine-gen
           eq2_TURB     energy consumption equation for turbine-gen
           eq3_TURB     investment equation for turbine-gen
           eq4_TURB     active-reactive power limits of turbine
           eq5_TURB     active-reactive power limits of turbine
           eq6_TURB     active-reactive power limits of turbine
           eq7_TURB     active-reactive power limits of turbine
           eq8_TURB     Heat from turbine to grid
*---------- end of CHP components

*          HP in the model =  winter heat pump 2 (HP_w2) in the article
           eq_HP1       heat production from HP
           eq_HP2       cooling production from HP
           eq_HP3       for determining capacity of HP
           eq_HP4       Set minimum output from HP under wintermode

*          The investment in thermal energy storage was zero, so the capacity is zero in the article
           eq_TESen0    initial energy content of the TES
           eq_TESen1    initial energy content of the TES
           eq_TESen2    energy content of the TES at hour h
           eq_TESen3    for determining the capacity of TES
           eq_TESdis    discharging rate of the TES
           eq_TESch     charging rate of the TES
           eq_TESinv    investment decision for TES

*          Building advanced control system(BAC) and system offset(SO) are used to
*          utilize building inertia thermal energy storage(BITES).
*          Therefore, some of them are considered under BITES in the article
           eq_BAC_S_init    initial energy stored in shallow storage of BAC
           eq_BAC_D_init    initial energy stored in deep storage of BAC
           eq_BAC_Sch       limit on maximum hourly charging of BAC shallow
           eq_BAC_Sdis      limit on maximum hourly discharging of BAC shallow
           eq_BAC_Sdis2G        Estimate the useful energy discharged from the BAC storage
           eq_BAC_Sch_from_grid Estimate the useful energy stored in the BAC storage
           eq_BAC_S_change  hourly change in energy stored in shallow storage of BAC
           eq_BAC_D_change  hourly change in energy stored in deep storage of BAC
           eq_BAC_link      hourly flow between shallow and deep storage of BAC
           eq_BAC_savings   hourly energy savings of BAC
           eq_BAC_cooling_savings hourly savings in cooling of BAC
           eq_BAC_S_loss    losses from shallow storage of BAC
           eq_BAC_D_loss    losses from deep storage of BAC

           eq_SO_S_init    initial energy stored in shallow storage of SO
           eq_SO_D_init    initial energy stored in deep storage of SO
           eq_SO_Sch       limit on maximum hourly charging of SO shallow
           eq_SO_Sdis      limit on maximum hourly discharging of SO shallo
           eq_SO_Sdis2G        Estimate the useful energy discharged from the SO storage
           eq_SO_Sch_from_grid Estimate the useful energy stored in the SO storage
           eq_SO_S_change  hourly change in energy stored in shallow storage of SO
           eq_SO_D_change  hourly change in energy stored in deep storage of SO
           eq_SO_link      hourly flow between shallow and deep storage of SO
           eq_SO_S_loss    losses from shallow storage of SO
           eq_SO_D_loss    losses from deep storage of SO

           eq_maximum_BTES_investments   Limits BTES Bids preventing double investments

           eq_BES1       intial energy in the Battery
           eq_BES2       energy in the Battery at hour h
           eq_BES3       maximum energy in the Battery
           eq_BES4       Limit minimum SoC
           eq_BES_ch     maximum charging limit
           eq_BES_dis    maximum discharign limit
           eq_BES_Sdis2G        Estimate the useful energy discharged from the BES storage
           eq_BES_Sch_from_grid Estimate the useful energy stored in the BES storage

           eq_PV            electricity generated by PV

           eq_RMInv1     cooling production from RMInv
           eq_RMInv2     capacity determination of RMInv


           eq_hbalance1  maximum heating export from AH system
           eq_hbalance2  heating supply-demand balance excluding AH buildings
           eq_hbalance3  heating supply-demand balance excluding nonAH buildings
           eq_hbalance4  Limit AH heat import to 0 during summer mode

           eq_cbalance   Balance equation cooling

           eq_ebalance3  supply demand balance equation from AH
           eq_ebalance4  electrical import equation to nonAH

*          NREF and PE aspects are not used in the paper
           eq_AH_NREF    NREF use in AH buildings
           eq_nonAH_NREF NREF use in nonAH buildings
           eq_NREF       NREF use in the FED system
           eq_totNREF    total NREF used in the FED system
           eq_AH_PE
           eq_nonAH_PE
           eq_PE         PE use in the FED system (marginal or average depending on which factors are used)
           eq_totPE      Total PE use in the FED system (marginal or average depending on which factors are used)
           eq_CO2        FED CO2 emissions (marginal or average depending on which factors are used)
           eq_AH_CO2     FED CO2 emissions (marginal or average depending on which factors are used) for AH system
           eq_nonAH_CO2  FED CO2 emissions (marginal or average depending on which factors are used) for non-AH system
           eq_totCO2     Total CO2 emissions during the modelled period.
           eq_max_exG1 maximum monthly peak demand
           eq_PTexG   monthly power tariff
           eq_PTexG1

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
           eq_var_cost_existing_AH hourly variable cost for existing units AH
           eq_var_cost_new_AH      hourly variable cost for new units AH
           eq_Ainv_cost  total annualized investment cost
           eq_invCost_PV      investment cost of PV
           eq_invCost_BES     investment cost of battery storage
           eq_invCost_TES     investment cost of thermal energy storage
           eq_invCost_SO      investment cost of building inertia thermal energy storage with Setpoint Offset
           eq_invCost_BAC     investment cost of building advanced control
           eq_invCost_HP      investment cost of heat pump
           eq_invCost_RMMC    investment cost of connecting MC2 RM
           eq_invCost_AbsCInv     investment cost of absorption cooler
           eq_invCost_Boiler2          investment cost of B2
           eq_invCost_TURB        investment cost of turbine
           eq_invCost_RMInv       investment cost of RMInv
           eq_invCost    total investment cost with aim to minimize investment cost
           eq_totCost    with aim to minimize total cost including fuel and O&M
           eq_peak_CO2   with aim to to reduce CO2 peak

           eq_obj        Objective function
;

*-------------------------------------------------------------------------------
*--------------------------Define equations-------------------------------------
*-------------------------------------------------------------------------------

***************For Existing units***********************************************
*-----------------VKA1 equations------------------------------------------------


el_VKA1.fx(h) $ ((min_totCost_0 = 1) or (synth_baseline = 1)) = el_VKA1_0(h);

eq_VKA11(h)..
        h_VKA1(h) =e= VKA1_H_COP*el_VKA1(h);
eq_VKA12(h)..
        c_VKA1(h) =e= VKA1_C_COP*el_VKA1(h);
eq_VKA13(h) $(min_totCost_0 = 0 and (synth_baseline = 0))..
        el_VKA1(h) =l= VKA1_el_cap*(1-DH_heating_season(h));
* Only run VKA1 during summer -DS


*-----------------VKA4 equations------------------------------------------------

el_VKA4.fx(h) $ ((min_totCost_0 = 1) or (synth_baseline = 1)) = el_VKA4_0(h);

eq_VKA41(h)..
        h_VKA4(h) =e= VKA4_H_COP*el_VKA4(h);
eq_VKA42(h)..
        c_VKA4(h) =e= VKA4_C_COP*el_VKA4(h);
eq_VKA43(h) $ ((min_totCost_0 eq 0) and (synth_baseline = 0))..
        el_VKA4(h) =l= VKA4_el_cap*DH_heating_season(h);
* Only run VKA4 during Winter -DS

*------------------Boiler1 equation(when dispachable)----------------------------

Boiler1_cap.fx=cap_sup_unit('B1');
h_Boiler1.up(h)$(P1P2_dispatchable(h)=1 and min_totCost_0 = 0 and (synth_baseline = 0))=B1_max;
h_Boiler1.fx(h)$((min_totCost_0 = 1) or (synth_baseline = 1)) = h_Boiler1_0(h);

eq1_h_Boiler1(h) $ (min_totCost_0 eq 0)..
        h_Boiler1(h)=l=Boiler1_cap;

eq2_h_Boiler1(h)$(ord(h) gt 1 and (P1P2_dispatchable(h)=1 or P1P2_dispatchable(h-1)=1) and synth_baseline eq 0 and min_totCost_0 eq 0)..
        h_Boiler1(h-1)- h_Boiler1(h)=g=-B1_hourly_ramprate;

eq3_h_Boiler1(h)$(ord(h) gt 1 and (P1P2_dispatchable(h)=1 or P1P2_dispatchable(h-1)=1)  and synth_baseline eq 0 and min_totCost_0 eq 0)..
        h_Boiler1(h-1)- h_Boiler1(h)=l=B1_hourly_ramprate;

eq4_h_Boiler1(h)$(ord(h) eq 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0 and min_totCost_0 eq 0 )..
             Boiler1_prev_disp- h_Boiler1(h)=l=B1_hourly_ramprate;

eq5_h_Boiler1(h)$(ord(h) eq 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0 and min_totCost_0 eq 0 )..
             Boiler1_prev_disp- h_Boiler1(h)=g=-B1_hourly_ramprate;

eq6_h_Boiler1(h)..
          fuel_Boiler1(h) =e= ((h_Boiler1(h))/B1_eff);

eq_h_Boiler1_dispatch(h)$(P1P2_dispatchable(h) eq 0)..
        h_Boiler1(h) =e= h_Boiler1_0(h);


*--------------------Flue gas condenser-------------------------------------
h_FlueGasCondenser1.up(h)$(P1P2_dispatchable(h)=1 and min_totCost_0 = 0)=FlueGasCondenser1_cap;
h_FlueGasCondenser1.fx(h)$(min_totCost_0 = 1 or (synth_baseline = 1))=h_FlueGasCondenser1_0(h);


eq_h_FlueGasCondenser11(h)$(P1P2_dispatchable(h)=1 and synth_baseline eq 0 and min_totCost_0 eq 0)..
        h_FlueGasCondenser1(h)=l=fuel_Boiler1(h)*(1-B1_eff)*FlueGasCondenser1_eff;

eq_h_FlueGasCondenser1_dispatch(h)$(P1P2_dispatchable(h)=0)..
        h_FlueGasCondenser1(h) =e= h_FlueGasCondenser1_0(h);

*-----------AbsC (Absorption Chiller) equations  -----------------------------
AbsC_cap.fx = cap_sup_unit('AbsC');

h_AbsC.lo(h)$(min_totCost_0 = 1 or (synth_baseline = 1)) = c_AbsC_0(h) / AbsC_COP;

eq_AbsC1(h)..
             c_AbsC(h) =e= AbsC_COP*h_AbsC(h);

eq_AbsC2(h) $ (min_totCost_0 eq 0 and (synth_baseline = 0))..
             c_AbsC(h) =l= AbsC_cap;

eq_AbsC3(h)..
             el_AbsC(h) =e= c_AbsC(h) / AbsC_el_COP;

* When its not the cooling season the absorption chillers are switched on
* and thus have a minimum production.

eq_AbsC4(h) $ (DC_cooling_season(h)=1 and min_totCost_0 = 0 and (synth_baseline = 0)and (AbsC_min_prod le (sum(BID_AH_c,c_demand_AH(h,BID_AH_c))-c_DC_slack(h))))..
                        c_AbsC(h) =g= AbsC_min_prod;

eq_AbsC5(h) $ (DC_cooling_season(h)=1 and min_totCost_0 = 0 and (synth_baseline = 0) and (AbsC_min_prod gt (sum(BID_AH_c,c_demand_AH(h,BID_AH_c))-c_DC_slack(h))))..
                        c_AbsC(h) =g= sum(BID_AH_c,c_demand_AH(h,BID_AH_c))-c_DC_slack(h)- sum(BID,c_BAC_savings(h,BID));

*----------Refrigerator Machine equations -------------------------------------
*this is the aggregated capacity of five exisiting RM Units
*This unit is only used in emergency need, so the COP has been put to 0.2 to prevent it from dispatching
RM_cap.fx =cap_sup_unit('RM');
c_RM.fx(h)$(min_totCost_0 = 1 or (synth_baseline = 1))=0;
eq_RM1(h)..
             c_RM(h) =e= RM_COP*el_RM(h);
eq_RM2(h)..
             c_RM(h) =l= RM_cap;


*****************For new investment optons--------------------------------------

*----------MC2 Heat pump equations (electricity => heating + cooling)-----------

el_RMMC.fx(h) $ (min_totCost_0 = 1 or (synth_baseline = 1))=0;
RMMC_inv.fx $ (opt_fx_inv_RMMC gt -1) = opt_fx_inv_RMMC;

eq_RMMC1(h)..
         h_RMMC(h) =l= RMCC_H_COP * el_RMMC(h);

eq_RMMC2(h)..
         c_RMMC(h) =e= RMCC_C_COP * el_RMMC(h);

eq_RMMC3(h)..
         c_RMMC(h) =l= RMMC_inv * RMMC_cap*DH_heating_season(h);
* Assuming DH_heating_season equal "wintermode" -DS

eq_RMMC4(h)..
         h_RMMC(h) =l= h_demand(h,'O3060133')*0.2;
* 2019-08-20 DS - Reduced max heat production from MC2 HP to 20% of the demand in MC2,
* still the HP can produce more heat but it will not be useful

*----------------Absorption Chiller Investment----------------------------------
AbsCInv_cap.fx $ (opt_fx_inv_AbsCInv_cap gt -1) = opt_fx_inv_AbsCInv_cap;
c_AbsCInv.fx(h)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;
eq1_AbsCInv(h)..
             c_AbsCInv(h) =e= AbsCInv_COP*h_AbsCInv(h);
eq2_AbsCInv(h)..
             c_AbsCInv(h) =l= AbsCInv_cap;

*----------------Boiler 2 equations ---------------------------------------------
*CHP boiler
h_Boiler2.up(h)=B2_max;
B_Boiler2.fx $ (opt_fx_inv_Boiler2 gt -1) = opt_fx_inv_Boiler2;
h_Boiler2.fx(h)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;

eq1_Boiler2(h)..
         h_Boiler2(h) =e= fuel_Boiler2(h) * B2_eff;
eq2_Boiler2(h)..
         h_Boiler2(h) =l= B_Boiler2 * B2_cap;

eq3_Boiler2(h)$((P1P2_dispatchable(h)=1 or P1P2_dispatchable(h-1)=1)  and ord(h) gt 1)..
         h_Boiler2(h)-h_Boiler2(h-1) =l= B2_hourly_ramprate;

eq4_Boiler2(h)$((P1P2_dispatchable(h)=1  or P1P2_dispatchable(h-1)=1) and ord(h) gt 1)..
         h_Boiler2(h) - h_Boiler2(h-1) =g= -B2_hourly_ramprate;

eq5_h_Boiler2(h)$(ord(h) eq 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0 and min_totCost_0 eq 0)..
             Boiler2_prev_disp- h_Boiler2(h)=l=B2_hourly_ramprate;

eq6_h_Boiler2(h)$(ord(h) eq 1 and P1P2_dispatchable(h)=1 and synth_baseline eq 0 and min_totCost_0 eq 0)..
             Boiler2_prev_disp- h_Boiler2(h)=g=-B2_hourly_ramprate;

eq_h_Boiler2_research(h)$(P1P2_dispatchable(h)=0 and min_totCost_0 = 0 and (synth_baseline = 0))..
         h_Boiler2(h) =e= B_Boiler2 * B2_research_prod;

*----------------Refurb turbine equations --------------------------------------
*CHP turbine
B_TURB.fx $ (opt_fx_inv_TURB gt -1) = opt_fx_inv_TURB;

eq1_TURB(h)..
         el_TURB(h) =e= TURB_eff * h_TURB(h);

eq2_TURB(h)..
         H_B2_to_grid(h) =l= h_Boiler2(h) - h_TURB(h);

eq3_TURB(h)..
         el_TURB(h) =l= B_TURB * TURB_cap;


eq8_TURB(h)..
         h_from_turb(h) =l= (1-TURB_eff) * h_TURB(h);

eq4_TURB(h)..el_TURB_reac(h)=l=0.4843*el_TURB(h);
eq5_TURB(h)..el_TURB_reac(h)=g=-0.4843*el_TURB(h);
eq6_TURB(h)..-0.58*el_TURB_reac(h)+el_TURB(h)=l=1.15*TURB_cap;
eq7_TURB(h)..+0.58*el_TURB_reac(h)+el_TURB(h)=l=1.15*TURB_cap;

*----------------HP equations --------------------------------------------------
HP_cap.fx $ (opt_fx_inv_HP_cap gt -1) = opt_fx_inv_HP_cap;
el_HP.fx(h)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;

eq_HP1(h)..
             h_HP(h) =e= HP_H_COP*el_HP(h);
eq_HP2(h)..
             c_HP(h) =e= HP_C_COP*el_HP(h);
eq_HP3(h)..
             h_HP(h) =l= HP_cap*DH_heating_season(h);
*Limit heat to be produce during winter mode -DS

eq_HP4(h)..
            h_hp(h)=g=opt_fx_inv_HP_min*DH_heating_season(h);


*------------------TES equations------------------------------------------------
TES_inv.fx $ (opt_fx_inv_TES_cap gt -1) = 0 $ (opt_fx_inv_TES_cap eq 0) + 1 $ (opt_fx_inv_TES_cap gt 0);
TES_cap.fx $ (opt_fx_inv_TES_cap gt -1) = opt_fx_inv_TES_cap;
TES_ch.fx(h)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;
TES_dis.fx(h)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;
eq_TESen0(h,BID)$(ord(h) eq 1)..
             TES_en(h) =e= TES_hourly_loss_fac*(TES_en(h-1)+TES_ch(h)-TES_dis(h));

eq_TESen1(h,BID)$(ord(h) eq 1)..
             TES_en(h) =e= TES_inv;

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

*----------Cold Water Basin equations (cold storage)----------------------------
CWB_en.up(h) = sum(BID,opt_fx_inv_CWB_cap(BID))$(min_totCost_0 = 0)+0$(min_totCost_0 = 1);
CWB_ch.up(h) = sum(BID,opt_fx_inv_CWB_ch_max(BID));
CWB_dis.up(h) = sum(BID,opt_fx_inv_CWB_dis_max(BID));
CWB_ch.fx(h)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;
CWB_dis.fx(h)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;

eq_CWB_en_init(h)$(ord(h) eq 1)..
         CWB_en(h) =e= sum(BID,opt_fx_inv_CWB_init(h,BID)) + CWB_ch(h)* CWB_chr_eff - CWB_dis(h)/ CWB_dis_eff;
eq_CWB_en(h)$(ord(h) gt 1)..
         CWB_en(h) =e= CWB_en(h-1) + CWB_ch(h)* CWB_chr_eff - CWB_dis(h)/ CWB_dis_eff;

eq_CWB_discharge(h)..
         CWB_dis(h) =l= c_demand(h,'O0007028');
eq_CWB1(h)..
         CWB_B_dis(h)+CWB_B_ch(h) =l= 1;
eq_CWB2(h)..
         CWB_ch(h)=l=CWB_B_ch(h)*100000;
eq_CWB3(h)..
         CWB_dis(h)=l=CWB_B_dis(h)*100000;

*------------------Building Advanced Control equations--------------------------
BAC_Sen.up(h,BID)=1000*BTES_model('BTES_Scap',BID);
BAC_Den.up(h,BID)=1000*BTES_model('BTES_Dcap',BID);

B_BAC.fx(BID) $ (opt_fx_inv_BAC gt -1 or min_totCost_0 = 1 or (synth_baseline = 1))=0;
B_BAC.fx(BTES_BAC_Inv) $ (opt_fx_inv_BAC eq 1 and min_totCost_0 = 0 and synth_baseline = 0)=1;


eq_BAC_S_init(h,BID) $ (ord(h) eq 1)..
         BAC_Sen(h,BID) =e= (BTES_kSloss(BID)*opt_fx_inv_BTES_BAC_S_init(h,BID) - BAC_Sdis(h,BID)/BTES_Sdis_eff
                           + BAC_Sch(h,BID)*BTES_Sch_eff - BAC_link_BS_BD(h,BID));

eq_BAC_D_init(h,BID) $ (ord(h) eq 1)..
         BAC_Den(h,BID) =e= (BTES_kDloss(BID)*opt_fx_inv_BTES_BAC_D_init(h,BID) + BAC_link_BS_BD(h,BID));

eq_BAC_Sch(h,BID)..
         BAC_Sch(h,BID) =l= B_BAC(BID)*BTES_Sch_max(h,BID);

eq_BAC_Sdis(h,BID)..
         BAC_Sdis(h,BID) =l= B_BAC(BID)*BTES_Sdis_max(h,BID);

eq_BAC_Sdis2G(h,BID)..
         BAC_Sdis_to_grid(h,BID) =e= BAC_Sdis(h,BID)*BTES_dis_eff;

eq_BAC_Sch_from_grid(h,BID)..
         BAC_Sch_from_grid(h,BID) =e= BAC_Sch(h,BID)/BTES_chr_eff;

eq_BAC_S_change(h,BID) $ (ord(h) gt 1)..
        BAC_Sen(h,BID) =e= (BTES_kSloss(BID)*BAC_Sen(h-1,BID) - BAC_Sdis(h,BID)/BTES_Sdis_eff
                           + BAC_Sch(h,BID)*BTES_Sch_eff - BAC_link_BS_BD(h,BID));

eq_BAC_D_change(h,BID) $ (ord(h) gt 1)..
         BAC_Den(h,BID) =e= (BTES_kDloss(BID)*BAC_Den(h-1,BID) + BAC_link_BS_BD(h,BID));

eq_BAC_link(h,BID) $ (BTES_model('BTES_Scap',BID) ne 0)..
         BAC_link_BS_BD(h,BID) =e= ((BAC_Sen(h,BID)/BTES_model('BTES_Scap',BID)
                              - BAC_Den(h,BID)/BTES_model('BTES_Dcap',BID))*BTES_model('K_BS_BD',BID));

eq_BAC_savings(h,BID)..
          h_BAC_savings(h,BID) =e= BAC_savings_factor(h)*B_BAC(BID)*h_demand(h,BID);

eq_BAC_cooling_savings(h, BID)..
          c_BAC_savings(h,BID) =e= BAC_cooling_savings_factor * B_BAC(BID)*c_demand(h,BID)*DC_cooling_season(h);

eq_BAC_S_loss(h,BID)..
         BAC_Sloss(h,BID) =e= BTES_kSloss(BID)*BAC_Sen(h-1,BID);

eq_BAC_D_loss(h,BID)..
         BAC_Dloss(h,BID) =e= BTES_kDloss(BID)*BAC_Den(h-1,BID);

*------------------Building Setpoint Offset equations---------------------------
SO_Sen.up(h,BID)=1000*BTES_model('BTES_Scap',BID);
SO_Den.up(h,BID)=1000*BTES_model('BTES_Dcap',BID);

B_SO.fx(BID) $ (opt_fx_inv_SO gt -1 or min_totCost_0 = 1 or (synth_baseline = 1))=0;
B_SO.fx(BTES_SO_Inv) $ (opt_fx_inv_SO eq 1 and min_totCost_0 = 0 and synth_baseline = 0)=1;

eq_SO_S_init(h,BID) $ (ord(h) eq 1)..
         SO_Sen(h,BID) =e= (BTES_kSloss(BID)*opt_fx_inv_BTES_SO_S_init(h,BID) - SO_Sdis(h,BID)/BTES_Sdis_eff
                           + SO_Sch(h,BID)*BTES_Sch_eff - SO_link_BS_BD(h,BID));

eq_SO_D_init(h,BID) $ (ord(h) eq 1)..
         SO_Den(h,BID) =e= (BTES_kDloss(BID)*opt_fx_inv_BTES_SO_D_init(h,BID) + SO_link_BS_BD(h,BID));

eq_SO_Sch(h,BID)..
         SO_Sch(h,BID) =l= B_SO(BID)*BTES_SO_max_power(BID);

eq_SO_Sdis(h,BID)..
         SO_Sdis(h,BID) =l= B_SO(BID)*BTES_SO_max_power(BID);

eq_SO_Sdis2G(h,BID)..
         SO_Sdis_to_grid(h,BID) =e= SO_Sdis(h,BID)*BTES_dis_eff;

eq_SO_Sch_from_grid(h,BID)..
         SO_Sch_from_grid(h,BID) =e= SO_Sch(h,BID)/BTES_chr_eff;

eq_SO_S_change(h,BID) $ (ord(h) gt 1)..
        SO_Sen(h,BID) =e= (BTES_kSloss(BID)*SO_Sen(h-1,BID) - SO_Sdis(h,BID)/BTES_Sdis_eff
                           + SO_Sch(h,BID)*BTES_Sch_eff - SO_link_BS_BD(h,BID));

eq_SO_D_change(h,BID) $ (ord(h) gt 1)..
         SO_Den(h,BID) =e= (BTES_kDloss(BID)*SO_Den(h-1,BID) + SO_link_BS_BD(h,BID));

eq_SO_link(h,BID) $ (BTES_model('BTES_Scap',BID) ne 0)..
         SO_link_BS_BD(h,BID) =e= ((SO_Sen(h,BID)/BTES_model('BTES_Scap',BID)
                              - SO_Den(h,BID)/BTES_model('BTES_Dcap',BID))*BTES_model('K_BS_BD',BID));

eq_SO_S_loss(h,BID)..
         SO_Sloss(h,BID) =e= BTES_kSloss(BID)*SO_Sen(h-1,BID);

eq_SO_D_loss(h,BID)..
         SO_Dloss(h,BID) =e= BTES_kDloss(BID)*SO_Den(h-1,BID);

eq_maximum_BTES_investments(BID)..
         1 =g= B_SO(BID) + B_BAC(BID);

*-----------------Battery constraints-------------------------------------------
BES_cap.fx(BID) $ (opt_fx_inv_BES gt -1) = opt_fx_inv_BES_cap(BID)$(opt_fx_inv_BES eq 1)+ 0$(opt_fx_inv_BES eq 0);
BES_ch.fx(h,BID)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;
BES_dis.fx(h,BID)$ (min_totCost_0 = 1 or (synth_baseline = 1))=0;

eq_BES1(h,BID) $ (ord(h) eq 1)..
             BES_en(h,BID)=e= (opt_fx_inv_BES_init(h,BID)+BES_ch(h,BID)-BES_dis(h,BID));

eq_BES2(h,BID)$(ord(h) gt 1)..
             BES_en(h,BID)=e=(BES_en(h-1,BID)+BES_ch(h,BID)-BES_dis(h,BID));
eq_BES3(h,BID) ..
             BES_en(h,BID)=l=BES_cap(BID);
eq_BES4(h,BID) ..
             BES_en(h,BID)=g=BES_cap(BID)*BES_min_SOC;


****************
eq_BES_ch(h,BID) ..
             BES_ch(h,BID)=l=opt_fx_inv_BES_maxP(BID);

eq_BES_dis(h,BID)..
             BES_dis(h,BID)=l=opt_fx_inv_BES_maxP(BID);

*********************************

eq_BES_Sdis2G(h,BID)..
         BES_dis_to_grid(h,BID) =e= BES_dis(h,BID)*BES_dis_eff;

eq_BES_Sch_from_grid(h,BID)..
         BES_ch_from_grid(h,BID) =e= BES_ch(h,BID)/BES_chr_eff;

*-----------------Solar PV equations--------------------------------------------
PV_cap_roof.fx(PVID) $ (opt_fx_inv_PV gt -1)=0;
PV_cap_facade.fx(PVID) $ (opt_fx_inv_PV gt - 1)=0;
PV_cap_roof.fx(PVID_roof) $ (opt_fx_inv_PV eq 1) = PV_roof_cap(PVID_roof);
PV_cap_facade.fx(PVID_facade) $ (opt_fx_inv_PV eq 1) = PV_facade_cap(PVID_facade);

eq_PV(h)..
             el_PV(h) =e= eta_Inverter * (sum(PVID, PV_roof_cap(PVID) * PV_power_roof(h,PVID))
                                              + sum(PVID, PV_facade_cap(PVID) * PV_power_facade(h,PVID)));

*-----------------Refrigeration machine investment equations--------------------
RMInv_cap.fx $ (opt_fx_inv_RMInv_cap gt -1) = opt_fx_inv_RMInv_cap;

eq_RMInv1(h)..
             c_RMInv(h) =e= RMInv_COP*el_RMInv(h);
eq_RMInv2(h)..
             c_RMInv(h) =l= RMInv_cap;

**************************Demand Supply constraints*****************************
*---------------- Demand supply balance for heating ----------------------------
* Set maximum import and export to the grid.
h_imp_AH.up(h)$(min_totCost_0 ne 1)=  DH_max_cap;
h_exp_AH.up(h)$(min_totCost_0 ne 1)=DH_max_cap;

h_exp_AH.fx(h)$(min_totCost_0 eq 1)= h_exp_AH_hist(h);
h_imp_AH.lo(h)$(min_totCost_0 eq 1)= h_imp_AH_hist(h);

eq_hbalance1(h)..
             h_exp_AH(h) =l= h_Boiler1(h) + h_DH_slack_var(h);

eq_hbalance2(h)..
             sum(BID,h_demand(h,BID)) =l= h_imp_AH(h) + h_DH_slack(h)+ h_DH_slack_var(h) + h_imp_nonAH(h) - h_exp_AH(h)  + h_Boiler1(h) + h_FlueGasCondenser1(h) + h_VKA1(h)
                                     + h_VKA4(h) + H_from_turb(h) + H_B2_to_grid(h) + h_RMMC(h)
                                     + h_HP(h)
                                     + (TES_dis_eff*TES_dis(h)-TES_ch(h)/TES_chr_eff)
                                     + (sum(BID,BAC_Sdis_to_grid(h,BID)) - sum(BID,BAC_Sch_from_grid(h,BID)))
                                     + (sum(BID,SO_Sdis_to_grid(h,BID)) - sum(BID,SO_Sch_from_grid(h,BID)))
                                     + (sum(BID,h_BAC_savings(h,BID)))
                                     - h_AbsCInv(h);
eq_hbalance3(h)..
             h_imp_nonAH(h)=e=sum(BID_nonAH_h,h_demand_nonAH(h,BID_nonAH_h))
                       - (sum(BID_nonAH_h,BAC_Sdis(h,BID_nonAH_h))*BTES_dis_eff-sum(BID_nonAH_h,BAC_Sch(h,BID_nonAH_h))/BTES_chr_eff);

eq_hbalance4(h)$((no_imp_h_season(h)) = 1 and (min_totCost_0 = 0))..
            h_imp_AH(h) =e= 0;


*-------------- Demand supply balance for cooling ------------------------------
eq_cbalance(h)..

         sum(BID_AH_c,c_demand_AH(h,BID_AH_c))=e=C_DC_slack_var(h) + c_DC_slack(h) + c_VKA1(h) + c_VKA4(h) +  c_AbsC(h)
                                + c_RM(h) + c_RMMC(h) + c_HP(h) + c_RMInv(h)
                                + (sum(BID,c_BAC_savings(h,BID))) + c_AbsCInv(h)
                                + CWB_dis(h) - CWB_ch(h);

*--------------Demand supply balance for electricity ---------------------------
el_imp_AH.up(h)=el_imp_max_cap;
el_exp_AH.up(h)=el_imp_max_cap;
V.up(h,BusID)=1.1;

eq_ebalance3(h)..
        sum(BID,el_demand(h,BID)) =l= el_imp_AH(h) + el_imp_nonAH(h)+ el_slack_var(h) + el_exG_slack(h) - el_exp_AH(h) - el_VKA1(h) - el_VKA4(h) - el_RM(h) - el_RMMC(h)
                                 + el_PV(h) - el_HP(h) - el_RMInv(h)
                                 + sum(BID_AH_el, BES_dis_to_grid(h,BID_AH_el) - BES_ch_from_grid(h,BID_AH_el))
                                 + el_TURB(h);
eq_ebalance4(h)..
        sum(BID_nonAH_el,el_demand(h,BID_nonAH_el)) =e= el_imp_nonAH(h);

*-------------- FED NREF use ------------------------
*Not used in the article
eq_AH_NREF(h)..
         AH_NREF(h) =e= (el_imp_AH(h)-el_exp_AH(h))*NREF_El(h)
                       + el_PV(h)*NREF_PV
                       + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_heating_season(h))*NREF_DH(h) + fuel_Boiler1(h)*NREF_Boiler1
                       + fuel_Boiler2(h) * NREF_Boiler2;

eq_nonAH_NREF(h)..
         nonAH_NREF(h) =e= el_imp_nonAH(h) * NREF_El(h)
                       + h_imp_nonAH(h) * NREF_DH(h);

eq_NREF(h)..
        FED_NREF(h)=e= (el_imp_AH(h)-el_exp_AH(h) + el_imp_nonAH(h))*NREF_El(h)
                     + el_PV(h)*NREF_PV
                     + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_heating_season(h) + h_imp_nonAH(h))*NREF_DH(h) + fuel_Boiler1(h)*NREF_Boiler1
                     + fuel_Boiler2(h)*NREF_Boiler2
                     + h_DH_slack_var(h)*1000000000
                      + C_DC_slack_var(h)*1000000000
                      + el_slack_var(h)*1000000000;

eq_totNREF..
         tot_NREF=e=sum(h,FED_NREF(h));

*--------------Primary energy use-------------------------------------------

**********************Total PE use in the FED system****************************

eq_AH_PE(h)..
         AH_PE(h) =e= (el_imp_AH(h)-el_exp_AH(h))*PE_El(h)
                       + el_PV(h)*PE_PV
                       + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_heating_season(h))*PE_DH(h) + fuel_Boiler1(h) * PE_Boiler1
                       + fuel_Boiler2(h) * PE_Boiler2;

eq_nonAH_PE(h)..
         nonAH_PE(h) =e= el_imp_nonAH(h) * PE_El(h)
                       + h_imp_nonAH(h) * PE_DH(h);

eq_PE(h)..
        FED_PE(h)=e= (el_imp_AH(h)-el_exp_AH(h) + el_imp_nonAH(h)) * PE_El(h)
                     + el_PV(h)*PE_PV
                     + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_heating_season(h) + h_imp_nonAH(h))*PE_DH(h) + fuel_Boiler1(h)*PE_Boiler1
                     + fuel_Boiler2(h)*PE_Boiler2
                     + h_DH_slack_var(h)*1000000000
                      + C_DC_slack_var(h)*1000000000
                      + el_slack_var(h)*1000000000;
eq_totPE..
         tot_PE=e=sum(h,FED_PE(h));
*---------------FED CO2 emission------------------------------------------------
eq_AH_CO2(h)..
         AH_CO2(h) =e= (el_imp_AH(h)-el_exp_AH(h))*CO2F_El(h)
                       + el_PV(h)*CO2F_PV
                       + (h_AbsC(h)+h_imp_AH(h)-h_exp_AH(h)*DH_heating_season(h))*CO2F_DH(h) + fuel_Boiler1(h)*CO2F_Boiler1
                       + fuel_Boiler2(h) * CO2F_Boiler2;

eq_nonAH_CO2(h)..
         nonAH_CO2(h) =e= el_imp_nonAH(h) * CO2F_El(h)
                       + h_imp_nonAH(h) * CO2F_DH(h);

eq_CO2(h)..
         FED_CO2(h) =e= AH_CO2(h) + nonAH_CO2(h)
                        + h_DH_slack_var(h)*1000000000
                        + C_DC_slack_var(h)*1000000000
                        + el_slack_var(h)*1000000000;

eq_peak_CO2(h)..
          peak_CO2=g=FED_CO2(h);

****************Total CO2 emission in the FED system****************************
eq_totCO2..
         FED_CO2_tot =e= sum(h, FED_CO2(h));

**************** Power tariffs *******************
eq_max_exG1(h,m)..
               max_exG(m) =g= (el_imp_AH(h)-el_exp_AH(h) + 0*el_imp_nonAH(h))*HoM(h,m);

* Peak tariffs not used in rolling time horizon, hence not working in current code - ZN
*eq_max_exG2(h,m)..
*               max_exG(m) =g= max_exG_prev*HoM(h,m);

eq_PTexG(m)..
               PT_exG(m) =e= max_exG(m)*PT_cost('exG');
eq_PTexG1(m)..
               max_PT_exG =g= PT_exG(m);

eq_mean_DH(d)..
              mean_DH(d) =g=   sum(h,(h_imp_AH(h)- h_exp_AH(h) + 0*h_imp_nonAH(h))*HoD(h,d))/24;

eq_PT_DH(d)..
              PT_DH      =g=   mean_DH(d)*PT_cost('DH');

**************** Objective function ***********************

eq_fix_cost_existing..
         fix_cost_existing =e=sum(sup_unit,fix_cost(sup_unit)*cap_sup_unit(sup_unit));

eq1_fix_cost_DH(h)..h_imp_AH(h)+1000000*y_temp(h)=g=0;
eq2_fix_cost_DH(h)..w(h)+1000000*y_temp(h)=g=166.666;
eq3_fix_cost_DH(h)..w(h)+1000000*(1-y_temp(h))=g=41.666;
eq4_fix_cost_DH(h)..h_imp_AH(h)-(1-y_temp(h))*10000000=l=0;


eq_fix_cost_new..
         fix_cost_new =e=  (sum(PVID, PV_cap_roof(PVID) + PV_cap_facade(PVID)))*fix_cost('PV')
                           + HP_cap*fix_cost('HP')
                           + sum(BID,BES_cap(BID)*fix_cost('BES'))
                           + TES_cap*fix_cost('TES')
                           + RMInv_cap*fix_cost('RMInv')
                           + fix_cost('BAC')*sum(BID,B_BAC(BID))
                           + fix_cost('SO')*sum(BID,B_SO(BID))
                           + B_Boiler2 * fix_cost('B2')
                           + B_TURB * fix_cost('TURB')
                           + fix_cost('AbsCInv');

eq_var_cost_existing..
         var_cost_existing =e= sum(h,(el_imp_AH(h) + el_imp_nonAH(h)) * utot_cost('exG',h))
                               - sum(h,el_exp_AH(h) * el_sell_price(h))
                               + sum(h,el_AbsC(h) * utot_cost('exG',h))
                               + sum(h,(h_imp_AH(h) + h_imp_nonAH(h)) * utot_cost('DH',h))
                               - sum(h,h_exp_AH(h) * (utot_cost('DH',h)/(1+DH_margin)))
                               + sum(h,(h_Boiler1(h)+h_FlueGasCondenser1(h)) * var_cost('B1',h)+fuel_Boiler1(h)*fuel_cost('B1',h))
                               + sum(h,h_VKA1(h) * utot_cost('HP',h))
                               + sum(h,h_VKA4(h) * utot_cost('HP',h))
                               + sum(h,c_AbsC(h) * utot_cost('AbsC',h))
                               + sum(h,c_RM(h) * utot_cost('RM',h))
                               + sum(h,c_RMMC(h) * utot_cost('RM',h))
                               + sum(h,h_AbsC(h) * utot_cost('DH',h))
                               +sum(h,h_DH_slack_var(h)) * 1000000000
                               +sum(h,c_DC_slack_var(h)) * 1000000000
                               +sum(h,el_slack_var(h)) * 1000000000;

eq_var_cost_new..
         var_cost_new =e=  sum(h,el_PV(h)*utot_cost('PV',h))
                           + sum(h,h_HP(h)*utot_cost('HP',h))
                           + sum(h,c_RMInv(h)*utot_cost('RMInv',h))
                           + sum((h,BID),BES_dis(h,BID)*utot_cost('BES',h))
                           + sum(h,TES_dis(h)*utot_cost('TES',h))
                           + sum((h,BID),BAC_Sch(h,BID)*utot_cost('BAC',h))
                           + sum((h,BID),SO_Sch(h,BID)*utot_cost('SO',h))
                           + sum(h,h_Boiler2(h) * var_cost('B2',h)+fuel_Boiler2(h)*fuel_cost('B2',h))
                           + sum(h,el_TURB(h)*utot_cost('TURB',h))
                           + sum(h,c_AbsCInv(h)*utot_cost('AbsCInv',h));



*************** Variable cost for AH ***********************
* NOTE: cost for absC are include in AH costs, both Cooling, heat (fuel cost) and electricity cost
* For electricity all solar PVs are included in AHs cost, however var cost are currently assumed to be zero. -DS

eq_var_cost_existing_AH(h)..
var_cost_existing_AH(h) =e=      (el_imp_AH(h) * utot_cost('exG',h))
                               - el_exp_AH(h) * el_sell_price(h)
                               + el_AbsC(h) * utot_cost('exG',h)
                               + h_imp_AH(h) * utot_cost('DH',h)
                               - h_exp_AH(h) * (utot_cost('DH',h)/(1+DH_margin))
                               + (h_Boiler1(h)+h_FlueGasCondenser1(h)) * var_cost('B1',h)+fuel_Boiler1(h)*fuel_cost('B1',h)
                               + h_VKA1(h) * utot_cost('HP',h)
                               + h_VKA4(h) * utot_cost('HP',h)
                               + c_AbsC(h) * utot_cost('AbsC',h)
                               + c_RM(h) * utot_cost('RM',h)
                               + c_RMMC(h) * utot_cost('RM',h)
                               + h_AbsC(h) * utot_cost('DH',h);

eq_var_cost_new_AH(h)..
var_cost_new_AH(h)   =e=     el_PV(h)*utot_cost('PV',h)
                           + h_HP(h)*utot_cost('HP',h)
                           + c_RMInv(h)*utot_cost('RMInv',h)
                           + sum(BID,BES_dis(h,BID)*utot_cost('BES',h))
                           + TES_dis(h)*utot_cost('TES',h)
                           + sum(BID,BAC_Sch(h,BID)*utot_cost('BAC',h))
                           + sum(BID,SO_Sch(h,BID)*utot_cost('SO',h))
                           + h_Boiler2(h) * var_cost('B2',h)+fuel_Boiler2(h)*fuel_cost('B2',h)
                           + el_TURB(h)*utot_cost('TURB',h)
                           + c_AbsCInv(h)*utot_cost('AbsCInv',h);

******************************************************

eq_Ainv_cost..
          Ainv_cost =e=
                + HP_cap*cost_inv_opt('HP')/lifT_inv_opt('HP')
                + RMInv_cap*cost_inv_opt('RMInv')/lifT_inv_opt('RMInv')
                + (sum(PVID, PV_cap_roof(PVID) + PV_cap_facade(PVID)))*cost_inv_opt('PV')/lifT_inv_opt('PV')
                + sum(BID,BES_cap(BID)*cost_inv_opt('BES')/lifT_inv_opt('BES'))
                + (TES_cap*TES_vr_cost + TES_inv * TES_fx_cost)/lifT_inv_opt('TES')
                + cost_inv_opt('SO')*sum(BID,B_SO(BID))/lifT_inv_opt('SO')
                + cost_inv_opt('BAC')*sum(BID,B_BAC(BID))/lifT_inv_opt('BAC')
                + RMMC_inv*cost_inv_opt('RMMC')/lifT_inv_opt('RMMC')
                + B_Boiler2 * cost_inv_opt('B2')/lifT_inv_opt('B2')
                + B_TURB * cost_inv_opt('TURB')/lifT_inv_opt('TURB')
                + AbsCInv_cap * cost_inv_opt('AbsCInv')/lifT_inv_opt('AbsCInv');
eq_totCost..
         totCost =e= fix_cost_existing + var_cost_existing
                     + fix_cost_new + var_cost_new + Ainv_cost;
****************Total investment cost*******************************************
eq_invCost_HP..
         invCost_HP =e= HP_cap * cost_inv_opt('HP');

eq_invCost_PV..
         invCost_PV =e= sum(PVID, PV_cap_roof(PVID) + PV_cap_facade(PVID)) * cost_inv_opt('PV');

eq_invCost_BES..
         invCost_BES =e= sum(BID, BES_cap(BID) * cost_inv_opt('BES'));

eq_invCost_TES..
         invCost_TES =e= TES_cap * TES_vr_cost + TES_inv * TES_fx_cost;

eq_invCost_SO..
         invCost_SO =e= cost_inv_opt('SO') * sum(BID,B_SO(BID));

eq_invCost_BAC..
         invCost_BAC =e= cost_inv_opt('BAC') * sum(BID,B_BAC(BID));

eq_invCost_RMMC..
         invCost_RMMC =e= cost_inv_opt('RMMC') * RMMC_inv;

eq_invCost_Boiler2..
         invCost_Boiler2 =e= B_Boiler2 * cost_inv_opt('B2');

eq_invCost_TURB..
         invCost_TURB =e= B_TURB * cost_inv_opt('TURB');

eq_invCost_AbsCInv..
         invCost_AbsCInv =e= AbsCInv_cap * cost_inv_opt('AbsCInv');

eq_invCost_RMInv..
         invCost_RMInv =e= RMInv_cap * cost_inv_opt('RMInv');

eq_invCost..
         invCost =e= invCost_HP + invCost_PV + invCost_BES + invCost_TES
                  + invCost_SO + invCost_BAC + invCost_RMMC + invCost_Boiler2
                  + invCost_TURB + invCost_AbsCInv + invCost_RMInv;

****************Objective function**********************************************
*For the article, only totCost and FED_CO2_tot are used.
*In the objective function in the paper (equation (1)), alpha is min_totCost and
* beta is min_totCO2
eq_obj..
         obj=e= min_totCost*totCost + min_totPE*tot_PE + min_totCO2*FED_CO2_tot;


********************************************************************************
