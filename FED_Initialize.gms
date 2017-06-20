*******************************************************************************
*---------------------------Initialize input parameters------------------------
*******************************************************************************


*--------------Creat GDX data files(if there not any, fist time)---------------
$Include FED_GENERAGE_GDX_FILE

*-------------SET THE LENGTH OF INPUT DATA USED FOR SIMULATION--------------
set
        h(h0)                 Number of hours                     /H1*H720/
        i(b0)                 Number of buildings in the system   /1*12/
;
alias(i,j);

*---------------------Energy systems included----------------------------------
PARAMETERS
sw_DR        switch to decide whether to use building inertia or not
sw_HP        switch to decide whether to operate HP or not
sw_AC        switch to decide whether to operate Absobtion Chiller
sw_R         switch to decide whether to operate Absobtion Chiller
sw_TES       switch to decide whether whether to operate TES or not
sw_CHP       switch to decide whether to operate CHP or not
sw_trans     switch to decide whether to operate transmission or not
sw_BTES      switch to decide whether to include building storage or not
sw_BES       switch to decide whether to include Battery storage or not
sw_PV        switch to decide whether to include solar PV or not
;

*-----use of switch to determine whether HP, CHP, TES should operate or not----
* 1=in operation, 0=out of operation
sw_DR=0;
sw_HP=1;
sw_AC=1;
sw_R=1;
sw_TES=1;
sw_CHP=1;
sw_trans=1;
sw_BTES=1;
sw_BES=1;
sw_PV=1;


*-----------------------HP constants and parameters----------------------------
scalar
HP_COP                Coefficent of performance of the Heat Pump (HP)/4/
;

*-----------------------VKA4 constants and parameters-----------------------
scalar
VKA1_H_COP            Heating coefficient of performance for VKA1/3.3/
VKA1_C_COP            Cooling coefficient of performance for VKA1/2/
VKA1_el_cap           Maximum electricity usage by VKA1/300/
;

*-----------------------VKA4 constants and parameters-----------------------
scalar
VKA4_H_COP            Heating coefficient of performance for VKA4/2.6/
VKA4_C_COP            Cooling coefficient of performance for VKA4/1.7/
VKA4_el_cap           Maximum electricity usage by VKA4/300/
;
*----------------------AC(Absorbition Refregerator), cooling source------------
scalar AC_COP Coefficent of performance of AC /4/
;

*----------------------Refrigerator, coling source----------------------------
scalar R_COP Coefficent of performance of AC /4/
;

*----------------------CHP constants and parameters----------------------------
scalar
CHP_el_heat           Ratio between elec and heat produced in CHP /0.7/
CHP_eff               Efficiency of CHP /0.95/
;

*----------------------TES constants and parameters----------------------------
scalar
TES_chr_eff           TES charging efficiency /0.95/
TES_dis_eff           TES discharging efficiency/0.95/
TES_max_cap           Maximum capacity available in m3/1000/
TES_density           Energy density at 35C temp diff according to BDAB/39/
TES_fx_cost           Fixed cost attributable to TES investment/4404119/
TES_vr_cost           Variable cost attributable to TES investment/1887/
TES_dis_max           Maximum discharge rate in kWh per h/23000/
TES_ch_max            Maximum charge rate in kWh per h/11000/
;


*---------------------Temprature data------------------------------------------
Parameter temp_out(h) heat demand in buildings as obtained from metrys for;
temp_out(h)=temp_out0(h);
*-------------------Building storage characteristics---------------------------
set
    BTES_properties(BTES_properties0)  Building termal properties
                     /BTES_Scap, BTES_Dcap, BTES_Esig, BTES_Sch_hc, BTES_Sdis_hc,
                      kloss_Sday,  kloss_Snight, kloss_D, K_BS_BD/
;
Parameters
BTES_model(i,BTES_properties)
BTES_Sen_int(i)      Initial energy stored in the shalow medium of the building
BTES_Den_int(i)      Initial energy stored in the deep medium of the building
BTES_Sdisch_eff      Discharge efficiency of the shallow midium
BTES_Sch_eff         Charging efficiency of the shallow midium
BTES_Sch_max(h,i)    maximum charging limit
BTES_Sdis_max(h,i)   maximum discharging limit
BTES_kSloss(h,i)     loss coefficient-shallow
BTES_kDloss(h,i)     loss coefficient-deep
;

