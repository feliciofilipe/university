#ifndef VIEW
#define VIEW
#include "../include/interface.h"

/**
 *@brief Prompt to put the client file path
 */
void printClientPath();

/**
 *@brief Prints the prompt to put the product file path
 */
void printProductsPath();

/**
 *@brief Prints the prompt to put the sales file path
 */
void printSalesPath();

/**
 *@brief Prints the Load Screen
 */
void printLoad();

/**
 *@brief Prints the Menu Screen
 */
void printMenu(int row, int column);

/**
 *@brief Prints the Greeter Screen
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis
 */
void printGreeter(int row, int column);

/**
 *@brief Prints the Menu for the Query2
 *@param letter Buffer with the letter that the user inserted
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis
 *@param sizeLetter Number of characters in the letter buffer 
 */
void printMenuQuery2(char letter, int row, int column, int sizeLetter);

/**
 *@brief Prints the Menu for the Query3
 *@param product Buffer with the product that the user inserted
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis
 *@param sizeProduct Number of characters in the product buffer
 *@param option Type of display wanted by the user
 *@param month Month selected by the user 
 */
void printMenuQuery3(char *product, int row, int column, int sizeProduct,
                     int option, int month, int error);
/**
 *@brief Prints the Menu for the Query4
 *@param row Information with the place where the user is in the Oy axis
 *@param branch Number of the branch the user wish to see information about 
 */
void printMenuQuery4(int row, int branch);

/**
 *@brief Prints the Menu for the Query7
 *@param client Buffer with the client that the user inserted
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis 
 *@param sizeClient Number of characters in the client buffer
 *@param error Information on the validity of the input
 */
void printMenuQuery7(char *client, int row, int column, int sizeClient,
                     int error);

/**
 *@brief Prints the Menu for the Query8
 *@param row Information with the place where the user is in the Oy axis
 *@param minMonth The intial month of the time frame
 *@param maxMonth The last month of the time frame
 */
void printMenuQuery8(int row, int minMonth, int maxMonth);

/**
 *@brief Prints the Menu for the Query9
 *@param product Buffer with the product that the user inserted
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis
 *@param sizeProduct Number of characters in the product buffer
 *@param branch Number of the branch the user wish to see information about
 *@param type Type of sale
 */
void printMenuQuery9(char *product, int row, int column, int sizeProduct,
                     int branch, int type);

/**
 *@brief Prints the Menu for the Query10
 *@param client Buffer with the client that the user inserted
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis
 *@param sizeClient Number of characters in the client buffer
 *@param month Month selected by the user
 */
void printMenuQuery10(char *client, int row, int column, int sizeClient,
                      int month);

/**
 *@brief Prints the Menu for the Query11
 *@param N Buffer with the number input
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis
 *@param sizeN Number of characters in the number buffer
 */
void printMenuQuery11(char *N, int row, int column, int sizeN);

/**
 *@brief Prints the Menu for the Query12
 *@param client Buffer with the client that the user inserted
 *@param N Buffer with the number input
 *@param row Information with the place where the user is in the Oy axis
 *@param column Information with the place where the user is in the Ox axis in the first row
 *@param column2 Information with the place where the user is in the Ox axis in the second row
 *@param sizeClient Number of characters in the client buffer
 *@param sizeN Number of characters in the number buffer
 *@param error Information on the validity of the input
 */
void printMenuQuery12(char *client, char *N, int row, int column, int column2,
                      int sizeClient, int sizeN, int error);

/**
 *@brief Prints the Query1
 *@param time Duration of the query
 */
void printQuery1(double time);

/**
 *@brief Prints the Query2
 *@param products Products ID's list outputed by the Query
 *@param from Initial index of the desired range of products displayed
 *@param rows Number of rows in the display table
 *@param columns Number of columns in the display table
 *@param qLength Length of the Products ID's list
 *@param letter Letter selected by the user
 *@param time Duration of the query
 */
void printQuery2(char **products, int from, int rows, int columns,int qLength,char letter,double time);

/**
 *@brief Prints the Query3
 *@param numSalesArray List with the sales quantities
 *@param valueSalesArray List with the sales values
 *@param id ID of the product selected by the user
 *@param option Type of display
 *@param time Duration of the query
 */
void printQuery3(int *numSalesArray, float *valueSalesArray ,char *id, int option,double time);

