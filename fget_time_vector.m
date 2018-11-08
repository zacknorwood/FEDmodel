function [HoS, MoS] = fget_time_vector( start_y, stop_y)

%% Hour of the simulation 
i=1;
for y=start_y:stop_y
for m=1:1:12
    d=1;
    x=calendar(y,m);
    for l=1:1:6
        for w=1:1:7
            if x(l,w)> 0
                for h=1:1:24
                    HoS(y,m,d,h)=i;
                    MoS(i)=m;
                    i=i+1;
                end
                d=d+1;
            end
        end
    end
end
end
end