BTES_model(i,BTES_properties)=BTES_model0(i,BTES_properties);
BTES_Sen_int(i)=BTES_model(i,'BTES_Scap');
BTES_Den_int(i)=BTES_model(i,'BTES_Dcap');
BTES_Sdisch_eff=1;
BTES_Sch_eff=1;

BTES_Sch_max(h,i)=Min(BTES_model(i,'BTES_Sch_hc'), BTES_model(i,'BTES_Esig')*Max(Min(temp_out(h) - (-16),15 - (-16)),0));
BTES_Sdis_max(h,i)=Min(BTES_model(i,'BTES_Sdis_hc'), BTES_model(i,'BTES_Esig')*Max(Min(15 - temp_out(h),15 - (-16)),0));
display BTES_Sch_max,BTES_Sdis_max
;

*BTES_kSloss needs to be modified since it different values during day and night
BTES_kSloss(h,i)= BTES_model(i,'kloss_Sday');
BTES_kDloss(h,i)= BTES_model(i,'kloss_D');
*-------------Battery storage characteristics-------------------
parameter
BES_ch_max    Maximum charging rate of the battery at building i
BES_dis_max   Maximum discharging rate of the battery at building i
BES_cost         Annualized cost of the battery at building i
;
BES_ch_max=0.2;
BES_dis_max=0.2;
BES_cost=12060;

*---------------PV data---------------
parameter nPV_ird(h)  Normalized PV irradiance;
nPV_ird(h)=nPV_ird0(h);

*-----------------set building energy demands---------------------------------
Parameter heat_demand(h,i) heat demand in buildings as obtained from metrys for
          el_demand(h,i) heat demand in buildings as obtained from metrys for
          cooling_demand(h,i) cool demand in buildings as obtained from metrys for 2016;
heat_demand(h,i)=heat_demand0(h,i);
el_demand(h,i)=el_demand0(h,i);
cooling_demand(h,i)=cooling_demand0(h,i);

*----------------------cost related constants and parameters-------------------
*------------------set energy prices------------------------------------------
Parameter heat_price(h) heat demand in buildings as obtained from metrys for
          el_price(h) heat demand in buildings as obtained from metrys for;
heat_price(h)=heat_price0(h);
el_price(h)=el_price0(h);

scalar
f_price               Fuel price in SEK per KWh/100/
C_price               Carbon price for fuel burnt in SEK per KWH/10/
;

set     fs                    Fuel source                         /Wood, Naturalgas/
        fp                    Fuel price                          /24, 6/
        chp(fs)               Fuel type used in CPH               /Wood/
        dh(fs)                Fuel type used in DH                /Wood/
        b_tp                  Building thermal property           /t_r, t_c/
;

Table heat_trans_capa(i,j) transmission capacity that export or import to other areas[KW]
         1       2       3       4       5       6       7       8       9       10      11      12
1        0      100     400      0       0       0       0       0       0       0       0       0
2       100      0       0      300      0       0       0       0       0       0       0       0
3       200      0       0       0      100      0       0       0       0       0       0       0
4        0      300      0       0       0      300      0       0       0       0       0       0
5        0       0      100      0       0       0      200      0       0       0       0       0
6        0       0       0      300      0       0       0      300      0       0       0       0
7        0       0       0       0      200      0       0       0      200      0       0       0
8        0       0       0       0       0      300      0       0       0      400      0       0
9        0       0       0       0       0       0      200      0       0       0      200      0
10       0       0       0       0       0       0       0      400      0       0       0      50
11       0       0       0       0       0       0       0       0      200      0       0      10
12       0       0       0       0       0       0       0       0       0      50      10       0
;

**********  Capacity in electricity system **********************************************
Table el_trans_capa(i,j) transmission capacity that export or import to other areas[KW]
         1       2       3       4       5       6       7       8       9       10      11      12
1        0      100     400      0       0       0       0       0       0       0       0       0
2       100      0       0      300      0       0       0       0       0       0       0       0
3       200      0       0       0      100      0       0       0       0       0       0       0
4        0      300      0       0       0      300      0       0       0       0       0       0
5        0       0      100      0       0       0      200      0       0       0       0       0
6        0       0       0      300      0       0       0      300      0       0       0       0
7        0       0       0       0      200      0       0       0      200      0       0       0
8        0       0       0       0       0      300      0       0       0      400      0       0
9        0       0       0       0       0       0      200      0       0       0      200      0
10       0       0       0       0       0       0       0      400      0       0       0      50
11       0       0       0       0       0       0       0       0      200      0       0      10
12       0       0       0       0       0       0       0       0       0      50      10       0
;
