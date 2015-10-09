function run()
%% Intialise System
[potential,v] = listdlg('PromptString','Select a Potential type:',...
                'SelectionMode','single',...
                'ListString',['None             ';'Potential Barrier';'Quantum Well     ']);
switch potential
    case 1
        sys = System();
    case 2
        sys = System_Barrier();
    case 3
        sys = System_QWell();
    otherwise
        warning('Unexpected potential type.')
end

%% Open and Setup GUI 
fig=figure;
bgcolor = fig.Color;

% Create Axes (positioning [l b w h])
wave_ax = axes('Parent',fig,'position',[0.1 0.6 0.55 0.35]);
pd_ax = axes('Parent',fig,'position',[0.1 0.15 0.55 0.35]);
V_ax = axes('Parent',fig,'position',[0.1 0.15 0.55 0.35],...
    'YAxisLocation','right','XAxisLocation','top','XColor','none','Color','none');

% Create Controls
top = 400;
left = 420;
% Initial Conditions
uicontrol('Parent',fig,'Style','text','Position',[left-20 top-20 120 20],...
           'String','Initial Conditions','BackgroundColor',bgcolor, 'FontWeight','bold','FontSize',12)
% an editable text field to enter the intial gaussian wavefunction variance
uicontrol('Parent',fig,'Style','text','Position',[left top-50 50 20],...
                'String','Wave Var:','BackgroundColor',bgcolor)
uicontrol('Parent',fig,'Style','edit',...
    'String',num2str(sys.init_var),'position',[left+60 top-50 40 20],...
    'Callback',{@change_variance,sys});
% an editable text field to enter the intial gaussian wavefunctions
% momentum wave number k
uicontrol('Parent',fig,'Style','text','Position',[left top-75 50 20],...
                'String','Wave k:','BackgroundColor',bgcolor)
uicontrol('Parent',fig,'Style','edit',...
    'String',num2str(sys.init_k),'position',[left+60 top-75 40 20],...
    'Callback',{@change_k,sys});

% Simulation Conditions
uicontrol('Parent',fig,'Style','text','Position',[left-20 top-105 140 20],...
           'String','Simulation Conditions','BackgroundColor',bgcolor, 'FontWeight','bold','FontSize',12)       
% a slider to control the x step
labelx = slider_labels(fig,sys.x_step_bounds(1),sys.x_step_bounds(2),...
    sprintf('X Step = %2.2f',sys.x_step),left+10,top-160,100,50,bgcolor);
uicontrol('Parent',fig,'Style','slider',...
    'position',[left+10 top-160 100 50],...
    'value',sys.x_step, 'min',sys.x_step_bounds(1), 'max',sys.x_step_bounds(2),...
    'Callback',{@change_x_step,sys,labelx});
% a slider to control the x upper bound
labelu = slider_labels(fig,sys.x_ubound_limit(1),sys.x_ubound_limit(2),...
    sprintf('Upper X = %2.2f',sys.x_ubound),left+10,top-200,100,50,bgcolor);
uicontrol('Parent',fig,'Style','slider',...
    'position',[left+10 top-200 100 50],...
    'value',sys.x_ubound, 'min',sys.x_ubound_limit(1), 'max',sys.x_ubound_limit(2),...
    'Callback',{@change_x_ubound,sys,labelu});
% a check box to toggle between fixed and periodic boundary conditions
uicontrol('Parent',fig,'Style','text','Position',[left-5 top-245 95 50],...
           'String','Periodic Boundary?','BackgroundColor',bgcolor)       
uicontrol('Parent',fig,'Style','checkbox',...
    'position',[left+90 top-210 100 20],...
    'value',sys.periodic,'Callback',{@change_periodic,sys}); 
% a slider to select barrier width
if potential==2
    labelp = slider_labels(fig,0.01,sys.x_ubound/4,...
        sprintf('Barrier Width = %2.2f',sys.barrier_width),left+10,top-275,100,50,bgcolor);
    uicontrol('Parent',fig,'Style','slider',...
        'position',[left+10 top-275 100 50],...
        'value',sys.barrier_width, 'min',0.01, 'max',sys.x_ubound/4,...
        'Callback',{@change_barrier_width,sys,labelp});
end
% a slider to select well steepness
if potential==3
    labels = slider_labels(fig,sys.well_steep_boundary(1),sys.well_steep_boundary(2),...
        sprintf('Well Shape = %2.2f',sys.well_steep),left+10,top-275,100,50,bgcolor);
    uicontrol('Parent',fig,'Style','slider',...
        'position',[left+10 top-275 100 50],...
        'value',sys.well_steep, 'min',sys.well_steep_boundary(1), 'max',sys.well_steep_boundary(2),...
        'Callback',{@change_well_steep,sys,labels});
