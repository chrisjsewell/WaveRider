classdef System < handle
   properties
       % using natural units
       h_bar = 1
       i = sqrt(-1)
       
       t = 0
       t_step = 1
       t_step_bounds = [0.1,10]
       
       x_lbound = 0
       x_ubound = 10
       x_ubound_limit = [1,10]
       x_step = 1
       x_step_bounds = [0.1,1]
       
       init_var = 1
       %init_var_bounds = [0.1,10]
       init_x = 0
       
       mass = 1
       
       propogate = false
   end
   methods
       %initialiser
       function obj = System()
       end
       %reset system
       function reset(obj)
            obj.t = 0;
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
           amp = 1/sqrt(2*pi*obj.init_var);
           pd = amp*exp(-(obj.x - obj.t/10).^2/2*obj.init_var);
       end
       % step the time
       function step_time(obj)
           if obj.propogate
            obj.t = obj.t + obj.t_step;
           end
       end
   end
   
end
 