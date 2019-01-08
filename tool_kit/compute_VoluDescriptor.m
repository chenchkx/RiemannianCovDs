%% function for mean vectors and covariance matrices of Volumes
% Author: Kai-Xuan Chen
% Date: 2018.12.14

function descriptor_Cell = compute_VoluDescriptor(option,image_Volume,block_Location_Matrix,net)
dim_Fea = 0;
fea_Cell = cell(1,length(block_Location_Matrix));
for img_th = 1:length(image_Volume)
    sample = image_Volume{1,img_th};
    for sca_th = 1:length(option.scales); 
        image_Sample = imresize(sample, option.scales(sca_th));    
        switch option.type_F
            case 'VGG'
                if size(sample,3) == 1 
                    image_Sample = repmat(image_Sample,1,1,3);
                end
                image_Sample = single(image_Sample);
                im_mean = imresize(net.meta.normalization.averageImage, [size(image_Sample,1) size(image_Sample,2)]) ;
                image_Sample = image_Sample - im_mean;
                res = vl_simplenn(net, image_Sample);
                temp_Fea = res(option.num_Layers).x;
                for region_th = 1:length(block_Location_Matrix)
                    x_end = floor((block_Location_Matrix(1,region_th) + option.block_Row - 1)*option.scales(sca_th));
                    y_end = floor((block_Location_Matrix(2,region_th) + option.block_Col - 1)*option.scales(sca_th));
                    x_beg = ceil(x_end - option.block_Row*option.scales(sca_th) + 1);
                    y_beg = ceil(y_end - option.block_Col*option.scales(sca_th) + 1);
                    region_Fea = temp_Fea(x_beg:x_end,y_beg:y_end,:);                
                    region_Fea = reshape(region_Fea,[size(region_Fea,1)*size(region_Fea,2) size(region_Fea,3)]);
                    fea_Cell{1,region_th} = [fea_Cell{1,region_th};region_Fea];   
                    if dim_Fea~=size(region_Fea,2)
                        dim_Fea = size(region_Fea,2);
                    end
                    clear('region_Fea');                
                end

            case 'Sift'
                dsiftOpts = {'norm', 'fast', 'floatdescriptors', ...
                 'step', 3, 'size', 4, 'geometry', [4 4 8]} ;
                if size(image_Sample,3)>1, image_Sample = rgb2gray(image_Sample) ; end
                image_Sample = im2single(image_Sample) ;
                image_Sample = vl_imsmooth(image_Sample, 0) ;
                [locat_Matrix, descrs_Matrix] = vl_dsift(image_Sample, dsiftOpts{:}) ;  
                descrs_Matrix = sqrt(descrs_Matrix);
                for region_th = 1:length(block_Location_Matrix)
                    x_end = floor((block_Location_Matrix(1,region_th) + option.block_Row - 1)*option.scales(sca_th));
                    y_end = floor((block_Location_Matrix(2,region_th) + option.block_Col - 1)*option.scales(sca_th));
                    x_beg = ceil(x_end - option.block_Row*option.scales(sca_th) + 1);
                    y_beg = ceil(y_end - option.block_Col*option.scales(sca_th) + 1);
                    x_Ind = find(locat_Matrix(1,:)>=x_beg & locat_Matrix(1,:)<=x_end);
                    y_Ind = find(locat_Matrix(2,:)>=y_beg & locat_Matrix(2,:)<=y_end);
                    xy_Ind = intersect(x_Ind,y_Ind);
                    region_Fea = descrs_Matrix(:,xy_Ind)';
                    fea_Cell{1,region_th} = [fea_Cell{1,region_th};region_Fea]; 
                    if dim_Fea~=size(region_Fea,2)
                        dim_Fea = size(region_Fea,2);
                    end            
                    clear('region_Fea');                
                end 

            case 'Local'
                temp_Fea = compute_LocalFea(option,image_Sample);
                for region_th = 1:length(block_Location_Matrix)
                    x_end = floor((block_Location_Matrix(1,region_th) + option.block_Row - 1)*option.scales(sca_th));
                    y_end = floor((block_Location_Matrix(2,region_th) + option.block_Col - 1)*option.scales(sca_th));
                    x_beg = ceil(x_end - option.block_Row*option.scales(sca_th) + 1);
                    y_beg = ceil(y_end - option.block_Col*option.scales(sca_th) + 1);
                    region_Fea = temp_Fea(x_beg:x_end,y_beg:y_end,:);                
                    region_Fea = reshape(region_Fea,[size(region_Fea,1)*size(region_Fea,2) size(region_Fea,3)]);
                    fea_Cell{1,region_th} = [fea_Cell{1,region_th};region_Fea];   
                    if dim_Fea~=size(region_Fea,2)
                        dim_Fea = size(region_Fea,2);
                    end
                    clear('region_Fea');                
                end            
        end

    end
    
end
for region_th = 1:length(block_Location_Matrix)
    current_Fea = fea_Cell{1,region_th};
    if isempty(current_Fea)
        region_Mean = zeros(1,dim_Fea)';
        region_Cov = eye(dim_Fea);
    else
        region_Mean = mean(current_Fea)';
        region_Cov = cov(current_Fea); 
    end  
    descriptor_Cell.mean{1,region_th} = region_Mean;  % feature mean
    descriptor_Cell.cov{1,region_th} = region_Cov;  % feature covariance
end
clear('fea_Cell');

end