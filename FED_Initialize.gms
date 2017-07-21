*******************************************************************************
*---------------------------Initialize input parameters------------------------
*******************************************************************************


*--------------IMPORT IMPUT DATA TO THE MODEL-----------------------------------

$Include FED_GENERAGE_GDX_FILE
*_no_gen
*-------------SET THE LENGTH OF INPUT DATA USED FOR SIMULATION------------------

set
        h(h0)                 Number of hours                     /H1*H8760/
        i(b0)                 Number of buildings in the system   /1*30/
        m(m0)                 Number of month                     /M1*M12/
        d(d0)                 Number of days                      /D1*D365/
;

alias(i,j);
*--------------SET PARAMETRS OF PRODUCTION UNITS---------------------------------

set
         sup_unit   supply units /HP,exG, DH, CHP, PV, TB, RHP, AbsC, AAC, RM, RMMC, P2, TURB, AbsCInv/
         inv_opt    investment options /PV, BES, HP, TES, BTES, RMMC, P2, TURB, AbsCInv/
;
* Remove hard coding of lifetimes in Acost_sup_unit and make this a set and show the calculation here
Parameter
         cap_sup_unit(sup_unit)   operational capacity of the units
         /PV 60, TB 9000, RHP 1600, AbsC 2300, AAC 1000, RM 2170, RMMC 4200/


         Acost_sup_unit(inv_opt) Annualized cost of the technologies in SEK per kW except RMMC which is a fixed cost
                                 /PV 410, BES 400, HP 667, TES 50, BTES 1166, RMMC 25000, P2 1533333, TURB 66666, AbsCInv 72.4/
;
*The annualized cost of the BTES is for a building 35000/30, assuming 30 years of technical life time
*table technology(n1,head2) technology with annualised investment cost in (SEK per MW or MWh per year for i=5)
*                            Price                    Lifetime      Annualised_Cost1       Annualised_Cost2        Annualised_Cost3
*HP                          18000000                 15            1728000                2034000                 2358000
*CHP                         3170000                  20            253600                 310660                  370890
*TES                         10000                    25            710                    900                     1100
*Battery                     12060000                 15            1157760                1362780                 1579860
*Solar_PV                    18000000                 30            1170000                1530000                 1908000
*RMMC2                       500000                   20
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
sw_HP=1;
sw_TES=1;
sw_BTES=1;
sw_BES=1;
sw_PV=1;
sw_RMMC = 1;
sw_P2 = 1;
sw_TURB = 1;
sw_AbsCInv = 1;
***************Existing units***************************************************
*--------------Existing Solar  constants and parameters (existing unit)---------

parameter
         nPV_ird(h)  Normalized PV irradiance
         e0_PV(h)    Existing PV power
;
nPV_ird(h)=nPV_ird0(h);
e0_PV(h)=cap_sup_unit('PV')*nPV_ird(h);
*--------------Existing Thermal boiler constants and parameters-----------------

parameter
         tb_2016(h)  Total heat power from the thermal boiler
;
tb_2016(h) = q_tb_2016(h) + q_fgc_2016(h);
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
*--------------AbsC(Absorbition Refregerator), cooling source-------------------

scalar
         AbsC_COP Coefficent of performance of AbsC /0.5/
         AbsC_eff Effciency of AbsC /0.95/
;
*--------------AAC(Ambient Air Cooler), cooling source--------------------------

scalar
         AAC_COP Coefficent of performance of AAC /1/
         AAC_eff Effciency of AbsC /0.95/
;
*--------------Refrigerator Machines, coling source-----------------------------

scalar
      RM_COP Coefficent of performance of AC /2/
      RM_eff Coefficent of performance of AC /0.95/
;
**************Investment options************************************************
*--------------Outside Temprature data------------------------------------------

Parameter
         tout(h) heat demand in buildings as obtained from metrys for
;
tout(h)=tout0(h);
*----------------Absorption Chiller Investment----------------------------------
*Assumed technical lifetime of 25 years, fixed investment cost 1610 kSek

scalar
         AbsCInv_COP    Coefficient of performance for cooling /0.75/
         AbsCInv_fx     Fixed cost for investment in Abs chiller /64400/
         AbsCInv_MaxCap Maximum possible investment in kW cooling /1000/
;
*----------------Panna 2  ------------------------------------------------------

scalar
      P2_eff Efficiency of P2 /0.9/
      q_P2_cap Capacity of P2 /6666/
;
*----------------Refurbished turbine for Panna 2  ------------------------------

scalar
      TURB_eff Efficiency of turbine /0.4/
      TURB_cap Maximum power output of turbine /600/
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
      eta_facade_data compensating for underestimated facade data/3.0/
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
      Tmod_roof(h,BID)=tout(h)+0.035*G_roof(h,BID);
      Tmod_facade(h,BID)=tout(h)+0.035*G_facade(h,BID);
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
         TES_max_cap           Maximum capacity available in m3/1000/
         TES_density           Energy density at 35C temp diff according to BDAB/39/
         TES_fx_cost           Fixed cost attributable to TES investment/4404119/
         TES_vr_cost           Variable cost attributable to TES investment/1887/
         TES_dis_max           Maximum discharge rate in kWh per h/23000/
         TES_ch_max            Maximum charge rate in kWh per h/11000/
         TES_hourly_loss_fac   Hourly loss factor/0.999208093/
