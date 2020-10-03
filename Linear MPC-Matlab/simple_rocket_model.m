
function simple_rocket_model(block)
%MSFUNTMPL A Template for a MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl' with the name
%   of your S-function.  
%
%   It should be noted that the MATLAB S-function is very similar
%   to Level-2 C-Mex S-functions. You should be able to get more 
%   information for each of the block methods by referring to the
%   documentation for C-Mex S-functions.
%  
%   Copyright 2003-2010 The MathWorks, Inc.
  
%
% The setup method is used to setup the basic attributes of the
% S-function such as ports, parameters, etc. Do not add any other
% calls to the main body of the function.  
%   
setup(block);
  
%endfunction

% Function: setup ===================================================
% Abstract:
%   Set up the S-function block's basic characteristics such as:
%   - Input ports
%   - Output ports
%   - Dialog parameters
%   - Options
% 
%   Required         : Yes
%   C-Mex counterpart: mdlInitializeSizes
%
function setup(block)

  % Register the number of ports.
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 4;
  
  % Set up the port properties to be inherited or dynamic.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;

  % Override the input port properties.
  % Total thrust
  block.InputPort(1).DatatypeID  = 0;  % double
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).Dimensions = 1;
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(1).DirectFeedthrough = false;
  
  % Thrust direction
  block.InputPort(2).DatatypeID  = 0;  % double
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).Dimensions = 1;
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(2).DirectFeedthrough = false;
  
  % 2D Wind perturbations
  block.InputPort(3).DatatypeID  = 0;  % double
  block.InputPort(3).Complexity  = 'Real';
  block.InputPort(3).Dimensions = 2;
  block.InputPort(3).SamplingMode = 'Sample';
  block.InputPort(3).DirectFeedthrough = false;
  
  
  % Override the output port properties.
  % 2D Position
  block.OutputPort(1).DatatypeID  = 0; % double
  block.OutputPort(1).Complexity  = 'Real';
  block.OutputPort(1).Dimensions = 2;
  block.OutputPort(1).SamplingMode = 'Sample';
  
  % 2D Speed
  block.OutputPort(2).DatatypeID  = 0; % double
  block.OutputPort(2).Complexity  = 'Real';
  block.OutputPort(2).Dimensions = 2;
  block.OutputPort(2).SamplingMode = 'Sample';
  
  % 1D attitude (pitch)
  block.OutputPort(3).DatatypeID  = 0; % double
  block.OutputPort(3).Complexity  = 'Real';
  block.OutputPort(3).Dimensions = 1;
  block.OutputPort(3).SamplingMode = 'Sample';
  
  % 1D angular speed
  block.OutputPort(4).DatatypeID  = 0; % double
  block.OutputPort(4).Complexity  = 'Real';
  block.OutputPort(4).Dimensions = 1;
  block.OutputPort(4).SamplingMode = 'Sample';

  % Register the parameters.
  block.NumDialogPrms     = 3; % Mass, Inertia and position of CM
  block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable'};
  


  % Register the sample times.
  %  [0 offset]            : Continuous sample time
  %  [positive_num offset] : Discrete sample time
  %
  %  [-1, 0]               : Inherited sample time
  %  [-2, 0]               : Variable sample time
  block.SampleTimes = [0.1 0];
  
  % -----------------------------------------------------------------
  % Options
  % -----------------------------------------------------------------
  % Specify if Accelerator should use TLC or call back to the 
  % MATLAB file
  block.SetAccelRunOnTLC(false);
  
  % Specify the block simStateCompliance. The allowed values are:
  %    'UnknownSimState', < The default setting; warn and assume DefaultSimState
  %    'DefaultSimState', < Same SimState as a built-in block
  %    'HasNoSimState',   < No SimState
  %    'CustomSimState',  < Has GetSimState and SetSimState methods
  %    'DisallowSimState' < Errors out when saving or restoring the SimState
  block.SimStateCompliance = 'DefaultSimState';
  
  % -----------------------------------------------------------------
  % The MATLAB S-function uses an internal registry for all
  % block methods. You should register all relevant methods
  % (optional and required) as illustrated below. You may choose
  % any suitable name for the methods and implement these methods
  % as local functions within the same file.
  % -----------------------------------------------------------------
  
   
  % -----------------------------------------------------------------
  % Register the methods called during update diagram/compilation.
  % -----------------------------------------------------------------
  
  % 
  % CheckParameters:
  %   Functionality    : Called in order to allow validation of the
  %                      block dialog parameters. You are 
  %                      responsible for calling this method
  %                      explicitly at the start of the setup method.
  %   C-Mex counterpart: mdlCheckParameters
  %
  block.RegBlockMethod('CheckParameters', @CheckPrms);
  
  
  %
  % PostPropagationSetup:
  %   Functionality    : Set up the work areas and the state variables. You can
  %                      also register run-time methods here.
  %   C-Mex counterpart: mdlSetWorkWidths
  %
  block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);

  % -----------------------------------------------------------------
  % Register methods called at run-time
  % -----------------------------------------------------------------
  
  % 
  % ProcessParameters:
  %   Functionality    : Call to allow an update of run-time parameters.
  %   C-Mex counterpart: mdlProcessParameters
  %  
  block.RegBlockMethod('ProcessParameters', @ProcessPrms);
  
  % 
  % Start:
  %   Functionality    : Call to initialize the state and the work
  %                      area values.
  %   C-Mex counterpart: mdlStart
  %
  block.RegBlockMethod('Start', @Start);

  % 
  % Outputs:
  %   Functionality    : Call to generate the block outputs during a
  %                      simulation step.
  %   C-Mex counterpart: mdlOutputs
  %
  block.RegBlockMethod('Outputs', @Outputs);

  % 
  % Update:
  %   Functionality    : Call to update the discrete states
  %                      during a simulation step.
  %   C-Mex counterpart: mdlUpdate
  %
  block.RegBlockMethod('Update', @Update);
  
  % 
  % Terminate:
  %   Functionality    : Call at the end of a simulation for cleanup.
  %   C-Mex counterpart: mdlTerminate
  %
  block.RegBlockMethod('Terminate', @Terminate);

  %
  % GetSimState:
  %   Functionality    : Return the SimState of the block.
  %   C-Mex counterpart: mdlGetSimState
  %
  block.RegBlockMethod('GetSimState', @GetSimState);
  
  %
  % SetSimState:
  %   Functionality    : Set the SimState of the block using a given value.
  %   C-Mex counterpart: mdlSetSimState
  %
  block.RegBlockMethod('SetSimState', @SetSimState);

  % -----------------------------------------------------------------
  % Register the methods called during code generation.
  % -----------------------------------------------------------------
  
  %
  % WriteRTW:
  %   Functionality    : Write specific information to model.rtw file.
  %   C-Mex counterpart: mdlRTW
  %
  block.RegBlockMethod('WriteRTW', @WriteRTW);
