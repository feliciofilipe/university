#include "../include/branch.h"
#include <stdbool.h>
#include "../libs/config.h"

/*STRUCTS*/

struct branch {
    GHashTable* products; /* key:productID, value:productRecord*/
    GHashTable* clients;  /* key: clientID, value; clientRecord */
};

/* Structs that will be inside the main and nested hashtables */
typedef struct productRecord {
    char* id;
    GHashTable* clients; /* key: clientID, value:productClients, */
} * ProductRecord;

typedef struct productClients {
    int totalN;
    int totalP;
} * ProductClients;

typedef struct clientRecord {
    char* id;
    int quantities[NMONTHS];
    GHashTable* products; /*, key: productID, value: clientProducts */
} * ClientRecord;
;

typedef struct clientProducts {
    char* id;
    int quantities[NMONTHS];
    float expenditure;
} * ClientProducts;

/* Fress of the above structures */
static void freeClientProducts(void* c) {
    ClientProducts clientProducts = (ClientProducts)c;
    free(clientProducts->id);
    free(clientProducts);
}

static void freeProductClients(void* p) {
    ProductClients productClients = (ProductClients)p;
    free(productClients);
}

static void freeClientRecord(void* r) {
    ClientRecord clientRecord = (ClientRecord)r;
    free(clientRecord->id);
    g_hash_table_destroy(clientRecord->products);
    free(clientRecord);
}

static void freeProductRecord(void* r) {
    ProductRecord productRecord = (ProductRecord)r;
    free(productRecord->id);
    g_hash_table_destroy(productRecord->clients);
    free(productRecord);
}

/*INITS*/

Branch initBranch() {
    Branch branch = malloc(sizeof(struct branch));
    branch->clients =
        g_hash_table_new_full(g_str_hash, g_str_equal, free, freeClientRecord);
    branch->products =
        g_hash_table_new_full(g_str_hash, g_str_equal, free, freeProductRecord);
    return branch;
}

static ProductClients initProductClients() {
    ProductClients productClients = malloc(sizeof(struct productClients));
    productClients->totalN = 0;
    productClients->totalP = 0;
    return productClients;
}

static ClientRecord initClientRecord(char* id) {
    ClientRecord clientRecord = malloc(sizeof(struct clientRecord));
    clientRecord->id = strdup(id);
    memset(clientRecord->quantities, 0, NMONTHS * sizeof(int));
    clientRecord->products = g_hash_table_new_full(g_str_hash, g_str_equal,
                                                   free, freeClientProducts);
    return clientRecord;
}

static ClientProducts initClientProducts(char* id) {
    ClientProducts clientProducts = malloc(sizeof(struct clientProducts));
    clientProducts->id = strdup(id);
    memset(clientProducts->quantities, 0, NMONTHS * sizeof(int));
    clientProducts->expenditure = 0;
    return clientProducts;
}

static ProductRecord initProductRecord(char* id) {
    ProductRecord productRecord = malloc(sizeof(struct productRecord));
    productRecord->id = strdup(id);
    productRecord->clients = g_hash_table_new_full(g_str_hash, g_str_equal,
                                                   free, freeProductClients);
    return productRecord;
}

/*UPDATES*/

static void updateProductClients(ProductRecord productRecord, char* clientID,
                                 char type) {
    if (g_hash_table_contains(productRecord->clients, clientID)) {
        ProductClients productClients =
            g_hash_table_lookup(productRecord->clients, clientID);
        if (type == 'N') {
            productClients->totalN++;
        } else {
            productClients->totalP++;
        }
    } else {
        ProductClients productClients = initProductClients();
        if (type == 'N') {
            productClients->totalN++;
        } else {
            productClients->totalP++;
        }
        char* id = strdup(clientID);
        g_hash_table_insert(productRecord->clients, id, productClients);
    }
}

static void updateBranchProducts(Branch branch, char* productID, char* clientID,
                                 char type) {
    if (g_hash_table_contains(branch->products, productID)) {
        ProductRecord productRecord =
            g_hash_table_lookup(branch->products, productID);
        updateProductClients(productRecord, clientID, type);
    } else {
        ProductRecord productRecord = initProductRecord(productID);
        char* id = strdup(productID);
        updateProductClients(productRecord, clientID, type);
        g_hash_table_insert(branch->products, id, productRecord);
    }
}

