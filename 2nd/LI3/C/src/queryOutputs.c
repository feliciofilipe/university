#include "../libs/queryOutputs.h"
#include <glib.h>
#include <stdbool.h>
#include <stdlib.h>
#include "../libs/config.h"


/* Query 2 */
struct query2Output {
    char** productsList;
    int length;
};

Q2Output initQ2Output(char** productsList, int length) {
    Q2Output q = malloc(sizeof(struct query2Output));
    q->productsList = productsList;
    q->length = length;
    return q;
}

char** getQuery2OutputProductsList(Q2Output q) { return q->productsList; }

int getQuery2OutputLength(Q2Output q) { return q->length; }

void freeQuery2Output(Q2Output q) {
    int i;
    for (i = 0; i < q->length; i++) {
        free(q->productsList[i]);
    }
    free(q->productsList);
    free(q);
}

/* Query 3*/
struct query3Output {
    int* numSalesArray; /* Primeiros 3 -> N, filial 1, 2 e 3*/
    float* valueSalesArray;
};

Q3Output initQ3Output(int* numSalesArray, float* valueSalesArray) {
    Q3Output q = malloc(sizeof(struct query3Output));
    q->numSalesArray = numSalesArray;
    q->valueSalesArray = valueSalesArray;
    return q;
}

int* getQuery3OutputNumSalesArray(Q3Output q) { return q->numSalesArray; }

float* getQuery3OutputValuealesArray(Q3Output q) { return q->valueSalesArray; }

void freeQuery3Output(Q3Output q) {
    free(q->numSalesArray);
    free(q->valueSalesArray);
    free(q);
}

/* Query 4 */
struct query4Output {
    GPtrArray* productsNotBought;
    int length;
};

Q4Output initQ4Output(GPtrArray* productsNotBough, int length) {
    Q4Output q = malloc(sizeof(struct query4Output));
    q->productsNotBought = productsNotBough;
    q->length = length;
    return q;
}

GPtrArray* getQuery4OutputProductsNotBought(Q4Output q) {
    return q->productsNotBought;
}

int getQuery4OutputLength(Q4Output q) { return q->length; }

void freeQuery4Output(Q4Output q) {
    g_ptr_array_free(q->productsNotBought, true);
    free(q);
}

/* Query 5 */
struct query5Output {
    GPtrArray* clientsList;
    int length;
};

Q5Output initQ5Output(GPtrArray* clientsList, int length) {
    Q5Output q = malloc(sizeof(struct query5Output));
    q->clientsList = clientsList;
    q->length = length;
    return q;
};

GPtrArray* getQuery5OutputClientsList(Q5Output q) { return q->clientsList; }

int getQuery5OutputLength(Q5Output q) { return q->length; }

void freeQuery5Output(Q5Output q) {
    g_ptr_array_free(q->clientsList, true);
    free(q);
}

/* Query 6 */
struct query6Output {
    int clientsDidntBuy;
    int productsNotBought;
};

Q6Output initQ6Output(int clientclientsDidntBuy, int productsNotBought) {
    Q6Output q = malloc(sizeof(struct query6Output));
    q->clientsDidntBuy = clientclientsDidntBuy;
    q->productsNotBought = productsNotBought;
    return q;
}

int getQuery6OutputClientsDidntBuy(Q6Output q) { return q->clientsDidntBuy; }

int getQuery6OutputProductsNotBought(Q6Output q) {
    return q->productsNotBought;
}

void freeQuery6Output(Q6Output q) { free(q); }

/* Query 7 */
struct query7Output {
    int** clientQuantities;     /* [NUMBEROFBRANCHES][NMONTHS] */
    int* totalQuantityBranches; /* [NUMBEROFBRANCHES] */
    int* totalQuantityMonths;   /*[NMONTHS]*/
    int totalQuantity;
};

Q7Output initQ7Output(int** clientQuantities, int* totalQuantityBranches,
                      int* totalQuantityMonths, int totalQuantity) {
    Q7Output q = malloc(sizeof(struct query7Output));
    q->clientQuantities = clientQuantities;
    q->totalQuantityBranches = totalQuantityBranches;
    q->totalQuantityMonths = totalQuantityMonths;
    q->totalQuantity = totalQuantity;
    return q;
}

int getQuery7OutputClientTotalQuantity(Q7Output q) { return q->totalQuantity; }

int* getQuery7OutputClientTotalQuantityBranches(Q7Output q) {
    return q->totalQuantityBranches;
}

int* getQuery7OutputClientTotalQuantityMonths(Q7Output q) {
    return q->totalQuantityMonths;
}

int** getQuery7OutputClientQuantities(Q7Output q) {
    return q->clientQuantities;
}

void freeQuery7Output(Q7Output q) {
    int branch = 0;
    for (branch = 0; branch < NUMBEROFBRANCHES; branch++)
        free(q->clientQuantities[branch]);
    free(q->clientQuantities);
    free(q->totalQuantityBranches);
    free(q->totalQuantityMonths);
    free(q);
}

/* Query 8 */
struct query8Output {
    int numSales;
    double valueSales;
};

