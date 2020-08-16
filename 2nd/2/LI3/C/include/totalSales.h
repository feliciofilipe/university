/**
 @file product.h
 \brief Module responsible for storing the sales record from each product
*/
#ifndef TOTALSALES
#define TOTALSALES

#include <glib.h>

/**
 *@brief Structure responsible for storing the sales record from each product
 */
typedef struct totalSales* TotalSales;

/**
 *@brief Initializes the totalSales structure
 */
TotalSales initTotalSales();

/**
 *@brief Updates the sales ledger of a given product with the new sale
 *@param totalSales Structure containing the Sales structures organized int an
 *hash table.
 *@param productID ID of the product which was bought
 *@param price Price of an unit of the product
 *@param units Number of units bought
 *@param type Char indicating the type of sale
 *@param month Month when the product was bought
 *@param branch Integer indicating in which branch the product was bought
 */
void updateSales(TotalSales totalSales, const char* productID, float price,
                 int units, char type, int month, int branch);

/**
 *@brief Returns the global quantity and value of sales for each month, within a
 *specified range.
 *@param totalSales Structure containing the Sales structures organized int an
 *hash table.
 *@param minMonth First month.
 *@param maxMonth Last month.
 *@param numSalesPtr 12-element array used to return the quantity of sales.
 *@param valueSalesPtr 12-element array used to return the value of sales.
 */
void getGlobalSalesInfoInterval(const TotalSales totalSales, int minMonth,
                                int maxMonth, int* numSalesPtr,
                                double* valueSalesPtr);

/**
 * @brief Returns the quantity and value of sales for a specific month and
 *product.
 *@param totalSales Structure containing the Sales structures organized int an
 *hash table.
 *@param productID ID of the product.
 *@param month Month to be searched.
 *@param numSalesArray 12-element array used to return the quantity of sales.
 *@param valueSalesArray 12-element array used to return the value of sales.
 */
void getProductSalesAndProfitTotalSales(const TotalSales totalSales,
                                        const char* productID, int month,
                                        int* numSalesArray,
                                        float* valueSalesArray);

/**
 *@brief  Returns a sorted GPtrArray array of productInfo structs with only the
 *id and unitsSold fields filled in.
 *@param totalSales Structure containing the Sales structures organized int an
 *hash table.
 *@param length Pointer to an integer to be updated with the length of the
 *returning array.
 */
GPtrArray* getAllProductsSalesInfo(const TotalSales totalSales, int* length);

void freeTotalSales();
#endif
