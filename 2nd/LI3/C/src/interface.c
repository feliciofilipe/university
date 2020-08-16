#include "../include/interface.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/branch.h"
#include "../include/clients.h"
#include "../libs/config.h"
#include "../include/products.h"
#include "../include/totalSales.h"
#include "../libs/productInfo.h"



struct sgv {
    Products products;
    char* productsFilePath;
    int productsRead;
    int productsValidated;

    Clients clients;
    char* clientsFilePath;
    int clientsRead;
    int clientsValidated;

    TotalSales totalSales;
    char* salesFilePath;
    int salesRead;
    int salesValidated;

    Branch branches[NUMBEROFBRANCHES];
};

SGV initSGV() {
    SGV sgv = malloc(sizeof(struct sgv));

    sgv->products = initProducts();
    sgv->productsFilePath = NULL;
    sgv->productsRead = 0;
    sgv->productsValidated = 0;

    sgv->clients = initClients();
    sgv->clientsFilePath = NULL;
    sgv->clientsRead = 0;
    sgv->clientsValidated = 0;

    sgv->totalSales = initTotalSales();
    sgv->salesFilePath = NULL;
    sgv->salesRead = 0;
    sgv->salesValidated = 0;

    int i;
    for (i = 0; i < NUMBEROFBRANCHES; i++) {
        sgv->branches[i] = initBranch();
    }
    return sgv;
}


/**
*@brief Validates a sale.
*@param products Struct containing valid products.
*@param clients Struct containing valid products.
*@param productID Id of the product mentioned in a sale record.
*@param clientID Id of the client mentioned in a sale record.
*@param n_parameters Number of paramaters returned by the sscanf function when reading a sale record.
*/
static bool validateSale(const Products products, const Clients clients,
                  const char* productID, const char* clientID, int n_parameters,
                  float price, int units, char type, int month, int branch) {
    return n_parameters == 7 && existsProduct(products, productID) &&
           existsClient(clients, clientID) && price >= 0 && price < 1000 &&
           units >= 1 && units <= 200 && (type == 'N' || type == 'P') &&
           month >= 1 && month <= 12 && branch >= 1 && branch <= NUMBEROFBRANCHES;
}

/**
*@brief Reads the sales list and updates de sales structure with valid sales.
*@param sgv the sgv structure in which the information will be stored
*@param salesPath Path to the sales file to be read. 
*/
static void readSalesList(SGV sgv, const char* salesPath) {
    Products products = sgv->products;
    Clients clients = sgv->clients;
    TotalSales totalSales = sgv->totalSales;
    Branch* branches = sgv->branches;

    char* buf = malloc(sizeof(char) * 40);
    FILE* fptr = fopen(salesPath, "r");
    if (fptr) {
        char* productID =
            malloc(sizeof(char) * SIZEIDPRODUCT + 1); 
        float price;
        int units;
        char type;
        char* clientID =
            malloc(sizeof(char) * SIZEIDCLIENT + 1);
        int month;
        int branch;
        int n_parameters = 0;
        char* str =
            malloc(sizeof(char) *
                   12); /* any int fits in a string o size 12 */
        while (fgets(buf, 45, fptr)) {
            sgv->salesRead++;
            n_parameters =
                sscanf(buf, "%s %f %d %c %s %d %d", productID, &price, &units,
                       &type, clientID, &month, &branch);

            if (validateSale(products, clients, productID, clientID,
                             n_parameters, price, units, type, month, branch)) {
                sgv->salesValidated++;

                updateSales(totalSales, productID, price, units, type, month,
                              branch);
                updateBranchesBoughtClients(clients, clientID, branch);

                updateBranchesBoughtProducts(products, productID, branch);

                updateBranch(branches[branch - 1], productID, clientID, month,
                             units, type, price);
            }
        }
        free(str);
        free(clientID);
        free(productID);
        fclose(fptr);
    }
    free(buf);
}


/** 
 *@brief Reads the client file and creates a structure containing valid clients.
 *@param sgv the sgv structure in which the information will be stored
 *@param clientsPath Path to the clients file to be read.
 */
