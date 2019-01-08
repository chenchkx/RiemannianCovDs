function featureVector = ZF_GaborFilter(img,u,v,m,n)

% GABORFILTERBANK generates a custum Gabor filter bank.
% It creates a u by v array, whose elements are m by n matries;
% each matrix being a 2-D Gabor filter.
%
%
% Inputs:
%       u	:	No. of scales (usually set to 5)
%       v	:	No. of orientations (usually set to 8)
%       m	:	No. of rows in a 2-D Gabor filter (an odd integer number usually set to 39)
%       n	:	No. of columns in a 2-D Gabor filter (an odd integer number usually set to 39)
%
% Output:
%       gaborArray: A u by v array, element of which are m by n
%                   matries; each matrix being a 2-D Gabor filter
%
%
% Sample use:
% gaborArray = gaborFilterBank(5,8,39,39);
%
%
% (C)	Mohammad Haghighat, University of Miami
%       haghighat@ieee.org



% Create Gabor filters

% Create u*v gabor filters each being an m*n matrix

gaborArray = cell(u,v);
fmax = 0.25;
gama = sqrt(2);
eta = sqrt(2);

for i = 1:u
    
    fu = fmax/((sqrt(2))^(i-1));
    alpha = fu/gama;
    beta = fu/eta;
    
    for j = 1:v
        tetav = ((j-1)/8)*pi;
        gFilter = zeros(m,n);
        
        for x = 1:m
            for y = 1:n
                xprime = (x-((m+1)/2))*cos(tetav)+(y-((n+1)/2))*sin(tetav);
                yprime = -(x-((m+1)/2))*sin(tetav)+(y-((n+1)/2))*cos(tetav);
                gFilter(x,y) = (fu^2/(pi*gama*eta))*exp(-((alpha^2)*(xprime^2)+(beta^2)*(yprime^2)))*exp(1i*2*pi*fu*xprime);
            end
        end
        gaborArray{i,j} = gFilter;
        
    end
end

gaborResult = cell(u,v);
for i = 1:u
    for j = 1:v
        gaborResult{i,j} = conv2(img,gaborArray{i,j},'same');
        % J{u,v} = filter2(G{u,v},I);
    end
end
[n1,m1] = size(img);
featureVector = zeros(n1,m1,u*v);
c = 0;
for i = 1:u
    for j = 1:v
        
        c = c+1;
        gaborAbs = abs(gaborResult{i,j});
        %gaborAbs = downsample(gaborAbs,d1);
        %gaborAbs = downsample(gaborAbs.',d2);
        %         gaborAbs = reshape(gaborAbs.',[],1);
        
        % Normalized to zero mean and unit variance. (if not applicable, please comment this line)
        %         gaborAbs = (gaborAbs-mean(gaborAbs))/std(gaborAbs,1);
        
        featureVector(:,:,c) = gaborAbs;
        
    end
end


% % Show Gabor filters
% 
% % Show magnitudes of Gabor filters:
% figure('NumberTitle','Off','Name','Magnitudes of Gabor filters');
% for i = 1:u
%     for j = 1:v
%         subplot(u,v,(i-1)*v+j);
%         imshow(abs(gaborArray{i,j}),[]);
%     end
% end
% 
% % Show real parts of Gabor filters:
% figure('NumberTitle','Off','Name','Real parts of Gabor filters');
% for i = 1:u
%     for j = 1:v
%         subplot(u,v,(i-1)*v+j);
%         imshow(real(gaborArray{i,j}),[]);
%     end
% end
