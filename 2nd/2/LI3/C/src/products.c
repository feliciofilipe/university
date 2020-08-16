#include "../include/products.h"
#include <stdlib.h>
#include "../include/clients.h"
#include "../libs/config.h"

struct products {
    GHashTable* hashT;
};

Products initProducts() {
    Products products = malloc(sizeof(struct products));
    products->hashT =
        g_hash_table_new_full(g_str_hash, g_str_equal, free, freeProduct);
    return products;
}

void addProduct(Products products, const Product product) {
    char* id = getProductID(product);
    g_hash_table_insert(products->hashT, id, product);
}

void updateBranchesBoughtProducts(Products products, const char* productID,
                                  int branch) {
    Product product = g_hash_table_lookup(products->hashT, productID);
    updateBranchesBoughtProduct(product, branch);
}

bool existsProduct(const Products products, const char* productID) {
    return (bool)g_hash_table_contains(products->hashT, productID);
}


char** getProductsByLetter(const Products products, char letter,
                           int* productsArrayLength) {
    guint glength = 0;
    gpointer* gKeysArray =
        g_hash_table_get_keys_as_array(products->hashT, &glength);
    char** keysArray = (char**)gKeysArray;
    int length = (int)glength;

    /* counting how many keys start by the letter*/
    char** res = malloc(sizeof(char*) * g_hash_table_size(products->hashT));
    int i, j = 0;
    for (i = 0; i < length; i++) {
        if ((keysArray[i])[0] == letter) {
            res[j] = strdup(keysArray[i]);
            j++;
        }
    }

    /* freeing the original array*/
    g_free(gKeysArray);
    *productsArrayLength = j;
    return res;
}

static void notBoughtTraverse(gpointer key __attribute__((unused)),
                              gpointer value, gpointer data) {
    Product product = (Product)value;
    int* ptr = (int*)data;
    if (productWasntBought(
            product, 0)) { /* The 0 is there to indicate to check all branches*/
        (*ptr)++;
    }
}

int numProductsNotBought(const Products products) {
    int res = 0;
    g_hash_table_foreach(products->hashT, notBoughtTraverse, &res);
    return res;
}

static gint compareStringsGPtrArray(gconstpointer a, gconstpointer b) {
    char* s1 = *((char**)a);
    char* s2 = *((char**)b);
    return strcmp(s1, s2);
}

GPtrArray* productsNotBought(const Products products, int branch, int* length) {
    GPtrArray* array =
        g_ptr_array_new_full(g_hash_table_size(products->hashT), free);
    /*GCompareFunc)g_ascii_strcasecmp*/
    GHashTableIter iter;
    gpointer key, value;
    *length = 0;
    g_hash_table_iter_init(&iter, products->hashT);
    while (g_hash_table_iter_next(&iter, &key, &value)) {
        Product product = (Product)value;
        if (productWasntBought(product, branch)) {
            (*length)++;
            g_ptr_array_add(array, strdup((char*)key));
        }
    }
    g_ptr_array_sort(array, (GCompareFunc)compareStringsGPtrArray);
    return array;
}

void freeProducts(Products products) {
    g_hash_table_destroy(products->hashT);
    free(products);
}
