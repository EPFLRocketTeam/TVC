//
// Created by emma-hoggett on 04/10/2020.
//
#include "robust_controller.h"


void computeError(RSTImpl* K, Data* data, Estimation* estimation){

    unsigned int _input_size = K->input_size;
    unsigned int _order = K ->order;
    int i; int j; int k; double temp;
    for (i = 0; i < _order;i++){
        for (j = 0; j< _input_size; j++){
            temp = 0;
            for(k = 0; k<_input_size;k++){
                temp +=  K->K_mat[i][j][k]*data->state_x[i][k];
            }
            data->input_u[i][j] = -temp + data->dist[i][j];
        }
    }
}

void computeState(LTISystemImpl* LTI, Data* data, double next_state[]){
    unsigned int _input_size = LTI->state_size;
    unsigned int _order = data->order;
    int i; int j; double sum1; double sum2 = 0;
    for (i = 0; i < _input_size; i++){
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

void addInput(Data* data, double next_state[]){
    unsigned int _input_size = data->state_size;
    unsigned int _order = data->order -1;
    int i; int j;
    for (i = 0; i <_order; i++){
        for (j = 0; j < _input_size; j++){
            data->input_u[i+1][j] = data->input_u[i][j];
        }
    }
    for (j = 0; j < _input_size; j++){
        data->input_u[0][j] = next_state[j];
    }
}

void addState(Data* data, double next_state[]){
    unsigned int _ref_size = data->ref_size;
    unsigned int _order = data->order -1;
    int i; int j;
    for (i = 0; i <_order; i++){
        for (j = 0; j < _ref_size; j++){
            data->reference_r[i+1][j] = data->reference_r[i][j];
        }
    }
    for (j = 0; j < _input_size; j++){
        data->reference_r[0][j] = next_state[j];
    }
}

void addOutput (Data* data, double next_output){
    unsigned int _order = data->order -1;
    int i;
    for (i = 0; i < _order; i++){
        data->output_y[i+1] = data->output_y[i];
    }
    data ->output_y[0] = next_output;
}