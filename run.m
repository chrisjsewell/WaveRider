function run()
% intialise system with t_step, x_ubound, x_step
sys=System();

%open and setup figure [l b w h]
fig=figure;
bgcolor = fig.Color;

wave_ax = axes('Parent',fig,'position',[0.1 0.6 0.6 0.35]);
pd_ax = axes('Parent',fig,'position',[0.1 0.15 0.6 0.35]);

% a button to turn on/off the propogation of the wavefunction
uicontrol('Parent',fig,'Style','togglebutton',...
    'String','Propogate Sim','position',[420 350 100 50],...
    'Callback',{@toggle_propogate,sys});
% an editable text field to enter the intial gaussian wavefunction variance
uicontrol('Parent',fig,'Style','edit',...
    'String',num2str(sys.init_var),'position',[480 170 40 20],...
    'Callback',{@change_variance,sys});
edit_label(fig,'Variance',480, 170, 40, 20,bgcolor);
% a slider to control the time step
label = slider_labels(fig,sys.t_step_bounds(1),sys.t_step_bounds(2),...
    sprintf('Time Step = %d',sys.t_step),430,280,100,50,bgcolor);
uicontrol('Parent',fig,'Style','slider',...
    'position',[430 280 100 50],...
    'value',sys.t_step, 'min',sys.t_step_bounds(1), 'max',sys.t_step_bounds(2),...
    'Callback',{@change_t_step,sys,label});
% a slider to control the x step
label = slider_labels(fig,sys.x_step_bounds(1),sys.x_step_bounds(2),...
    sprintf('X Step = %2.2f',sys.x_step),430,220,100,50,bgcolor);
uicontrol('Parent',fig,'Style','slider',...
    'position',[430 220 100 50],...
    'value',sys.x_step, 'min',sys.x_step_bounds(1), 'max',sys.x_step_bounds(2),...
    'Callback',{@change_x_step,sys,label});
% reset function wavefunction
uicontrol('Parent',fig,'Style','pushbutton',...
    'String','Reset Sim','position',[420 100 100 50],...
    'Callback',{@reset_system,sys});

            
pd_data = plot(pd_ax,sys.x,sys.pd);
ylabel(pd_ax,'Probability Density, |\Phi|^2');

% run simulation
while ishandle(fig)
    sys.step_time();

    plot(wave_ax,sys.x,sys.real_phi, sys.x,sys.img_phi)
    xlabel(wave_ax, num2str(sys.t));
    ylabel(wave_ax,'Wavefunction, \Phi');    
    legend(wave_ax,'Real','Imaginary')
    
    set(pd_data,'XData',sys.x,'YData',sys.pd);
    
    wave_ax.XLim = [sys.x_lbound,sys.x_ubound];
    pd_ax.XLim = [sys.x_lbound,sys.x_ubound];
    wave_ax.YLim = [0,0.2];
    pd_ax.YLim = [0,0.05];


    % wait for some time
    pause(0.1);
end
end
% a function to add label to edit
function edit_label(parent,string,l,b,w,h,bgcolor)
	uicontrol('Parent',parent,'Style','text','Position',[l-50 b 50 h],...
                'String',string,'BackgroundColor',bgcolor);    
end
% a function to add labels to slider
function label = slider_labels(parent,min,max,name,l,b,w,h,bgcolor)
	uicontrol('Parent',parent,'Style','text','Position',[l-20 b 20 50],...
                'String',min,'BackgroundColor',bgcolor);
	uicontrol('Parent',parent,'Style','text','Position',[l+w,b,20,50],...
                'String',max,'BackgroundColor',bgcolor);
	label = uicontrol('Parent',parent,'Style','text','Position',[l,b-20,w,50],...
                'String',name,'BackgroundColor',bgcolor);
end
%function to reset system
function reset_system(hObject,callbackdata,sys)
   sys.reset();
end
% a function to change the gaussian variance
function change_variance(hObject,callbackdata,sys)

  val = str2double(hObject.String);
  sys.init_var = val;

end
% a function to turn on/off the propogation of the wavefunction
function toggle_propogate(hObject,callbackdata,sys)
   sys.propogate = hObject.Value;
end
% a function to change the time step
function change_t_step(hObject,callbackdata,sys,label)
   sys.t_step = hObject.Value;
   label.String = sprintf('Time Step = %2.2f',sys.t_step);
end
% a function to change the x step
function change_x_step(hObject,callbackdata,sys,label)
   sys.x_step = hObject.Value;
   sys.reset();
   label.String = sprintf('X Step = %2.2f',sys.x_step);
end


