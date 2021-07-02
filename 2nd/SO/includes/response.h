#ifndef __REPONSE__
#define __REPONSE__

typedef struct response {
    int argc;
    char argv[64][516];
    int flag;
} Response;

#endif
