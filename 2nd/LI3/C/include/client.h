/**
 @file
 \brief Module responsible for representing a client
*/
#ifndef CLIENT
#define CLIENT

#include <stdbool.h>

/** 
 @brief Structure holding information about a client
*/ 
typedef struct client* Client;

/**
 @brief Instanciates a client structure
*/
Client initClient(char* id);

/**
 *@brief Get the id of a client from the Client structure.
 *@param client client whose ID will be returned
  Returns a string located in the heap (malloc).
 */
char* getIdClient(const Client client);

/**
 *@brief Verifies a client ID.
 *@param id ID to be validated
 */
bool validateClient(const char* id);

/**
 *@brief Updates client structure based on if a client bought any product from a
 *specific branch.
 *@param client Client to be updated.
 *@param branch Number that identifies the branch.
 */
void updateBranchesBoughtClient(Client client, int branch);

/**
 *@brief Checks if a client has bought from all branches.
 *@param client client to be verified
 */
bool boughtAllBranchesClient(const Client client);

/**
 *@brief Checks if a client has not bought any product.
 *@param client client to be verified
 */
bool didntBuyClient(const Client client);

/**
 *@brief Frees a client
 *@param c client to be freed
 */
void freeClient(void* c);

#endif
