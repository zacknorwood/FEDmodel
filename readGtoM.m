function[InitialSoC]=readGtoM(currenthour);
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
 
 [BTES_D]=rgdx('GtoM',BTES_Den);
 [BTES_S]=rgdx('GtoM',BTES_Sen);
 [TES]=rgdx('GtoM',TES_en);
 [BFCh]=rgdx('GtoM',BFCh_en);
 [BES]=rgdx('GtoM',BES_en);
 
 initial(1:5)=[BTES_D,BTES_S,TES,BFCh,BES];
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
end
