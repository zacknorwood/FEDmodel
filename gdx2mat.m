function [ mat ] = gdx2mat( gdxData, pname, puels )
% this function takes in gdx file, parameter name and corresponding uels
% and returns the value of the parameter in the gdx file

if (nargin==3)
    mat=struct('name',pname); %,'form','full'
    mat.uels=puels;
    mat=rgdx(gdxData,mat);
    mat=mat.val;
elseif (nargin==2)
    mat=struct('name',pname); %,'form','full'    
    mat=rgdx(gdxData,mat);
    mat=mat.val;
end
end

