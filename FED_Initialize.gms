*******************************************************************************
*---------------------------Initialize input parameters------------------------
*******************************************************************************


*--------------IMPORT IMPUT DATA TO THE MODEL-----------------------------------

$Include FED_GET_GDX_FILE
*-------------SET THE LENGTH OF INPUT DATA USED FOR SIMULATION------------------

alias (h0,h);
alias (b0,i);
display h0,i;

set
        i_AH(i)               AH buildings
                              /O0007001-Fysikorigo, O0007005-Polymerteknologi
                              O0007006-NyaMatte,  O0007012-Elkraftteknik,
                              O0007014-GibraltarHerrgrd, O0007017-Chalmersbibliotek,
                              O0007018-Idelra,  O0007019-CentralaAdministrationen,
                              O0007021-HrsalarHC,  O0007022-HrsalarHA,
                              O0007023-Vg-och-vatten1,   O0007024-EDIT,
                              O0007025-HrsalarHB,   O0007026-Arkitektur,
                              O0007027-Vg-och-vatten2, O0007028-Maskinteknik,
                              O0007040-GamlaMatte,  O0007043-PhusCampusJohanneberg,
                              O0007888-LokalkontorAH, O0011001-FysikSoliden,
                              O0013001-Keramforskning, O3060132-Kemi-och-bioteknik-cfab,
                              O3060133-FysikMC2,  O3060150_1-Krhuset
                              /
        i_nonAH(i)            non-AH buildings
                             /O3060137-CTP,  O3060138-JSP, O3060101-Vasa1,
                              O3060102_3-Vasa-2-3, O3060104_15-Vasa-4-15, O4002700-Chabo
                             /
        i_nonBITES(i)         Buildings not applicable for BITES
                             /O0007005-Polymerteknologi,O0007014-GibraltarHerrgrd,
                              O0007018-Idelra,O0007888-LokalkontorAH,
                              O3060150_1-Krhuset,O3060137-CTP,O3060138-JSP/
        m(m0)                 Number of month                     /1*12/
        d(d0)                 Number of days                      /1*365/
;

alias(i,j);
*--------------SET PARAMETRS OF PRODUCTION UNITS---------------------------------

set
         sup_unit   supply units /PV, HP, BES, TES, BTES, RMMC, P1, P2, TURB, AbsC, AbsCInv, AAC, RM, exG, DH, CHP/
         inv_opt    investment options /PV, HP, BES, TES, BTES, RMMC, P2, TURB, AbsCInv/
;

Parameter

* Investment costs from WP4_D4.2.1 prestudy report
* PV 7600000+3970000 SEK / 265+550 kW = 14 196, BES 1200000 SEK / 200 kWh = 600, P2 46000000 / 6000000 = 7666, Turb 1800000 SEK / 800 kW = 2250
* note: check AbsCInv and HP, sources?
* cost_sup_unit(inv_opt) cost of the investment options in SEK per kW or kWh for battery or SEK per building in the case of BTES and RMMC
*         /PV 14196, BES 6000, HP 10000, BTES 35000, RMMC 500000, P2 7666, Turb 2250/
*         Acost_sup_unit(inv_opt) Annualized cost of the technologies in SEK per kW except RMMC which is a fixed cost
*                                 /PV 410, BES 400, HP 667, BTES 1166, RMMC 25000, P2 1533333, TURB 66666, AbsCInv 72.4/

* Acost_sup_unit(inv_opt) = cost_sup_unit(inv_opt) / lifetime_sup_unit(inv_opt);
*The annualized cost of the BTES is for a building 35000/30, assuming 30 years of technical life time
*table technology(n1,head2) technology with annualised investment cost in (SEK per MW or MWh per year for i=5)
*                            Price                    Lifetime      Annualised_Cost1       Annualised_Cost2        Annualised_Cost3
*HP                          18000000                 15            1728000                2034000                 2358000
*CHP                         3170000                  20            253600                 310660                  370890
*TES                         10000                    25            710                    900                     1100
*Battery                     12060000                 15            1157760                1362780                 1579860
*Solar_PV                    18000000                 30            1170000                1530000                 1908000
*RMMC2                       500000                   20
         cap_sup_unit(sup_unit)   operational capacity of the existing units
                     /PV 60, P1 9000, AbsC 2300, AAC 1000, RM 2170, RMMC 4200/

