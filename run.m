function run()
%% Intialise System
sys=System();

%% Open and Setup GUI 
fig=figure;
bgcolor = fig.Color;

% Create Axes (positioning [l b w h])
wave_ax = axes('Parent',fig,'position',[0.1 0.6 0.6 0.35]);
pd_ax = axes('Parent',fig,'position',[0.1 0.15 0.6 0.35]);

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
% a slider to control the x step
label = slider_labels(fig,sys.x_step_bounds(1),sys.x_step_bounds(2),...
    sprintf('X Step = %2.2f',sys.x_step),left+10,top-140,100,50,bgcolor);
uicontrol('Parent',fig,'Style','slider',...
    'position',[left+10 top-140 100 50],...
    'value',sys.x_step, 'min',sys.x_step_bounds(1), 'max',sys.x_step_bounds(2),...
    'Callback',{@change_x_step,sys,label});

% Simulation Conditions
uicontrol('Parent',fig,'Style','text','Position',[left-20 top-160 140 20],...
           'String','Simulation Conditions','BackgroundColor',bgcolor, 'FontWeight','bold','FontSize',12)       
% a slider to control the x upper bound
label = slider_labels(fig,sys.x_ubound_limit(1),sys.x_ubound_limit(2),...
    sprintf('Upper xbound'),left+10,top-220,100,50,bgcolor);
uicontrol('Parent',fig,'Style','slider',...
    'position',[left+10 top-220 100 50],...
    'value',sys.x_ubound, 'min',sys.x_ubound_limit(1), 'max',sys.x_ubound_limit(2),...
    'Callback',{@change_x_ubound,sys,label});
% a check box to toggle between fixed and periodic boundary conditions


% a button to turn on/off the propogation of the wavefunction
uicontrol('Parent',fig,'Style','togglebutton','ForegroundColor','b',...
    'String','Propogate Sim','position',[left+10 top-300 100 50],...
    'Callback',{@toggle_propogate,sys});
% reset function wavefunction
uicontrol('Parent',fig,'Style','pushbutton','ForegroundColor','r',...
    'String','Reset Sim','position',[left+10 top-350 100 50],...
    'Callback',{@reset_system,sys});

% intialise plots            
pd_data = plot(pd_ax,sys.x,sys.pd);
ylabel(pd_ax,'Probability Density, |\Phi|^2');

%% Run Simulation
while ishandle(fig)
    %propogate system
    sys.step_time();

    % update plots
    plot(wave_ax,sys.x,sys.real_phi, sys.x,sys.img_phi)
    ylabel(wave_ax,'Wavefunction, \Phi');    
    legend(wave_ax,'Real','Imaginary')
    
    set(pd_data,'XData',sys.x,'YData',sys.pd);
    xlabel(wave_ax, num2str(sys.t));
    xlabel(pd_ax, num2str(sys.sum_pd));
    
    wave_ax.XLim = [sys.x_lbound,sys.x_ubound];
    pd_ax.XLim = [sys.x_lbound,sys.x_ubound];
    wave_ax.YLim = [0,0.2];
    pd_ax.YLim = [0,0.05];


    % wait for some time
    pause(0.1);
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

% a function to change the time step
function change_x_ubound(hObject,callbackdata,sys,label)
   sys.x_ubound = hObject.Value;
   sys.reset();
end
% a function to change the x step
function change_x_step(hObject,callbackdata,sys,label)
   sys.set_x_step(hObject.Value);
   label.String = sprintf('X Step = %2.2f',sys.x_step);
end


