#include "../include/product.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

struct product {
    char* id;
    bool branchesBought[NUMBEROFBRANCHES];
};

Product initProduct(char* id) {
    Product product = malloc(sizeof(struct product));
    product->id = strdup(strtok(id, " \r\n"));
    memset(product->branchesBought,false,NUMBEROFBRANCHES*sizeof(bool));
    return product;
}

char* getProductID(const Product prod) {
    return strdup(prod->id);
}

bool validateProduct(const char* id) {
    if (strlen(id) == SIZEIDPRODUCT) {
        int num = atoi(id + 2);
        return (bool)(isupper(id[0]) && isupper(id[1]) && num >= 1000 &&
                      num <= 9999);
    } else
        return false;
}

void updateBranchesBoughtProduct(Product product, int branch) {
    product->branchesBought[branch - 1] = true;
}

bool productWasntBought(const Product product, int branch) {
    if (branch == 0) {
        int branchNumber;
        for (branchNumber = 0; branchNumber < NUMBEROFBRANCHES; branchNumber++) {
            if (product->branchesBought[branchNumber] == true) return false;
        }
        return true;
    } else {
        return !(product->branchesBought[branch - 1]);
    }
}

void freeProduct(void* p) {
    Product product = (Product)p;
    free(product->id);
    free(product);
}
