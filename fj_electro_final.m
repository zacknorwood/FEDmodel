function [y1] = fj_electro_final(x1)
%FJ_ELECTRO_FINAL neural network simulation function.
%
% Auto-generated by MATLAB, 07-May-2019 12:47:50.
% 
% [y1] = fj_electro_final(x1) takes these arguments:
%   x = 4xQ matrix, input #1
% With 
%   Row 1: Outdoor temperature in Celsius
%   Row 2: Month [1-12]
%   Row 3: Workday or non-workday [1 = workday, 0 = non-workday] 
%   Row 4: Time of day [1-24, with 24 = 00 is treated as the start of the
%          year, i.e., the first hour of the year has value 24. This since
%          the logged value for that time is primarly between 23 -24 the
%          day before]
% and returns:
%   y = 1xQ matrix, output #1
% where Q is the number of samples.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-12.5;1;0;1];
x1_step1.gain = [0.0436681222707424;0.181818181818182;2;0.0869565217391304];
x1_step1.ymin = -1;

% Layer 1
b1 = [4.8699744709500993878;4.0363028315212439168;-3.7495212464451683765;-4.2422866718719545176;-2.4395460956628216564;-3.4974882008057441851;-3.6472810372402855172;4.6376137747951888812;-4.8493478734427224452;5.799360391371308765;5.6603992153013686917;5.9581955811149818203;2.5778882903468463006;-2.6362410726290068652;1.5588931405991626189;3.0684381398445141897;2.6075953686152111288;-2.115524040559809027;-1.171904502405315629;0.38567836400501692706;2.6852447698188441905;-2.6260302574697216293;0.19726492365085887548;0.81311278980268197891;1.4354274029723366191;-0.39288301766081401567;0.35393142540685096353;-1.1962944040028409276;-0.57003793082315312724;0.65109029564110110222;-0.91746726138289569352;0.1235078584152596165;0.41436914537500080247;0.7890769647985758084;-1.2874776175077795592;-0.60935991482338613956;0.29409745362149380954;2.0975549132446218437;1.687319688490533931;-2.6705994009511684339;1.620818757451214065;-1.1772699737362104511;1.7276225112543974749;-1.4508620494429593784;-2.216699250632175211;-3.5101080673506825924;-2.6470485857930183826;4.4610922849710377136;-3.2941760629853282794;2.5285732284390651792;3.3466592503211298748;2.7465050176936953719;3.8059907511221653387;-2.9881293401413437927;-2.8916764051301653282;-5.8524506386923427215;4.5520244360130552863;3.337789143793684854;5.1613438107526752319;-4.0227921350479363127];
IW1_1 = [-1.5891961847434767918 5.3297165096305940679 0.37841432643262756796 -1.1382224411133683439;-0.9010451769753227147 -2.925555208010607533 -1.7436556162592364849 -2.2536364420250118989;0.1482415461088311126 -1.0205676007147808093 -2.4531733361948866445 1.5971102767833234015;3.7003927747848863739 2.592300276615700394 1.8166240293492204039 -0.5621306436845998622;1.6163767956966530459 3.2009532706130663371 -2.5181911002715970938 -1.0724244241955844803;1.2748617264793549175 -3.1492674932859086034 -2.5953212017787490318 0.51731640702478731697;2.1514432286001605732 -3.6419410390095703356 -2.4326621687126941396 0.21608624807478965524;0.78624059968653370323 4.9920565023232912338 1.6926304361894850548 -1.7434831138203070733;-1.7256481495571884821 -4.1326004672627076886 -1.0532073668663193278 5.4041683111058347322;-0.20266883605775917743 0.038886759657114529365 -1.9941982572635945647 9.2062591533121072018;-0.61803701049210124641 0.051534825153711702472 -1.7601485558118405983 8.8649110610705985636;0.14046423847133515661 0.034879667018834853431 -2.1899304861307968828 9.5673921826294634485;-1.3439574648834922144 1.6764024326189372882 -2.9130008208633690892 -3.3648824281341167541;4.0299515491381265875 3.5094009988678953604 -0.019010698487000453338 -1.0637204521695597936;-2.7378115890487082495 0.81212822152310770729 1.4030884413486797158 -1.472326038474136789;-0.977299380314726851 -3.9153161104870553011 -2.7958388573740005079 0.98565808571773849689;-2.6587949259229191057 0.090219370658513514671 1.0055241332578346292 2.7846707682905100789;3.4793157036854762687 -1.1648712099946294529 4.2241292516219077768 1.6649346200015575636;1.6054615697453349377 1.9458037655173132663 -2.4395546709793332063 1.8876414872729483374;-1.8344316836376175495 -2.4403691233889626133 3.3112952123968026896 -0.6455464826386291266;-0.13857711833536359713 0.060597569258177254314 2.7902955187820697169 -11.4052020872849873;1.4720902762318663903 -2.1703355430516690916 -3.4487864605737930113 -1.0639675691923971002;-1.1174662786760927169 2.2075086560004013592 2.7424906866945746309 -2.8906375768379852786;-1.3738390738984198602 0.39179728877125175046 -1.7934937384516262959 -2.7734045422355890764;-2.1302668825051562784 2.6780597652405226938 1.7615159605458377001 -1.37986554308694509;2.7319095648900288964 1.1539591198813412554 2.4236127795455955081 -6.0524985486788462907;-1.2248911905172259473 -0.66302702927231860208 -2.8550919283722020481 -3.2445737728087955531;1.1821699308414650442 2.5399520913196496075 2.1179148897262023432 1.310653424689169233;0.66674568664305300381 -3.7371267436924027194 0.10928198775472999782 1.6966909530137801454;-0.48794978869180627434 -2.7011694278901043909 -2.9800040855087250868 1.6697001504596289401;1.3011260392019723398 1.2956063276324936151 -2.5940534192480768638 -2.4641246897300437269;0.1958857408157324842 -3.8811238010925266373 -1.7304462952295591727 0.43083217505032556094;-1.2602329333207464845 -2.4988029415676740186 -2.6075455815345205401 1.6519632553458938329;0.30340014770999390592 -2.4924388993992439012 -2.9072295462882680184 1.6532108913148961804;-2.1884995692000748235 0.20131538974461349323 3.5117444148070409149 0.44941266520788802907;-0.55217377098075259845 2.2431299903490207193 -1.4548744001312239327 2.9575074837605965783;4.989320201487465134 1.2851231325624787871 -1.3773352432861691863 -0.73979435717804065131;2.9688939143636980944 -0.19959510614182102151 -2.9907010230217023761 -0.31216483889373763949;1.9722378526389108266 -1.8434167874478257776 -2.9853758205024303329 2.3379502887727006133;-0.019331762459281653238 -0.041614769808572600607 -2.8003431119231469992 11.563900325739766117;1.3683611919542730817 -2.0304190170802391968 3.2494501770580197508 -0.31765630333534267127;0.75764232395702979517 0.57122468212989097047 0.65778485870225522625 -4.0359636700220402616;2.3477485869725582823 -2.4428015964775808833 1.8375360035636694178 -0.5714781993685686956;-1.392573314137268703 1.6734931227409526322 -1.8181125934052415616 0.098727858053893280399;0.57430385183938215121 3.0680551531831472545 -2.575307896057529522 -0.70267290896540357537;-4.2458222482380110208 -4.00629935529188419 0.92774458239031187823 0.45490742023625524437;-3.4576678738635808763 -0.44257147280570879877 -2.8751183499677455124 -1.8373791749294274833;2.4591309132936425286 0.3823620552511685089 -2.8213951209617316174 -5.2235524951447622755;-3.2183983384255010485 4.0406877869279247406 -1.6895023531872854772 -0.66063481667005263809;3.2411460494706747504 -2.4766235478012870175 1.2007148971580583474 2.5121135987626499464;2.4073419457881737316 -2.3000608531786794764 2.1833530518729271641 1.3979364803207854351;3.757285169172885464 -2.2863937316392939358 2.0194392409129711119 0.44251055956285939574;2.6428658658973782636 -2.1639440323221528217 3.3164615495543525725 -1.470733068451605341;-1.1852073385684234186 -3.6481325207218677775 -1.1507689209467635294 -2.8539036791177880836;-2.5518825265768243504 -1.1962102707216937247 -2.7372668946443550198 1.9002406987297593144;-4.7159764976441334028 5.3621788953207305539 -0.29491976635537192619 0.39104456876099047413;1.5745379398480876532 -1.0857748603981667301 1.4550018681256466913 2.3329113111602493014;2.7079856299451394719 -0.97584229025059132656 -1.6979183767355889856 1.2501074358585670954;3.9954373455040581575 1.6246397271561989761 1.9583020658435101868 0.58992228316313444214;-0.56076120082437719283 -0.01689791927440889574 2.470741183954728637 -3.9239910250800233982];

