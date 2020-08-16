#include "../include/sales.h"
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "../libs/config.h"

struct sales {
    int totalNumSales[NUMBEROFBRANCHES][NMONTHS][TYPESOFSALE]; /* number of sales entries*/
    float totalValueSales[NUMBEROFBRANCHES][NMONTHS][TYPESOFSALE]; /*value sold in that branch and month by type of sales*/
    int totalNumUnitsBought[NUMBEROFBRANCHES]; /*number of units sold for each branch*/
};


Sales initSales() {
    Sales sales = malloc(sizeof(struct sales));
    memset(sales->totalNumSales,0,NUMBEROFBRANCHES * NMONTHS * TYPESOFSALE * sizeof(int));
    memset(sales->totalValueSales,0,NUMBEROFBRANCHES * NMONTHS * TYPESOFSALE * sizeof(float));
    memset(sales->totalNumUnitsBought,0,NUMBEROFBRANCHES * sizeof(int));
    return sales;
}

void addSale(Sales sales, float price, int units, char type, int month,
             int branch) {
    int typeInt = (type == 'N') ? 0 : 1;

    sales->totalNumSales[branch - 1][month - 1][typeInt]++;

    sales->totalValueSales[branch - 1][month - 1][typeInt]+=
        price * units;

    sales->totalNumUnitsBought[branch - 1] += units;
}

void getSalesInfoInMonthByBranch(const Sales sales, int month,
                                 int* numSalesArray, float* valueSalesArray) {
    int branchNumber;
    for (branchNumber = 0; branchNumber < NUMBEROFBRANCHES; branchNumber++) {
        numSalesArray[branchNumber] +=
            sales->totalNumSales[branchNumber][month - 1][0];

        numSalesArray[branchNumber+NUMBEROFBRANCHES] +=
            sales->totalNumSales[branchNumber][month - 1][1];

        valueSalesArray[branchNumber] +=
            sales->totalValueSales[branchNumber][month - 1][0];

        valueSalesArray[branchNumber+NUMBEROFBRANCHES] +=
            sales->totalValueSales[branchNumber][month - 1][1];

    }
}

int totalNumUnitsBoughtByBranch(const Sales sales, int branch) {
    return sales->totalNumUnitsBought[branch - 1];
}

void freeSales(void* s) {
    Sales sales = (Sales)s;
    free(sales);
}
