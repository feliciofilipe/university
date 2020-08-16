#include "../include/client.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "../libs/config.h"

struct client {
    char* id;
    bool branchesBought[NUMBEROFBRANCHES];
};

Client initClient(char* id) {
    Client client = malloc(sizeof(struct client));
    client->id = strdup(strtok(id, "\r\n"));
    memset(client->branchesBought,false,NUMBEROFBRANCHES*sizeof(bool));
    return client;
}

char* getIdClient(const Client client) {
    return strdup(client->id);
}

bool validateClient(const char* id) {
    if (strlen(id) == SIZEIDCLIENT) {
        int num = atoi(id + 1);
        return (isupper(id[0]) && num >= 1000 && num <= 5000);
    } else
        return false;
}

void updateBranchesBoughtClient(Client client, int branch) {
    client->branchesBought[branch - 1] = true;
}

bool boughtAllBranchesClient(const Client client) {
    int branch;
    for (branch = 0; branch < NUMBEROFBRANCHES; branch++) {
        if (client->branchesBought[branch] == false) return false;
    }
    return true;
}

bool didntBuyClient(const Client client) {
    int branch;
    for (branch = 0; branch < NUMBEROFBRANCHES; branch++) {
        if (client->branchesBought[branch]) return false;
    }
    return true;
}

void freeClient(void* c) {
    Client client = (Client)c;
    free(client->id);
    free(client);
}
