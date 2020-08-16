/**
 @file products.h
 \brief Module reesponsible for storing all the products
*/

#ifndef PRODUCTS
#define PRODUCTS

#include <glib.h>

#include "product.h"

/**
 *@brief Structure which stores all the Product structures
*/
typedef struct products* Products;

/**
 *@brief Initializes the Products structure
*/
Products initProducts();

/**
 *@brief Updates a Product based on if it was bought in a specific branch.
 *@param products Structure containing products.
 *@param productID ID of the product to be updated.
 *@param branch Number that indentifies the branch.
 */
void updateBranchesBoughtProducts(Products products, const char* productID,
                                  int branch);

/**
 *@brief Checks if a product exists.
 *@param products Structure containing products.
 *@param productID ID of the product to be searched.
 */
bool existsProduct(const Products products, const char* productID);

/**
 *@brief Adds a product.
 *@param products Structure containing products.
 *@param product Product to be added.
 */
void addProduct(Products products, const Product product);

/**
 *@brief Returns an array of products starting by a specified letter.
 *@param products Structure containing products.
 *@param letter Letter that must be the first character of the products ids.
 *@param productsArrayLength Pointer to an integer that must be updated to the
 *length of the returning array.
 */
char** getProductsByLetter(const Products products, char letter,
                           int* productsArrayLength);

GPtrArray* getProductsByLetter2(const Products products, char letter,
                                int* productsArrayLength);

/**
 *@brief Counts the number of products that were never bought.
 */
int numProductsNotBought(const Products products);

/**
 *@brief Returns an array of products that were never bought, specified by
 *branch.
 *@param products Structure containing products.
 *@param branch Number identifying the branch.
 *@param length Pointer to an integer that must be updated to the length of the
 *returning array.
 */
GPtrArray* productsNotBought(const Products products, int branch, int* length);

/**
 * @brief frees the products structure
 * @param products The products structure to be freed
 */
void freeProducts(Products products);

#endif
