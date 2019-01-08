
function outStein = Compute_Stein_Metric(Set1,Set2)


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
outStein = zeros(l2,l1);

if (simFlag)
    for tmpC1 = 1:l1
        X = Set1_Cell{1,tmpC1};
        for tmpC2 = tmpC1+1:l2
            Y = Set2_Cell{1,tmpC2};
%             outStein(tmpC2,tmpC1) = log(prod(eigs(0.5*(X+Y)))) -  0.5*(log(prod(eigs(X*Y))));
            
            outStein(tmpC2,tmpC1) = log(det(0.5*(X+Y))) -  0.5*(log(det(X*Y)));
            if  (outStein(tmpC2,tmpC1) < 1e-10)
                outStein(tmpC2,tmpC1) = 0.0;
            end
            outStein(tmpC1,tmpC2) = outStein(tmpC2,tmpC1);
        end
    end
    
else
    for tmpC1 = 1:l1
        X = Set1_Cell{1,tmpC1};
        for tmpC2 = 1:l2
            Y = Set2_Cell{1,tmpC2};
%             outStein(tmpC2,tmpC1) = log(prod(eigs(0.5*(X+Y)))) -  0.5*(log(prod(eigs(X*Y))));
            
            outStein(tmpC2,tmpC1) = log(det(0.5*(X+Y))) -  0.5*(log(det(X*Y)));
            if  (outStein(tmpC2,tmpC1) < 1e-10)
                outStein(tmpC2,tmpC1) = 0.0;
            end
        end
    end
end

end
