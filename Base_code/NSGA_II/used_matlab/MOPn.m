%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function z = MOPn(x)

    a = 0.8;
    
    b = 3;

    c = 9;
    
    z1 = sum(-10*exp(-0.2*sqrt(x(1:end-1).^2+x(2:end).^2)));
    
    z2 = sum(abs(x).^a+5*(sin(x)).^b);
    
    z3 = sum(abs(x).^b+5*(sin(x)).^a);

    z4 = sum(x.^c+5*(tan(x)).^b);
    
    z = [z1 z2 z3 z4]';%几个目标，就返回几个objfun

end