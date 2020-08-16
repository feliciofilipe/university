#include "../include/clients.h"

#include <stdlib.h>

struct clients {
    GHashTable* hashT;
};

Clients initClients() {
    Clients clients = malloc(sizeof(struct clients));
    clients->hashT =
        g_hash_table_new_full(g_str_hash, g_str_equal, free, freeClient);
    return clients;
}

void updateBranchesBoughtClients(Clients clients, char* clientID, int branch) {
    Client client = g_hash_table_lookup(clients->hashT, clientID);
    updateBranchesBoughtClient(client, branch);
}

bool existsClient(const Clients clients, const char* clientID) {
    return g_hash_table_contains(clients->hashT, clientID);
}

void addClient(Clients clients, Client client) {
    char* id = getIdClient(client);
    g_hash_table_insert(clients->hashT, id, client);
}

static gint compareStringsGPtrArray(gconstpointer a, gconstpointer b) {
    char* s1 = *((char**)a);
    char* s2 = *((char**)b);
    return strcmp(s1, s2);
}

GPtrArray* getClientsOfALLBranchesClients(const Clients clients, int* length) {
    GPtrArray* clientsList =
        g_ptr_array_new_full(g_hash_table_size(clients->hashT) / 26, free);
    GHashTableIter iter;
    gpointer key, value;
    g_hash_table_iter_init(&iter, clients->hashT);
    while (g_hash_table_iter_next(&iter, &key, &value)) {
        Client client = (Client)value;
        if (boughtAllBranchesClient(client)) {
            (*length)++;
            g_ptr_array_add(clientsList, strdup((char*)key));
        }
    }
    g_ptr_array_sort(clientsList, (GCompareFunc)compareStringsGPtrArray);
    return clientsList;
}

static void didntBuyTraverse(gpointer key __attribute__((unused)),
                             gpointer value, gpointer data) {
    Client client = (Client)value;
    int* ptr = (int*)data;
    if (didntBuyClient(client)) {
        (*ptr)++;
    }
}

int numClientsDidntBuy(const Clients clients) {
    int res = 0;
    g_hash_table_foreach(clients->hashT, didntBuyTraverse, &res);
    return res;
}

void freeClients(Clients clients) {
    g_hash_table_destroy(clients->hashT);
    free(clients);
}
