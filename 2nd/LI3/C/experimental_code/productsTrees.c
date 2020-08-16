#include <glib.h>
#include "../libs/config.h"
#include "../include/productsTrees.h"

struct productsTrees{
    GTree* products[NLETTERS];
};


static gint treeStrcmp (gconstpointer a,gconstpointer b, __attribute__((unused))gpointer user_data){
    char* s1 = (char*) a;
    char* s2 = (char*) b;
    return strcmp(s1, s2);
}

ProductsTrees initProductsTrees(){
    ProductsTrees productsTrees = malloc(sizeof(struct productsTrees));
    int letter;
    for(letter=0;letter<NLETTERS;letter++){
        productsTrees->products[letter] = 
            g_tree_new_full(treeStrcmp, NULL, free, freeProduct);
    }
    return productsTrees;
}


void addProductTrees(ProductsTrees productsTrees, const Product product) {
    char* productID = getProductID(product);
    g_tree_insert (productsTrees->products[(int)(productID[0]-LETTEROFFSET)],
                productID,product);
}


bool existsProductTrees(const ProductsTrees productsTrees, const char* productID){
    if(strlen(productID)>0){
        Product p = g_tree_lookup(productsTrees->products[(int)(productID[0]-LETTEROFFSET)],productID);
        return (p)?true:false;
    }
    return false;
}

void updateBranchesBoughtProductsTrees(ProductsTrees productsTrees, const char* productID,
                                  int branch) {
    Product product = g_tree_lookup(productsTrees->products[(int)(productID[0]-LETTEROFFSET)], productID);
    updateBranchesBoughtProduct(product, branch);
}

static gboolean threeToArray(gpointer key,  __attribute__((unused))gpointer value, gpointer data) {
    char** array = *(char***)data;
    char* id = (char*)key;
    *array = malloc(sizeof(char) * (SIZEIDPRODUCT + 1));
    strcpy(*(array++), id);
    *(char***)data = array;

    return 0;
}


char** getProductsByLetterTrees(ProductsTrees productsTrees, const char letter, int* length) {
    GTree* t = productsTrees->products[(int)(letter-LETTEROFFSET)];

    /*Passar a GTree para array de strings*/
    *length =g_tree_nnodes(t);
    char** array = malloc(g_tree_nnodes(t) * sizeof(char*));
    char** aux = array;
    g_tree_foreach(t, (GTraverseFunc)threeToArray, &aux);
    return array;
}



typedef struct auxProductsNotBoughtTrees{
    GPtrArray* array;
    int length;
    int branch;
}* AuxProductsNotBoughtTrees;



static gint foreachProductWasntBought(gpointer key,gpointer value, gpointer data){
    Product product = (Product) value;
    char* id = (char*) key;
    AuxProductsNotBoughtTrees auxStruct = (AuxProductsNotBoughtTrees)data;
    GPtrArray* array = auxStruct->array;
    int branch = auxStruct->branch;
    if(productWasntBought(product,branch)){
        auxStruct->length++;
        g_ptr_array_add(array,strdup(id));
    }
    return 0;
}

GPtrArray* productsNotBoughtTrees(const ProductsTrees productsTrees, int branch, int* length) {
    GPtrArray* array =g_ptr_array_new_with_free_func(free);
    AuxProductsNotBoughtTrees aux = malloc(sizeof(struct auxProductsNotBoughtTrees));
    aux->array = array;
    aux->length = 0;
    aux->branch = branch;

    int letter;
    for(letter=0;letter<NLETTERS;letter++){
        GTree* t = productsTrees->products[(int)(letter)];
        g_tree_foreach(t,foreachProductWasntBought,aux);
    }
    *length = aux->length;
    return array;
}


void freeProductsTrees(ProductsTrees p){
    int letter;
    for(letter=0;letter<NLETTERS;letter++){
        g_tree_destroy (p->products[letter]);
    }
    free(p->products);
}