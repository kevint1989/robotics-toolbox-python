%MDL_PUMA560STD Create model of Puma 560 manipulator
%
%      mdl_puma560std
%
% MDL_PUMA560STD is a script that creates the workspace variable p560s
% which describes the kinematic and dynamic characterstics of a Unimation
% Puma 560 manipulator standard DH conventions.
%
% Also defines the workspace vectors:
%   qz, qz_s    zero joint angle configuration
%   qr, qr_s    vertical 'READY' configuration
%   qs, qs_s    arm is stretched out in the X direction
%   qn, qn_s    arm is at a nominal non-singular configuration
%
% Notes::
% - SI units are used.
%
% References::
% - "A search for consensus among model parameters reported for the PUMA 560 robot",
%   P. Corke and B. Armstrong-Helouvry, 
%   Proc. IEEE Int. Conf. Robotics and Automation, (San Diego), 
%   pp. 1608-1613, May 1994.
%
% See also Link SerialLink, mdl_puma560akb, mdl_stanford_mdh.

% MODEL: Unimation, Puma560, dynamics, 6DOF, standard_DH
%
%
% Notes:
%    - the value of m1 is given as 0 here.  Armstrong found no value for it
% and it does not appear in the equation for tau1 after the substituion
% is made to inertia about link frame rather than COG frame.
% updated:
% 2/8/95  changed D3 to 150.05mm which is closer to data from Lee, AKB86 and Tarn
%  fixed errors in COG for links 2 and 3
% 29/1/91 to agree with data from Armstrong etal.  Due to their use
%  of modified D&H params, some of the offsets Ai, Di are
%  offset, and for links 3-5 swap Y and Z axes.
% 14/2/91 to use Paul's value of link twist (alpha) to be consistant
%  with ARCL.  This is the -ve of Lee's values, which means the
%  zero angle position is a righty for Paul, and lefty for Lee.
%  Note that gravity load torque is the motor torque necessary
%  to keep the joint static, and is thus -ve of the gravity
%  caused torque.
%
% 8/95 fix bugs in COG data for Puma 560. This led to signficant errors in
%  inertia of joint 1. 
% $Log: not supported by cvs2svn $
% Revision 1.4  2008/04/27 11:36:54  cor134
% Add nominal (non singular) pose qn

% Copyright (C) 1993-2015, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

clear L
deg = pi/180;

% link DH parameters
%            theta    d        a       alpha
L(1) = Link([  0      0        0       pi/2    0], 'standard');
L(2) = Link([  0      0        0.4318  0       0], 'standard');
L(3) = Link([  0      0.15005  0.0203 -pi/2    0], 'standard');
L(4) = Link([  0      0.4318   0       pi/2    0], 'standard');
L(5) = Link([  0      0        0      -pi/2    0], 'standard');
L(6) = Link([  0      0        0       0       0], 'standard');

% link mass
L(1).m = 0;
L(2).m = 17.4;
L(3).m = 4.8;
L(4).m = 0.82;
L(5).m = 0.34;
L(6).m = 0.09;

% link COG wrt link coordinate frame
%         rx        ry       rz
L(1).r = [0,        0,       0     ];
L(2).r = [-0.3638,  0.006,   0.2275];
L(3).r = [-0.0203, -0.0141,  0.070 ];
L(4).r = [0,        0.019,   0     ];
L(5).r = [0,        0,       0     ];
L(6).r = [0,        0,       0.032 ];

% link inertia matrix about link COG
%         Ixx      Iyy      Izz      Ixy  Iyz  Ixz
L(1).I = [0,       0.35,    0,       0,   0,   0];
L(2).I = [0.13,    0.524,   0.539,   0,   0,   0];
L(3).I = [0.066,   0.086,   0.0125,  0,   0,   0];
L(4).I = [1.8e-3,  1.3e-3,  1.8e-3,  0,   0,   0];
L(5).I = [0.3e-3,  0.4e-3,  0.3e-3,  0,   0,   0];
L(6).I = [0.15e-3, 0.15e-3, 0.04e-3, 0,   0,   0];

% actuator motor inertia (motor referred)
L(1).Jm =  200e-6;
L(2).Jm =  200e-6;
L(3).Jm =  200e-6;
L(4).Jm =  33e-6;
L(5).Jm =  33e-6;
L(6).Jm =  33e-6;

% actuator gear ratio
L(1).G =  -62.6111;
L(2).G =  107.815;
L(3).G =  -53.7063;
L(4).G =   76.0364;
L(5).G =   71.923;
L(6).G =   76.686;

% viscous friction (motor referenced)
L(1).B =   1.48e-3;
L(2).B =   0.817e-3;
L(3).B =   1.38e-3;
L(4).B =  71.2e-6;
L(5).B =  82.6e-6;
L(6).B =  36.7e-6;

% Coulomb friction (motor referenced)
L(1).Tc = [0.395, -0.435];
L(2).Tc = [0.126, -0.071];
L(3).Tc = [0.132, -0.105];
L(4).Tc = [11.2e-3, -16.9e-3];
L(5).Tc = [9.26e-3, -14.5e-3];
L(6).Tc = [3.96e-3, -10.5e-3];

% joint variable limits [min max]
L(1).qlim = [-160, 160]*deg;
L(2).qlim = [-45,  225]*deg;
L(3).qlim = [-225,  45]*deg;
L(4).qlim = [-110, 170]*deg;
L(5).qlim = [-100, 100]*deg;
L(6).qlim = [-266, 266]*deg;

%
% some useful poses
%
qz = [0 0 0 0 0 0];         % zero angles, L shaped pose
qr = [0 pi/2 -pi/2 0 0 0];  % ready pose, arm up
qs = [0 0 -pi/2 0 0 0];     % stretch horizontal along x-axis
qn = [0 pi/4 pi 0 pi/4 0];  % nominal non-singular configuration

# following assignments avoid pose name collisions with mdl_puma560akb
qz_s = qz;
qr_s = qr;
qs_s = qs;
qn_s = qn;

p560s = SerialLink(L, 'name', 'Puma 560', ...
                      'manufacturer', 'Unimation', 'comment', 'params of 8/95');
p560s.plotopt = {'ortho', 'nowrist', 'joints', ...
                 'workspace', [-1.0 1.0 -1.0 1.0 -1.0 1.0], 'mag', 1.0};                      
clear L