% Layer 2
b2 = -0.061745632029582296629;
LW2_1 = [0.25987468208646724577 -0.19511057466604070365 0.9110357429774432747 -0.30329164312561129879 0.82687004158611998594 -1.9168176579982170171 1.1376771838096200185 0.1663923569072912334 0.13193712997504591922 4.2654699719473434527 -1.8141494064098728778 -2.4764205860928552028 0.16308061738898935178 0.1713101490968853835 0.5660746817391463237 -0.2031205144157967879 0.27971542026758955402 0.98355018493448487238 0.51425590193646297799 0.85474157519161286789 -1.3468073898482522122 0.9033157218322507287 0.28895419913324499328 0.46861715677138027214 -0.33712181200294538685 0.18986760809560923602 -0.35182335351265375811 -0.38957110339801820365 0.27157793843685318347 -2.1945532597063968083 0.40434320215967833878 -0.36907582034426822393 1.109942652355784487 1.6205108591097785453 -0.83215190468681599079 -0.16842188409086453205 -0.11175278077490581607 0.32516057443766394064 -0.27530462105479652779 -1.3415194508019785413 0.562868942602178568 -0.22271564596672682734 0.60197616912455864657 1.1073383451054277238 -1.1630726860378228782 0.15465290236877771157 -0.24679664771163292714 -0.31440277282442258278 -0.18492900805489267957 -0.1639058065704899203 0.61632678707456978184 -0.47439673139256310908 -0.55648888701419252367 0.27618143850351134505 0.097913103401645579238 0.14219319300369517856 -0.18018503663606172394 -1.2827652137287519629 0.86325195374568497453 -0.4962002226335577304];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 5.88235294117647;
y1_step1.xoffset = 0;

% ===== SIMULATION ========

% Dimensions
Q = size(x1,2); % samples

% Input 1
xp1 = mapminmax_apply(x1,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
y1 = mapminmax_reverse(a2,y1_step1);
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end