static void updateClientProducts(ClientRecord clientRecord, char* productID,
                                 int month, int quantity, float price) {
    if (g_hash_table_contains(clientRecord->products, productID)) {
        ClientProducts clientProducts =
            g_hash_table_lookup(clientRecord->products, productID);
        clientProducts->quantities[month - 1] += quantity;
        clientProducts->expenditure += price * quantity;
    } else {
        ClientProducts clientProducts = initClientProducts(productID);
        clientProducts->quantities[month - 1] += quantity;
        clientProducts->expenditure += price * quantity;
        char* id = strdup(productID);
        g_hash_table_insert(clientRecord->products, id, clientProducts);
    }
}

static void updateBranchClients(Branch branch, char* clientID, char* productID,
                                int month, int quantity, float price) {
    if (g_hash_table_contains(branch->clients, clientID)) {
        ClientRecord clientRecord =
            g_hash_table_lookup(branch->clients, clientID);
        clientRecord->quantities[month - 1] += quantity;
        updateClientProducts(clientRecord, productID, month, quantity, price);
    } else {
        ClientRecord clientRecord = initClientRecord(clientID);
        char* id = strdup(clientID);
        clientRecord->quantities[month - 1] += quantity;
        updateClientProducts(clientRecord, productID, month, quantity, price);
        g_hash_table_insert(branch->clients, id, clientRecord);
    }
}

void updateBranch(Branch branch, char* productID, char* clientID, int month,
                  int quantities, int type, float price) {
    updateBranchProducts(branch, productID, clientID, type);
    updateBranchClients(branch, clientID, productID, month, quantities, price);
}

/* Query 7 */
int* getClientQuantitiesByBranch(const Branch branch, const char* clientID) {
    int* branchQuantities = calloc(NMONTHS, sizeof(int));
    if (g_hash_table_contains(branch->clients, clientID)) {
        ClientRecord clientRecord =
            g_hash_table_lookup(branch->clients, clientID);
        int i;
        for (i = 0; i < NMONTHS; i++) {
            branchQuantities[i] = clientRecord->quantities[i];
        }
    }
    return branchQuantities;
}

/* Query 9 + aux functions */
static gint compareStringsGPtrArray(gconstpointer a, gconstpointer b) {
    char* s1 = *((char**)a);
    char* s2 = *((char**)b);
    return strcmp(s1, s2);
}

void getClientsThatBoughtProductByBranch(const Branch branch,
                                         const char* productID,
                                         GPtrArray** arrayN, GPtrArray** arrayP,
                                         int* totalN, int* totalP) {
    *totalN = 0;
    *totalP = 0;
    *arrayN = g_ptr_array_new_with_free_func(free);
    *arrayP = g_ptr_array_new_with_free_func(free);

    if (g_hash_table_contains(branch->products, productID)) {
        ProductRecord productRecord =
            g_hash_table_lookup(branch->products, productID);
        GHashTableIter iter;
        gpointer key, value;
        g_hash_table_iter_init(&iter, productRecord->clients);

        while (g_hash_table_iter_next(&iter, &key, &value)) {
            char* clientID = (char*)key;
            ProductClients productClients = (ProductClients)value;
            if (productClients->totalN > 0) {
                (*totalN)++;
                g_ptr_array_add(*arrayN, strdup(clientID));
            }
            if (productClients->totalP > 0) {
                (*totalP)++;
                g_ptr_array_add(*arrayP, strdup(clientID));
            }
        }

        g_ptr_array_sort(*arrayN, (GCompareFunc)compareStringsGPtrArray);
        g_ptr_array_sort(*arrayP, (GCompareFunc)compareStringsGPtrArray);
    }
}

/*Auxliary structs for query 10+ aux functions + Query 10*/

/* Auxiliary structs */
typedef struct infoClientQuantityProduct {
    char* id;
    int quantity;
} * InfoClientQuantityProduct;

static void freeInfoClientQuantityProduct(void* i) {
    InfoClientQuantityProduct info = (InfoClientQuantityProduct)i;
    free(info->id);
    free(info);
}

/* Transfers the data in an hash table to a gptrArray */
/* the values of the HTable are already clones and won't be freed by it*/
static void gHashTableToGPtrArray(gpointer key __attribute__((unused)),
                                  gpointer value, gpointer data) {
    GPtrArray* array = (GPtrArray*)data;
    g_ptr_array_add(array, value);
}

static gint compareInfoClientQuantityProduct(gconstpointer a, gconstpointer b) {
    InfoClientQuantityProduct i1 = *((InfoClientQuantityProduct*)a);
    InfoClientQuantityProduct i2 = *((InfoClientQuantityProduct*)b);
    int quantity1 = i1->quantity;
    int quantity2 = i2->quantity;
    if (quantity1 > quantity2) {
        return -1;
    } else if (quantity1 == quantity2) {
        return 0;
    } else {
        return 11;
    }
}

