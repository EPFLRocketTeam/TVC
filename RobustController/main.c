#include <stdio.h>
#include "robust_controller.h"

int main() {
    LTISystemImpl *LTI = malloc(sizeof(*LTI));
    RSTImpl *RSTcontroller = malloc(sizeof(*RSTcontroller));
    Data *data = malloc(sizeof(*data));

    double next_ref_output[data->y_size];
    double next_command[data->u_size];
    while (1){
        estimateOutput(LTI, data, next_ref_output);
        addRefOutput(data, RSTcontroller, next_ref_output);
        computeCommand(RSTcontroller, data, next_command);
    }
}
