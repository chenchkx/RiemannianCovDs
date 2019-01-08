function outS = Jeff_Divergence_Here(current_StructuralDes,current_m1,cluster_center,center_m1)
    n = size(current_StructuralDes,1);
    t = 0.5 * trace(center_m1 * current_StructuralDes) + 0.5 * trace(cluster_center* current_m1) - n;
    outS = t;

    if  (outS < 1e-10)
        outS= 0.0;
    end
end