#ifndef BRANCH
#define BRANCH

#include <glib.h>

/**
 *@brief structure which holds information relating clients to the products 
 they bought and products to the clients which bought them in a specific
 branch
*/
typedef struct branch* Branch;

/**
*@brief Instanciates the branch structure
*/
Branch initBranch();

/**
 *@brief Updates the values of a product and client record in the branch
 *structure.
 *@param branch Branch structure containing the record to be updated.
 *@param productID Id of the product who was bought
 *@param clientID Id of the client who bought
 *@param month month of the sales
 *@param quantities number of units bought
 *@param type int signalling the type of sale
 *@param price price of a unit
 */
void updateBranch(Branch branch, char* productID, char* clientID, int month,
                  int quantities, int type, float price);

/* Query 7*/
/**
 *@brief Gets the quantity of products bought by a certain client for each
 *month.
 *@param branch Branch structure containing the record to be updated.
 *@param clientID Id of the client to be searched.
 *@return Array with 12 elements corresponding to the quantity of products
 *bought by the selected client for each month.
 */
int* getClientQuantitiesByBranch(const Branch branch, const char* clientID);

/* Query 9*/

/**
 *@brief Gets the ids of clients that purchased the selected product, separating
 *by sales of type N and P.
 *@param branch Branch structure containing the record to be updated.
 *@param productID Id of the product to be searched.
 *@param arrayN Array with client ids that bought product with type N.
 *@param arrayP Array with client ids that bought product with type P.
 *@param totalN Pointer to an integer to be updated with the length of 'arrayN'.
 *@param totalP Pointer to an integer to be updated with the length of 'arrayP'.
 */
void getClientsThatBoughtProductByBranch(const Branch branch,
                                         const char* productID,
                                         GPtrArray** arrayN, GPtrArray** arrayP,
                                         int* totalN, int* totalP);

/* Query 10 */

/**
 *@brief For a chosen client and month, gets the list of most purchased products
 *by the client, by descending order.
 *@param branches array of branches
 *@param clientID Id of the chosen client.
 *@param total Pointer to an integer that must be updated with the length of
 *returning array.
 *@param month Month to be checked
 */
GPtrArray* getClientFavoriteProductsBranches(const Branch* branches,
                                             const char* clientID, int* total,
                                             const int month);

/*Part of Query 11*/
/**
 @brief For a chosen product, gets the number of clients who bought it in a
 specific branch.
 *@param branch Branch structure to be checked
 *@param productID Id of the chosen product.
 */
int getNumberOfCLientsProduct(const Branch branch, const char* productID);

/*Funções relativas unicamente à query 12*/
/**
 *@brief For a chosen client, gets the list of products the client spent the
 *most on, by descending order.
 *@param branches array of branches
 *@param clientID Id of the chosen client.
 *@param length Pointer to an integer that must be updated with the length of
 *returning array.
 *@param limit Limit of products to be presented.
 */
GPtrArray* getClientTopProfitProductsBranches(const Branch* branches,
                                              const char* clientID, int* length,
                                              const int limit);

/*Frees the memory allocated to the Branch structure*/
void freeBranch(Branch branch);
#endif
