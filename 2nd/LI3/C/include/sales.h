/**
 @file sales.h
 \brief Module responsible for holding the
        information about the sales of a product
*/
#ifndef SALES
#define SALES

/**
 *@brief Structure which holds the
        information about the sales of a product
*/
typedef struct sales* Sales;

/**
 *@brief Initializes the sales structure
 */
Sales initSales();

/**
 *@brief Adds a sale to the Sales structure.
 */
void addSale(Sales sales, float price, int units, char type, int month,
             int branch);

/**
* @brief Returns the quantity and value of sales for a specific month.
Auxilliary function, called by getProductSalesAndProfitTotalSales in sales.c.
 *@param sales Sales struct with info to obtain.
 *@param month Month to be searched.
 *@param numSalesArray 12-element array used to return the quantity of sales.
 *@param valueSalesArray 12-element array used to return the value of sales.
*/
void getSalesInfoInMonthByBranch(const Sales sales, int month,
                                 int* numSalesArray, float* valueSalesArray);

/**
 * @brief Returns the quantity of sales of a product for a specific branch. The
 *id of the product is the key corresponding to the Sales struct in the
 *hashtable hashT in struct TotalSales.
 *@param sales Sales struct with info to obtain.
 *@param branch Branch to be searched.
 */
int totalNumUnitsBoughtByBranch(const Sales sales, int branch);

void freeSales(void* s);

#endif
