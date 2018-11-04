function mbi = gibbs_test()
    A = [0 1 1 1; 
         1 0 0 1; 
         1 0 0 1; 
         1 1 1 0];
     
    w = [1 2 3 4];
    [~, weight_size] = size(w);
    burnin_vector = [2^6 2^10 2^14 2^18];
    [~, bv_size] = size(burnin_vector);
    
    its_vector = [2^6 2^10 2^14 2^18];
    [~, it_size] = size(its_vector);
    
    clc
    mbi = zeros(4, 4);
    for i = 1:bv_size
        for j = 1:it_size
             m = gibbs(A, w, burnin_vector(i), its_vector(j));
             %display(m);
             mbi(i, j) = m(1, weight_size);
        end
    end
    display(mbi);
end