/* Given the hashtable present in a clientRecod struct,
 will copy the month's quantity to the mergeHTable*/
static void fillMergeProductQuantityHTable(GHashTable* recordHTable,
                                           GHashTable* mergeHTable, int month) {
    GHashTableIter iter;
    gpointer key, value;
    g_hash_table_iter_init(&iter, recordHTable);
    while (g_hash_table_iter_next(&iter, &key, &value)) {
        ClientProducts clientProducts = (ClientProducts)value;
        char* productID = (char*)key;
        if (clientProducts->quantities[month - 1] > 0) {
            if (g_hash_table_contains(mergeHTable, productID)) {
                InfoClientQuantityProduct i =
                    (InfoClientQuantityProduct)g_hash_table_lookup(mergeHTable,
                                                                   productID);
                i->quantity += clientProducts->quantities[month - 1];
            } else {
                InfoClientQuantityProduct i =
                    malloc(sizeof(struct infoClientQuantityProduct));
                i->id = strdup(productID);
                i->quantity = clientProducts->quantities[month - 1];
                g_hash_table_insert(mergeHTable, strdup(productID), i);
            }
        }
    }
}

/* Creates an hashtable where there will be stored infoClientQuantityProduct
structs, merging info from all the branches*/
static GHashTable* createMergedProductQuantityHTable(const Branch* branches,
                                                     const char* clientID,
                                                     const int month) {
    GHashTable* mergedInfo =
        g_hash_table_new_full(g_str_hash, g_str_equal, free, NULL);
    int branchNumber;
    for (branchNumber = 0; branchNumber < NUMBEROFBRANCHES; branchNumber++) {
        Branch currentBranch = branches[branchNumber];
        if (g_hash_table_contains(currentBranch->clients, clientID)) {
            ClientRecord record =
                g_hash_table_lookup(currentBranch->clients, clientID);
            fillMergeProductQuantityHTable(record->products, mergedInfo, month);
        }
    }
    return mergedInfo;
}

/*Converts a GPtrArray of infoClientQuantityProduct structs
in a GPtrArray only of the productsId's*/
static GPtrArray* convertQuantityInfoPtrArrayToStringPtrArray(
    const GPtrArray* quantityInfoPtrArray, const int length) {
    int i;
    GPtrArray* topNProductsStringArray = g_ptr_array_new_full(length, free);
    for (i = 0; i < length; i++) {
        InfoClientQuantityProduct quantityInfoStruct =
            (InfoClientQuantityProduct)g_ptr_array_index(quantityInfoPtrArray,
                                                         i);
        g_ptr_array_add(topNProductsStringArray,
                        strdup(quantityInfoStruct->id));
    }
    return topNProductsStringArray;
}

/* Query 10 */
GPtrArray* getClientFavoriteProductsBranches(const Branch* branches,
                                             const char* clientID, int* total,
                                             const int month) {
    GHashTable* mergeHTable =
        createMergedProductQuantityHTable(branches, clientID, month);

    int length = (int)g_hash_table_size(mergeHTable);
    *total = length;

    GPtrArray* quantityInfoArray =
        g_ptr_array_new_full(length, freeInfoClientQuantityProduct);
    g_hash_table_foreach(mergeHTable, gHashTableToGPtrArray, quantityInfoArray);
    g_ptr_array_sort(quantityInfoArray, compareInfoClientQuantityProduct);

    GPtrArray* favoriteProductsIds =
        convertQuantityInfoPtrArrayToStringPtrArray(quantityInfoArray, length);

    g_hash_table_destroy(mergeHTable);
    g_ptr_array_free(quantityInfoArray, true);

    return favoriteProductsIds;
}

/* Query 11 */
int getNumberOfCLientsProduct(const Branch branch, const char* productID) {
    ProductRecord p = g_hash_table_lookup(branch->products, productID);
    return (p) ? g_hash_table_size(p->clients) : 0;
}

/* Query 12 + auxiliary structs + functions */

/* struct containing info about how much was spend in a product by a given
 * client*/
typedef struct infoClientExpenditureProduct {
    char* id;
    float expenditure;
} * InfoClientExpenditureProduct;

static InfoClientExpenditureProduct initinfoClientExpenditureProduct() {
    InfoClientExpenditureProduct i =
        malloc(sizeof(struct infoClientExpenditureProduct));
    i->id = NULL;
    i->expenditure = 0;
    return i;
}

