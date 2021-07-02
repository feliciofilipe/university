#ifndef __REQUEST__
#define __REQUEST__

typedef struct request {
    int pid;
    int argc;
    char argv[64][64];
} Request;

#endif
