# -*- coding: utf-8 -*-
# Used to estimate the state of the Hopper
import slycot
import control
from control.matlab import *
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import AttitudeControl as AC
from pyquaternion import Quaternion

class StateVector:
    q = Quaternion(axis=[0, 1, 0], angle=0);
    omega = np.zeros((3,1))
    pos = np.zeros((3,1))
    speed = np.zeros((3,1))
    u = np.array([[9.81],[9.81],[0],[0]])
    
    def UpdatePosition(self,Ts,HopData,EnvData):
        T = self.u[0]+self.u[1]
        mux = self.u[2]
        muz = self.u[3]
        F = np.array([T*muz,
                      T,
                      -T*mux]).reshape(3,1)
        F = self.q.rotate(F).reshape(3,1)
        F[1]= F[1] - HopData.m*EnvData.g
    
        self.pos = self.pos + Ts*self.speed + Ts**2/2/HopData.m*F
        self.speed = self.speed + Ts/HopData.m*F
        
        
        return self.pos[0], self.pos[1], self.pos[2]
        
    def UpdateAttitude(self,Ts,HopData):
        self.q.integrate(self.omega, Ts);
        T = self.u[0]+self.u[1]
        dF = self.u[0]-self.u[1]
        mux = self.u[2]
        muz = self.u[3]
        
        dOmega = Ts*np.array([[T*HopData.xi*mux/HopData.Ixz],
                      [dF*HopData.CdCl/HopData.Iy],
                      [T*HopData.xi*muz/HopData.Ixz]])
        self.omega = self.omega + dOmega
        return
        
    def ErrorQuat(self,q_r):
        q_Mat = np.array([[self.q.real, self.q.vector[0], self.q.vector[1], self.q.vector[2]],
            [-self.q.vector[0], self.q.real, self.q.vector[2], -self.q.vector[1]],
            [-self.q.vector[1], -self.q.vector[2], self.q.real, self.q.vector[0]],
            [-self.q.vector[2], self.q.vector[1], -self.q.vector[0], self.q.real]])
                          
        q_temp = np.array([[q_r.real],
                           [q_r.vector[0]],
                           [q_r.vector[1]],
                           [q_r.vector[2]]])
        q_e = Quaternion(q_Mat@q_temp)
        return q_e
    