static void freeInfoClientExpenditureProduct(void* i) {
    InfoClientExpenditureProduct info = (InfoClientExpenditureProduct)i;
    free(info->id);
    free(info);
}

/* Compare function for two InfoClientExpenditureProduct, returns -1 when its
 * bigger becuase we want it sorted from highest to lowest*/
/* Remember that it recieves pointers to the pointers*/
static gint compareInfoClientExpenditureProduct(gconstpointer a,
                                                gconstpointer b) {
    InfoClientExpenditureProduct i1 = *((InfoClientExpenditureProduct*)a);
    InfoClientExpenditureProduct i2 = *((InfoClientExpenditureProduct*)b);

    float expenditure1 = i1->expenditure;
    float expenditure2 = i2->expenditure;

    if (expenditure1 > expenditure2) {
        return -1;
    } else if (expenditure1 == expenditure2) {
        return 0;
    } else {
        return 1;
    }
}

/*Given an HashTable from the function createMergedInfoHTable, will update the
information about how much the client spent on that product, updating or
creating new InfoClientExpenditureProduct structures*/
static void fillMergedInfoHTable(gpointer key, gpointer value, gpointer data) {
    ClientProducts c = (ClientProducts)value;
    char* productID = (char*)key;
    GHashTable* mergeHTable = (GHashTable*)data;
    if (g_hash_table_contains(mergeHTable, productID)) {
        InfoClientExpenditureProduct i =
            (InfoClientExpenditureProduct)g_hash_table_lookup(mergeHTable,
                                                              productID);
        i->expenditure += c->expenditure;
    } else {
        InfoClientExpenditureProduct i = initinfoClientExpenditureProduct();
        i->id = strdup(productID);
        i->expenditure = c->expenditure;
        g_hash_table_insert(mergeHTable, strdup(productID), i);
    }
}

/* Creates an hashtable where there are stored InfoClientExpenditureProduct
 * containing merged information from all branches*/
static GHashTable* createMergedInfoHTable(const Branch* branches,
                                          const char* clientID) {
    int branchNumber;
    /* Won't use a free function for clientRecords because
    the values will later be transfered to GPtrArray*/
    GHashTable* mergedInfo =
        g_hash_table_new_full(g_str_hash, g_str_equal, free, NULL);
    for (branchNumber = 0; branchNumber < NUMBEROFBRANCHES; branchNumber++) {
        Branch currentBranch = branches[branchNumber];
        if (g_hash_table_contains(currentBranch->clients, clientID)) {
            ClientRecord record =
                g_hash_table_lookup(currentBranch->clients, clientID);
            g_hash_table_foreach(record->products, fillMergedInfoHTable,
                                 mergedInfo);
        }
    }
    return mergedInfo;
}

/* Transfers the first N elements to a new GPtrArray consisting of only the
ids.*/
static GPtrArray* convertInfoPtrArrayToStringPtrArray(GPtrArray* infoPtrArray,
                                                      const int limitLength) {
    int i;
    GPtrArray* topNProductsStringArray =
        g_ptr_array_new_full(limitLength, free);
    InfoClientExpenditureProduct infoStruct;
    for (i = 0; i < limitLength; i++) {
        infoStruct =
            (InfoClientExpenditureProduct)g_ptr_array_index(infoPtrArray, i);
        g_ptr_array_add(topNProductsStringArray, strdup(infoStruct->id));
    }
    return topNProductsStringArray;
}

/*Query 12*/
GPtrArray* getClientTopProfitProductsBranches(const Branch* branches,
                                              const char* clientID, int* length,
                                              const int limit) {
    GHashTable* mergedInfo = createMergedInfoHTable(branches, clientID);
    *length = ((int)g_hash_table_size(mergedInfo) > limit)
                  ? limit
                  : (int)g_hash_table_size(mergedInfo);

    GPtrArray* ptrArray = g_ptr_array_new_full(
        g_hash_table_size(mergedInfo), freeInfoClientExpenditureProduct);
    g_hash_table_foreach(mergedInfo, gHashTableToGPtrArray, ptrArray);
    g_ptr_array_sort(ptrArray, compareInfoClientExpenditureProduct);

    GPtrArray* topNProducts =
        convertInfoPtrArrayToStringPtrArray(ptrArray, *length);

    g_hash_table_destroy(mergedInfo);
    g_ptr_array_free(ptrArray, true);

    return topNProducts;
}

/*FREES*/

void freeBranch(Branch branch) {
    g_hash_table_destroy(branch->products);
    g_hash_table_destroy(branch->clients);
    free(branch);
}
