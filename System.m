classdef System < handle
   properties (SetAccess = protected)
       % constants (using natural units)
       h_bar = 1
       i = sqrt(-1)
       
       % space
       x_step = 0.1
       
       % other
       D       
   end
   properties
       % time 
       t = 0
       t_step = 0.1
       t_step_bounds = [0.01,0.2]
       
       % space
       x_step_bounds = [0.01,0.2]
       x_lbound = 0
       x_ubound = 10
       x_ubound_limit = [10,100]       
       periodic = true
       
       % particle
       mass = 1
       k = 4
       psi
       init_var = 4
       %init_var_bounds = [0.1,10]
       init_x = 1
       
       % potential
       V
       
       % other
       propogate = false
   end
   methods
       % initialise the system
       function obj = System()
           obj.init_psi();
           obj.init_D();
       end
       % reset the system
       function reset(obj)
            obj.t = 0;
            obj.init_psi();
            obj.init_D();
       end
       % set x step
       function set_x_step(obj,x_step)
           obj.x_step = x_step;
           obj.reset();
       end
       % a function to intialise the wavefunction
       function init_psi(obj)
           amp = 1/sqrt(2*pi*obj.init_var);
           obj.psi = transpose(amp*exp(-(obj.x-obj.init_x).^2/2*obj.init_var + obj.i*obj.x*obj.k));
           obj.V = zeros(length(obj.psi),1);
       end
        % a function to intialise D (using crank-nicholson method)
       function init_D(obj)
           obj.D = C_N_function(obj.h_bar, obj.i, obj.mass, ...
                            obj.x_step, obj.t_step, ...
                            obj.V, obj.periodic);
       end       
       % step the time and update wave function
       function step_time(obj)
           if obj.propogate
                obj.t = obj.t + obj.t_step;
                obj.psi = obj.D*obj.psi;
           end
       end
      % a function to return the values for x,
       function x = x(obj)
           x = obj.x_lbound:obj.x_step:obj.x_ubound;
       end
       % a function to return the values for the real part of phi,
       function real_phi = real_phi(obj)
           real_phi = real(obj.psi);
       end
       % a function to return the values for the imaginary part of phi,
       function img_phi = img_phi(obj)
           img_phi = imag(obj.psi);
       end
       % a function to return the values for the probability density,
       function pd = pd(obj)
           pd = abs(obj.psi).^2;
       end
   end
   
end
 