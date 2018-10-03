function[InitialSoC,max_exG_prev]=readGtoM(currenthour);
%Read GtoM.gdx

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
 
 h_Pana1.name='h_Pana1';
 h_Pana1.form='full';
 h_Pana1.compress='true';
 
 max_exG_prev1.name='max_exG_prev';
 max_exG_prev1.form='full';
 max_exG_prev1.compress='true';
 
 [BTES_D]=rgdx('GtoM',BTES_Den);
 [BTES_S]=rgdx('GtoM',BTES_Sen);
 [TES]=rgdx('GtoM',TES_en);
 [BFCh]=rgdx('GtoM',BFCh_en);
 [BES]=rgdx('GtoM',BES_en);
  [Pana]=rgdx('GtoM',h_Pana1);
  [max_exG_prev]=rgdx('GtoM',max_exG_prev1);
  max_exG_prev=max_exG_prev.val;
  
 initial(1:6)=[BTES_D,BTES_S,TES,BFCh,BES,Pana];
 for i=1:6
     temp=0;
     s=size(initial(i).uels{1,1},2);
   for j=1:s
     if str2num(initial(i).uels{1,1}{1,j})==currenthour;
     temp=initial(i).val(j);
     end
   end
   if i==6;
       for j=1:s
     if str2num(initial(i).uels{1,1}{1,j})==currenthour-1;
     temp=initial(i).val(j);
     end
       end
   end
   InitialSoC(i)=temp;
 end
end
