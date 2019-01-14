function[InitialSoC,max_exG_prev,BTES_S,BTES_D]=readGtoM(currenthour)
%Read GtoM.gdx Assume placement of storage systems in one place otherwise
%needs modification

 BES_en.name='BES_en';
 BES_en.form='full';
 BES_en.compress='true';
 
 BFCh_en.name='BFCh_en';
 BFCh_en.form='full';
 BFCh_en.compress='true';
 
 TES_en.name='TES_en';
 TES_en.form='full';
 TES_en.compress='true';
 
 BTES_Sen.name='BTES_Sen';
 BTES_Sen.form='full';
 BTES_Sen.compress='true';
 
 BTES_Den.name='BTES_Den';
 BTES_Den.form='full';
 BTES_Den.compress='true';
 
 h_Boiler1.name='h_Boiler1';
 h_Boiler1.form='full';
 h_Boiler1.compress='true';
 
 h_VKA1.name='h_VKA1';
 h_VKA1.form='full';
 h_VKA1.compress='true';
 
 h_VKA4.name='h_VKA4';
 h_VKA4.form='full';
 h_VKA4.compress='true';
 
  
 c_AAC.name='c_AAC';
 c_AAC.form='full';
 c_AAC.compress='true';
 
 max_exG_prev1.name='max_exG_prev';
 max_exG_prev1.form='full';
 max_exG_prev1.compress='true';
 
 [BTES_D]=rgdx('GtoM',BTES_Den);
 [BTES_S]=rgdx('GtoM',BTES_Sen);
 [TES]=rgdx('GtoM',TES_en);
 [BFCh]=rgdx('GtoM',BFCh_en);
 [BES]=rgdx('GtoM',BES_en);
  [Boiler]=rgdx('GtoM',h_Boiler1);
  [VKA1]=rgdx('GtoM',h_VKA1);
  [VKA4]=rgdx('GtoM',h_VKA4);
  [AAC]=rgdx('GtoM',c_AAC);
  [max_exG_prev]=rgdx('GtoM',max_exG_prev1);
  max_exG_prev=max_exG_prev.val;
  
 initial(1:9)=[BTES_D,BTES_S,TES,BFCh,BES,Boiler,VKA1,VKA4,AAC];
 for i=1:5
     temp=0;
     s=size(initial(i).uels{1,1},2);
   for j=1:s
     if str2num(initial(i).uels{1,1}{1,j})==currenthour;
     temp=initial(i).val(j);
     end
   end
     InitialSoC(i)=temp;
 end
 for i=6:9
     temp=0;
     s=size(initial(i).uels{1,1},2);
   for j=1:s
    if str2num(initial(i).uels{1,1}{1,j})==currenthour-1;
     temp=initial(i).val(j);
    end
   end
      InitialSoC(i)=temp;
 end
 end

