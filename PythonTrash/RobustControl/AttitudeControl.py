# -*- coding: utf-8 -*-
import slycot
import control
from control.matlab import *
import matplotlib
import matplotlib.pyplot as plt
import numpy as np

import StateEstimation as SE

class Gain:
    
    # Gain Values
    omega_n = 50
    zeta_n = 7
    omega_att = 15
    zeta_att = 2
    A1 = np.diag([-pow(omega_att,2),-pow(omega_n,2),-pow(omega_att,2)]);
    A2 =np.diag([-2*omega_att*zeta_att,-2*omega_n*zeta_n,-2*omega_att*zeta_att]);
    
def Controller(q_e, T, State, HopData, EnvData, GainData):
        
    S = np.array([[q_e.scalar, -q_e.vector[2], q_e.vector[1]],
        [q_e.vector[2], q_e.scalar, -q_e.vector[0]],
        [-q_e.vector[1], q_e.vector[0], q_e.scalar]]);
    J = np.array([[HopData.Ixz, 0, 0],
        [0, HopData.Iy, 0],
        [0, 0, HopData.Ixz]]);
    B = np.array([[-1/(HopData.xi*T), 0, 0],
        [0, 1/HopData.CdCl*2, 0],
        [0, 0, -1/(HopData.xi*T)]]);
    G = np.linalg.inv(J)@B;
 
    qDot_e = q_e.derivative(-State.omega);
    
    OmegaMat = np.array([[0, State.omega[2][0], -State.omega[1][0]],
                [-State.omega[2][0], 0, State.omega[0][0]],
                [State.omega[1][0], -State.omega[0][0], 0]]);
    
    f = np.linalg.inv(J)@OmegaMat@J@State.omega;
    
    g = 1/2*(OmegaMat@qDot_e.vector.reshape(3,1)+qDot_e[0]*State.omega+S@f);
    v_n = GainData.A1@q_e.vector.reshape(3,1) + GainData.A2@qDot_e.vector.reshape(3,1) ; 
    u_virt = 2 *np.linalg.inv(S@G)@(-g + v_n);
    
    mux = u_virt[0][0]
    
    if mux < -20*np.pi/180:
        mux = -20*np.pi/180;
    if mux > 20*np.pi/180:
        mux = 20*np.pi/180;
        
    muz = u_virt[2][0]
    
    if muz < -20*np.pi/180:
        muz = -20*np.pi/180;
    if muz > 20*np.pi/180:
        muz = 20*np.pi/180;
        
    Fm = T/2
    if Fm > 1.8*HopData.m*EnvData.g:
        Fm = 1.8*HopData.m*EnvData.g;
    if Fm < 0.4*HopData.m*EnvData.g:
        Fm = 0.4*HopData.m*EnvData.g;
    
    dF = u_virt[1][0]
    if dF > 0.15*HopData.m*EnvData.g:
        dF = 0.15*HopData.m*EnvData.g;
        
    if dF < -0.15*HopData.m*EnvData.g:
        dF = -0.15*HopData.m*EnvData.g;
    
    Fa = Fm-dF;
    Fb = Fm+dF;
    
    u = np.array([Fa, Fb, mux, muz])
    return u;
