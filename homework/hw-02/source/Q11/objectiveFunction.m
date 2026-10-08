function J = objectiveFunction(K)
   
    Kp = K(1);
    Ki = K(2);
    Kd = K(3);
    Tf = 0.05; 

 
    s = tf('s');
    G = 2 / ((5*s + 1)*(2*s + 1));
    G.InputDelay = 0.2; 

    C = pid(Kp, Ki, Kd, Tf);

  

    CL_Y = feedback(C * G, 1); 
    

    CL_U = feedback(C, G); 

   
  t = (0:0.1:50)';

    [y, ~] = step(CL_Y, t);
    [u, ~] = step(CL_U, t);

  
    error = 1 - y;
    ITAE = trapz(t, t .* abs(error));
    J = ITAE;

    
    penalty_weight = 10000;


    OS = max(0, max(y) - 1) * 100;
    if OS > 5
        J = J + penalty_weight * (OS - 5);
    end

   
    ess = abs(1 - y(end));
    if ess > 0.01
        J = J + penalty_weight * ess;
    end

   
    max_u = max(abs(u));
    if max_u > 5
        J = J + penalty_weight * (max_u - 5);
    end
    
  
    if any(isnan(y)) || any(isinf(y)) || y(end) > 2
        J = 1e6; 
    end
end
