function[BTES_D_init, BTES_S_init, BES_init, BFCh_init, Boiler1_init, Boiler2_init]=readGtoM(hour,BTES_BID_uels, BES_BID_uels, BFCh_BID_uels)
%Read GtoM.gdx reads the output GAMS GDX file to keep State of Charge (SoC) for relevant energy
%storage devices (Batteries, Cold water storage, PCM) and devices with ramp rate
%constraints (Boilers)consistent over the rolling time horizon runs. The
%values of these structures are returned, not the structures themselves.
% Note Cold Water Storage and PCM is not implemented at this time.

BTES_Den=struct('name','BTES_Den','form','full','compress','false');
BTES_Sen=struct('name','BTES_Sen','form','full','compress','false');
BES_en=struct('name','BES_en','form','full','compress','false');
BFCh_en=struct('name','BFCh_en','form','full','compress','false');
h_Boiler1=struct('name','h_Boiler1','form','full','compress','false');
h_Boiler2=struct('name','h_Boiler2','form','full','compress','false');

% By setting the uels to the current hour and only the required BIDS,
% rgdx does a "selective read" for only these values.
BTES_uels = {num2cell(hour), BTES_BID_uels};

BTES_Den.uels=BTES_uels;
BTES_Den = rgdx('GtoM',BTES_Den);
BTES_D_init = BTES_Den.val;

BTES_Sen.uels=BTES_uels;
BTES_Sen = rgdx('GtoM',BTES_Sen);
BTES_S_init = BTES_Sen.val;

BES_en.uels={num2cell(hour), BES_BID_uels};
BES_en=rgdx('GtoM',BES_en);
BES_init = BES_en.val;

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
% try
%     BTES_Den.uels{1} = BTES_Den.uels{1}(1); % This ensures only the first hour is present in the uels
%     BTES_Den.val = BTES_Den.val(1,:); % This ensures only the values corresponding to the first hour is present
%     if isempty(BTES_Den.val)
%         warning('Error processing BTES_Den in readGtoM, no values passed from GtoM. Creating struct with assumed 0 energy stored');
%         BTES_Den.val=zeros(1,8);
%         BTES_Den.uels=BTES_uels;
%     end
% catch
%     warning('Error processing BTES_D, cannot index uels, in readGtoM, probably empty struct. Creating struct with assumed 0 energy stored');
%     BTES_Den.val=zeros(1,8);
%     BTES_Den.uels=BTES_uels;
% end


% try
%     BTES_S.uels{1} = BTES_S.uels{1}(1); % This ensures only the first hour is present in the uels
%     BTES_S.val = BTES_S.val(1,:); % This ensures only the values corresponding to the first hour is present
%     if isempty(BTES_S.val)
%         warning('Error processing BTES_S in readGtoM, no values passed from GtoM. Creating struct with assumed 0 energy stored');
%         BTES_S.val=zeros(1,8);
%         BTES_S.uels=BTES_uels;
%     end
% catch
%     warning('Error processing BTES_S, cannot index uels, in readGtoM, probably empty struct. Creating struct with assumed 0 energy stored');
%     BTES_S.val=zeros(1,8);
%     BTES_S.uels=BTES_uels;
% end




