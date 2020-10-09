//
// Created by emma-hoggett on 04/10/2020.
//
#ifndef ROBUST_CONTROLLER_H_
#define ROBUST_CONTROLLER_H_

#include "stdio.h"
#include "stdlib.h"


typedef struct{
    double ***R;
    double ***S;
    double ***T;
    unsigned int n_R;
    unsigned int n_S;
    unsigned int n_T;
    double *max;
    double *min;
    double dt;
}RSTImpl;


typedef struct{
    double ***A;
    double ***B;
    unsigned int _n_A;
    unsigned int _n_B;
}LTISystemImpl;


typedef struct {
    double **input_u;
    double *reference_r;
    double **ref_output_y;
    double **output_y;

    unsigned int r_size;
    unsigned int y_size;
    unsigned int u_size;
}Data;


/**
 * \brief Function that make predictions on the next desired output y*(t+1)
 *
 * The function return a vector that correspond to the prediction of the next desired output according to the reference.
 * This value is either stored in the computer or generated from the reference signal r(t).
 *
 * @param LTI : Structure that contain tracking reference model y*(t+1)= Bm/Am*r(t)
 * @param data : Structure that contain the current and past references r(t), inputs u(t), predictions y*(t) and outputs y(t)
 * @param next_ref_output : Prediction on the next desired output y*(t+1)
 */
void estimateOutput(LTISystemImpl* LTI, Data* data, double next_ref_output[]);

/**
 * \brief Function that compute the next
 *
 * @param K : Structure that include an RST controller
 * @param data : Structure that contain the current and past references r(t), inputs u(t), predictions y*(t) and outputs y(t)
 * @param next_command : Command computed for the motor control u(t)
 */
void computeCommand(RSTImpl* K, Data* data, double next_command[]);

/**
 * \brief Update the command matrix u
 *
 * The last value of the u(t-i) matrix is erased and the current command is added to the matrix, u(t). i correspond to
 * the order of the S matrix and u(t) is a vector.
 *
 * @param data : Structure that contain the current and past references r(t), inputs u(t), predictions y*(t) and outputs y(t)
 * @param K : Structure that include an RST controller
 * @param next_command : Command computed for the motor control u(t)
 */
void addCommand(Data* data, RSTImpl* K, double next_command[]);

/**
 * \brief Update the output matrix y
 *
 * The last value of the y(t-i) matrix is erased and the current command is added to the matrix, y(t). i correspond to
 * the order of the R matrix and y(t) is a vector.
 *
 * @param data : Structure that contain the current and past references r(t), inputs u(t), predictions y*(t) and outputs y(t)
 * @param K : Structure that include an RST controller
 * @param next_output : Output measured by the sensor, y(t)
 */
void addOutput (Data* data, RSTImpl* K, double next_output[]);

/**
 * \brief Update the prediction matrix y*
 *
 * The last value of the y*(t-i) matrix is erased and the current command is added to the matrix, y*(t). i correspond to
 * the order of the T matrix and y*(t) is a vector.
 *
 * @param data : Structure that contain the current and past references r(t), inputs u(t), predictions y*(t) and outputs y(t)
 * @param K : Structure that include an RST controller
 * @param next_ref_output : Desired next output y* according to the reference.
 */
void addRefOutput (Data* data, RSTImpl* K, double next_ref_output[]);

#endif /* ROBUST_CONTROLLER_H_ */
