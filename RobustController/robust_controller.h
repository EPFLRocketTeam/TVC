//
// Created by emma-hoggett on 04/10/2020.
//
#ifndef ROBUST_CONTROLLER_H_
#define ROBUST_CONTROLLER_H_

#include "stdio.h"
#include "stdlib.h"

typedef struct{
    double **K_mat;
    unsigned int input_size;
    double max;
    double min;
    double dt;
}KImpl;

typedef struct{
    double **A;
    double **B;
    double **C;
    double **D;
    unsigned int state_size;
}LTISystem;

void computeInput(KImpl* K, double prev_state[], double dist[], double input[]);

void computeOutput(LTISystem* LTI ,double prev_state[], double input[], double next_state[]);

#endif /* ROBUST_CONTROLLER_H_ */
