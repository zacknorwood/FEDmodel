********************************************************************************
*---------------------Declare variables and equations---------------------------
********************************************************************************
variable
         DH_node_flows(h, DH_Node_ID) Total flows for nodes in district heating system
         DC_node_flows(h, DC_Node_ID) Total flows for nodes in district cooling system
         DH_node_slack(h, DH_Node_ID) Slack variable for nodes in district heating system
         DC_node_slack(h, DC_Node_ID) Slack variable for nodes in district cooling system
;

DH_node_slack.lo(h, DH_Node_ID)=0;
DH_node_slack.up(h, DH_Node_ID)=50;
DC_node_slack.lo(h, DC_Node_ID)=0;
DC_node_slack.up(h, DC_Node_ID)=0;

positive variable
       h_DH_slack_var(h)
       ;

*******************Existing units***********************************************
*------------------VKA1 Heatpump related----------------------------------------
positive variable
         h_VKA1(h)         heating power available from VKA1
         c_VKA1(h)         cooling power available from VKA1
         el_VKA1(h)        electricity needed by VKA1
;
el_VKA1.fx(h) $ (min_totCost_0 = 1) = el_VKA1_0(h);
*------------------VKA4 Heatpump related----------------------------------------
positive variable
         h_VKA4(h)         heating power available from VKA4
         c_VKA4(h)         cooling power available from VKA4
         el_VKA4(h)        electricity needed by VKA4
;
el_VKA4.fx(h) $ (min_totCost_0 = 1) = el_VKA4_0(h);
*------------------Boiler1 (if re-dispatch is allowed)----------------------------
positive variable
         h_Boiler1(h)           heat generated by Boiler1
         Boiler1_cap           capacity of Boiler1
;
Boiler1_cap.fx=cap_sup_unit('B1');
h_Boiler1.up(h)$(P1P2_dispatchable(h)=1 and min_totCost_0 = 0)=B1_max;
h_Boiler1.fx(h)$(min_totCost_0 = 1) = h_Boiler1_0(h);

*--------------------For flue gas condenser-------------------------------------
positive variable
         h_FlueGasCondenser1(h)           heat generated by flue gas condencer
;
h_FlueGasCondenser1.up(h)$(P1P2_dispatchable(h)=1 and min_totCost_0 = 0)=FlueGasCondenser1_cap;
h_FlueGasCondenser1.fx(h)$(min_totCost_0 = 1)=h_FlueGasCondenser1_0(h);

*------------------AbsC(Absorption Chiller) related-----------------------------
positive variable
         h_AbsC(h)           heat demand for Absorption Chiller
         c_AbsC(h)           cooling power available in AbsC
         el_AbsC(h)          electricity demand of Absorption chiller
         AbsC_cap            capacity of AbsC
;
* Assumes that the cooling season is the inverse of the heating season
* So when its not the heating season the absorption chillers are switched on
* and thus have a minimum production.
c_AbsC.lo(h)$(DH_heating_season(h)=0 and min_totCost_0 = 0) = AbsC_min_prod;
AbsC_cap.fx = cap_sup_unit('AbsC');
*in BAU Abs chiller is used as balancing unit since the AAC is set to zero
h_AbsC.lo(h)$(min_totCost_0 = 1) = c_AbsC_0(h) / AbsC_COP;

*------------------Refrigerator Machine related---------------------------------
positive variable
         el_RM(h)          electricity demand for refrigerator
         c_RM(h)           cooling power available from the refrigerator
         RM_cap            capacity of refrigerator
;
*this is the aggregated capacity of five exisiting RM Units
RM_cap.fx =cap_sup_unit('RM');

*------------------Cold Water Basin related-------------------------------------
positive variable
         CWB_en(h)       energy loaded in basin
         CWB_ch(h)       hourly charging of basin
         CWB_dis(h)      hourly discharging of basin
;
CWB_en.up(h) = sum(BID,opt_fx_inv_CWB_cap(BID))$(min_totCost_0 = 0)+0$(min_totCost_0 = 1);
CWB_ch.up(h) = sum(BID,opt_fx_inv_CWB_ch_max(BID));
CWB_dis.up(h) = sum(BID,opt_fx_inv_CWB_dis_max(BID));