static void readClientsList(const SGV sgv, const char* clientsPath) {
    Clients clients = sgv->clients;
    char* buf = malloc(sizeof(char) * 10);
    FILE* fptr = fopen(clientsPath, "r");
    if (fptr) {
        while (fgets(buf, 10, fptr)) {
            sgv->clientsRead++;
            buf = strtok(buf, "\r\n");
            if (validateClient(buf)) {
                sgv->clientsValidated++;
                Client client = initClient(buf);
                addClient(clients, client);
            }
        }
    	fclose(fptr);
    }
    free(buf);
}

/** 
 *@brief Reads the product file and creates a structure containing valid products.
 *@param sgv the sgv structure in which the information will be stored
 *@param productsPath Path to the products file to be read.
 */
static void readProductsList(const SGV sgv, const char* productsPath) {
    Products products = sgv->products;
    char* buf = malloc(sizeof(char) * 10);
    FILE* fptr = fopen(productsPath, "r");

    if (fptr) {
        while (fgets(buf, 10, fptr)) {
            sgv->productsRead++;
            buf = strtok(buf, "\r\n");
            if (validateProduct(buf)) {
                sgv->productsValidated++;
                Product prod = initProduct(buf);
                addProduct(products, prod);
            }
        }
    fclose(fptr);
    }
    free(buf);
}


SGV loadSGVFromFiles(SGV sgv, const char* clientsFilePath,
                      const char* productsFilePath, const char* salesFilePath) {

    sgv->productsFilePath = strdup(productsFilePath);
    readProductsList(sgv, productsFilePath);

    sgv->clientsFilePath = strdup(clientsFilePath);
    readClientsList(sgv,clientsFilePath);

    sgv->salesFilePath = strdup(salesFilePath);
    readSalesList(sgv, salesFilePath);

    return sgv;
    
}

/*Query 2*/
Q2Output getProductsStartedByLetter(const SGV sgv, const char letter) {
    int length = 0;
    char** productsList = getProductsByLetter(sgv->products, letter, &length);
    Q2Output q = initQ2Output(productsList, length);
    return q;
}

/*Query 3*/
Q3Output getProductSalesAndProfit(const SGV sgv, const char* productID,
                                  int month) {
    int* numSalesArray = calloc(NUMBEROFBRANCHES * 2, sizeof(int));
    float* valueSalesArray = calloc(NUMBEROFBRANCHES * 2, sizeof(float));
    getProductSalesAndProfitTotalSales(sgv->totalSales, productID, month,
                                       numSalesArray, valueSalesArray);
    Q3Output q = initQ3Output(numSalesArray, valueSalesArray);
    return q;
}

/* Query 4*/
Q4Output getProductsNeverBought(const SGV sgv, const int branchId) {
    int length = 0;
    GPtrArray* productsNotBoughtArray =
        productsNotBought(sgv->products, branchId, &length);
    Q4Output q = initQ4Output(productsNotBoughtArray, length);
    return q;
}

/* Query 5*/
Q5Output getClientsOfALLBranches(const SGV sgv) {
    int length = 0;
    GPtrArray* clientsList =
        getClientsOfALLBranchesClients(sgv->clients, &length);
    Q5Output q = initQ5Output(clientsList, length);
    return q;
}

/* Query 6*/
Q6Output getClientsAndProductsNeverBoughtCount(const SGV sgv) {
    int clientsDidntBuy = numClientsDidntBuy(sgv->clients);
    int productsNotBought = numProductsNotBought(sgv->products);
    Q6Output q = initQ6Output(clientsDidntBuy, productsNotBought);
    return q;
}

/* Query 7 */
Q7Output getProductsBoughtByClient(const SGV sgv, const char* clientID) {
    int branch, month;

    int** clientQuantities = malloc(NUMBEROFBRANCHES * sizeof(int*));
    for (branch = 0; branch < NUMBEROFBRANCHES; branch++) {
        clientQuantities[branch] =
            getClientQuantitiesByBranch(sgv->branches[branch], clientID);
    }

    int* totalQuantityBranches = calloc(NUMBEROFBRANCHES, sizeof(int));
    int* totalQuantityMonths = calloc(NMONTHS, sizeof(int));
    int totalQuantity = 0;

    for (branch = 0; branch < NUMBEROFBRANCHES; branch++) {
        for (month = 0; month < NMONTHS; month++) {
            totalQuantityBranches[branch] += clientQuantities[branch][month];
            totalQuantityMonths[month] += clientQuantities[branch][month];
            totalQuantity += clientQuantities[branch][month];
        }
    }

    Q7Output q = initQ7Output(clientQuantities, totalQuantityBranches,
                              totalQuantityMonths, totalQuantity);
    return q;
}

