i=1;
d=1;
for year=2016:2017
for month=1:1:12
x=calendar(year,month);
for l=1:1:6
    for m=1:1:7
        if x(l,m)> 0
            for h=1:1:24
           HoD(i,1)=i;
           HoD(i,2)=d;           
           i=i+1;
            end
           d=d+1;
        end
    end
end
end
end

HoD(:,3)=1;

    HoD_struct.name='HoD';
    HoD_struct.form='sparse';
    HoD_struct.dim=2;
    HoD_struct.type = 'parameter';
    HoD_struct.val = HoD;
    HoD_struct.ts = 'Hour of day';
%%
i=1;
d=1;
for year=2016:2017
for month=1:1:12
x=calendar(year,month);
for l=1:1:6
    for w=1:1:7
        if x(l,w)> 0
            for h=1:1:24
                HoM(i,1)=i;
                HoM(i,2)=month;
                i=i+1;
            end
           d=d+1;
        end
    end
end
end
end

HoM(:,3)=1;

    HoM_struct.name='HoM';
    HoM_struct.form='sparse';
    HoM_struct.dim=2;
    HoM_struct.type = 'parameter';
    HoM_struct.val = HoM;
    HoM_struct.ts = 'Hour of month';

wgdx('date_vector.gdx', HoM_struct, HoD_struct)
%%