clc;
close all;
%% Convert the data into daily mean

data0=cooling_demand_2016;
rs=24;
len=length(data0)/rs;
[x, y]=size(data0);
data=zeros(len,y);
temp=reshape(data0,rs,[]);
for i=1:y
    temp2=mean(temp(:,((i-1)*len+1):i*len),1);
    data(:,i)=temp2';
end
%% Here, results are ploted and saved when needed

clc;
close all;
% intialize plot properties
properties=finit_plot_properties;   %initialise plot properties
properties.legendFontsize = 1;
properties.labelFontsize = 1;
properties.axelFontsize = 20;
Font_Size=properties.axelFontsize;
lgnd_size=1;
LineWidth=1;

LineThickness=2;

figure('Units','centimeters','PaperUnits','centimeters',...
       'PaperPosition',properties.PaperPosition,'Position',properties.Position,...
       'PaperSize',properties.PaperSize)

ydata=FED_PE/1000;
ydata2=FED_PE_gams/1000;
duration= 0 : 100/(length(ydata)-1) : 100;
time=(1:length(ydata))/(24*30);
xdata=time;
%plot(duration,sort(ydata,'descend'),'LineWidth',LineThickness);
plot(duration(1:8760),sort(ydata(1:8760),'descend'),'-.r',...
     duration(1:8760),sort(ydata2(1:8760),'descend'),'g','LineWidth',LineThickness);
%plot(time,ydata,'LineWidth',LineThickness);
%area(time,ydata);
xlabel('Duration [%]','FontSize',Font_Size,'FontName','Times New Roman')
ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
%ylabel('CO2eq [kg]','FontSize',Font_Size,'FontName','Times New Roman')
%set(gca,'XTickLabel',{'','Winter', 'Spring', 'Summer', 'Fall'},'FontName','Times New Roman','FontSize',Font_Size)
%legend('xL=100km','xL=200km','xL=300km','xL=400km','xL=500km');
%h=legend('$$\overline{D}$$=3250MW','$$\overline{D}$$=6500MW','$$\overline{D}$$=9750MW','$$\overline{D}$$=13000MW','$$\overline{D}$$=16250MW','$$\overline{D}$$=19500MW');
%set(h,'Interpreter','latex')
%legend('Cap=300MW','Cap=600MW','Cap=900MW','Cap=1200MW','Cap=1500MW');
%h=legend('$$\overline{D}$$=33GW','$$\overline{D}$$=25GW','$$\overline{D}$$=16GW');
%set(h,'Interpreter','latex')
%legend('\Delta\theta=0%','\Delta\theta=25%','\Delta\theta=50%');
%legend('\theta=0.0052','\theta=0.0032','\theta=0.0012')

set(gca,'FontName','Times New Roman','FontSize',Font_Size)
box off
xlim([0 100])
legend('Base case','Improved case')
%legend('ANG HP1 ','ANG HP2','ANG HP3','SÄV HP1 + RK1','SÄV HP2',...
%        'SÄV HP3 (H1) + RK2','ROS HP2','ROS HP3','ROS HP4','ROS HP5',...
%        'ROS LK1 + del i RK1', 'ROS LK2 + del i RK1', 'RYA HP6',...
%        'RYA HP7', 'RYA VP','RYA KVV','TYN HVC','HÖG KVV NM1-3','Spillvärme' )
%ylim([0 3])
%DTyp=['NO'; 'SE'; 'DK'; 'FI'; 'EE'; 'LV'; 'LT'];
%NPVComp={'C1'; 'C2'; 'C3'; 'C4'; 'C5'};
%% save plot
return
folder_name='D:\PhD project\PhD\Report\Thesis\figures\phd_ch05\';
plot_fname=['ME_C2_gen_cor1_D1eqD2'];
fsave_figure(folder_name,plot_fname);