end

% a button to turn on/off the propogation of the wavefunction
uicontrol('Parent',fig,'Style','togglebutton','ForegroundColor','b',...
    'String','Propogate Sim','position',[left+10 top-320 100 50],...
    'Callback',{@toggle_propogate,sys});
% reset function wavefunction
uicontrol('Parent',fig,'Style','pushbutton','ForegroundColor','r',...
    'String','Reset Sim','position',[left+10 top-370 100 50],...
    'Callback',{@reset_system,sys});

% a text box to show simulation data
data_label1 = uicontrol('Parent',fig,'Style','text','Position',[35 20 220 20],...
           'String','','BackgroundColor',bgcolor,'HorizontalAlignment','left',...
           'FontWeight','bold');
data_label2 = uicontrol('Parent',fig,'Style','text','Position',[118 10 200 20],...
           'String','','BackgroundColor',bgcolor,'HorizontalAlignment','left',...
           'FontWeight','bold');
       
%% Run Simulation
while ishandle(fig)

    %propogate system
    sys.step_time();

    % update plots
    plot(wave_ax,sys.x,sys.real_phi,sys.x,sys.img_phi)
    ylabel(wave_ax,'Wavefunction, \Phi');    
    legend(wave_ax,'Real','Imaginary');
    
    stairs(V_ax,sys.x,sys.V,'--r');
    V_ax.YAxisLocation = 'right';
    V_ax.Color = 'none';
    V_ax.XColor = 'none';
    ylabel(V_ax,'Potential, V');
    legend(V_ax,'Potential');
    plot(pd_ax,sys.x,sys.pd);
    ylabel(pd_ax,'Probability Density, |\Phi|^2');

    wave_ax.XLim = [sys.x_lbound,sys.x_ubound];
    pd_ax.XLim = [sys.x_lbound,sys.x_ubound];
    wave_ax.YLim = [0,0.3];
    pd_ax.YLim = [0,0.2];
    
    data_label1.String = ['Simulation Data: t = ',num2str(sys.t)];
    data_label2.String = ['Total PD = ',num2str(sys.sum_pd())];
    
    % wait for some time
    pause(0.01);
end
end

% a function to add labels to slider
function label = slider_labels(parent,min,max,name,l,b,w,h,bgcolor)
	uicontrol('Parent',parent,'Style','text','Position',[l-30 b 30 50],...
                'String',min,'BackgroundColor',bgcolor);
	uicontrol('Parent',parent,'Style','text','Position',[l+w,b,30,50],...
                'String',max,'BackgroundColor',bgcolor);
	label = uicontrol('Parent',parent,'Style','text','Position',[l,b-20,w,50],...
                'String',name,'BackgroundColor',bgcolor);
end

%% Callback functions
% a function to turn on/off the propogation of the wavefunction
function toggle_propogate(hObject,callbackdata,sys)
   sys.propogate = hObject.Value;
end
%function to reset system
function reset_system(hObject,callbackdata,sys)
   sys.reset();
end
% a function to change the gaussian variance
function change_variance(hObject,callbackdata,sys)
  val = str2double(hObject.String);
  sys.init_var = val;
  sys.reset();
end
% a function to change the gaussian wave number k
function change_k(hObject,callbackdata,sys)
  val = str2double(hObject.String);
  sys.init_k = val;
  sys.reset();
end

% a function to change the x upper bound
function change_x_ubound(hObject,callbackdata,sys,label)
   sys.x_ubound = hObject.Value;
   sys.reset();
   label.String = sprintf('Upper X = %2.2f',sys.x_ubound);
end
% a function to change the x step
function change_x_step(hObject,callbackdata,sys,label)
   sys.set_x_step(hObject.Value);
   label.String = sprintf('X Step = %2.2f',sys.x_step);
end
% a function to change boundary condition
function change_periodic(hObject,callbackdata,sys,label)
   sys.periodic = hObject.Value;
end
% a function to change the barrier width
function change_barrier_width(hObject,callbackdata,sys,label)
   sys.barrier_width = hObject.Value;
   sys.reset()
   label.String = sprintf('Barrier Width = %2.2f',sys.barrier_width);
end
% a function to change the well steepness
function change_well_steep(hObject,callbackdata,sys,label)
   sys.well_steep = hObject.Value;
   sys.reset()
   label.String = sprintf('Well Shape = %2.2f',sys.well_steep);
end





