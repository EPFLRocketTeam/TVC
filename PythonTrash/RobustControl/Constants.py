# -*- coding: utf-8 -*-

class VehicleData:
    m = 2;
    # Inertia [kgm^2]
    ry = 25E-3;
    Iy = m*ry*ry;
    rxz = 200E-3;
    Ixz = m*rxz*rxz;
    # CM-thrust point
    xi = 10E-3;

    Cl = 0.6;
    Cl_eff = 1.25/2*3*(5E-3*125E-3)*0.6;
    CdCl = 1/8;
    Cd_eff = Cl_eff*CdCl;
    
class Env:
    g = 9.81;