%endfunction

% -------------------------------------------------------------------
% The local functions below are provided to illustrate how you may implement
% the various block methods listed above.
% -------------------------------------------------------------------

function CheckPrms(block)
  
  a = block.DialogPrm(1).Data;
  if ~strcmp(class(a), 'double')
    me = MSLException(block.BlockHandle, message('Simulink:blocks:invalidParameter'));
    throw(me);
  end
  
%endfunction

function ProcessPrms(block)

  block.AutoUpdateRuntimePrms;
 
%endfunction

    
function DoPostPropSetup(block)
  block.NumDworks = 4;
  
  block.Dwork(1).Name            = 'position';
  block.Dwork(1).Dimensions      = 2;      % X and Y
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;
  
  block.Dwork(2).Name            = 'speed';
  block.Dwork(2).Dimensions      = 2;      % X and Y
  block.Dwork(2).DatatypeID      = 0;      % double
  block.Dwork(2).Complexity      = 'Real'; % real
  block.Dwork(2).UsedAsDiscState = true;
  
  block.Dwork(3).Name            = 'Attitude';
  block.Dwork(3).Dimensions      = 1;      % Pitch
  block.Dwork(3).DatatypeID      = 0;      % double
  block.Dwork(3).Complexity      = 'Real'; % real
  block.Dwork(3).UsedAsDiscState = true;

  block.Dwork(4).Name            = 'Angular_speed';
  block.Dwork(4).Dimensions      = 1;      % Pitch speed
  block.Dwork(4).DatatypeID      = 0;      % double
  block.Dwork(4).Complexity      = 'Real'; % real
  block.Dwork(4).UsedAsDiscState = true;
  
  % Register all tunable parameters as runtime parameters.
  block.AutoRegRuntimePrms;

%endfunction

 
function Start(block)

  block.Dwork(1).Data = [0; 2]; % Init position at 2m high, 0m horizontal
  block.Dwork(2).Data = [0; 0]; % Init speed at zero 
  
  block.Dwork(3).Data = 0; % Init pitch at zero 
  block.Dwork(4).Data = 0; % Init pitch speed at zero 
   
%endfunction

function WriteRTW(block)
  
   block.WriteRTWParam('matrix', 'M',    [1 2; 3 4]);
   block.WriteRTWParam('string', 'Mode', 'Auto');
   
%endfunction

function Outputs(block)
  
  block.OutputPort(1).Data = block.Dwork(1).Data; % Output position
  block.OutputPort(2).Data = block.Dwork(2).Data; % Output speed
  block.OutputPort(3).Data = block.Dwork(3).Data; % Output pitch
  block.OutputPort(4).Data = block.Dwork(4).Data; % Output angular speed
  
%endfunction

function Update(block)
  
    dT = block.SampleTimes(1); % Time step in seconds
    
    mass = block.DialogPrm(1).Data;
    I = block.DialogPrm(2).Data;
    CM = block.DialogPrm(3).Data;
    
    motor_angle = double(block.InputPort(2).Data);
    
    Thrust = [sin(motor_angle)*block.InputPort(1).Data;
              cos(motor_angle)*block.InputPort(1).Data]; % 2D Thrust
          
    Wind = block.InputPort(3).Data; % 2D wind in world frame
          
    block.Dwork(4).Data = block.Dwork(4).Data + Thrust(1)*CM/I *dT; % Angular speed
    block.Dwork(3).Data = block.Dwork(3).Data + block.Dwork(4).Data *dT; % Pitch
    
    R = [cos(block.Dwork(3).Data), -sin(block.Dwork(3).Data);
         sin(block.Dwork(3).Data), cos(block.Dwork(3).Data)]; % Rotation matrix from rocket to world frame
    
    acceleration = R*Thrust/mass - [0; 9.81] + Wind/mass; % 2D Acceleration with thrust and gravity + perturnations from wind
    
    block.Dwork(2).Data = block.Dwork(2).Data + acceleration*dT; % 2D Speed
    block.Dwork(1).Data = block.Dwork(1).Data + block.Dwork(2).Data*dT; % 2D Position
  
%endfunction


    
function Terminate(block)

disp(['Terminating the block with handle ' num2str(block.BlockHandle) '.']);

%endfunction
 
