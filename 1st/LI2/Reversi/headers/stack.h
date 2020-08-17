

#ifndef REVERSIF_STACK_H
#define REVERSIF_STACK_H

#include "estado.h"


/**
 * Estrutura da STACK de Estados
 */
typedef struct stack {
    ESTADO e;
    struct  stack *prox;
} *STACK;

STACK pop(STACK pointer);
STACK push(STACK pointer,ESTADO new);

#endif //REVERSIF_STACK_H



