function [ output_args ] = fsave_figure(folder_name,fig_name)
%function that saves the current figure into the desired location 
%print('-depsc2','-r300',[folder_name fig_name '.eps'])           %save as .eps
saveas(gcf,[folder_name fig_name '.fig'])                        %save as .fig
print('-dpdf','-r300','-painters',[folder_name fig_name '.pdf']) %save as .pdf
print('-dmeta','-painters',[folder_name fig_name '.emf'])        %save as .emf
saveas(gcf,[folder_name fig_name '.png'])        %save as .png
end

