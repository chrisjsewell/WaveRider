classdef System_QWell < System
properties
    init_x = 2
    well_center = 2
    well_steep = 10
    well_steep_boundary = [0,20]
    well_height = 10
end
methods
       function init_V(obj)
           obj.V = transpose(obj.well_height*(obj.well_steep*(obj.x-obj.well_center)).^2);
       end
end
end