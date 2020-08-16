/**
 @file clients.h
 \brief Module reesponsible for storing all the clients
*/
#ifndef CLIENTS
#define CLIENTS

#include <glib.h>
#include <stdbool.h>

#include "client.h"

/**
*@brief Structure storing all the Client structures
*/
typedef struct clients* Clients;

/**
*@brief Instanciates the clients structure
*/
Clients initClients();

/**
 *@brief Searches for a Client and updates it based on if the client bought any
 *product from a specific branch.
 *@param clients Structure containing clients.
 *@param clientID ID of the client to be searched.
 *@param branch Number that identifies the branch.
 */
void updateBranchesBoughtClients(Clients clients, char* clientID, int branch);

/**
 *@brief Checks if a certain client exists.
 *@param clients Structure containing clients.
 *@param clientID ID of the client to be searched.
 */
bool existsClient(const Clients clients, const char* clientID);

/**
 *@brief Adds a Client to the Clients structure.
 *@param clients Structure containing clients.
 *@param client Client to be added.
 */
void addClient(Clients clients, Client client);

/**
 *@brief Returns an array of clients who have made purchases in all branches.
 *@param clients Structure containing clients.
 *@param length Pointer to an integer that determines the length of the array to
 *be returned.
 *@return Array with clients.
 */
GPtrArray* getClientsOfALLBranchesClients(const Clients clients, int* length);

/**
 *@brief Returns the number of clients of haven't mande any purchases.
 *@param clients Structure containing clients.
 */
int numClientsDidntBuy(const Clients clients);

/**
 * @brief frees the clients structure
 * @param clients The clients structure to be freed
 */
void freeClients(Clients clients);

#endif
