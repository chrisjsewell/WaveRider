classdef System < handle
   properties
       t = 0
       t_step = 1
       t_step_bounds = [0.1,10]
       
       x_lbound = 0
       x_ubound = 10
       x_ubound_limit = [1,10]
       x_step = 1
       x_step_bounds = [0.1,1]
       
       propogate = false
   end
   methods
       %initialiser
       function obj = System()
       end
       % a function to return the values for x,
       function x = x(obj)
           x = obj.x_lbound:obj.x_step:obj.x_ubound;
       end
       % a function to return the values for the real part of phi,
       function real_phi = real_phi(obj)
           real_phi = sin(obj.x - obj.t);
       end
       % a function to return the values for the imaginary part of phi,
       function img_phi = img_phi(obj)
           img_phi = cos(obj.x - obj.t);
       end
       % a function to return the values for the probability density,
       function pd = pd(obj)
           pd = sin(obj.x - obj.t).^2;
       end
       % step the time
       function step_time(obj)
           if obj.propogate
            obj.t = obj.t + obj.t_step;
           end
       end
   end
   
end
 