* Investment costs source WP4_D4.2.1 prestudy report, except absorption chiller and HP from Danish Energy Agency, year 2015 cost: https://ens.dk/sites/ens.dk/files/Analyser/technology_data_catalogue_for_energy_plants_-_aug_2016._update_june_2017.pdf
* PV 7600000+3970000 SEK / 265+550 kW = 14 196, BES 1200000 SEK / 200 kWh = 6000, P2 46000000 / 6000000 = 7666, Turb 1800000 SEK / 800 kW = 2250
* Exchange rate 2015: Eur to SEK = 9.36; 1.7/0.75 = COPheat / COPcool for an absorption heat pump, for cost conversion from Danish Energy Agency report.
* HP 700 * 9.36 = 6552 , AbsC 600 * 9.36 * 1.7/0.75= 5616

         cost_inv_opt(inv_opt)    Cost of the investment options in SEK per kW or kWh for battery or SEK per unit or building in the case of BTES RMMC P2 and Turbine
                     /PV 14196, BES 6000, HP 6552, BTES 35000, RMMC 500000, P2 46000000, TURB 1800000, AbsCInv 12730/

* Lifetimes source Danish Energy Agency: https://ens.dk/sites/ens.dk/files/Analyser/technology_data_catalogue_for_energy_plants_-_aug_2016._update_june_2017.pdf
         lifT_inv_opt(inv_opt)    Life time of investment options
                     /PV 30, BES 15, HP 25, TES 30, BTES 30, RMMC 25, P2 30, TURB 30, AbsCInv 25/;

*--------------CHoice of investment options to consider-------------------------

PARAMETERS
         sw_HP        switch to decide whether to operate HP or not
         sw_TES       switch to decide whether whether to operate TES or not
         sw_BTES      switch to decide whether to include building storage or not
         sw_BES       switch to decide whether to include Battery storage or not
         sw_PV        switch to decide whether to include solar PV or not
         sw_RMMC      switch to decide whether investment in connecting refrigeration machines at MC2 to KB0
         sw_P2        switch to decide whether to include P2 or not
         sw_TURB      switch to decide whether to include turbine or not
         sw_AbsCInv   switch to decide whether to include absorption chiller investments
;
*use of switch to determine whether HP, CHP, TES should operate or not
* 1=in operation, 0=out of operation
sw_HP = 1;
sw_TES = 1;
sw_BTES = 1;
sw_BES = 1;
sw_PV = 1;
sw_RMMC = 1;
sw_P2 = 1;
sw_TURB = 1;
sw_AbsCInv = 1;
***************Existing units***************************************************
*--------------Existing Solar PV  constants and parameters (existing unit)---------

parameter
         nPV_ird(h)  Normalized PV irradiance
         e0_PV(h)    Existing PV power
;
nPV_ird(h)=nPV_el0(h);
e0_PV(h)=cap_sup_unit('PV')*nPV_ird(h);
*--------------Existing Thermal boiler constants and parameters (P1)------------
*This data is imported from MATLAB and stored in MtoG

Parameter
          P1_eff      Efficiency of Panna1
          q_P1(h)     Total heat output from P1
;
P1_eff=0.9;
q_P1(h)= q_P1_TB(h) + q_P1_FGC(h);
*--------------VKA4 constants and parameters------------------------------------

scalar
         VKA1_H_COP            Heating coefficient of performance for VKA1/3.3/
         VKA1_C_COP            Cooling coefficient of performance for VKA1/2/
         VKA1_el_cap           Maximum electricity usage by VKA1/300/
;
*--------------VKA4 constants and parameters------------------------------------

scalar
         VKA4_H_COP            Heating coefficient of performance for VKA4/2.6/
         VKA4_C_COP            Cooling coefficient of performance for VKA4/1.7/
         VKA4_el_cap           Maximum electricity usage by VKA4/300/
;
*--------------AbsC(Absorbition Refrigerator), cooling source-------------------

scalar
         AbsC_COP Coefficent of performance of AbsC /0.5/
         AbsC_eff Efficiency of AbsC /0.95/
;
*--------------AAC(Ambient Air Cooler), cooling source--------------------------

scalar
         AAC_COP Coefficent of performance of AAC /10/
         AAC_eff Efficiency of AbsC /0.95/
