#include "../libs/productInfo.h"
#include <stdlib.h>
#include <string.h>
#include "../libs/config.h"

struct productInfo {
    char* productID;
    int unitsSold[NUMBEROFBRANCHES];
    int numberOfClients[NUMBEROFBRANCHES];
};

ProductInfo initProductInfo(char* productID) {
    ProductInfo p = malloc(sizeof(struct productInfo));
    p->productID = strdup(productID);
    memset(p->unitsSold,0,NUMBEROFBRANCHES*sizeof(int));
    memset(p->numberOfClients,0,NUMBEROFBRANCHES*sizeof(int));
    return p;
}

/* Setters */
void setProductInfoUnitsSold(ProductInfo p, int branch, int units) {
    p->unitsSold[branch - 1] = units;
}
void setProductInfoNumberOfClients(ProductInfo p, int branch, int numClients) {
    p->numberOfClients[branch - 1] = numClients;
}

/* Getters */
char* getProductInfoProductId(const ProductInfo p) {
    return strdup(p->productID);
}

int getProductInfoUnitsSold(const ProductInfo p, int branch) {
    return p->unitsSold[branch - 1];
}
int getProductInfoNumberOfClients(const ProductInfo p, int branch) {
    return p->numberOfClients[branch - 1];
}

ProductInfo productInfoClone(const ProductInfo p) {
    ProductInfo productInfo = initProductInfo(p->productID);
    int branch = 0;
    for (branch = 0; branch < NUMBEROFBRANCHES; branch++) {
        productInfo->unitsSold[branch] = p->unitsSold[branch];
        productInfo->numberOfClients[branch] = p->numberOfClients[branch];
    }
    return productInfo;
}

void freeProductInfo(void* p) {
    ProductInfo productInfo = (ProductInfo)p;
    free(productInfo->productID);
    free(productInfo);
}
