/**
 @file product.h
 \brief Module responsible for holding the information about
        one product*/
#ifndef PRODUCT
#define PRODUCT

#include <stdbool.h>

#include "../libs/config.h"

/** 
*@brief Structures which holds information about a product
 */
typedef struct product* Product;

/**
*@brief Initializes the product structure
*/
Product initProduct(char* id);

/**
 *@brief Returns the id of a product.
 */
char* getProductID(const Product prod);

/**
 *@brief Checks if the given ID is valid
 *@param id id to be ckecked
 *
 */
bool validateProduct(const char* id);

/**
 *@brief Updates a Product based on if it was bought in a specific branch.
 *@param product Product to check
 *@param branch Number that indentifies the branch.
 */
void updateBranchesBoughtProduct(const Product product, int branch);

/**
 *@brief Verifies if a product was never bought.
 *@param product Product to check
 *@param branch Number that indentifies the branch.
 */
bool productWasntBought(Product product, int branch);

/**
 *@brief Frees a product
 *@param p Product to be freed
 */
void freeProduct(void* p);

#endif
