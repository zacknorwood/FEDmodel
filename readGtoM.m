function[BTES_BAC_D_init, BTES_BAC_S_init, BTES_SO_S_init, BTES_SO_D_init, BTES_PS_init, BES_init, BFCh_init, Boiler1_init, Boiler2_init]=readGtoM(hour,BTES_BAC_uels, BTES_SO_uels, BTES_PS_uels, BES_BID_uels, BFCh_BID_uels)
%Read GtoM.gdx reads the output GAMS GDX file to keep State of Charge (SoC) for relevant energy
%storage devices (Batteries, Cold water storage, PCM) and devices with ramp rate
%constraints (Boilers)consistent over the rolling time horizon runs.
% Note Cold Water Storage and PCM is not implemented at this time.

BAC_Den=struct('name','BAC_Den','form','full','compress','false');
BAC_Sen=struct('name','BAC_Sen','form','full','compress','false');
SO_Den=struct('name','SO_Den','form','full','compress','false');
SO_Sen=struct('name','SO_Sen','form','full','compress','false');
BTES_PS_init=struct('name','BTES_Den','form','full','compress','false');
BES_en=struct('name','BES_en','form','full','compress','false');
BFCh_en=struct('name','BFCh_en','form','full','compress','false');
h_Boiler1=struct('name','h_Boiler1','form','full','compress','false');
h_Boiler2=struct('name','h_Boiler2','form','full','compress','false');

% By setting the uels to the current hour and only the required BIDS,
% rgdx does a "selective read" for only these values.
BTES_BAC_uels = {num2cell(hour), BTES_BAC_uels};

BAC_Den.uels=BTES_BAC_uels;
BAC_Den = rgdx('GtoM',BAC_Den);
BTES_BAC_D_init = BAC_Den.val;

BAC_Sen.uels=BTES_BAC_uels;
BAC_Sen = rgdx('GtoM',BAC_Sen);
BTES_BAC_S_init = BAC_Sen.val;


BTES_SO_uels = {num2cell(hour), BTES_SO_uels};
SO_Den.uels=BTES_SO_uels;
SO_Den = rgdx('GtoM',SO_Den);
BTES_SO_D_init = SO_Den.val;

SO_Sen.uels=BTES_SO_uels;
SO_Sen = rgdx('GtoM',SO_Sen);
BTES_SO_S_init = SO_Sen.val;

% AK Implement pump stop
BTES_PS_init = 0
%BTES_PS_uels = {num2cell(hour), BTES_PS_uels};
%BTES_PS_en.uels=BTES_PS_uels;
%BTES_PS_en = rgdx('GtoM',BTES_PS_en);
%BTES_PS_init = BTES_PS_en.val;

%AK ADD THSE BACK 
%BES_en.uels={num2cell(hour), BTES_BAC_uels};
%BES_en=rgdx('GtoM',BES_en);
%BES_init = BES_en.val;
BES_init = 0
BFCh_en.uels={num2cell(hour), BFCh_BID_uels};
BFCh_en=rgdx('GtoM',BFCh_en);
BFCh_init = BFCh_en.val;

h_Boiler1.uels = num2cell(hour);
h_Boiler1=rgdx('GtoM',h_Boiler1);
Boiler1_init = h_Boiler1.val;

h_Boiler2.uels = num2cell(hour);
h_Boiler2=rgdx('GtoM',h_Boiler2);
Boiler2_init = h_Boiler2.val;
end



