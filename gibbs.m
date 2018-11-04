function m = gibbs(A, w, burnin, its)
    % phi function
    function phi_f = phi(x)
        phi_f = exp(w(x));
    end
    
    % psi function
    function psi_f = psi_function(x,y)
        psi_f = x~= y;
    end

    % Get dimensions of nodes and weights
    [node_size, ~] = size(A);
    [~, weight_size] = size(w);
    
    samples = zeros(its, node_size);
    weight_vector = zeros(1, node_size);
    % Get a valid initial assignment
    flag = 0;
    while(flag == 0)
        flag = 1;
        for i = 1:node_size
            weight_vector(1, i) = w(randi([1 weight_size], 1, 1));
        end
        for i = 1:node_size
            for k = 1:i
                if A(i, k) == 1
                    if weight_vector(1, i) == weight_vector(1, k)
                        flag = 0;
                    end
                end
            end
        end
    end
    disp(weight_vector);  
    
    for it = 1 : its + burnin
        for i = 1 : node_size
            prob_vector = ones(1, weight_size); 
            for j = 1 : weight_size
                weight_vector(1, i) = w(j);
                prob_vector(1, w(j)) = 1;
                for k = 1 : node_size
                    prob_vector(1, w(j)) = prob_vector(1, w(j)) * phi(weight_vector(k));
                end
                %disp(prob_vector);
                for k1 = 1 : node_size
                    for k2 = 1: k1
                        if A(k1, k2) == 1 
                            prob_vector(1, w(j)) = prob_vector(1, w(j)) * psi_function(weight_vector(1, k1), weight_vector(1, k2));
                        end
                    end
                end
            end
            prob_vector(1,:) = prob_vector(1,:) / sum(prob_vector(1,:));
            
            r = rand(1.0);
            for j = 1 : weight_size
                r = r - prob_vector(w(j));
                if (r <= 0.0); weight_vector(1,i) = w(j); break; end
            end      
        end
        if it > burnin
            samples(it-burnin, :) = weight_vector(1, :);
        end
    end
    
    % Count probability
    m = zeros(node_size, weight_size);
    for it = 1:its
        for i = 1:node_size
            m(i, samples(it, i)) = m(i,samples(it, i)) + 1;
        end
    end
    m = m/its;
    
    disp(m);
    
    
    
end