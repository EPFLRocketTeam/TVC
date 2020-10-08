//
// Created by emma-hoggett on 04/10/2020.
//
#include "robust_controller.h"


void computeError(RSTImpl* K, Data* data, Estimation* estimation){
    for (int i = 0; i < data->out_size; i++){
        double inSum =  estimation->output_y[i] * K ->T[i];
        double outSum = 0;

        for (int j = 0; j < K->n_R; ++j) {
            outSum += data->output_y[i][j] * K->R[i][j];
        }
        estimation->error[i] = inSum - outSum;

    }
}

void computeCommand(LTISystemImpl* LTI, Data* data, double next_state[]){
    unsigned int _input_size = LTI->state_size;
    unsigned int _order = data->order;
    int i; int j; double sum1; double sum2 = 0;
    for (i = 0; i < data->ref_size; i++){
        sum1 = 0;
        for (j = 0; j < _input_size; j++){
            sum1 += LTI->A[i][j] *data->reference_r[0][j];
            sum2 += LTI->B[i][j]*data->input_u[0][j];
        }
        next_state[i] = sum1 + sum2;
    }
}

void estimateOutput(LTISystemImpl* LTI, Data* data, Estimation* estimation){
    for (int i = 0; i <data->out_size; i++){
        int temp = 0;
        for (int j = 0; j < LTI->_n_A; j++){
            temp -= LTI->A[i][j]*data->output_y[j][i];
        }

        for (int k = 0; k < LTI->_n_B; ++k) {
            temp += LTI->B[i][k]*data->reference_r[k][i];
        }
        estimation->output_y[i] = temp;
    }
}

void addCommand(Data* data, RSTImpl* K, double next_command[]){
    double tempA; double tempB;
    for (int i = 0; i <K ->n_S; i++){
        tempA = data->input_u[i][0];
        for (int j = 0; j < data->in_size; j++){
            tempB = data->input_u[i+1][j];
            data->input_u[i+1][j] = tempA;
            tempA = tempB;
        }
    }
    for (int j = 0; j < data->in_size; j++){
        data->input_u[0][j] = next_command[j];
    }
}

void addOutput (Data* data, RSTImpl* K, double next_output[]){
    double tempA; double tempB;
    for (int i = 0; i < K ->n_R; i++){
        for (int j = 0; j < data ->out_size; j++){
            tempA = data->output_y[i][j];
            tempB = data->output_y[i+1][j];
            data->output_y[i+1][j] = tempA;
            tempA = tempB;
        }
    }
    for (int i = 0; i < data->out_size; ++i) {
        data ->output_y[0][i] = next_output[i];
    }
}