*------------------Ambient Air Cooling Machine related--------------------------
*positive variable
*         el_AAC(h)           electricity demand for refrigerator
*         c_AAC(h)           cooling power available from the refrigerator
*         AAC_cap            capacity of refrigerator
*;
*AAC_cap.fx = cap_sup_unit('AAC');
*el_AAC.fx(h)$(min_totCost_0 = 1)=el_AAC_0(h);


******************New investments***********************************************
*------------------MC2 Refrigerator Machine related-----------------------------
positive variable
         el_RMMC(h)          electricity demand for refrigerators
         h_RMMC(h)          cooling power available from refrigerators
         c_RMMC(h)          cooling power available from refrigerators
;
el_RMMC.fx(h) $ (min_totCost_0 = 1)=0;

binary variable
         RMMC_inv           decision variable for MC2 connection investment
;
RMMC_inv.fx $ (opt_fx_inv_RMMC gt -1) = opt_fx_inv_RMMC;
*----------------Absorption Chiller Investment----------------------------------
positive variable
         h_AbsCInv(h)      heat demand by absorption chiller
         c_AbsCInv(h)      cooling generated by absorption chiller
         AbsCInv_cap       Installed capacity in kW cooling
;
*AbsCInv_cap.up=AbsCInv_MaxCap;
AbsCInv_cap.fx $ (opt_fx_inv_AbsCInv_cap gt -1) = opt_fx_inv_AbsCInv_cap;
*----------------Boiler 2 related -----------------------------------------------
positive variable
         fuel_Boiler2(h)        fuel demand in B2
         h_Boiler2(h)           generated heating in B2
;
h_Boiler2.up(h)=B2_max;
*h_P2.lo(h)=P2_min;
binary variable
         B_Boiler2              Decision variable for B2 investment
;
B_Boiler2.fx $ (opt_fx_inv_Boiler2 gt -1) = opt_fx_inv_Boiler2;

*----------------Refurbished turbine for Boiler 2  ------------------------------
positive variable
         el_TURB(h)         electricity generated in turbine-gen
         h_TURB(h)         steam demand in turbine
         H_from_turb(h)    steam generated in B2-turb combo
         H_B2_to_grid(h)   heat from B2 directly to the grid
;
Variable
         el_TURB_reac(h)    Turbines reactive power
;
binary variable
         B_TURB            Decision variable for turbine investment
;
B_TURB.fx $ (opt_fx_inv_TURB gt -1) = opt_fx_inv_TURB;

*------------------HP related---------------------------------------------------
positive variable
         h_HP(h)           heating power available in HP
         c_HP(h)           cooling power available from HP
         el_HP(h)           electricity needed by the HP
         HP_cap            capacity of HP-cooling?
;
HP_cap.fx $ (opt_fx_inv_HP_cap gt -1) = opt_fx_inv_HP_cap;

*------------------TES related--------------------------------------------------
positive variable
         TES_ch(h)         input to the TES-chargin the TES
         TES_dis(h)        output from the TES-discharging the TES
         TES_en(h)         energy content of TES at any instant
         TES_cap           capacity of the TES in m3
;

binary variable
         TES_inv          Decision variable for Accumulator investment
;
TES_inv.fx $ (opt_fx_inv_TES_cap gt -1) = 0 $ (opt_fx_inv_TES_cap eq 0) + 1 $ (opt_fx_inv_TES_cap gt 0);
TES_cap.fx $ (opt_fx_inv_TES_cap gt -1) = opt_fx_inv_TES_cap;
*------------------Building Advanced Control related----------------------
positive variable
         BAC_Sch(h,BID)    charing rate of shallow section of the building
         BAC_Sdis(h,BID)   dischargin rate of shallow section of the building
         BAC_Sdis_to_grid(h,BID)  Useful discharging energy to the grid
         BAC_Sch_from_grid(h,BID) Useful charging energy from the grid
         BAC_Sen(h,BID)    energy stored in the shallow section of the building
         BAC_Den(h,BID)    energy stored in the deep section of the building
         BAC_Sloss(h,BID)  heat loss from the shallow section of the building
         BAC_Dloss(h,BID)  heat loss from the deep section of the building
         h_BAC_savings(h,BID) hourly heat consumption savings per building attributable to BAC investment

