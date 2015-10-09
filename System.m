classdef System < handle
   properties (SetAccess = protected)
       % constants (using natural units)
       h_bar = 1
       i = sqrt(-1)
       
       % space
       x_step_bounds = [0.01,0.2]
       x_step = 0.1

       % time 
       t = 0
       t_step
       
       % particle
       psi
       D       
       
       % potential
       V
   end
   properties
       
       % space
       x_lbound = 0
       x_ubound = 5
       x_ubound_limit = [1,10]       
       periodic = true
       
       % particle
       mass = 1
       init_k = 4
       init_var = 4
       %init_var_bounds = [0.1,10]
       init_x = 2
              
       % other
       propogate = false
   end
   methods
       % initialise the system
       function obj = System()
           obj.set_x_step(obj.x_step);
           obj.init_psi();
           obj.init_V();
           obj.init_D();
       end
       % reset the system
       function reset(obj)
            obj.t = 0;
            obj.init_psi();
            obj.init_V();
            obj.init_D();
       end
       % set x step
       function set_x_step(obj,x_step)
           obj.x_step = x_step;
           obj.t_step = 0.25*x_step^2;
           obj.reset();
       end
       % a function to intialise the wavefunction
       function init_psi(obj)
           amp = 1/sqrt(2*pi*obj.init_var);
           psi = amp*exp(-(obj.x-obj.init_x).^2/2*obj.init_var + obj.i*obj.x*obj.init_k);
           psi = psi/sqrt(psi*psi');
           obj.psi = transpose(psi);
       end
       % a function to initialise the potential
       function init_V(obj)
           obj.V = zeros(length(obj.x),1);
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
       % a function to return the sum of the probability density,
       function sum_pd = sum_pd(obj)
           sum_pd = sum(obj.pd());
       end
   end
   
end
 