Q8Output initQ8Output(int numSales, double valueSales) {
    Q8Output q = malloc(sizeof(struct query8Output));
    q->numSales = numSales;
    q->valueSales = valueSales;
    return q;
}

int getQuery8OutputNumSales(Q8Output q) { return q->numSales; }

double getQuery8OutputValueSales(Q8Output q) { return q->valueSales; }

void freeQuery8Output(Q8Output q) { free(q); }

/* Query9 */
struct query9Output {
    GPtrArray* arrayN;
    GPtrArray* arrayP;
    int totalN;
    int totalP;
};

Q9Output initQ9Output(GPtrArray* arrayN, GPtrArray* arrayP, int totalN,
                      int totalP) {
    Q9Output q = malloc(sizeof(struct query9Output));
    q->arrayN = arrayN;
    q->arrayP = arrayP;
    q->totalN = totalN;
    q->totalP = totalP;
    return q;
}

int getQuery9OutputTotalN(Q9Output q) { return q->totalN; }

int getQuery9OutputTotalP(Q9Output q) { return q->totalP; }

GPtrArray* getQuery9OutputArrayN(Q9Output q) { return q->arrayN; }

GPtrArray* getQuery9OutputArrayP(Q9Output q) { return q->arrayP; }

void freeQuery9Output(Q9Output q) {
    g_ptr_array_free(q->arrayN, true);
    g_ptr_array_free(q->arrayP, true);
    free(q);
}

/* Query10 */
struct query10Output {
    GPtrArray* productsArray;
    int length;
};

Q10Output initQ10Output(GPtrArray* productsArray, int length) {
    Q10Output q = malloc(sizeof(struct query10Output));
    q->productsArray = productsArray;
    q->length = length;
    return q;
}

GPtrArray* getQuery10OutputProductsArray(Q10Output q) {
    return q->productsArray;
}

int getQuery10OutputLength(Q10Output q) { return q->length; }

void freeQuery10Output(Q10Output q) {
    g_ptr_array_free(q->productsArray, true);
    free(q);
}

/* Query11 */
struct query11Output {
    GPtrArray* productInfoArray;
    int length;
};

Q11Output initQ11Output(GPtrArray* productInfoArray, int length) {
    Q11Output q = malloc(sizeof(struct query11Output));
    q->productInfoArray = productInfoArray;
    q->length = length;
    return q;
}

GPtrArray* getQuery11OutputProductInfoArray(Q11Output q) {
    return q->productInfoArray;
}
int getQuery11OutputLength(Q11Output q) { return q->length; }

void freeQuery11Output(Q11Output q) {
    g_ptr_array_free(q->productInfoArray, true);
    free(q);
}

/* Query 12 */
struct query12Output {
    GPtrArray* topProfitProducts;
    int length;
};

Q12Output initQ12Output(GPtrArray* topProfitProducts, int length) {
    Q12Output q = malloc(sizeof(struct query12Output));
    q->topProfitProducts = topProfitProducts;
    q->length = length;
    return q;
}

GPtrArray* getQuery12OutputTopProfitProducts(Q12Output q) {
    return q->topProfitProducts;
}

int getQuery12OutputLength(Q12Output q) { return q->length; }

void freeQuery12Output(Q12Output q) {
    g_ptr_array_free(q->topProfitProducts, true);
    free(q);
}

/* Query 13 */
struct query13Output {
    char* productsFilePath;
    int productsRead;
    int productsValidated;

    char* clientsFilePath;
    int clientsRead;
    int clientsValidated;

    char* salesFilePath;
    int salesRead;
    int salesValidated;
};

Q13Output initQ13Output(char* productsFilePath, int productsRead,
                        int productsValidated, char* clientsFilePath,
                        int clientsRead, int clientsValidated,
                        char* salesFilePath, int salesRead,
                        int salesValidated) {
    Q13Output q = malloc(sizeof(struct query13Output));

    q->productsFilePath = productsFilePath;
    q->productsRead = productsRead;
    q->productsValidated = productsValidated;

    q->clientsFilePath = clientsFilePath;
    q->clientsRead = clientsRead;
    q->clientsValidated = clientsValidated;

    q->salesFilePath = salesFilePath;
    q->salesRead = salesRead;
    q->salesValidated = salesValidated;
    return q;
}

char* getQuery13OutputProductsFilePath(Q13Output q) {
    return q->productsFilePath;
}

int getQuery13OutputProductsRead(Q13Output q) { return q->productsRead; }

int getQuery13OutputProductsValidated(Q13Output q) {
    return q->productsValidated;
}

char* getQuery13OutputClientsFilePath(Q13Output q) {
    return q->clientsFilePath;
}

int getQuery13OutputClientsRead(Q13Output q) { return q->clientsRead; }

int getQuery13OutputClientsValidated(Q13Output q) {
    return q->clientsValidated;
}

char* getQuery13OutputSalesFilePath(Q13Output q) { return q->salesFilePath; }

int getQuery13OutputSalesRead(Q13Output q) { return q->salesRead; }

int getQuery13OutputSalesValidated(Q13Output q) { return q->salesValidated; }

void freeQuery13Output(Q13Output q) {
    free(q->productsFilePath);
    free(q->clientsFilePath);
    free(q->salesFilePath);
    free(q);
}