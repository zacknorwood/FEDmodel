function [ data ] = fstore_results(h_sim,B_ID)
%Function that prepares simulation results for storage

%Simulation results
gdxData='GtoM';

%Extract electricity, heat and cooling demand in the FED system
data.el_demand=gdx2mat(gdxData,'el_demand',{h_sim.uels,B_ID.uels});
data.h_demand=gdx2mat(gdxData,'h_demand',{h_sim.uels,B_ID.uels});
data.c_demand=gdx2mat(gdxData,'c_demand',{h_sim.uels,B_ID.uels});


end

