//
// Created by emma-hoggett on 04/10/2020.
//
#include "robust_controller.h"


void computeInput(KImpl* K, double prev_state[], double dist[], double input[]){
    unsigned int _input_size = K->input_size;
    int i; int j; double temp;
    for (i = 0; i < _input_size;i++){
        temp = 0;
        for(j = 0; j<_input_size;j++){
            temp +=  K->K_mat[i][j]*prev_state[j];
        }
        input[i] = -temp + dist[i];
    }
}

void computeOutput(LTISystem* LTI ,double prev_state[], double input[], double next_state[]){
    unsigned int _input_size = LTI->state_size;
    int i; int j; int k; double sum1; double sum2;
    for (i = 0; i < _input_size; i++){
        sum1 = 0; sum2 = 0;
        for (j = 0; j < _input_size; j++){
            sum1 += LTI->A[i][j] *prev_state[j];
            sum2 += LTI->B[i][j] *input[j];
        }
        next_state[i] = sum1 + sum2;
    }
}
