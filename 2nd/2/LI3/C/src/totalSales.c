#include "../include/totalSales.h"
#include "../libs/config.h"
#include "../libs/productInfo.h"
#include "../include/sales.h"

struct totalSales {
    GHashTable* hashT;
    int globalNumSales[NMONTHS];
    double globalValueSales[NMONTHS];
};

TotalSales initTotalSales() {
    TotalSales totalSales = malloc(sizeof(struct totalSales));
    totalSales->hashT =
        g_hash_table_new_full(g_str_hash, g_str_equal, free, freeSales);

    memset(totalSales->globalNumSales, 0, NMONTHS * sizeof(int));

    memset(totalSales->globalValueSales, 0, NMONTHS * sizeof(double));
    return totalSales;
}

void updateSales(TotalSales totalSales, const char* productID, float price,
                   int units, char type, int month, int branch) {
    totalSales->globalNumSales[month - 1] += 1;
    totalSales->globalValueSales[month - 1] += units * price;

    if (g_hash_table_contains(totalSales->hashT, productID)) {
        Sales sales = g_hash_table_lookup(totalSales->hashT, productID);
        addSale(sales, price, units, type, month, branch);
    } else {
        char* id = strdup(productID);
        Sales sales = initSales();
        addSale(sales, price, units, type, month, branch);
        g_hash_table_insert(totalSales->hashT, id, sales);
    }
}

void getGlobalSalesInfoInterval(const TotalSales totalSales, int minMonth,
                                int maxMonth, int* numSalesPtr,
                                double* valueSalesPtr) {
    *numSalesPtr = 0;
    *valueSalesPtr = 0;
    for (; minMonth <= maxMonth; minMonth++) {
        *numSalesPtr += totalSales->globalNumSales[minMonth - 1];
        *valueSalesPtr += totalSales->globalValueSales[minMonth - 1];
    }
}

void getProductSalesAndProfitTotalSales(TotalSales totalSales,
                                        const char* productID, int month,
                                        int* numSalesArray,
                                        float* valueSalesArray) {
    if (g_hash_table_contains(totalSales->hashT, productID)) {
        Sales sales = g_hash_table_lookup(totalSales->hashT, productID);
        getSalesInfoInMonthByBranch(sales, month, numSalesArray,
                                    valueSalesArray);
    }
}

static gint compareProductInfo(gconstpointer a, gconstpointer b) {
    ProductInfo p1 = *((ProductInfo*)a);
    ProductInfo p2 = *((ProductInfo*)b);
    int unitsSold1 = 0, unitsSold2 = 0;
    int branch;
    for (branch = 1; branch <= NUMBEROFBRANCHES; branch++) {
        unitsSold1 += getProductInfoUnitsSold(p1, branch);
        unitsSold2 += getProductInfoUnitsSold(p2, branch);
    }
    if (unitsSold1 > unitsSold2) {
        return -1;
    } else if (unitsSold1 == unitsSold2) {
        return 0;
    } else {
        return 1;
    }
}

GPtrArray* getAllProductsSalesInfo(const TotalSales totalSales, int* length) {
    *length = g_hash_table_size(totalSales->hashT);
    /*Creates a GPtrArray of productInfo where the info from all products will
     * be stored*/
    GPtrArray* productInfoArray =
        g_ptr_array_new_full((*length), (GDestroyNotify)freeProductInfo);
    GHashTableIter iter;
    gpointer key, value;
    int branch;
    char* productID;
    int unitsSold;
    g_hash_table_iter_init(&iter, totalSales->hashT);
    while (g_hash_table_iter_next(&iter, &key, &value)) {
        productID = (char*)key;
        Sales sales = (Sales)value;
        ProductInfo productInfo = initProductInfo(productID);
        for (branch = 1; branch <= NUMBEROFBRANCHES; branch++) {
            unitsSold = totalNumUnitsBoughtByBranch(sales, branch);
            setProductInfoUnitsSold(productInfo, branch, unitsSold);
        }
        g_ptr_array_add(productInfoArray, productInfo);
    }

    g_ptr_array_sort(productInfoArray, compareProductInfo);
    return productInfoArray;
}

void freeTotalSales(void* t) {
    TotalSales totalSales = (TotalSales)t;
    g_hash_table_destroy(totalSales->hashT);
    free(totalSales);
}