;
*--------------Refrigerator Machines, cooling source-----------------------------

scalar
      RM_COP Coefficent of performance of AC /2/
      RM_eff Coefficent of performance of AC /0.95/
;
**************Investment options************************************************

*----------------Absorption Chiller Investment----------------------------------

scalar
         AbsCInv_COP    Coefficient of performance for absorption cooling investment /0.75/
         AbsH_COP       Coeffiicent of performance for absorption heating investment /1.7/

*        AbsCInv_fx     Fixed cost for investment in Abs chiller /64400/
         AbsCInv_MaxCap Maximum possible investment in kW cooling /100000/
*         AbsCInv_fx     Fixed cost for investment in Abs chiller /1610000/


;
*----------------Panna 2  ------------------------------------------------------

scalar
      P2_eff Efficiency of P2 /0.9/
      q_P2_cap Capacity of P2 /6000/
;
*----------------Refurbished turbine for Panna 2  ------------------------------

scalar
      TURB_eff Efficiency of turbine /0.25/
      TURB_cap Maximum power output of turbine /800/
;
*--------------MC2 Refrigerator Machines, cooling source------------------------
* Real capacity of RMMC is 4200 but since MC2 internal cooling demand isn't
* accounted for RMMC capacity is here decreased by 600 kW

scalar
      RMCC_COP Coefficient of performance for RM /1.94/
      RMMC_cap Maximum cooling capacity for RM in kW/3600/
;
*--------------PV data----------------------------------------------------------

scalar
      Tstc Temperature at standard temperature and conditions in degree Celsius /25/
      Gstc Irradiance at standard temperature and conditions in kW per m^2 /1/
      PV_cap_density kW per m^2 for a mono-Si PV module e.g. Sunpower SPR-E20-327 dimensions 1.558*1.046 of 327Wp /0.20065/
      eta_Inverter efficiency of solar PV inverter and balance of system /0.96/
      eta_roof_data compensating for overestimated roof data /0.5/
      eta_facade_data compensating for underestimated facade data/2.0/
      coef_temp_PV coefficient coupling irradiance and PV temperature /0.035/
;

set coefs Coefficient numbering for PV calculations /1*6/
parameter
      coef_Si(coefs) Si solar PV coefficient
      /1 -0.017162, 2 -0.040289, 3 -0.004681, 4 0.000148, 5 0.000169, 6 0.000005/
;

parameter
      Gekv_roof(h,BID) Equivalent irradiance parameter for solar PV on roof in kW per m^2
      Gekv_facade(h,BID) Equivalent irradiance parameter for solar PV on facade in kW per m^2
      Tmod_roof(h,BID) Module temperature roof in Celsius
      Tmod_facade(h,BID) Module temperature facade in Celsius
      Tekv_roof(h,BID) Equivalent temperature parameter for solar PV on roof
      Tekv_facade(h,BID) Equivalent temperature parameter for solar PV on facade

;
      Gekv_roof(h,BID)=abs(G_roof(h,BID))/Gstc;
      Gekv_facade(h,BID)=abs(G_facade(h,BID))/Gstc;

      Tmod_roof(h,BID)=tout0(h)+coef_temp_PV*G_roof(h,BID);
      Tmod_facade(h,BID)=tout0(h)+coef_temp_PV*G_facade(h,BID);

      Tekv_roof(h,BID)=Tmod_roof(h,BID) - Tstc;
      Tekv_facade(h,BID)=Tmod_facade(h,BID) - Tstc;
*--------------HP constants and parameters (an investment options)-------------

*[COP and eff values need to be checked]
scalar
         HP_H_COP       Coefficent of performance for heat of the Heat Pump (HP)/3.5/
         HP_C_COP       Coefficent of performance for cooling of the Heat Pump (HP)/2/
;
*--------------TES constants and parameters-------------------------------------

scalar
         TES_chr_eff           TES charging efficiency /0.95/
         TES_dis_eff           TES discharging efficiency/0.95/
         TES_max_cap           Maximum capacity available in m3/100000/
         TES_density           Energy density at 35C temp diff according to BDAB/39/
         TES_fx_cost           Fixed cost attributable to TES investment/5732000/
         TES_vr_cost           Variable cost attributable to TES investment/1887/
         TES_dis_max           Maximum discharge rate in kWh per h/23000/
         TES_ch_max            Maximum charge rate in kWh per h/11000/
         TES_hourly_loss_fac   Hourly loss factor/0.999208093/