;

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
         BTES_Sdis_eff        Discharge efficiency of the shallow midium
         BTES_Sch_eff         Charging efficiency of the shallow midium
         BTES_Sch_max(h,i)    maximum charging limit
         BTES_Sdis_max(h,i)   maximum discharging limit
         BTES_kSloss(h,i)     loss coefficient-shallow
         BTES_kDloss(h,i)     loss coefficient-deep
;
BTES_model(BTES_properties,i)=BTES_model0(BTES_properties,i);
BTES_Sen_int(i)=BTES_model('BTES_Scap',i);
BTES_Den_int(i)=BTES_model('BTES_Dcap',i);
BTES_Sdis_eff=1;
BTES_Sch_eff=1;

BTES_Sch_max(h,i)=Min(BTES_model('BTES_Sch_hc',i), BTES_model('BTES_Esig',i)*Max(Min(tout(h) - (-16),15 - (-16)),0));
BTES_Sdis_max(h,i)=Min(BTES_model('BTES_Sdis_hc',i), BTES_model('BTES_Esig',i)*Max(Min(15 - tout(h),15 - (-16)),0));
display BTES_Sch_max,BTES_Sdis_max
;

*[BTES_kSloss needs to be modified since it has different values during day and night]
*here, it is assumed that BTES_kSloss is the same and the value for the day is used, which means that the loss is over estimated
BTES_kSloss(h,i)= BTES_model('kloss_Sday',i);
BTES_kDloss(h,i)= BTES_model('kloss_D',i);
*--------------Battery storage characteristics----------------------------------

scalar
         BES_ch_eff    Charging efficiency /0.95/
         BES_dis_eff   Discharding efficiency /0.95/
;

*--------------set building energy demands--------------------------------------

Parameter
         q_demand(h,i) heat demand in buildings as obtained from metrys for
         q_demand_nonAH(h,i) heat demand in non-AH buildings as obtained from metrys for
         e_demand(h,i) heat demand in buildings as obtained from metrys for
         k_demand(h,i) cool demand in buildings as obtained from metrys for 2016
;
q_demand(h,i)=1000*q_demand0(h,i);
q_demand_nonAH(h,'25')=q_demand(h,'25');
q_demand_nonAH(h,'26')=q_demand(h,'26');
q_demand_nonAH(h,'27')=q_demand(h,'27');
q_demand_nonAH(h,'28')=q_demand(h,'28');
q_demand_nonAH(h,'29')=q_demand(h,'29');
q_demand_nonAH(h,'30')=q_demand(h,'30');
e_demand(h,i)=1000*el_demand0(h,i);
k_demand(h,i)=1000*k_demand0(h,i);
*--------------unit total cost for all the generating units---------------------

parameter
         price(sup_unit,h)       unit market price of energy
         fuel_cost(sup_unit,h)   fuel cost of a production unit
         var_cost(sup_unit,h)    variable cost of a production unit
         en_tax(sup_unit,h)      energy tax of a production unit
         co2_cost(sup_unit,h)    CO2 cost
         utot_cost(sup_unit,h)   unit total cost of every production unit
         PT_cost(sup_unit)       Power tariff SEK per kW per month
         heat_price(h)    heat price by GÃ¶teborg Energi in 2016 sek per MWh
                 /h1*h2184      519
                 h2185*h2904    357
                 h2905*h6576    99
                 h6577*h8040    357
                 h8041*h8760    519
                 /
;
price('exG',h)=0.0031 + el_price0(h)/1000;
price('DH',h)=heat_price(h)/1000;
fuel_cost('CHP',h)=0.186;
fuel_cost('TB',h)=0.186;
fuel_cost('P2',h)=0.186;
var_cost(sup_unit,h)=0;
*8.43 is an exhange rate usd to sek 2015
var_cost('CHP',h)=200*0.65*8.43;
var_cost('P2',h)=200*0.65*8.43;
var_cost('TB',h)=200*0.65*8.43;
var_cost('PV',h)=16*8.43;
var_cost('HP',h)=16*8.43;
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
         base_PE    Base case value of PE /98428000/
         PE_lim     Desired or limiting value of PE
         CO2_ref    Reference value of CO2 peak /1700000/
         CO2_peak   Peak value of CO2 in the base case /2402700/
         dCO2       Delta CO2
         CO2_lim    Desired or limiting value of CO2
;

PE_lim=(1-0.3)*base_PE;
dCO2=CO2_peak-CO2_ref;
CO2_lim=CO2_ref+0.2*dCO2;
*--------------PE and CO2 factors of external grids-----------------------------

Parameters
         PEF_DH(h)               Primary energy factor of the external DH system
         PEF_exG(h)              Primary energy factor of the external electricty grid
         CO2F_DH(h)              CO2 factor of the external DH system
         CO2F_exG(h)             CO2 factor of the external electricty grid
         CO2F_loc(sup_unit)      CO2 factor for a supply unit /'CHP' 177, 'TB' 177, 'P2' 177, 'PV' 45/
         PEF_loc(sup_unit)       PE factor for a supply unit /'CHP' 0.78, 'TB' 0.78, 'P2' 0.78, 'PV' 1.25/
;
PEF_DH(h)=PEF_DH0(h);
PEF_exG(h)=PEF_exG0(h);
CO2F_DH(h)=CO2F_DH0(h);
CO2F_exG(h)=CO2F_exG0(h);
