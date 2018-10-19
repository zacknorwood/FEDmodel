function[]= excel_results(sim_start,sim_stop,Results,Time)
% Function that stores results in excel file
%stores dispatch for Panna1, Panna2, Flue G. cond., Heatpump1, Heatpump2,
%Import/Export heating, Turbines prod., PV prod, Import elec., AbsC cooling
%prod, AAC cooling prod, Refrigirator cooling prod., storage untis etc.
count=0;
for i=sim_start:sim_stop
    count=count+1;
    
    %--------Dispatch of different Units, Export/Import ------------------
    if (not(isempty(Results(i).dispatch.h_Pana1)) && Results(i).dispatch.h_Pana1(1,1)==1)
        pana1(count)=Results(i).dispatch.h_Pana1(1,2);
    else 
        pana1(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.h_P2)) && Results(i).dispatch.h_P2(1,1)==1)
       pana2(count)=Results(i).dispatch.h_P2(1,2);
    else 
        pana2(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.h_RGK1)) && Results(i).dispatch.h_RGK1(1,1)==1)
        fgc(count)=Results(i).dispatch.h_RGK1(1,2);
    else 
        fgc(count)=0;
    end
   
    if (not(isempty(Results(i).dispatch.H_VKA1)) && Results(i).dispatch.H_VKA1(1,1)==1)
        VKA1_h(count)=Results(i).dispatch.H_VKA1(1,2);
    else 
        VKA1_h(count)=0;
    end
 
    if (not(isempty(Results(i).dispatch.H_VKA4)) && Results(i).dispatch.H_VKA4(1,1)==1)
        VKA4_h(count)=Results(i).dispatch.H_VKA4(1,2);
    else 
        VKA4_h(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.h_imp_AH)) && Results(i).dispatch.h_imp_AH(1,1)==1)
       import_h(count)=Results(i).dispatch.h_imp_AH(1,2);
    else 
        import_h(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.h_imp_nonAH)) && Results(i).dispatch.h_imp_nonAH(1,1)==1)
       h_imp_nonAH(count)=Results(i).dispatch.h_imp_nonAH(1,2);
    else 
        h_imp_nonAH(count)=0;
    end

    if (not(isempty(Results(i).dispatch.h_exp_AH)) && Results(i).dispatch.h_exp_AH(1,1)==1)
       export_h(count)=Results(i).dispatch.h_exp_AH(1,2);
    else 
        export_h(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.e_TURB)) && Results(i).dispatch.e_TURB(1,1)==1)
       turbine(count)=Results(i).dispatch.e_TURB(1,2);
    else 
        turbine(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.e_imp_AH)) && Results(i).dispatch.e_imp_AH(1,1)==1)
       import_el(count)=Results(i).dispatch.e_imp_AH(1,2);
    else 
        import_el(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.c_AbsC)) && Results(i).dispatch.c_AbsC(1,1)==1)
       absC(count)=Results(i).dispatch.c_AbsC(1,2);
    else 
        absC(count)=0;
    end
   
    if (not(isempty(Results(i).dispatch.C_VKA1)) && Results(i).dispatch.C_VKA1(1,1)==1)
      VKA1_c(count)=Results(i).dispatch.C_VKA1(1,2);
    else 
        VKA1_c(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.C_VKA4)) && Results(i).dispatch.C_VKA4(1,1)==1)
      VKA4_c(count)=Results(i).dispatch.C_VKA4(1,2);
    else 
        VKA4_c(count)=0;
    end
    
    if (not(isempty(Results(i).dispatch.c_RM)) && Results(i).dispatch.c_RM(1,1)==1)
      refr(count)=Results(i).dispatch.c_RM(1,2);
    else 
        refr(count)=0;
    end
      
    if (not(isempty(Results(i).dispatch.e_AAC)) && Results(i).dispatch.e_AAC(1,1)==1)
      aac_el(count)=Results(i).dispatch.e_AAC(1,2);
    else 
        aac_el(count)=0;
    end
       
    if (not(isempty(Results(i).dispatch.c_AAC)) && Results(i).dispatch.c_AAC(1,1)==1)
      aac_c(count)=Results(i).dispatch.c_AAC(1,2);
    else 
        aac_c(count)=0;
    end
         
    if (not(isempty(Results(i).dispatch.cool_demand)) && Results(i).dispatch.cool_demand(1,1)==1)
      cool_demand(count)=Results(i).dispatch.cool_demand(1,2);
    else 
        cool_demand(count)=0;
    end        
          
    if (not(isempty(Results(i).dispatch.elec_demand)) && Results(i).dispatch.elec_demand(1,1)==1)
      elec_demand(count)=Results(i).dispatch.elec_demand(1,2);
    else 
        elec_demand(count)=0;
    end
         
    if (not(isempty(Results(i).dispatch.heat_demand)) && Results(i).dispatch.heat_demand(1,1)==1)
      heat_demand(count)=Results(i).dispatch.heat_demand(1,2);
    else 
        heat_demand(count)=0;
    end
         
    if (not(isempty(Results(i).dispatch.c_RM)) && Results(i).dispatch.c_RM(1,1)==1)
      c_RM(count)=Results(i).dispatch.c_RM(1,2);
    else 
        c_RM(count)=0;
    end
  %----------------Storage units--------------------------------------------      
    if (not(isempty(Results(i).dispatch.BES_en)) && Results(i).dispatch.BES_en(1,1)==1 && Results(i).dispatch.BES_en(1,2)==1)
      BES_en(count)=Results(i).dispatch.BES_en(1,3);
    else 
        BES_en(count)=0;
    end
         
    if (not(isempty(Results(i).dispatch.BES_ch)) && Results(i).dispatch.BES_ch(1,1)==1 && Results(i).dispatch.BES_ch(1,2)==1)
      BES_ch(count)=Results(i).dispatch.BES_ch(1,3);
    else 
        BES_ch(count)=0;
    end
      
    if (not(isempty(Results(i).dispatch.BES_dis)) && Results(i).dispatch.BES_dis(1,1)==1 && Results(i).dispatch.BES_dis(1,2)==1)
      BES_dis(count)=Results(i).dispatch.BES_dis(1,3);
    else 
        BES_dis(count)=0;
    end
      
    if (not(isempty(Results(i).dispatch.BFCh_en)) && Results(i).dispatch.BFCh_en(1,1)==1 && Results(i).dispatch.BFCh_en(1,2)==1)
      BFCh_en(count)=Results(i).dispatch.BFCh_en(1,3);
    else 
        BFCh_en(count)=0;
    end
      
    if (not(isempty(Results(i).dispatch.BFCh_ch)) && Results(i).dispatch.BFCh_ch(1,1)==1 && Results(i).dispatch.BFCh_ch(1,2)==1)
      BFCh_ch(count)=Results(i).dispatch.BFCh_ch(1,3);
    else 
        BFCh_ch(count)=0;
    end    
      
    if (not(isempty(Results(i).dispatch.BFCh_dis)) && Results(i).dispatch.BFCh_dis(1,1)==1 && Results(i).dispatch.BFCh_dis(1,2)==1)
      BFCh_dis(count)=Results(i).dispatch.BFCh_dis(1,3);
    else 
        BFCh_dis(count)=0;
    end 
      
    if (not(isempty(Results(i).dispatch.TES_ch)) && Results(i).dispatch.TES_ch(1,1)==1)
      TES_ch(count)=Results(i).dispatch.TES_ch(1,2);
    else 
        TES_ch(count)=0;
    end  
      
    if (not(isempty(Results(i).dispatch.TES_dis)) && Results(i).dispatch.TES_dis(1,1)==1)
      TES_dis(count)=Results(i).dispatch.TES_dis(1,2);
    else 
        TES_dis(count)=0;
    end 
      
    if (not(isempty(Results(i).dispatch.TES_en)) && Results(i).dispatch.TES_en(1,1)==1)
      TES_en(count)=Results(i).dispatch.TES_en(1,2);
    else 
        TES_en(count)=0;
    end 
          
    BTES_Sch(count)=0;
    for k=1:size(Results(i).dispatch.BTES_Sch,1)
        if (not(isempty(Results(i).dispatch.BTES_Sch)) && Results(i).dispatch.BTES_Sch(k,1)==1)
            BTES_Sch(count)= BTES_Sch(count)+Results(i).dispatch.BTES_Sch(k,3);
        end
    end
      
    BTES_Sdis(count)=0;
    for k=1:size(Results(i).dispatch.BTES_Sdis,1)
        if (not(isempty(Results(i).dispatch.BTES_Sdis)) && Results(i).dispatch.BTES_Sdis(k,1)==1)
            BTES_Sdis(count)=BTES_Sdis(count)+Results(i).dispatch.BTES_Sdis(k,3);
        end
    end
      
    BTES_Sen(count)=0; 
    for k=1:size(Results(i).dispatch.BTES_Sen,1)
        if (not(isempty(Results(i).dispatch.BTES_Sen)) && Results(i).dispatch.BTES_Sen(k,1)==1)
            BTES_Sen(count)=BTES_Sen(count)+Results(i).dispatch.BTES_Sen(k,3);
        end
    end
      
    BTES_Den(count)=0;
    for k=1:size(Results(i).dispatch.BTES_Den,1)
        if (not(isempty(Results(i).dispatch.BTES_Den)) && Results(i).dispatch.BTES_Den(k,1)==1)
            BTES_Den(count)= BTES_Den(count)+Results(i).dispatch.BTES_Den(k,3);
        end
    end
    
    %--------------Costs----------------------------
    if (not(isempty(Results(i).dispatch.tot_var_cost_AH)) && Results(i).dispatch.tot_var_cost_AH(1,1)==1)
        tot_var_cost_AH(count)=Results(i).dispatch.tot_var_cost_AH(1,2);
    else
        tot_var_cost_AH(count)=0;
    end        
           
    tot_fixed_cost(count)=Results(i).dispatch.tot_fixed_cost;
    sim_PT_exG(count)=Results(i).dispatch.sim_PT_exG;
    
    if (not(isempty(Results(i).dispatch.PT_DH)))
        PT_DH(count)=Results(i).dispatch.PT_DH;
    else
        PT_DH(count)=0;
    end    
 
    %tot_var_cost_AH(count)=Results(i).dispatch.tot_var_cost_AH;
            
    %tot_operation_cost_AH(count)=Results(i).dispatch.tot_operation_cost_AH;
    
    for k=1:size(Results(i).dispatch.B_Heating_cost,1)
        if (not(isempty(Results(i).dispatch.B_Heating_cost)) && Results(i).dispatch.B_Heating_cost(k,1)==1)
            B_Heating_cost(count,Results(i).dispatch.B_Heating_cost(k,2))=Results(i).dispatch.B_Heating_cost(k,3);
        end
    end
             
    for k=1:size(Results(i).dispatch.B_Electricity_cost,1)
        if (not(isempty(Results(i).dispatch.B_Electricity_cost)) && Results(i).dispatch.B_Electricity_cost(k,1)==1)
            B_Electricity_cost(count,Results(i).dispatch.B_Electricity_cost(k,2))=Results(i).dispatch.B_Electricity_cost(k,3);
        end
    end
             
    for k=1:size(Results(i).dispatch.B_Cooling_cost,1)
        if (not(isempty(Results(i).dispatch.B_Cooling_cost)) && Results(i).dispatch.B_Cooling_cost(k,1)==1)
            B_Cooling_cost(count,Results(i).dispatch.B_Cooling_cost(k,2))=Results(i).dispatch.B_Cooling_cost(k,3);
        end
    end
             
              
  %-------------------CO2/PE---------------------------
    if (not(isempty(Results(i).dispatch.FED_PE)) && Results(i).dispatch.FED_PE(1,1)==1)
        FED_PE(count)=Results(i).dispatch.FED_PE(1,2);
    else
        FED_PE(count)=0;
    end
               
    if (not(isempty(Results(i).dispatch.MA_FED_PE)) && Results(i).dispatch.MA_FED_PE(1,1)==1)
        MA_FED_PE(count)=Results(i).dispatch.MA_FED_PE(1,2);
    else
        MA_FED_PE(count)=0;
    end
                                             
    if (not(isempty(Results(i).dispatch.FED_CO2)) && Results(i).dispatch.FED_CO2(1,1)==1)
        FED_CO2(count)=Results(i).dispatch.FED_CO2(1,2);
    else
        FED_CO2(count)=0;
    end
               
    if (not(isempty(Results(i).dispatch.MA_FED_CO2)) && Results(i).dispatch.MA_FED_CO2(1,1)==1)
        MA_FED_CO2(count)=Results(i).dispatch.MA_FED_CO2(1,2);
    else
        MA_FED_CO2(count)=0;
    end
                            