;
BAC_Sen.up(h,BID)=1000*BTES_model('BTES_Scap',BID);
BAC_Den.up(h,BID)=1000*BTES_model('BTES_Dcap',BID);
variable
         BAC_link_BS_BD(h,BID)  heat flow between the shallow and the deep section
;
binary variable
         B_BAC(BID)       Decision variable weither to invest Building Advanced Control
;

*0 is used in case there is no investment ,
B_BAC.fx(BID) $ (opt_fx_inv_BAC gt -1)=0;
B_BAC.fx(BTES_BAC_Inv) $ (opt_fx_inv_BAC eq 1)=1;

*------------------Building Setpoint Offset related----------------------
positive variable
         SO_Sch(h,BID)    charing rate of shallow section of the building
         SO_Sdis(h,BID)   dischargin rate of shallow section of the building
         SO_Sdis_to_grid(h,BID)  Useful discharging energy to the grid
         SO_Sch_from_grid(h,BID) Useful charging energy from the grid
         SO_Sen(h,BID)    energy stored in the shallow section of the building
         SO_Den(h,BID)    energy stored in the deep section of the building
         SO_Sloss(h,BID)  heat loss from the shallow section of the building
         SO_Dloss(h,BID)  heat loss from the deep section of the building

;
SO_Sen.up(h,BID)=1000*BTES_model('BTES_Scap',BID);
SO_Den.up(h,BID)=1000*BTES_model('BTES_Dcap',BID);
variable
         SO_link_BS_BD(h,BID)  heat flow between the shallow and the deep section
;
binary variable
         B_SO(BID)       Decision variable weither to invest Setpoint offset
;

*0 is used in case there is no investment ,
B_SO.fx(BID) $ (opt_fx_inv_SO gt -1)=0;
B_SO.fx(BTES_SO_Inv) $ (opt_fx_inv_SO eq 1)=1;
*----------------Solar PV PV relate variables-----------------------------------
positive variable
         el_PV(h)                electricity produced by PV
         PV_cap_roof(PVID)       capacity of solar modules on roof
         PV_cap_facade(PVID)     capacity of solar modules on facade
         el_PV_reac_roof(h,PVID)  PVs reactive power
         el_PV_act_roof(h,PVID)   PVs active power
;
PV_cap_roof.fx(PVID) $ (opt_fx_inv_PV gt -1)=0;
PV_cap_facade.fx(PVID) $ (opt_fx_inv_PV gt - 1)=0;
PV_cap_roof.fx(PVID_roof) $ (opt_fx_inv_PV eq 1) = PV_roof_cap(PVID_roof);
PV_cap_facade.fx(PVID_facade) $ (opt_fx_inv_PV eq 1) = PV_facade_cap(PVID_facade);

*------------------Battery related----------------------------------------------
positive variables
         BES_en(h,BID)     Energy stored in the battry at time t and building BID
         BES_ch(h,BID)       Battery charing at time t and building BID
         BES_dis(h,BID)      Battery discharging at time t and building BID
         BES_dis_to_grid(h,BID)  Useful discharging energy to the grid
         BES_ch_from_grid(h,BID) Useful charging energy from the grid
         BES_cap(BID)         Capacity of the battery at building BID

*         BFCh_en(h,BID)       Energy stored in the battery at time t and building BID
*         BFCh_ch(h,BID)       Battery charing at time t and building BID
*         BFCh_dis(h,BID)      Battery discharging at time t and building BID
*         BFCh_dis_to_grid(h,BID)  Useful discharging energy to the grid
*         BFCh_ch_from_grid(h,BID) Useful charging energy from the grid
*         BFCh_cap(BID)         Capacity of the battery at building BID
;

BES_cap.fx(BID) $ (opt_fx_inv_BES gt -1) = opt_fx_inv_BES_cap(BID)$(opt_fx_inv_BES eq 1)+ 0$(opt_fx_inv_BES eq 0);
*BFCh_cap.fx(BID) $ (opt_fx_inv_BFCh gt -1) = opt_fx_inv_BFCh_cap(BID)$(opt_fx_inv_BFCh eq 1)+ 0$(opt_fx_inv_BFCh eq 0);

