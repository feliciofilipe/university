/**
 @file interface.h
 \brief Module where the SGV is implemented. The main module of the Module
 layer.
*/
#ifndef INTERFACE
#define INTERFACE

#include <glib.h>

#include "../libs/queryOutputs.h"

/**
 *@brief Main structure which encapsulates all the structures which hold information
 about the sales systeam
 */ 
typedef struct sgv* SGV;

/**
 *@brief Initializes the SGV structure
 */
SGV initSGV();

/**
 *@brief Read the clients, products and sales file names, checking if the
 *entries are valid and then process the information, loading it in it’s data
 *structures.
 *@param sgv the SGV structure
 *@param clientsFilePath Path to the clients file.
 *@param productsFilePath Path to the products file.
 *@param salesFilePath Path to the sales file.
 */
SGV loadSGVFromFiles(SGV sgv, const char* clientsFilePath,
                     const char* productsFilePath, const char* salesFilePath);
/**
 *@brief List all the products whose IDs start by a user provided character.
 *@param sgv the SGV structure
 *@param letter Character provided by the user.
 */
Q2Output getProductsStartedByLetter(const SGV sgv, const char letter);

/**
 *@brief  Given a product’s ID and a month,  return the number of sales and the
 *total value billed for that product.
 *@param sgv the SGV structure
 *@param productID Id of the chosen product.
 *@param month Chosen month.
 */
Q3Output getProductSalesAndProfit(const SGV sgv, const char* productID,
                                  int month);

/**
 *@brief Return a list of products which were never bought, alphabetically
 *ordered by their ID. Theuser can decide if he wants to check globally or by
 *branch.
 *@param sgv the SGV structure
 *@param branchID Number identifying the chosen branch.
 */
Q4Output getProductsNeverBought(const SGV sgv, const int branchID);

/**
 *@brief  Return a list of clients who bought in all branches, also
 *alphabetically ordered  by their ID.
 *@param sgv the SGV structure
 */
Q5Output getClientsOfALLBranches(const SGV sgv);

/**
 *@brief Determine the number of clients who never bought anything, as well as
 *the number of products which were never bought.
 *@param sgv the SGV structure
 */
Q6Output getClientsAndProductsNeverBoughtCount(const SGV sgv);

/**
 *@brief Given a client's ID, create a table a table with the number of products
 *bought by that client. The table must be divided by month and branch.
 *@param sgv the SGV structure
 *@param clientID Id of the chosen client.
 */
Q7Output getProductsBoughtByClient(const SGV sgv, const char* clientID);

/**
 *@brief Determine the number and value of the sales that happened between a
 *defined month interval.
 *@param sgv the SGV structure
 *@param minMonth First month of the specified timeframe.
 *@param maxMonth Last month of the specified timeframe.
 */
Q8Output getSalesAndProfits(const SGV sgv, int minMonth, int maxMonth);

/**
 *@brief  Given a product's ID and a branch number, list the ID's of the clients
 *who bought it, distinguishing them by if the client  bought it normally or
 *bought it at a discount.
 *@param sgv the SGV structure
 *@param productID Id of the chosen product.
 *@param branch Number identifying the chosen branch.
 */
Q9Output getProductBuyers(const SGV sgv, const char* productID, int branch);

/**
 *@brief  Given a client's ID and a month, list the ID's of the products he
 *bought more units. The list must be ordered  by the number of units bought, in
 *descending order.
 *@param sgv the SGV structure
 *@param clientID Id of the chosen client.
 *@param month The month of the sales in which we want do determine the units
 *bougtht
 */
Q10Output getClientFavoriteProducts(const SGV sgv, const char* clientID,
                                    int month);

/**
 *@brief  List the N most sold products during the whole year. For each product,
 *the number of sales and clients of that product in each branch must also be
 *presented.
 *@param sgv the SGV structure
 *@param limit Max number of products to be shown.
 */
Q11Output getTopSelledProducts(const SGV sgv, int limit);

/**
 *@brief  Given a client's ID, list the N products in which the client spent
 *more money.
 *@param sgv the SGV structure
 *@param clientID Id of the chosen client.
 *@param limit Max number of products to be shown.
 */
Q12Output getClientTopProfitProducts(const SGV sgv, const char* clientID,
                                     int limit);

/**
 *@brief  Show a summary of what happened in query 1. This summary must include
 *the path of each file read, as well as the number of lines read and the number
 *of lines which were valid.
 *@param sgv the SGV structure
 */
Q13Output getCurrentFilesInfo(const SGV sgv);

/**
 *@brief Frees the SGV structure
 *@param sgv the structure to be freed
 */
void destroySGV(SGV sgv);

#endif
