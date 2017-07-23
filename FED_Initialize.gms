*******************************************************************************
*---------------------------Initialize input parameters------------------------
*******************************************************************************


*--------------IMPORT IMPUT DATA TO THE MODEL-----------------------------------

$Include FED_GET_GDX_FILE
*-------------SET THE LENGTH OF INPUT DATA USED FOR SIMULATION------------------

set
        h(h0)                 Number of hours                     /H1*H8760/
        i(b0)                 Number of buildings in the system   /1*30/
        i_AH(i)               AH buildings                        /1*24/
        i_nonAH(i)            non-AH buildings                    /25*30/
        i_nonBITES(i)         Buildings not applicable for BITES  /2,5,7,18,24,25,26/
        m(m0)                 Number of month                     /M1*M12/
        d(d0)                 Number of days                      /D1*D365/
;

alias(i,j);
*--------------SET PARAMETRS OF PRODUCTION UNITS---------------------------------

set
         sup_unit   supply units /HP,exG, DH, CHP, PV, TB, RHP, AbsC, AAC, RM, RMMC, P2, TURB, AbsCInv/
         inv_opt    investment options /PV, BES, HP, TES, BTES, RMMC, P2, TURB, AbsCInv/
;

Parameter
         cap_sup_unit(sup_unit)   operational capacity of the units
                     /PV 60, TB 9000, RHP 1600, AbsC 2300, AAC 1000, RM 2170, RMMC 4200/
         cost_inv_opt(inv_opt)    Investment costs of FED investment options in SEK per kW except RMMC which is a fixed cost
                     /PV 12300, BES 6000, HP 10000, BTES 35000, RMMC 500000, P2 46000000, TURB 2000000/
         lifT_inv_opt(inv_opt)    Life time of invetment options
                     /PV 30, BES 10, HP 15, TES 50, BTES 30, RMMC 20, P2 40, TURB 30, AbsCInv 25/;
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
*--------------Existing Solar PV  constants and parameters (existing unit)---------

parameter
         nPV_ird(h)  Normalized PV irradiance
         e0_PV(h)    Existing PV power
;
nPV_ird(h)=nPV_ird0(h);
e0_PV(h)=cap_sup_unit('PV')*nPV_ird(h);
*--------------Existing Thermal boiler constants and parameters (P1)------------

scalar
         p1_eff_TB   Efficiency of primary heat converssion /0.9/
         p1_eff_FGC  Efficiency of secondary heat converssion /0.9/
;
Parameter
         q_p1_TB(h)  PRIMARY HEAT PRODUCED FROM THE THERMAL BOILER
         q_p1_FGC(h) SECONDARY HEAT PRODUCED FROM THE THERMAL BOILER
         q_p1(h)     Input fuel of THE THERMAL BOILER
;
q_p1_TB(h) = q_p1_TB0(h);
q_p1_FGC(h) = q_p1_FGC0(h);
q_p1(h)=(q_p1_TB(h)/p1_eff_TB) + (q_p1_FGC(h)/p1_eff_FGC);
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
         AAC_COP Coefficent of performance of AAC /4/
         AAC_eff Effciency of AbsC /0.95/
;
*--------------Refrigerator Machines, coling source-----------------------------

scalar
      RM_COP Coefficent of performance of AC /2/
      RM_eff Coefficent of performance of AC /0.95/
;
**************Investment options************************************************
*----------------Absorption Chiller Investment----------------------------------
*Assumed technical lifetime of 25 years, fixed investment cost 1610 kSek

scalar
         AbsCInv_COP    Coefficient of performance for cooling /0.75/
         AbsCInv_fx     Fixed cost for investment in Abs chiller /1610000/
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
      eta_facade_data compensating for underestimated facade data/2.0/
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
         BTES_Sdis_eff        Discharge efficiency of the shallow midium
         BTES_Sch_eff         Charging efficiency of the shallow midium
         BTES_Sch_max(h,i)    maximum charging limit
         BTES_Sdis_max(h,i)   maximum discharging limit
         BTES_kSloss(i)      loss coefficient-shallow
         BTES_kDloss(i)      loss coefficient-deep
;
BTES_model(BTES_properties,i)=BTES_model0(BTES_properties,i);
BTES_Sen_int(i)=BTES_model('BTES_Scap',i);
BTES_Den_int(i)=BTES_model('BTES_Dcap',i);
BTES_Sdis_eff=0.95;
BTES_Sch_eff=0.95;

BTES_Sch_max(h,i)=Min(BTES_model('BTES_Sch_hc',i), BTES_model('BTES_Esig',i)*Max(Min(tout(h) - (-16),15 - (-16)),0));
BTES_Sdis_max(h,i)=Min(BTES_model('BTES_Sdis_hc',i), BTES_model('BTES_Esig',i)*Max(Min(15 - tout(h),15 - (-16)),0));
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
         q_demand(h,i)             heat demand in buildings as obtained from metrys for
         q_demand_AH(h,i_AH)       heat demand in AH buildings as obtained from metrys for
         q_demand_nonAH(h,i_nonAH) heat demand in non-AH buildings as obtained from metrys for
         e_demand(h,i)             heat demand in buildings as obtained from metrys for
         k_demand(h,i)             demand in buildings as obtained from metrys for 2016
         k_demand_AH(h,i)          cool demand in AH buildings as obtained from metrys for 2016
         k_demand_nonAH(h,i)       cool demand in nonAH buildings as obtained from metrys for 2016
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
         fuel_cost(sup_unit,h)   fuel cost of a production unit
         var_cost(sup_unit,h)    variable cost of a production unit
         en_tax(sup_unit,h)      energy tax of a production unit
         co2_cost(sup_unit,h)    CO2 cost
         utot_cost(sup_unit,h)   unit total cost of every production unit
         PT_cost(sup_unit)       Power tariff SEK per kW per month
;
price('exG',h)=0.0031 + el_price0(h);
price('DH',h)=q_price0(h);

*the data is obtained from ENTSO-E
fuel_cost('CHP',h)=0.186;
fuel_cost('P1',h)=0.186;
fuel_cost('P2',h)=0.186;
var_cost(sup_unit,h)=0;

*the data is obtained from IEA
*An exchange rate of 8.43 (average in 2015) is used to convert usd to sek
var_cost('CHP',h)=200*0.65*8.43;
var_cost('P2',h)=200*0.65*8.43;
var_cost('P1',h)=200*0.65*8.43;
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
*--------------PE and CO2 factors of local generation---------------------------

Parameters
         CO2F_loc(sup_unit)      CO2 factor for a supply unit /'CHP' 23, 'P1' 23, 'P2' 23, 'PV' 45/
         PEF_loc(sup_unit)       PE factor for a supply unit /'CHP' 1.39, 'P1' 1.39, 'P2' 1.39,'PV' 1.25/;
*--------------FED PE and CO2 targets-------------------------------------------

scalar
         PE_lim     Desired or limiting value of PE
         CO2_ref    Reference value of CO2 peak
         dCO2       Delta CO2
         CO2_lim    Desired or limiting value of CO2
;

PE_lim=(1-0.3)*FED_PE_base;
CO2_ref=0.9*FED_CO2Peak_base;
dCO2=FED_CO2Peak_base-CO2_ref;
CO2_lim=CO2_ref+0.2*dCO2;
*--------------Limit on investment----------------------------------------------

scalar inv_lim  Maximum value of the investment in SEK /76761000/;

