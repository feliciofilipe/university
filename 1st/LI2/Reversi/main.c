#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include "functions.h"
#include "estado.h"
#include "stack.h"

int main()
{
    char buffer[100];
    ESTADO e = {0};

    STACK pointer = NULL;

    while (1) {
        bool_fim_do_jogo(&e);
        printf("[N] <peca> || [L] <file> || [E] <file> || [J] <L> <C> || [S] || [H] || [U] || [A] <peca> <nivel> || [C] <file> || [Q]\n");
        fgets(buffer, sizeof(buffer), stdin);
        if (buffer[0] == 'Q') break;
        menu(&e, buffer, &pointer);
    }
    return 0;
}