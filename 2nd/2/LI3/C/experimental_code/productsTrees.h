#ifndef PRODUCTSTREE
#define PRODUCTSTREE

#include "product.h"

typedef struct productsTrees* ProductsTrees;


ProductsTrees initProductsTrees();

void addProductTrees(ProductsTrees productsTrees, const Product product);

bool existsProductTrees(const ProductsTrees productsTrees, const char* productID);

void updateBranchesBoughtProductsTrees(ProductsTrees productsTrees, const char* productID,
                                  int branch);

char** getProductsByLetterTrees(ProductsTrees productsTrees, const char letter, int* length);

GPtrArray* productsNotBoughtTrees(const ProductsTrees productsTrees, int branch, int* length);

void freeProductsTrees(ProductsTrees p);

#endif