//
// Created by emma-hoggett on 04/10/2020.
//
#ifndef ROBUST_CONTROLLER_H_
#define ROBUST_CONTROLLER_H_

#include "stdio.h"
#include "stdlib.h"

typedef struct{
    double **R;
    double **S;
    double *T;
    unsigned int n_R;
    unsigned int n_S;
    unsigned int n_T;
    double max;
    double min;
    double dt;
}RSTImpl;

typedef struct{
    double **A;
    double **B;
    unsigned int _n_A;
    unsigned int _n_B;
    unsigned int _dimension;
}LTISystemImpl;

typedef struct {
    double **input_u;
    double *reference_r;
    double **ref_output_y;
    double **output_y;

    unsigned int ref_size;
    unsigned int in_size;
    unsigned int out_size;
    unsigned int _dimension;
}Data;

typedef struct {
    double * output_y;
    double **error;
    unsigned int err_size;
}Estimation;


void computeError(RSTImpl* K, Data* data, Estimation* estimation);
void estimateOutput(LTISystemImpl* LTI, Data* data, Estimation* estimation);


void computeCommand(LTISystemImpl* LTI, Data* data, double next_state[]);


void addCommand(Data* data, RSTImpl* K, double next_command[]);
void addOutput (Data* data, RSTImpl* K, double next_output[]);

#endif /* ROBUST_CONTROLLER_H_ */
