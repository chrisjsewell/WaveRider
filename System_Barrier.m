classdef System_Barrier < System
properties
    barrier_width = 0.5
    barrier_V = 10
end
methods
       function init_V(obj)
           V = zeros(length(obj.x),1);
           %calculate number of array points to change           
           num = fix(obj.barrier_width/obj.x_step);
           midpoint = fix(length(obj.x)/2);
           for i=[midpoint:midpoint+num]
               V(i) = obj.barrier_V;
           end
           obj.V = V;
       end
end
end