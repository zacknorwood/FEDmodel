function [ mat ] = gdx2mat( gdxData, pname, puels )
% this function takes in gdx file, parameter name and corresponding uels
% and returns the value of the parameter in the gdx file

mat=struct('name',pname,'form','full');
mat.uels=puels;
mat=rgdx(gdxData,mat);
mat=mat.val;
end

