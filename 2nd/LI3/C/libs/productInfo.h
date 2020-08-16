/**
 @file productInfo.h
 \brief Auxiliary structure for query 11, hold information about the number of
 units sold and the number of clients of a given product
*/
#include "../libs/config.h"

typedef struct productInfo* ProductInfo;

ProductInfo initProductInfo(char* productID);

/*Setters/Updates*/

/**
 * @brief Updates units sold, based on quantity sold and branch number.
 */
void setProductInfoUnitsSold(ProductInfo p, int branch, int units);

/**
 * @brief Updates units sold, based on quantity sold and branch number.
 */
void setProductInfoNumberOfClients(ProductInfo p, int branch, int numClients);

/* Getters*/

/**
 * @brief Returns the id of a product.
 */
char* getProductInfoProductId(const ProductInfo p);
/**
 * @brief Returns the number of units sold from a branch.
 */
int getProductInfoUnitsSold(const ProductInfo p, int branch);
/**
 * @brief Returns the number of clients who bought the product from a branch.
 */
int getProductInfoNumberOfClients(const ProductInfo p, int branch);

/**
 * @brief returns a copy of the productInfo structure
 */
ProductInfo productInfoClone(const ProductInfo p);

void freeProductInfo(void* p);