/* Query 8 */
Q8Output getSalesAndProfits(const SGV sgv, int minMonth, int maxMonth) {
    int numSales = 0;
    double valueSales = 0;
    getGlobalSalesInfoInterval(sgv->totalSales, minMonth, maxMonth, &(numSales),
                               &(valueSales));
    Q8Output q = initQ8Output(numSales, valueSales);
    return q;
}

/* Query 9 */
Q9Output getProductBuyers(const SGV sgv, const char* productID, int branch) {
    GPtrArray* arrayN = NULL;
    GPtrArray* arrayP = NULL;
    int totalN = 0;
    int totalP = 0;

    getClientsThatBoughtProductByBranch(sgv->branches[branch - 1], productID,
                                        &(arrayN), &(arrayP), &(totalN),
                                        &(totalP));
    Q9Output q = initQ9Output(arrayN, arrayP, totalN, totalP);
    return q;
}

/* Query 10*/
Q10Output getClientFavoriteProducts(const SGV sgv, const char* clientID,
                                    int month) {
    int length = 0;
    GPtrArray* productsArray = getClientFavoriteProductsBranches(
        sgv->branches, clientID, &(length), month);

    Q10Output q = initQ10Output(productsArray, length);
    return q;
}

/* Query 11*/
Q11Output getTopSelledProducts(const SGV sgv, int limit) {
    int length = 0;
    int i, branch;
    char* productID;

    GPtrArray* productInfoArray =
        getAllProductsSalesInfo(sgv->totalSales, &length);
    
    int trueLength = (limit < length) ? limit : length;
    for (i = 0; i < trueLength; i++) {
        ProductInfo productInfo =
            (ProductInfo)g_ptr_array_index(productInfoArray, i);
        productID = getProductInfoProductId(productInfo);
        for (branch = 1; branch <= NUMBEROFBRANCHES; branch++) {
            setProductInfoNumberOfClients(
                productInfo, branch,
                getNumberOfCLientsProduct(sgv->branches[branch - 1],
                                          productID));
        }
        free(productID);
    }

    GPtrArray* topProducts =
        g_ptr_array_new_full(trueLength, (GDestroyNotify)freeProductInfo);
    for (i = 0; i < trueLength; i++) {
        g_ptr_array_insert(topProducts, i,
                           productInfoClone((ProductInfo)g_ptr_array_index(
                               productInfoArray, i)));
    }

    g_ptr_array_free(productInfoArray, true);
    Q11Output q = initQ11Output(topProducts, trueLength);
    return q;
}

/* Query 12*/
Q12Output getClientTopProfitProducts(const SGV sgv, const char* clientID,
                                     int limit) {
    int length = 0;
    GPtrArray* topProfitProducts = getClientTopProfitProductsBranches(
        sgv->branches, clientID, &(length), limit);

    Q12Output q = initQ12Output(topProfitProducts, length);
    return q;
}

/* Query 13 */
Q13Output getCurrentFilesInfo(const SGV sgv) {
    char* productsFilePath = strdup(sgv->productsFilePath);
    int productsRead = sgv->productsRead;
    int productsValidated = sgv->productsValidated;

    char* clientsFilePath = strdup(sgv->clientsFilePath);
    int clientsRead = sgv->clientsRead;
    int clientsValidated = sgv->clientsValidated;

    char* salesFilePath = strdup(sgv->salesFilePath);
    int salesRead = sgv->salesRead;
    int salesValidated = sgv->salesValidated;

    Q13Output q =
        initQ13Output(productsFilePath, productsRead, productsValidated,
                      clientsFilePath, clientsRead, clientsValidated,
                      salesFilePath, salesRead, salesValidated);
    return q;
}

void destroySGV(SGV sgv) {
    freeProducts(sgv->products);
    free(sgv->productsFilePath);
    freeClients(sgv->clients);
    free(sgv->clientsFilePath);
    freeTotalSales(sgv->totalSales);
    free(sgv->salesFilePath);
    int i;
    for (i = 0; i < NUMBEROFBRANCHES; i++) {
        freeBranch(sgv->branches[i]);
    }
    free(sgv);
}
