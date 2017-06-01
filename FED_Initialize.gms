*******************************************************************************
*---------------------------Initialize input parameters------------------------
*******************************************************************************


*--------------Creat GDX data files(if there not any, fist time)---------------
$Include C:\Users\modelling\Desktop\FED model\Copy\FEDmodel\GENERATE_GDX_FILE

*-------------SET THE LENGTH OF INPUT DATA USED FOR SIMULATION--------------
set
        h(h0)                 Number of hours                     /H1*H168/
        i(i0)                 Number of buildings in the system   /1*12/
;
alias(i,j);

set
    BTES_properties(BTES_properties0)  Building termal properties
                     /BS_cap, BD_cap, BS_ch_cap1,
                     BS_dis_cap1, k_BS_loss1,
                     K_BD_loss,   K_BS_BD/;


set     fs                    Fuel source                         /Wood, Naturalgas/
        fp                    Fuel price                          /24, 6/
        chp(fs)               Fuel type used in CPH               /Wood/
        dh(fs)                Fuel type used in DH                /Wood/
        b_tp                  Building thermal property           /t_r, t_c/
;

*---------------------Energy systems included----------------------------------
PARAMETERS
switch_DR        switch to decide whether to use building inertia or not
switch_HP        switch to decide whether whether to operate HP or not
switch_TES       switch to decide whether whether to operate TES or not
switch_CHP       switch to decide whether to operate CHP or not
switch_trans     switch to decide whether to operate transmission or not
;
*-----use of switch to determine whether HP, CHP, TES should operate or not----
* 1=in operation, 0=out of operation
switch_DR=1;
switch_HP=1;
switch_TES=1;
switch_CHP=1;
switch_trans=1;
*-----------------------HP constants and parameters----------------------------
scalar
HP_COP                Coefficent of performance of the Heat Pump (HP)/4/
;

*----------------------TES constants and parameters----------------------------
scalar
TES_chr_eff           TES charging efficiency /0.95/
TES_dis_eff           TES discharging efficiency/0.95/
TES_max_dis_rate      Maximum discharge rate of TES/0.2/
TES_max_chr_rate      Maximum charge rate of TES/0.2/
;

*----------------------CHP constants and parameters----------------------------
scalar
CHP_el_heat           Ratio between elec and heat produced in CHP /0.7/
CHP_eff               Efficiency of CHP /0.95/
;

*----------------------cost related constants and parameters-------------------
scalar
f_price               Fuel price in SEK per KWh/100/
C_price               Carbon price for fuel burnt in SEK per KWH/10/
;

*-----------------set building energy demands---------------------------------
Parameter heat_demand(h,i) heat demand in buildings as obtained from metrys for
          el_demand(h,i) heat demand in buildings as obtained from metrys for
          cooling_demand(h,i) cool demand in buildings as obtained from metrys for 2016;
heat_demand(h,i)=heat_demand0(h,i);
el_demand(h,i)=el_demand0(h,i);
cooling_demand(h,i)=cooling_demand0(h,i);

*------------------set energy prices------------------------------------------
Parameter heat_price(h) heat demand in buildings as obtained from metrys for
          el_price(h) heat demand in buildings as obtained from metrys for;
heat_price(h)=heat_price0(h);
el_price(h)=el_price0(h);

*---------------------Temprature data------------------------------------------
Parameter temp_out(h) heat demand in buildings as obtained from metrys for;
temp_out(h)=temp_out0(h);


*-------------------Building storage characteristics---------------------------
Parameters
BTES_model(i,BTES_properties)
BS_en_int(i)      Initial energy stored in the shalow medium of the building
BD_en_int(i)      Initial energy stored in the deep medium of the building
BS_disch_eff      Discharge efficiency of the shallow midium
BS_ch_eff         Charging efficiency of the shallow midium
;

BTES_model(i,BTES_properties)=BTES_model0(i,BTES_properties);
BS_en_int(i)=1;
BD_en_int(i)=1;
BS_disch_eff=1;
BS_ch_eff=1;
******************************************************************
*** Building data extraxted from buildings thermal power signature

*1-maskingr�nd edit
*2-kemig�rden 1 fysik origa 3
*3-chalmersplatsen 4 administration
*4-h�rsalar hb
*5-h�rsalsv�gen 7 maskinteknik
*6-h�rsalsv�gen 11 elteknik
*7-kemig�rden 1 fysik origa 1
*8-sven hultins gata 6
*9-sven hultins gata 8 v�g
*10-tv�rgata 1 biblioteket
*11-tv�rgata 3 mathematiska
*12-tv�rgata 6 lokalkontor

Table p_data(i,b_tp) inherent physical property of the building
                           t_r             t_c
1                         .08             60000
2                         .34             20000
3                         .51             10000
4                         .945            7000
5                         .05             55000
6                         .355            16000
7                         .28             23000
8                         .156            47500
9                         .122            41200
10                        .53             20000
11                        .369            15000
12                        1.29            3000
;

*******************************************************************
$ontext
table technology(n1,head2) technology with annualised investment cost
                 name                       cost
1                 HP                         50
2                CHP                         50
3                TES                         50
display technology ;
$offtext

**********  Capacity in DH system **********************************************
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
Table elec_trans_capa(i,j) transmission capacity that export or import to other areas[KW]
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


$ontext
Table price(o,p) transmission price export or import to other areas[SEK per KWh]
         1       2       3       4       5       6       7       8       9       10      11      12
1        0      150     200      0       0       0       0       0       0       0       0       0
2        75      0       0      330      0       0       0       0       0       0       0       0
3       200      0       0       0      200      0       0       0       0       0       0       0
4        0      330      0       0       0      300      0       0       0       0       0       0
5        0       0      200      0       0       0      200      0       0       0       0       0
6        0       0       0      300      0       0       0      300      0       0       0       0
7        0       0       0       0      200      0       0       0      200      0       0       0
8        0       0       0       0       0      300      0       0       0      400      0       0
9        0       0       0       0       0       0      200      0       0       0      200      0
10       0       0       0       0       0       0       0      400      0       0       0      320
11       0       0       0       0       0       0       0       0      200      0       0      170
12       0       0       0       0       0       0       0       0       0      320     170      0
;
$offtext

