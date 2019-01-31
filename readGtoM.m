function[BTES_Den, BTES_Sen, BES_en, BFCh_en, h_Boiler1, h_Boiler2]=readGtoM(hour,BTES_BID_uels)
%Read GtoM.gdx reads the output GAMS GDX file to keep State of Charge (SoC) for relevant energy
%storage devices (Batteries, Cold water storage, PCM) and devices with ramp rate
%constraints (Boilers)consistent over the rolling time horizon runs.
% Note Cold Water Storage and PCM is not implemented at this time.

BTES_Den=struct('name','BTES_Den','form','full','compress','false');
BTES_Sen=struct('name','BTES_Sen','form','full','compress','false');
BES_en=struct('name','BES_en','form','full','compress','false');
BFCh_en=struct('name','BFCh_en','form','full','compress','false');
h_Boiler1=struct('name','h_Boiler1','form','full','compress','false');
h_Boiler2=struct('name','h_Boiler2','form','full','compress','false');

% By setting the uels to BTES to the current hour in the simulation and
% only the required buildings rgdx does a "selective read" for only these
% values.
BTES_uels = {num2cell(hour), BTES_BID_uels};

BTES_Den.uels=BTES_uels;
BTES_Den = rgdx('GtoM',BTES_Den);

BTES_Sen.uels=BTES_uels;
BTES_Sen = rgdx('GtoM',BTES_Sen);

BFCh_en=rgdx('GtoM',BFCh_en);
BES_en=rgdx('GtoM',BES_en);
h_Boiler1=rgdx('GtoM',h_Boiler1);
h_Boiler2=rgdx('GtoM',h_Boiler2);

% names must be changed here to match the variables in GAMS where the
% initial state data will be passed. They must also be changed from variables to
% parameters.
BTES_Den.name='opt_fx_inv_BTES_D_init';
BTES_Den.type='parameter';
BTES_Sen.name='opt_fx_inv_BTES_S_init';
BTES_Sen.type='parameter';
BES_en.name='opt_fx_inv_BES_init';
BES_en.type='parameter';
BFCh_en.name='opt_fx_inv_BFCh_init';
BFCh_en.type='parameter';
h_Boiler1.name='Boiler1_prev_disp';
h_Boiler1.type='parameter';
h_Boiler2.name='Boiler2_prev_disp';
h_Boiler2.type='parameter';

% rgdx creates a field called 'field' that must be removed before writing
% with wgdx.
% Uels for the BES and Boilers that are indexed over hours also need to be
% removed as they are now single dimension parameters when passed as
% initial values.
BTES_Den=rmfield(BTES_Den,'field');
BTES_Sen=rmfield(BTES_Sen,'field');
BES_en=rmfield(BES_en,'field');
BES_en=rmfield(BES_en,'uels');
BFCh_en=rmfield(BFCh_en,'field');
BFCh_en=rmfield(BFCh_en,'uels');
h_Boiler1=rmfield(h_Boiler1,'field');
h_Boiler1=rmfield(h_Boiler1,'uels');
h_Boiler2=rmfield(h_Boiler2,'field');
h_Boiler2=rmfield(h_Boiler2,'uels');
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



%initial(1:7)=[BFCh_en,BES_en,h_Boiler1,h_Boiler2];
% for i=1:5
%     temp=0;
%     s=size(initial(i).uels{1,1},2);
%     for j=1:s
%         if str2num(initial(i).uels{1,1}{1,j})==currenthour
%             temp=initial(i).val(j);
%         end
%     end
%     InitialSoC(i)=temp;
% end
% for i=6:9
%     temp=0;
%     s=size(initial(i).uels{1,1},2);
%     for j=1:s
%         if str2num(initial(i).uels{1,1}{1,j})==currenthour-1
%             temp=initial(i).val(j);
%         end
%     end
%     InitialSoC(i)=temp;
% end


