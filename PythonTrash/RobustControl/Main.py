# -*- coding: utf-8 -*-
import slycot
import control
from control.matlab import *
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from pyquaternion import Quaternion


import AttitudeControl as AC
import StateEstimation as SE
import Constants as CTE
import FlightStrategy as FS


Ts = 0.02;
    
HopData = CTE.VehicleData()
EnvData = CTE.Env()
GainData = AC.Gain()

State = SE.StateVector()
Strategy = FS.FlightStrategy()

umax_2 = 10;
umax_13= 7.5;

# Strategy.Init(umax_2,umax_13,Ts,HopData);
t = range(0,10000,20);

for i in t:
    roll = 0
    ref1 = 0
    ref2 = 1
    ref3 = 0
    F1 = 1
    F2 = HopData.m*EnvData.g
    F3 = 0
    
    pos1, pos2, pos3 = State.UpdatePosition(Ts,HopData,EnvData)
    #q_r, T = Strategy.UpdateReferenceQuaternion(pos1, ref1, pos2, ref2, pos3, ref3, roll,  HopData, EnvData)
    q_r, T = Strategy.F2Quat(F1, F2, F3, roll)
    print(q_r)
    q_e = Quaternion(State.ErrorQuat(q_r))
    u_temp = AC.Controller(q_e, T, State, HopData, EnvData, GainData)
    
    plt.scatter(i, q_r.vector[2])
    plt.scatter(i, State.q.vector[2])
    
    State.u = u_temp; 
    State.UpdateAttitude(Ts,HopData);
    
    
    

plt.show()