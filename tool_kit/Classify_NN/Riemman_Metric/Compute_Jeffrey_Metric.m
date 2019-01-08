function outJeffrey = Compute_Jeffrey_Metric(Set1,Set2)


simFlag = false;
if (nargin < 2)
    Set2 = Set1;
    simFlag = true;
end

if (iscell(Set1) && iscell(Set2)) == 0
    l1 = size(Set1,3);
    l2 = size(Set2,3);
    for ii = 1:l1
        Set1_Cell{1,ii} = Set1(:,:,ii);
    end
    for ii = 1:l2
        Set2_Cell{1,ii} = Set2(:,:,ii);
    end 
else
    Set1_Cell = Set1;
    Set2_Cell = Set2;
end

l1 = length(Set1_Cell);
l2 = length(Set2_Cell);

for ii = 1:l1
    Inv_Set1_Cell{1,ii} = inv(Set1_Cell{1,ii});
end
for ii = 1:l2
    Inv_Set2_Cell{1,ii} = inv(Set2_Cell{1,ii});
end
[~ ,d] = size(Inv_Set1_Cell{1,1});

outJeffrey = zeros(l2,l1);



if (simFlag)
    for tmpC1 = 1:l1
        X = Set1_Cell{1,tmpC1};
        Inv_X = Inv_Set1_Cell{1,tmpC1};
        for tmpC2 = tmpC1+1:l2
            Y = Set2_Cell{1,tmpC2};
            Inv_Y = Inv_Set2_Cell{1,tmpC2};
            outJeffrey(tmpC2,tmpC1) = 0.5*trace(Inv_X*Y)+0.5*trace(Inv_Y*X) - d;
            if  (outJeffrey(tmpC2,tmpC1) < 1e-10)
                outJeffrey(tmpC2,tmpC1) = 0.0;
            end
            outJeffrey(tmpC1,tmpC2) = outJeffrey(tmpC2,tmpC1);
        end
    end
    
else
    for tmpC1 = 1:l1
        X = Set1_Cell{1,tmpC1};
        Inv_X = Inv_Set1_Cell{1,tmpC1};
        for tmpC2 = 1:l2
            Y = Set2_Cell{1,tmpC2};
            Inv_Y = Inv_Set2_Cell{1,tmpC2};
            outJeffrey(tmpC2,tmpC1) = 0.5*trace(Inv_X*Y)+0.5*trace(Inv_Y*X) - d;
            if  (outJeffrey(tmpC2,tmpC1) < 1e-10)
                outJeffrey(tmpC2,tmpC1) = 0.0;
            end
        end
    end
end


end