;
*--------------Outside Temprature data------------------------------------------

Parameter
         tout(h) heat demand in buildings as obtained from metrys for
;
tout(h)=tout0(h);
*--------------Building storage characteristics---------------------------------

set
         BTES_properties(BTES_properties0)  Building inertia thermal energy storage properties
                 /BTES_Scap, BTES_Dcap, BTES_Esig, BTES_Sch_hc, BTES_Sdis_hc,
                 kloss_Sday,  kloss_Snight, kloss_D, K_BS_BD/
;
scalar
         BTES_chr_eff           BTES charging efficiency /0.95/
         BTES_dis_eff           BTES discharging efficiency/0.95/
;
Parameters
         BTES_model(BTES_properties,i)
         BTES_Sen_int(i)      Initial energy stored in the shalow medium of the building
         BTES_Den_int(i)      Initial energy stored in the deep medium of the building
         BTES_Sdis_eff        Discharge efficiency of the shallow medium
         BTES_Sch_eff         Charging efficiency of the shallow medium
         BTES_Sch_max(h,i)    maximum charging limit
         BTES_Sdis_max(h,i)   maximum discharging limit
         BTES_kSloss(i)      loss coefficient-shallow
         BTES_kDloss(i)      loss coefficient-deep
;
BTES_model(BTES_properties,i)=BTES_model0(BTES_properties,i);
BTES_Sen_int(i)=1000*BTES_model('BTES_Scap',i);
BTES_Den_int(i)=1000*BTES_model('BTES_Dcap',i);
BTES_Sdis_eff=0.95;
BTES_Sch_eff=0.95;

BTES_Sch_max(h,i)=1000*Min(BTES_model('BTES_Sch_hc',i), BTES_model('BTES_Esig',i)*Max(Min(tout(h) - (-16),15 - (-16)),0));
BTES_Sdis_max(h,i)=1000*Min(BTES_model('BTES_Sdis_hc',i), BTES_model('BTES_Esig',i)*Max(Min(15 - tout(h),15 - (-16)),0));
display BTES_Sch_max,BTES_Sdis_max
;

*[BTES_kSloss needs to be modified since it has different values during day and night]
*here, it is assumed that BTES_kSloss is the same and the value for the day is used, which means that the loss is over estimated
BTES_kSloss(i)= BTES_model('kloss_Sday',i);
BTES_kDloss(i)= BTES_model('kloss_D',i);
*--------------Battery storage characteristics----------------------------------

scalar
         BES_ch_eff    Charging efficiency /0.95/
         BES_dis_eff   Discharding efficiency /0.95/
;
*--------------set building energy demands--------------------------------------

Parameter

         q_demand(h,i)             heat demand in buildings as obtained from metry
         q_demand_AH(h,i_AH)       heat demand in AH buildings as obtained from metry
         q_demand_nonAH(h,i_nonAH) heat demand in non-AH buildings as obtained from metry
         e_demand(h,i)             heat demand in buildings as obtained from metry
         k_demand(h,i)             cool demand in buildings as obtained from metry and many estimations
         k_demand_AH(h,i)          cool demand in AH buildings as obtained from metry and many estimations
         k_demand_nonAH(h,i)       cool demand in non-AH buildings as obtained from metry and many estimations

;
q_demand(h,i)=q_demand0(h,i);
q_demand_AH(h,i_AH)=q_demand(h,i_AH);
q_demand_nonAH(h,i_nonAH)=q_demand(h,i_nonAH);

e_demand(h,i)=el_demand0(h,i);

k_demand(h,i)=k_demand0(h,i);
k_demand_AH(h,i_AH)=k_demand(h,i_AH);
k_demand_nonAH(h,i_nonAH)=k_demand(h,i_nonAH);
*--------------unit total cost for all the generating units---------------------

parameter
         price(sup_unit,h)       unit market price of energy
         fuel_cost(sup_unit,h)   fuel cost per kWh production
         var_cost(sup_unit,h)    variable cost O&M per kWh energy produced excluding the cost of the primary fuel
         fix_cost(sup_unit)      annual fixed cost per kW capacity of production
         en_tax(sup_unit,h)      energy tax of a production unit
         co2_cost(sup_unit,h)    CO2 cost
         utot_cost(sup_unit,h)   unit total cost of every production unit
         PT_cost(sup_unit)       Power tariff SEK per kW per month

