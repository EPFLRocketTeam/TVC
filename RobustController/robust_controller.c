//
// Created by emma-hoggett on 04/10/2020.
//
#include "robust_controller.h"



void computeCommand(RSTImpl* K, Data* data, double next_command[]){

    for (int i = 0; i < data->u_size; i++){
        double sum = 0;
        for (int j = 0; j < K->n_T; j++){
            for (int k = 0; k < data ->y_size; k++){
                sum += K->T[i][j][k] * data->ref_output_y[j][k];
            }
        }
        for (int j = 0; j < K->n_R; ++j) {
            for (int k = 0; k < data->y_size; ++k) {
                sum -= K->R[i][j][k] * data->output_y[j][k];
            }
        }
        for (int j = 0; j < K->n_S; ++j) {
            for (int k = 1; k < data->u_size; ++k) {
                sum -= K->S[i][j][k] * data->input_u[j][k];
            }
        }
        double u_ki = sum/(K -> S[i][0][0]);

        if (u_ki > K->max[i]){
            u_ki = K->max[i];
        }
        else if (u_ki < K->min[i]){
            u_ki = K->min[i];
        }
        next_command[i] = u_ki;
    }
}

void estimateOutput(LTISystemImpl* LTI, Data* data, double next_ref_output[]){
    for (int i = 0; i < data->y_size; i++){
        double temp = 0;
        for (int j = 0; j < LTI->_n_A; j++){
            for (int k = 0; k < data->y_size; ++k) {
                temp -= LTI->A[i][j][k]*data->output_y[j][k];
            }
        }
        for (int j = 0; j < LTI->_n_B; j++) {
            for (int k = 0; k < data->u_size; ++k){
                temp += LTI->B[i][j][k]*data->input_u[j][k];
            }
        }
        next_ref_output[i] = temp;
    }
}

void addCommand(Data* data, RSTImpl* K, double next_command[]){
    double tempA; double tempB;
    for (int i = 0; i <K ->n_S; i++){
        tempA = data->input_u[i][0];
        for (int j = 0; j < data->u_size; j++){
            tempB = data->input_u[i+1][j];
            data->input_u[i+1][j] = tempA;
            tempA = tempB;
        }
    }
    for (int j = 0; j < data->u_size; j++){
        data->input_u[0][j] = next_command[j];
    }
}

void addOutput (Data* data, RSTImpl* K, double next_output[]){
    double tempA; double tempB;
    for (int i = 0; i < K ->n_R; i++){
        tempA = data->output_y[i][0];
        for (int j = 0; j < data ->y_size; j++){
            tempB = data->output_y[i+1][j];
            data->output_y[i+1][j] = tempA;
            tempA = tempB;
        }
    }
    for (int i = 0; i < data->y_size; ++i) {
        data ->output_y[0][i] = next_output[i];
    }
}

void addRefOutput (Data* data, RSTImpl* K, double next_ref_output[]){
    double tempA; double tempB;
    for (int i = 0; i < K ->n_T; i++){
        tempA = data->ref_output_y[i][0];
        for (int j = 0; j < data ->y_size; j++){
            tempB = data->ref_output_y[i+1][j];
            data->ref_output_y[i+1][j] = tempA;
            tempA = tempB;
        }
    }
    for (int i = 0; i < data->y_size; ++i) {
        data ->ref_output_y[0][i] = next_ref_output[i];
    }
}

