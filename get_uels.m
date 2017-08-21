function [ uels_0ut ] = get_uels( uelgdx, uels_in)
%This function return uels from a gdx file
uels_0ut=struct('name',uels_in,'form','full');
uels_0ut=rgdx(uelgdx,uels_0ut);
uels_0ut=uels_0ut.uels{1,1};
end

