# -*- coding: utf-8 -*-
import slycot
import control
from control.matlab import *
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from pyquaternion import Quaternion

class FlightStrategy:
    K13 = 0;
    K2 = 0;
    R13 = np.array([[+24.08],
                  [-148.8],
                  [+391.4],
                  [-567.3],
                  [+488.9],
                  [-250.2],
                  [+70.28],
                  [-8.346],
                  [+3.472e-05]])
    S13 = np.array([[+1],
                  [-7.014],
                  [+21.41],
                  [-37.14],
                  [+40],
                  [-27.38],
                  [+11.62],
                  [-2.793],
                  [+0.2908]])
    T13 = np.array([[+24.08],
                  [-148.8],
                  [+391.4],
                  [-567.3],
                  [+488.9],
                  [-250.2],
                  [+70.28],
                  [-8.346],
                  [+3.472e-05]])
    
    R2 = np.array([[+131],
                   [-- 751.4],
                   [+1830],
                   [-2449],
                   [+1945],
                   [-916.1],
                   [+236.9],
                   [-25.93],
                   [+1.173e-06]])
    S2 = np.array([[+1],
                  [-5.901],
                  [+14.94],
                  [-21.14],
                  [+18.21],
                  [-9.729],
                  [+3.126],
                  [-0.5454],
                  [+0.03871]])
    T2 = np.array([[+131],
                   [-- 751.4],
                   [+1830],
                   [-2449],
                   [+1945],
                   [-916.1],
                   [+236.9],
                   [-25.93],
                   [+1.173e-06]])
    Gplant= tf(1,1);
    
    u1 = np.zeros((9,1))
    y1 = np.zeros((9,1))
    r1 = np.zeros((9,1))
    u2 = 9.81*2*np.ones((9,1))
    y2 = np.zeros((9,1))
    r2 = np.zeros((9,1))
    u3 = np.zeros((9,1))
    y3 = np.zeros((9,1))
    r3 = np.zeros((9,1))


    
    def F2Quat(self, F1, F2, F3, roll):
        T = np.sqrt(F1**2+F2**2+F3**2)
        qr0 = F2*np.cos(roll/2)/T
        qr1 = -F3*np.cos(roll/2)/T/2 -F1*np.sin(roll/2)/T/2
        qr2 = F2*np.sin(roll/2)/T
        qr3 = -F1*np.cos(roll/2)/T/2 -F3*np.sin(roll/2)/T/2
        q_r = Quaternion([qr0, qr1, qr2, qr3])
        return q_r, T
    
    
    def Circular(self, y1, r1, y2, r2, y3, r3):
        for i in range(5):
            self.y1[len(self.y1)-1-i] = self.y1[len(self.y1)-i-2]
            self.r1[len(self.r1)-1-i] = self.r1[len(self.r1)-i-2]
            self.y2[len(self.y2)-1-i] = self.y2[len(self.y2)-i-2]
            self.r2[len(self.r2)-1-i] = self.r2[len(self.r2)-i-2]
            self.y3[len(self.y3)-1-i] = self.y3[len(self.y3)-i-2]
            self.r3[len(self.r3)-1-i] = self.r3[len(self.r3)-i-2]
            
        self.y1[0] = y1
        self.r1[0] = r1
        self.y2[0] = y2
        self.r2[0] = r2
        self.y3[0] = y3
        self.r3[0] = r3

        return