*------------------Refrigeration machine investment related---------------------
positive variable
         c_RMInv(h)           cooling power available from RMInv
         el_RMInv(h)           electricity needed by the RMInv
         RMInv_cap            capacity of RMInv
;
RMInv_cap.fx $ (opt_fx_inv_RMInv_cap gt -1) = opt_fx_inv_RMInv_cap;
*------------------Grid El related----------------------------------------------
positive variable
         el_exp_AH(h)        Exported electricty from the AH system
         el_imp_AH(h)        Imported electricty to the AH system
         el_imp_nonAH(h)     Imported electricty to the AH system
         el_slack_var(h)    Slack electricty variable
         V(h,BusID)       Voltage magnitudes of EL Grid
;
el_imp_AH.up(h)=el_imp_max_cap;
el_exp_AH.up(h)=el_imp_max_cap;
V.up(h,BusID)=1.1;
variable
        rel_imp_AH(h)        Imported reactive to the AH system
        delta(h,BusID)    Voltage angles of EL Grid
*        BES_reac(h,BID)       BES reactive power
*        BFCh_reac(h,BID)      BFCh reactive power
;
*------------------Grid DH related----------------------------------------------
positive variable
         h_exp_AH(h)        Exported heat from the AH system
         h_imp_AH(h)        Imported heat to the AH system
         h_imp_nonAH(h)     Imported heat to the AH system
         w(h)               Fixed cost for using DH network (4000SEK if import otherwise 1000)
;
* Set maximum import and export to the grid.
h_imp_AH.up(h)=  DH_max_cap;

h_exp_AH.up(h)=DH_max_cap;
h_exp_AH.fx(h)$(min_totCost_0 eq 1)= h_exp_AH_hist(h);
h_imp_AH.lo(h)$(min_totCost_0 eq 1)= h_imp_AH_hist(h);


binary variable
y_temp(h);

*------------------Grid DC related----------------------------------------------
positive variable
         C_DC_slack_var(h)             cooling from district cooling system
;


*-------------------------PE and CO2 related -----------------------------------
variable
         AH_CO2(h)      Hourly CO2 emissions from the Akademiska Hus FED network
         nonAH_CO2(h)   Hourly CO2 emissions from the non-Akademiska Hus FED network
         FED_CO2(h)     Hourly CO2 emissions in the FED system
         tot_CO2        Total CO2 emissions of the FED system
         FED_PE(h)      Hourly PE use in the FED system
         tot_PE         Total PE use in the FED system
;

*-------------------- Power tariffs --------------------------------------------
positive variables
         max_exG(m)         hourly peak demand per month
         PT_exG(m)          Monthly peak demand charge
         max_PT_exG        Used to get the maximum of the peak tariif for RTH
         mean_DH(d)         daily mean demand DH
         PT_DH              peak demand charge DH
;

*--------------------Objective function-----------------------------------------
variable
         fix_cost_existing  total fixed cost for existing generation
         fix_cost_new       total fixed cost for new generation
         var_cost_existing  total variable cost for existing generation
         var_cost_new       total variable cost for new generation
         Ainv_cost          total annualized investment cost
         totCost            total cost
         invCost_PV      investment cost of PV
         invCost_BES     investment cost of battery storage
         invCost_TES     investment cost of thermal energy storage
         invCost_SO      investment cost of building inertia thermal energy storage with Setpoint Offset
         invCost_BAC     investment cost of building advanced control
         invCost_HP      investment cost of heat pump
         invCost_RMMC    investment cost of connecting MC2 RM
         invCost_AbsCInv     investment cost of absorption cooler
         invCost_Boiler2     investment cost of B2
         invCost_TURB        investment cost of turbine
         invCost_RMInv       investment cost of refrigeration machines
         invCost            total investment cost
         FED_CO2_tot        total av. CO2 emissions from the FED system
         peak_CO2           CO2 peak
         obj                objective function
;

