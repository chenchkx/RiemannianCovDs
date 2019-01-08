% Author:
% - Mehrtash Harandi (mehrtash.harandi at gmail dot com)
%
% This file is provided without any warranty of
% fitness for any purpose. You can redistribute
% this file and/or modify it under the terms of
% the GNU General Public License (GPL) as published
% by the Free Software Foundation, either version 3
% of the License or (at your option) any later version.

%Affine Invariant Riemmannian Metric (AIRM)
function outAIRM = Compute_AIRM_Metric(Set1,Set2)

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
outAIRM = zeros(l2,l1);

if (simFlag)
    for tmpC1 = 1:l1
        for tmpC2 = tmpC1+1:l2
            tmpEig = eig(Set1_Cell{1,tmpC1},Set2_Cell{1,tmpC2});
            outAIRM(tmpC2,tmpC1) = sum(log(tmpEig).^2);
            if  (outAIRM(tmpC2,tmpC1) < 1e-10)
                outAIRM(tmpC2,tmpC1) = 0.0;
            end
            outAIRM(tmpC1,tmpC2) = outAIRM(tmpC2,tmpC1);
        end
    end
    
else
    for tmpC1 = 1:l1
        for tmpC2 = 1:l2
            tmpEig = eig(Set1_Cell{1,tmpC1},Set2_Cell{1,tmpC2});
            outAIRM(tmpC2,tmpC1) = sum(log(tmpEig).^2);
            if  (outAIRM(tmpC2,tmpC1) < 1e-10)
                outAIRM(tmpC2,tmpC1) = 0.0;
            end
        end
    end
end

end



