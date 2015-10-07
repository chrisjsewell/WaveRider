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
    'String','Propogate','position',[420 350 100 50],...
    'Callback',{@toggle_propogate,sys});
% a slider to control the time step
uicontrol('Parent',fig,'Style','slider',...
    'String','Propogate','position',[430 280 100 50],...
    'value',sys.t_step, 'min',sys.t_step_bounds(1), 'max',sys.t_step_bounds(2),...
    'Callback',{@change_t_step,sys});
slider_labels(fig,sys.t_step_bounds(1),sys.t_step_bounds(2),'Time Step',430,280,100,50,bgcolor)

            
pd_data = plot(pd_ax,sys.x,sys.pd);
ylabel(pd_ax,'Probability Density, |\Phi^2|');

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


    % wait for some time
    pause(0.1);
end
end
% a function to add labels to slider
function slider_labels(parent,min,max,name,l,b,w,h,bgcolor)
	uicontrol('Parent',parent,'Style','text','Position',[l-20 b 20 50],...
                'String',min,'BackgroundColor',bgcolor);
	uicontrol('Parent',parent,'Style','text','Position',[l+w,b,20,50],...
                'String',max,'BackgroundColor',bgcolor);
	uicontrol('Parent',parent,'Style','text','Position',[l,b-20,w,50],...
                'String',name,'BackgroundColor',bgcolor);

end
% a function to turn on/off the propogation of the wavefunction
function toggle_propogate(hObject,callbackdata,sys)
   sys.propogate = hObject.Value;
end
% a function to change the time step
function change_t_step(hObject,callbackdata,sys)
   sys.t_step = hObject.Value;
end