/**
 *@brief Prints the Query4
 *@param products Products ID's list outputed by the Query
 *@param from Initial index of the desired range of products displayed
 *@param rows Number of rows in the display table
 *@param columns Number of columns in the display table
 *@param qLength Length of the Products ID's list
 *@param branch Branch selected by the user
 *@param time Duration of the query
 */
void printQuery4(GPtrArray *products, int from, int rows, int columns,int qLength,int branch, double time);

/**
 *@brief Prints the Query5
 *@param clients Clients ID's list outputed by the Query
 *@param from Initial index of the desired range of products displayed
 *@param rows Number of rows in the display table
 *@param columns Number of columns in the display table
 *@param qLength Length of the Products ID's list
 *@param time Duration of the query
 */
void printQuery5(GPtrArray *clients, int from, int rows, int columns,int qLength,double time);

/**
 *@brief Prints the Query6
 *@param clients Number of clients int the system 
 *@param clients Number of products int the system 
 *@param time Duration of the query
 */
void printQuery6(int clients, int products,double time);

/**
 *@brief Prints the Query7
 *@param clientQuantities Quantities' matrix of purchases by month and branch
 *@param totalQuantitiesBranches Quantities' list of total purchases by branches
 *@param totalQuantitiesMonths Quantities' list of total purchases by month
 *@param totalQuantity Total quantity of purchases
 *@param id Client's id
 *@param time Duration of the query
 */
void printQuery7(int **clientQuantities, int *totalQuantityBranches,
                int *totalQuantityMonths, int totalQuantity, char *id,double time);

/**
 *@brief Prints the Query8
 *@param numSales total quantity of sales
 *@param valueSales total value of sales
 *@param time Duration of the query
 */
void printQuery8(int numSales, double valueSales, double time);

/**
 *@brief Prints the Query9
 *@param clients Clients ID's list outputed by the Query
 *@param product Product's ID
 *@param from Initial index of the desired range of products displayed
 *@param rows Number of rows in the display table
 *@param columns Number of columns in the display table
 *@param qLength Length of the Products ID's list
 *@param branch Branch selected by the user
 *@param type Sale's type
 *@param time Duration of the query
 */
void printQuery9(GPtrArray *clients,char *product, int from, int rows, int columns,int qLength,int branch,char type,double time);

/**
 *@brief Prints the Query10
 *@param products Products ID's list outputed by the Query
 *@param client Client's ID
 *@param from Initial index of the desired range of products displayed
 *@param rows Number of rows in the display table
 *@param columns Number of columns in the display table
 *@param qLength Length of the Products ID's list
 *@param month Month selected by the user
 *@param time Duration of the query
 */
void printQuery10(GPtrArray *products, char* client,int from, int rows, int columns,int qLength,int month,double time);

/**
 *@brief Prints the Query11
 *@param products Products ID's list outputed by the Query
 *@param from Initial index of the desired range of products displayed
 *@param rows Number of rows in the display table
 *@param qLength Length of the Products ID's list
 *@param time Duration of the query
 */
void printQuery11(GPtrArray *products, int from, int rows,int qLength,double time);

/**
 *@brief Prints the Query12
 *@param products Products ID's list outputed by the Query
 *@param client Client's ID
 *@param from Initial index of the desired range of products displayed
 *@param rows Number of rows in the display table
 *@param columns Number of columns in the display table
 *@param qLength Length of the Products ID's list
 *@param time Duration of the query
 */
void printQuery12(GPtrArray *products, char* clients, int from, int rows, int columns,int qLength,double time);

/**
 *@brief Prints the Query13
 *@param clientsPath String with the path to the directory to clients file loaded
 *@param productsPath String with the path to the directory to products file loaded
 *@param salesPath String with the path to the directory to sales file loaded
 *@param clientsRead Number of clients read
 *@param clientsValidated Number of clients validated
 *@param productsRead Number of products read
 *@param productsValidated Number of products validated
 *@param salesRead Number of sales read
 *@param salesValidated Number of sales validated
 *@param time Duration of the query
 */
void printQuery13(char* clientsPath,char* productsPath,char* salesPath,int clientsRead,int clientsValidated,int productsRead,int productsValidated,int salesRead,int salesValidated,double time);

#endif
