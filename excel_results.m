function[]= excel_results(sim_start,sim_stop,Results,Time)
% Function that stores results in excel file
%stores dispatch for Panna1, Panna2, Flue G. cond., Heatpump1, Heatpump2,
%Import/Export heating, Turbines prod., PV prod, Import elec., AbsC cooling
%prod, AAC cooling prod, Refrigirator cooling prod.
count=0;
for i=sim_start:sim_stop
    count=count+1;
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
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\abs o frikyla 2016-2017.xlsx',1,strcat('C',num2str(sim_start-15),':C',num2str(sim_stop-15)))*1000,strcat('V3:V',num2str(count+2)));
    
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
    xlswrite('results',xlsread('Input_data_FED_SIMULATOR\abs o frikyla 2016-2017.xlsx',1,strcat('N',num2str(sim_start-15),':N',num2str(sim_stop-15)))*1000,strcat('AB3:AB',num2str(count+2)));
    
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