end

%Print dispatch outcome and historical dispatch
    xlswrite('results',export_h',strcat('E3:E',num2str(count+2)));
    xlswrite('results',{'Export H'},'E1:F1');
    xlswrite('results',{'Dispatch'},'E2:E2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\AH_h_import_exp.xlsx',2,strcat('D',num2str(sim_start+3),':D',num2str(sim_stop+3)))*1000,strcat('F3:F',num2str(count+2)));

    xlswrite('results',pana1',strcat('A3:A',num2str(count+2)));
    xlswrite('results',{'Dispatch'},'A2:A2');
    xlswrite('results',{'Pana1'},'A1:B1');
    xlswrite('results',xlsread('Input_dispatch_model\Panna1 2016-2017.xls',2,strcat('B',num2str(sim_start+2),':B',num2str(sim_stop+2)))*1000,strcat('B3:B',num2str(count+2)));

    xlswrite('results',pana2',strcat('C3:C',num2str(count+2)));
    xlswrite('results',{'Pana2'},'C1:D1');
    xlswrite('results',{'Dispatch'},'C2:C2');
    xlswrite('results',xlsread('Input_dispatch_model\P1P2_dispatchable.xlsx',1,strcat('C',num2str(sim_start),':C',num2str(sim_stop))),strcat('D3:D',num2str(count+2)));
      
    xlswrite('results',fgc',strcat('G3:G',num2str(count+2)));
    xlswrite('results',{'FGC'},'G1:H1');
    xlswrite('results',{'Dispatch'},'G2:G2');
    xlswrite('results',xlsread('Input_dispatch_model\Panna1 2016-2017.xls',2,strcat('C',num2str(sim_start+2),':C',num2str(sim_stop+2)))*1000,strcat('H3:H',num2str(count+2)));
      
    xlswrite('results',VKA1_h',strcat('I3:I',num2str(count+2)));
    xlswrite('results',{'VKA1_H'},'I1:J1');
    xlswrite('results',{'Dispatch'},'I2:I2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\värmepump VKA1.xls',1,strcat('C',num2str(sim_start-1990),':C',num2str(sim_stop-1990))),strcat('J3:J',num2str(count+2)));


    xlswrite('results',VKA4_h',strcat('K3:K',num2str(count+2)));
    xlswrite('results',{'VKA4_H'},'K1:L1');
    xlswrite('results',{'Dispatch'},'K2:K2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\värmepump VKA4.xls',1,strcat('C',num2str(sim_start-1438),':C',num2str(sim_stop-1438))),strcat('L3:L',num2str(count+2)));

    xlswrite('results',import_h',strcat('M3:M',num2str(count+2)));
    xlswrite('results',{'Import H'},'M1:N1');
    xlswrite('results',{'Dispatch'},'M2:M2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\AH_h_import_exp.xlsx',2,strcat('C',num2str(sim_start+3),':C',num2str(sim_stop+3)))*1000,strcat('N3:N',num2str(count+2)));

    xlswrite('results',turbine',strcat('O3:O',num2str(count+2)));
    xlswrite('results',{'Turbine'},'O1:P1');
    xlswrite('results',{'Dispatch'},'O2:O2');

    %xlswrite('results',temp,strcat('Q3:Q',num2str(count+2)));
    xlswrite('results',{'PV'},'Q1:R1');
    xlswrite('results',{'Dispatch'},'Q2:Q2');
    
    xlswrite('results',import_el',strcat('S3:S',num2str(count+2)));
    xlswrite('results',{'Import El'},'S1:T1');
    xlswrite('results',{'Dispatch'},'S2:S2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\AH_el_import.xlsx',1,strcat('C',num2str(sim_start),':C',num2str(sim_stop))),strcat('T3:T',num2str(count+2)));
    
    xlswrite('results',absC',strcat('U3:U',num2str(count+2)));
    xlswrite('results',{'AbsC'},'U1:V1');
    xlswrite('results',{'Dispatch'},'U2:U2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\abs o frikyla 2016-2017.xlsx',1,strcat('C',num2str(sim_start+3),':C',num2str(sim_stop+3)))*1000,strcat('V3:V',num2str(count+2)));
    
    xlswrite('results',VKA1_c',strcat('W3:W',num2str(count+2)));
    xlswrite('results',{'VKA1_C'},'W1:X1');
    xlswrite('results',{'Dispatch'},'W2:W2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\värmepump VKA1.xls',1,strcat('H',num2str(sim_start-1990),':H',num2str(sim_stop-1990))),strcat('X3:X',num2str(count+2)));

    xlswrite('results',VKA4_c',strcat('Y3:Y',num2str(count+2)));
    xlswrite('results',{'VKA4_C'},'Y1:Z1');
    xlswrite('results',{'Dispatch'},'Y2:Y2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\värmepump VKA4.xls',1,strcat('H',num2str(sim_start-1438),':H',num2str(sim_stop-1438))),strcat('Z3:Z',num2str(count+2)));

    xlswrite('results',aac_c',strcat('AA3:AA',num2str(count+2)));
    xlswrite('results',{'AAC_C'},'AA1:AB1');
    xlswrite('results',{'Dispatch'},'AA2:AA2');
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\abs o frikyla 2016-2017.xlsx',1,strcat('N',num2str(sim_start+3),':N',num2str(sim_stop+3)))*1000,strcat('AB3:AB',num2str(count+2)));
    
    xlswrite('results',refr',strcat('AC3:AC',num2str(count+2)));
    xlswrite('results',{'Refrig'},'AC1:AD1');
    xlswrite('results',{'Dispatch'},'AC2:AC2');
    
    xlswrite('results',aac_el',strcat('AE3:AE',num2str(count+2)));
    xlswrite('results',{'AAC_EL'},'AE1:AF1');
    xlswrite('results',{'Dispatch'},'AE2:AE2');
    
    %xlswrite('results',aac_el',strcat('AF3:AF',num2str(count+2)));
    xlswrite('results',{'C_RMMC'},'AG1:AH1');
    xlswrite('results',{'Dispatch'},'AG2:AG2');
   
    %xlswrite('results',aac_el',strcat('AH3:AH',num2str(count+2)));
    xlswrite('results',{'H_RMMC'},'AI1:AJ1');
    xlswrite('results',{'Dispatch'},'AI2:AI2');
           
    %xlswrite('results',aac_el',strcat('AJ3:AJ',num2str(count+2)));
    xlswrite('results',{'EL_RMMC'},'AK1:AL1');
    xlswrite('results',{'Dispatch'},'AK2:AK2');
    
    xlswrite('results',cool_demand',strcat('AN2:AN',num2str(count+2)));
    xlswrite('results',{'Cooling Demand'},'AN1:AN1');
    
    xlswrite('results',heat_demand',strcat('AR2:AR',num2str(count+2)));
    xlswrite('results',{'Heating Demand'},'AR1:AR1');
    
    xlswrite('results',elec_demand',strcat('AV2:AV',num2str(count+2)));
    xlswrite('results',{'Electricity Demand'},'AV1:AV1');
    
    xlswrite('results',h_imp_nonAH',strcat('BA2:BA',num2str(count+2)));
    xlswrite('results',{'Import H nonAH'},'BA1:BA1');
%Storage Units
    xlswrite('results',BES_en','Storages',strcat('A3:A',num2str(count+2)));
    xlswrite('results',{'BES_en'},'Storages','A2:A2');
    xlswrite('results',{'Battery'},'Storages','A1:C1');

    xlswrite('results',BES_ch','Storages',strcat('B3:B',num2str(count+2)));
    xlswrite('results',{'BES_ch'},'Storages','B2:B2');

    xlswrite('results',BES_dis','Storages',strcat('C3:C',num2str(count+2)));
    xlswrite('results',{'BES_dis'},'Storages','C2:C2');

    xlswrite('results',BFCh_en','Storages',strcat('D3:D',num2str(count+2)));
    xlswrite('results',{'BFCh_en'},'Storages','D2:D2');
    xlswrite('results',{'Battery Fast Charge'},'Storages','D1:F1');
    
    xlswrite('results',BFCh_ch','Storages',strcat('E3:E',num2str(count+2)));
    xlswrite('results',{'BFCh_ch'},'Storages','E2:E2');
    
    xlswrite('results',BFCh_dis','Storages',strcat('F3:F',num2str(count+2)));
    xlswrite('results',{'BFCh_dis'},'Storages','F2:F2');
    
    xlswrite('results',TES_en','Storages',strcat('H3:H',num2str(count+2)));
    xlswrite('results',{'TES_en'},'Storages','H2:H2');
    xlswrite('results',{'TES'},'Storages','H1:J1'); 
    
    xlswrite('results',TES_ch','Storages',strcat('I3:I',num2str(count+2)));
    xlswrite('results',{'TES_ch'},'Storages','I2:I2');
    
    xlswrite('results',TES_dis','Storages',strcat('J3:J',num2str(count+2)));
    xlswrite('results',{'TES_dis'},'Storages','J2:J2');
    
    xlswrite('results',BTES_Sen','Storages',strcat('K3:K',num2str(count+2)));
    xlswrite('results',{'BTES_Sen'},'Storages','K2:K2');
    xlswrite('results',{'BTES_S'},'Storages','K1:M1'); 
    
    xlswrite('results',BTES_Sch','Storages',strcat('L3:L',num2str(count+2)));
    xlswrite('results',{'BTES_Sch'},'Storages','L2:L2');
    
    xlswrite('results',BTES_Sdis','Storages',strcat('M3:M',num2str(count+2)));
    xlswrite('results',{'BTES_Sdis'},'Storages','M2:M2');
    
    xlswrite('results',BTES_Den','Storages',strcat('N3:N',num2str(count+2)));
    xlswrite('results',{'BTES_Den'},'Storages','N2:N2');
    xlswrite('results',{'BTES_D'},'Storages','N1:N1'); 
    
    xlswrite('results',c_RM','Storages',strcat('O3:O',num2str(count+2)));
    xlswrite('results',{'c_RM'},'Storages','O2:O2');
    xlswrite('results',{'c_RM'},'Storages','O1:O1'); 
%-------------Costs----------------------    
    xlswrite('results',tot_var_cost_AH','Costs',strcat('A2:A',num2str(count+2)));
    xlswrite('results',{'tot_var_cost_AH'},'Costs','A1:A1');
    
    xlswrite('results',tot_fixed_cost','Costs','B2:B2');
    xlswrite('results',{'tot_fixed_cost'},'Costs','B1:B1');
    
    %xlswrite('results',tot_operation_cost_AH','Costs','C2:C2');
    %xlswrite('results',{'tot_operation_cost_AH'},'Costs','C1:C1');

    xlswrite('results',B_Heating_cost,'B_Heating_cost',strcat('A2:AJ',num2str(count+2)));
    xlswrite('results',{'B_Heating_cost'},'B_Heating_cost','A1:A1');
    
    xlswrite('results',B_Electricity_cost,'B_Electricity_cost',strcat('A2:AJ',num2str(count+2)));
    xlswrite('results',{'B_Electricity_cost'},'B_Electricity_cost','A1:A1');
    
    xlswrite('results',B_Cooling_cost,'B_Cooling_cost',strcat('A2:AJ',num2str(count+2)));
    xlswrite('results',{'B_Cooling_cost'},'B_Cooling_cost','A1:A1');
%--------------CO2 and PE factors-------------------
    xlswrite('results',FED_PE','CO2_PE',strcat('A2:A',num2str(count+2)));
    xlswrite('results',{'FED PE'},'CO2_PE','A1:A1');
    
    xlswrite('results',MA_FED_PE','CO2_PE',strcat('B2:B',num2str(count+2)));
    xlswrite('results',{'Marginal FED PE'},'CO2_PE','B1:B1');
    
    xlswrite('results',FED_CO2','CO2_PE',strcat('C2:C',num2str(count+2)));
    xlswrite('results',{'FED CO2'},'CO2_PE','C1:C1');
       
    xlswrite('results',MA_FED_CO2','CO2_PE',strcat('D2:D',num2str(count+2)));
    xlswrite('results',{'Marginal FED CO2'},'CO2_PE','D1:D1');  
    
    
%Print running time and simulation infos
    xlswrite('results',{Time.point}','Sim infos','B3:B6');
    xlswrite('results',{Time.value}','Sim infos','D3:D6');
    xlswrite('results',{'Running time'},'Sim infos','C2:C2');
    xlswrite('results',[sim_start; sim_stop;],'Sim infos','B8:B9');
    [num,text,raw,]=xlsread('Input_dispatch_model\measured_demand.xlsx',1,strcat('A',num2str(sim_start),':A',num2str(sim_start)));
    xlswrite('results',text,'Sim infos','C8:C8');
    [num,text,raw,]=xlsread('Input_dispatch_model\measured_demand.xlsx',1,strcat('A',num2str(sim_stop),':A',num2str(sim_stop)));
    xlswrite('results',text,'Sim infos','C9:C9');
end