function [sys,x0,str,ts] = Phase_Transformation_Model(t,x,u,flag)

switch flag

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes

%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%

function sys=mdlDerivatives(t,x,u)

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

T = u(1); Td = u(2); Sig = u(3);
Sigd = u(4); Si_in = u(5); Sid = u(6);

persistent SiM
persistent SiA
if isempty(SiM) % SiA and SiM will only be intialized when the funtion runs for the first time
    SiM = 1;
    SiA = 0;
end

if Sid < 0
    SiA = Si_in;
elseif Sid >= 0
    SiM = Si_in;
end

if SiA < 0
    SiA = 0;
elseif SiM > 1
    SiM = 1;
end
global As Af Ms Mf aA bA cA aM bM cM 

% CA = 10.31;
CA = cA;
% CM = 10.31;
CM = cM;
%SiM = 1;



if Td-(Sigd/CA) > 0
   if T >= (As+Sig/CA) && T <= (Af+Sig/CA)
      Sid = (-SiM/2)*sin(aA*(T-As)+bA*Sig)*(aA*Td+bA*Sigd);
   else
      Sid = 0;
   end
elseif Td-(Sigd/CM)  < 0
   if T > (Mf+Sig/CM) && T < (Ms+Sig/CM)
      Sid = ((1-SiA)/2)*(-sin(aM*(T-Mf)+bM*Sig))*(aM*Td+bM*Sigd);
   else
      Sid = 0;
   end
elseif Td-(Sigd/CA) == 0 || Td-(Sigd/CM) == 0 
   Sid = 0;
else
    Sid = 0;
end
out1 = real(Sid);

sys = real(out1);

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;  
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