*         USD_to_SEK_2015 Exchange rate USD to SED 2015 /8.43/
         EUR_to_SEK_2015 Exchange rate EUR to SEK in 2015 /9.36/
         kilo Factor of 1000 conversion to kW from MW for example /1000/

;
price('exG',h)=0.0031 + el_price0(h);
price('DH',h)=q_price0(h);

*the data is obtained from ENTSO-E
fuel_cost('CHP',h)=0.186;
fuel_cost('P1',h)=0.186/P1_eff;
*fuel_cost('P1',h)=0.186*fuel_P1(h)/q_P1(h);
fuel_cost('P2',h)=0.186/P2_eff;
var_cost(sup_unit,h)=0;
fix_cost(sup_unit)=0;

* No data in Danish Energy Agency report for TES tank storage, assume costs zero
* No data in Danish Energy Agency report for BTES building thermal energy, assume costs zero
* HP variable O&M exclusive electricity costs
var_cost('HP',h)= 2 / kilo * EUR_to_SEK_2015;
fix_cost('HP')= 2000 / kilo * EUR_to_SEK_2015;
* Refrigerating machine assumed same as HP for both variable and O&M and fixed costs
var_cost('RM',h)= var_cost('HP',h);
fix_cost('RM')= fix_cost('HP');
var_cost('CHP',h)= 3.9 / kilo * EUR_to_SEK_2015;
fix_cost('CHP')= 29000 / kilo * EUR_to_SEK_2015;
* No data on turbine separate from CHP, assume total O&M costs same as variable for CHP
var_cost('TURB',h)= 3.9 / kilo * EUR_to_SEK_2015;
* variable costs of PV are assumed 0.
fix_cost('PV')= 12540 / kilo * EUR_to_SEK_2015;
* No data on fixed costs for wood chip boilers, included in variable O&M costs.
var_cost('P1',h)= 5.4 / kilo * EUR_to_SEK_2015;
var_cost('P2',h)= 5.4 / kilo * EUR_to_SEK_2015;
* AbsC variable O&M inclusive electricity, adjusted by COP for absorption heating compared to cooling factors
var_cost('AbsC',h)= 0.9 / kilo * AbsH_COP/AbsC_COP * EUR_to_SEK_2015;
fix_cost('AbsC')= 3000 / kilo * EUR_to_SEK_2015;
* AbsCInv variable O&M inclusive electricity, adjusted by COP for absorption heating compared to cooling factors
var_cost('AbsCInv',h)= 0.9 / kilo * AbsH_COP/AbsCInv_COP * EUR_to_SEK_2015;
fix_cost('AbsCInv')= 3000 / kilo * EUR_to_SEK_2015;
* No data on ambient air chillers, assume same as absorption heater for both variable O&M and fixed costs
var_cost('AAC',h)= 0.9 / kilo * EUR_to_SEK_2015;
fix_cost('AAC')= 3000 / kilo * EUR_to_SEK_2015;
* No data in Danish Energy Agency report for lithium ion, assume costs same as for NaS
var_cost('BES',h)= 5.3 / kilo * EUR_to_SEK_2015;
fix_cost('BES')= 51000 / kilo * EUR_to_SEK_2015;

en_tax(sup_unit,h)=0;
en_tax('exG',h)=0.295;

co2_cost(sup_unit,h)=0;

PT_cost(sup_unit)=0;
PT_cost('exG')=35.4;
PT_cost('DH')=452;

utot_cost(sup_unit,h)=price(sup_unit,h) + fuel_cost(sup_unit,h)
                      + var_cost(sup_unit,h) + en_tax(sup_unit,h);
*--------------FED PE and CO2 targets-------------------------------------------

scalar
         PE_lim     Desired or limiting value of PE
         dCO2       Delta CO2
         CO2_lim    Desired or limiting value of CO2
;

PE_lim=(1-0.3)*FED_PE_base;
dCO2=FED_CO2Peak_base-CO2_ref;
CO2_lim=CO2_ref+0.2*dCO2;
*--------------Limit on investment----------------------------------------------
