function syncMachinePhasorViz
    % Create main figure window
    fig = figure('Name', 'Synchronous Machine Phasor Diagram', ...
                'Position', [100 100 1000 600], ...
                'NumberTitle', 'off');
    
    % Create GUI controls panel
    controlPanel = uipanel('Parent', fig, ...
                          'Position', [0.02 0.02 0.3 0.96], ...
                          'Title', 'Machine Parameters');
    
    % Create plot panel
    plotPanel = uipanel('Parent', fig, ...
                       'Position', [0.34 0.02 0.64 0.96], ...
                       'Title', 'Phasor Diagram');
    
    % Create input fields
    createInputFields(controlPanel);
    
    % Initialize plot axes
    ax = axes('Parent', plotPanel);
    hold(ax, 'on');
    grid(ax, 'on');
    axis(ax, 'equal');
    
    % Create update button
    uicontrol('Parent', controlPanel, ...
             'Style', 'pushbutton', ...
             'String', 'Update Diagram', ...
             'Position', [20 20 100 30], ...
             'Callback', @(src,event)updatePhasorDiagram(ax));
end

function createInputFields(panel)
    % Define input parameters
    params = {'Terminal Voltage (V)', 'Current (A)', 'Power Factor', ...
              'Power Factor Angle (deg)', 'Synchronous Reactance (Ω)', ...
              'Armature Resistance (Ω)'};
    defaultVals = {'230', '10', '0.8', '36.87', '2.5', '0.2'};
    
    % Create input fields with labels
    for i = 1:length(params)
        y_pos = 500 - (i-1)*70;
        
        % Label
        uicontrol('Parent', panel, ...
                 'Style', 'text', ...
                 'String', params{i}, ...
                 'Position', [20 y_pos 150 20]);
             
        % Edit field
        uicontrol('Parent', panel, ...
                 'Style', 'edit', ...
                 'String', defaultVals{i}, ...
                 'Position', [20 y_pos-25 150 25], ...
                 'Tag', ['param' num2str(i)]);
    end
end

function updatePhasorDiagram(ax)
    % Get values from input fields
    Vt = str2double(findobj('Tag', 'param1').String);    % Terminal voltage
    I = str2double(findobj('Tag', 'param2').String);     % Current
    pf = str2double(findobj('Tag', 'param3').String);    % Power factor
    phi = str2double(findobj('Tag', 'param4').String);   % Power factor angle
    Xs = str2double(findobj('Tag', 'param5').String);    % Synchronous reactance
    Ra = str2double(findobj('Tag', 'param6').String);    % Armature resistance
    
    % Clear previous plot
    cla(ax);
    
    % Calculate phasor components
    % Convert angles to radians
    phi_rad = phi * pi/180;
    
    % Terminal voltage phasor (reference)
    Vt_re = Vt;
    Vt_im = 0;
    
    % Current phasor
    I_re = I * cos(-phi_rad);
    I_im = I * sin(-phi_rad);
    
    % IXs phasor
    IXs_re = -I * Xs * sin(phi_rad);
    IXs_im = I * Xs * cos(phi_rad);
    
    % IRa phasor
    IRa_re = I * Ra * cos(-phi_rad);
    IRa_im = I * Ra * sin(-phi_rad);
    
    % Induced EMF (Ef)
    Ef_re = Vt_re + IRa_re - IXs_im;
    Ef_im = Vt_im + IRa_im + IXs_re;
    
    % Plot phasors
    % Terminal voltage (reference)
    plotPhasor(ax, [0 0], [Vt_re Vt_im], 'b', 'V_t');
    
    % Current
    plotPhasor(ax, [0 0], [I_re I_im], 'r', 'I');
    
    % IXs
    plotPhasor(ax, [Vt_re Vt_im], [IXs_re IXs_im], 'g', 'IX_s');
    
    % IRa
    plotPhasor(ax, [0 0], [IRa_re IRa_im], 'm', 'IR_a');
    
    % Induced EMF
    plotPhasor(ax, [0 0], [Ef_re Ef_im], 'k', 'E_f');
    
    % Set plot properties
    grid(ax, 'on');
    axis(ax, 'equal');
    title(ax, 'Synchronous Machine Phasor Diagram');
    xlabel(ax, 'Real Component');
    ylabel(ax, 'Imaginary Component');
    legend(ax, 'show');
end

function plotPhasor(ax, start, end_point, color, label)
    % Plot phasor as arrow with label
    quiver(ax, start(1), start(2), end_point(1)-start(1), end_point(2)-start(2), ...
           0, 'Color', color, 'LineWidth', 2, 'MaxHeadSize', 0.5, ...
           'DisplayName', label);
           
    % Add label at midpoint
    mid_x = (start(1) + end_point(1))/2;
    mid_y = (start(2) + end_point(2))/2;
    text(ax, mid_x, mid_y, label, 'Color', color, 'FontWeight', 'bold');
end
