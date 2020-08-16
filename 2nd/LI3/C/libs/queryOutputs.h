#ifndef QUERYOUTPUTS
#define QUERYOUTPUTS

#include <glib.h>

/**
 *@brief Structure used to store the results of the second query.
 */
typedef struct query2Output* Q2Output;
Q2Output initQ2Output(char** productsList, int length);
char** getQuery2OutputProductsList(Q2Output q);
int getQuery2OutputLength(Q2Output q);
void freeQuery2Output(Q2Output q);

/**
 *@brief Structure used to store the results of the third query.
 */
typedef struct query3Output* Q3Output;
Q3Output initQ3Output(int* numSalesArray, float* valueSalesArray);
int* getQuery3OutputNumSalesArray(Q3Output q);
float* getQuery3OutputValuealesArray(Q3Output q);
void freeQuery3Output(Q3Output q);

/**
 *@brief Structure used to store the results of the fourth query.
 */
typedef struct query4Output* Q4Output;
Q4Output initQ4Output(GPtrArray* productsNotBough, int length);
GPtrArray* getQuery4OutputProductsNotBought(Q4Output q);
int getQuery4OutputLength(Q4Output q);
void freeQuery4Output(Q4Output q);

/**
 *@brief Structure used to store the results of the fifth query.
 */
typedef struct query5Output* Q5Output;
Q5Output initQ5Output(GPtrArray* clientsList, int length);
GPtrArray* getQuery5OutputClientsList(Q5Output q);
int getQuery5OutputLength(Q5Output q);
void freeQuery5Output(Q5Output q);

/**
 *@brief Structure used to store the results of the sixth query.
 */
typedef struct query6Output* Q6Output;
Q6Output initQ6Output(int clientclientsDidntBuy, int productsNotBought);
int getQuery6OutputClientsDidntBuy(Q6Output q);
int getQuery6OutputProductsNotBought(Q6Output q);
void freeQuery6Output(Q6Output q);

/**
 *@brief Structure used to store the results of the seventh query.
 */
typedef struct query7Output* Q7Output;
Q7Output initQ7Output(int** clientQuantities, int* totalQuantityBranches,
                      int* totalQuantityMonths, int totalQuantity);
int getQuery7OutputClientTotalQuantity(Q7Output q);
int* getQuery7OutputClientTotalQuantityBranches(Q7Output q);
int* getQuery7OutputClientTotalQuantityMonths(Q7Output q);
int** getQuery7OutputClientQuantities(Q7Output q);
void freeQuery7Output(Q7Output q);

/**
 *@brief Structure used to store the results of the eighth query.
 */
typedef struct query8Output* Q8Output;
Q8Output initQ8Output(int numSales, double valueSales);
int getQuery8OutputNumSales(Q8Output q);
double getQuery8OutputValueSales(Q8Output q);
void freeQuery8Output(Q8Output q);

/**
 *@brief Structure used to store the results of the ninth query.
 */
typedef struct query9Output* Q9Output;
Q9Output initQ9Output(GPtrArray* arrayN, GPtrArray* arrayP, int totalN,
                      int totalP);
int getQuery9OutputTotalN(Q9Output q);
int getQuery9OutputTotalP(Q9Output q);
GPtrArray* getQuery9OutputArrayN(Q9Output q);
GPtrArray* getQuery9OutputArrayP(Q9Output q);
void freeQuery9Output(Q9Output q);

/**
 *@brief Structure used to store the results of the tenth query.
 */
typedef struct query10Output* Q10Output;
Q10Output initQ10Output(GPtrArray* productsArray, int length);
GPtrArray* getQuery10OutputProductsArray(Q10Output q);
int getQuery10OutputLength(Q10Output q);
void freeQuery10Output(Q10Output q);

/**
 *@brief Structure used to store the results of the eleventh query.
 */
typedef struct query11Output* Q11Output;
Q11Output initQ11Output(GPtrArray* productInfoArray, int length);
GPtrArray* getQuery11OutputProductInfoArray(Q11Output q);
int getQuery11OutputLength(Q11Output q);
void freeQuery11Output(Q11Output q);

/**
 *@brief Structure used to store the results of the twelveth query.
 */
typedef struct query12Output* Q12Output;
Q12Output initQ12Output(GPtrArray* topProfitProducts, int length);
GPtrArray* getQuery12OutputTopProfitProducts(Q12Output q);
int getQuery12OutputLength(Q12Output q);
void freeQuery12Output(Q12Output q);

/**
 *@brief Structure used to store the results of the thirteenth query.
 */
typedef struct query13Output* Q13Output;
Q13Output initQ13Output(char* productsFilePath, int productsRead,
                        int productsValidated, char* clientsFilePath,
                        int clientsRead, int clientsValidated,
                        char* salesFilePath, int salesRead, int salesValidated);

char* getQuery13OutputProductsFilePath(Q13Output q);
int getQuery13OutputProductsRead(Q13Output q);
int getQuery13OutputProductsValidated(Q13Output q);

char* getQuery13OutputClientsFilePath(Q13Output q);
int getQuery13OutputClientsRead(Q13Output q);
int getQuery13OutputClientsValidated(Q13Output q);

char* getQuery13OutputSalesFilePath(Q13Output q);
int getQuery13OutputSalesRead(Q13Output q);
int getQuery13OutputSalesValidated(Q13Output q);
void freeQuery13Output(Q13Output q);
#endif
