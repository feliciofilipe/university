/*#include <glib.h>*/ /*!*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <limits.h>
#include "../include/clients.h"
#include "../include/products.h"
#include "../include/interface.h"
#include "../include/view.h"



bool validSGV(SGV sgv){
    if (sgv == NULL) return 0;
    Q13Output q = getCurrentFilesInfo(sgv);
    int productsValidated = getQuery13OutputClientsValidated(q);
    int clientsValidated = getQuery13OutputClientsValidated(q);
    int salesValidated = getQuery13OutputSalesValidated(q);
    return (productsValidated && clientsValidated && salesValidated);
}


static bool isValidChar(char c){   
    return (c >= LOWER_CASE_A && c <= LOWER_CASE_Z) || (c >= ZERO && c <= NINE);
}

static bool isValidLetter(char c){
    return (c >= LOWER_CASE_A && c <= LOWER_CASE_Z);
}

static bool isValidNumber(char c){
    return (c >= ZERO && c <= NINE);
}

static void editForm(char* buffer, char c,int size,int column){
    int i = column;
    char aux;
    while(i < size){
        aux=buffer[i];
        buffer[i++] = c;
        c=aux;
    }
}

static void editLetterForm(char* letter, char buffer,int column){
    if(column == 0)
        *letter = buffer;
}

static char shift(char c){
    return (c >= LOWER_CASE_A && c <= LOWER_CASE_Z) ? c-CASE_OFFSET : c;
}

void startController(){
    printf(HIDE_CURSOR);
    char client[SIZEIDCLIENT+1];
    client[SIZEIDCLIENT] = '\0';
    int sizeClient = 0;
    char product[SIZEIDPRODUCT+1];
    product[SIZEIDPRODUCT] = '\0';
    int sizeProduct = 0;
    char N[9];
    N[8] = '\0';
    char clientFilePath[512];
    char productFilePath[512];
    char salesFilePath[512];
    char auxLoad[512];
    int sizeN = 0;
    char buffer = '\0';
    char letter;
    int sizeLetter = 0;
    int row = 0;
    int column = 0;
    int column2 = 0;
    int error = 0;
    int count = 0;
    int month = 0;
    int month2 = 0;
    int branch = 0;
    int option = 0;
    int type = 0;
    int out = 0;
    int i;
    clock_t start1, end1;
    clock_t start2, end2;
    clock_t start3, end3;
    clock_t start4, end4;
    clock_t start5, end5;
    clock_t start6, end6;
    clock_t start7, end7;
    clock_t start8, end8;
    clock_t start9, end9;
    clock_t start10, end10;
    clock_t start11, end11;
    clock_t start12, end12;
    clock_t start13, end13;
    SGV sgv = NULL;
    int sgv_is_initialized = 0;
    int sgv_is_loaded = 0;
    while(out != 1){
        buffer = '\0';
        row = ROW_1;
        column = COLUMN_1;
        while (buffer != ENTER) {
            printGreeter(row,column);
            system("/bin/stty raw");
            buffer = getchar();
            system("/bin/stty cooked");
            switch(buffer){
                case LEFT:{
                    if(row == ROW_1)
                        if(column == COLUMN_2)
                            column = COLUMN_1; 
                    break;
                }   
                case RIGHT:{
                    if(row == ROW_1)
                        if(column == COLUMN_1)
                            column = COLUMN_2;
                    break;
                }
                case UP:{
                    if(row == ROW_2)
                        row = ROW_1;
                    break;
                }
                case DOWN:{
                    if(row == ROW_1)
                        row = ROW_2;
                    break;
                }
            }
        }
        if(row == ROW_1){
            if(column == COLUMN_1){
                if(sgv_is_loaded || sgv_is_initialized){
		            destroySGV(sgv);
		            sgv_is_initialized = 0;
 		            sgv_is_loaded = 0;
		        }
	            sgv = initSGV();
	            sgv_is_initialized = 1;
                sgv_is_loaded = 1;
		        printLoad();
                start1 = clock();
                sgv = loadSGVFromFiles(sgv, "../Dados Iniciais/Clientes.txt",
                                            "../Dados Iniciais/Produtos.txt",
                                            "../Dados Iniciais/Vendas_1M.txt");
                end1 = clock();
            } else{
                system("clear");
		        printClientPath();
                if(fgets(auxLoad, sizeof(auxLoad), stdin))
                    sscanf(auxLoad, "%[^\n]%*c", clientFilePath);
		        printProductsPath();
                if(fgets(auxLoad, sizeof(auxLoad), stdin))
                    sscanf(auxLoad, "%[^\n]%*c", productFilePath);
		        printSalesPath();
                if(fgets(auxLoad, sizeof(auxLoad), stdin))
                    sscanf(auxLoad, "%[^\n]%*c", salesFilePath);
		        SGV aux2 = initSGV();
                start1 = clock();
		        printLoad();
                aux2 = loadSGVFromFiles(aux2, clientFilePath,
                                            productFilePath,
                                            salesFilePath);
                end1 = clock();
	            if(sgv_is_loaded || sgv_is_initialized){
		            destroySGV(sgv);
	 	            sgv_is_initialized = 0;
	                sgv_is_loaded = 0;
		        }
		        sgv = aux2;
		        sgv_is_initialized = 1;
 		        sgv_is_loaded = 1;
    
            }
            printQuery1(((double)(end1 - start1))/ CLOCKS_PER_SEC);
        }else if(row == ROW_2){
            row = ROW_3;
            column = COLUMN_3;
            out = 1;
        }
        while (row != ROW_3 || column != COLUMN_3){
            buffer = '\0';
            while (buffer != ENTER) {
                printMenu(row,column);
                system("/bin/stty raw");
                buffer = getchar();
                system("/bin/stty cooked");
                switch(buffer){
                    case UP:{
                        if(row == ROW_3){
                            if(column == COLUMN_3){
                                column = COLUMN_5;
                            }else if(column == COLUMN_2){
                                column = COLUMN_3;
                            }else{
                                column = COLUMN_1;
                            }
                            row = ROW_2;
                        }
                        else if(row == ROW_2){
                            row = ROW_1;
                        }
                        break;
                    }
                    case DOWN:{
                        if(row == ROW_2){
                                if(column == COLUMN_5){
                                    column = COLUMN_3;
                                }else if(column == COLUMN_3 || column == COLUMN_4){
                                    column = COLUMN_2;
                                }else{
                                    column = COLUMN_1;
                                }
                                row = ROW_3;
                        } else if(row == ROW_1){
                            row = ROW_2;
                        }
                        break;
                    }
                    case LEFT:{
                        if(column > COLUMN_1){
                            column--;
                        }
                        break;
                    }   
                    case RIGHT:{
                        if(row != ROW_3){
                            if(column < COLUMN_5){
                                column++;
                            }
                        }
                        else
                            if(column < COLUMN_3){
                                column++;
                            }
                        break;
                    }
                }
            }
            switch (row) {
                case ROW_1: {
                    switch(column){
                        case COLUMN_1: {
                            buffer = '\0';
                            start13 = clock();
                            Q13Output q13 = getCurrentFilesInfo(sgv);
                            end13 = clock();
                            double time13 = ((double)(end13 - start13)) / CLOCKS_PER_SEC;
                            char* clientsPath = getQuery13OutputClientsFilePath(q13);
                            char* productsPath = getQuery13OutputProductsFilePath(q13);
                            char* salesPath = getQuery13OutputSalesFilePath(q13);
                            int clientsRead = getQuery13OutputClientsRead(q13);
                            int clientsValidated = getQuery13OutputClientsValidated(q13);
                            int productsRead = getQuery13OutputProductsRead(q13);
                            int productsValidated = getQuery13OutputProductsValidated(q13);
                            int salesRead = getQuery13OutputSalesRead(q13);
                            int salesValidated = getQuery13OutputSalesValidated(q13);
                            while(buffer != ENTER){
                                printQuery13(clientsPath,productsPath,salesPath,clientsRead,clientsValidated,productsRead,productsValidated,salesRead,salesValidated,time13);
                                system("/bin/stty raw");
                                buffer = getchar();
                                system("/bin/stty cooked");
                            }
                            freeQuery13Output(q13);
                            break;
                        }
                        case COLUMN_2: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                count = 0;
                                column = 0;
                                sizeLetter = 0;
                                letter = '\0';
                                while (buffer != ENTER) {
                                    printMenuQuery2(letter,row,column,sizeLetter);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row == ROW_1){
                                                if(sizeLetter == 1){
                                                    count = 0;
                                                    buffer = '\0';
                                                    start2 = clock();
                                                    Q2Output q2 = getProductsStartedByLetter(sgv, letter);
                                                    end2 = clock();
                                                    double time2 = ((double)(end2 - start2)) / CLOCKS_PER_SEC;
                                                    int qLength2 = getQuery2OutputLength(q2);
                                                    char **qContent2 = getQuery2OutputProductsList(q2);
                                                    while(buffer != ENTER){
                                                        printQuery2(qContent2,count,9,11,qLength2,letter,time2);
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                        if(buffer == DOWN && count < qLength2){
                                                            if(count+9*11 < qLength2){
                                                                count+=9*11;
                                                            }
                                                        }
                                                        if(buffer == UP && count > 0){
                                                            if(count-9*11 < 0){
                                                                count=0;
                                                            }else{
                                                                count-=9*11;
                                                            }
                                                        }
                                                    }
                                                    freeQuery2Output(q2);
                                                }
                                            } else if(row == ROW_2) {
                                                row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{ 
	                                        if (column > 0){
                                                column--;
	    	                                }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if (column < sizeLetter){
                                                    column++;
                                            }
                                            break;
                                        }
                                        case CLEAN: {
                                            if(row == ROW_1){
                                                if(column>0){
                                                    if(sizeLetter > 0){
                                                        --sizeLetter;
                                                        --column;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row == ROW_2)
                                                row = ROW_1;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row == ROW_1)
                                                row = ROW_2;
                                            break;
                                        }
                                        default:{
                                            if(row == ROW_1){
                                                if(sizeLetter < 1){
                                                    if(isValidLetter(buffer)){
                                                        buffer = shift(buffer);
                                                        ++sizeLetter;
                                                        editLetterForm(&letter,buffer,column);
                                                        column++;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_1;
                            column = COLUMN_2;
                            break;
                        }
                        case COLUMN_3: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column = 0;
                                sizeProduct = 0;
                                month = 0;
                                option = 0;
                                while (buffer != ENTER) {
                                    printMenuQuery3(product,row,column,sizeProduct,option,month,error);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row != 3){
                                                if(sizeProduct == SIZEIDPRODUCT && validateProduct(product)){
                                                    buffer = '\0';
                                                    start3 = clock();
                                                    Q3Output q3 = getProductSalesAndProfit(sgv, product,month+1);
                                                    end3 = clock();
                                                    double time3 = ((double)(end3 - start3)) / CLOCKS_PER_SEC;
                                                    int *numSalesArray = getQuery3OutputNumSalesArray(q3);
                                                    float *valueSalesArray = getQuery3OutputValuealesArray(q3);
                                                    while(buffer != ENTER){
                                                        printQuery3(numSalesArray,valueSalesArray,product,option,time3);
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                    }
                                                    freeQuery3Output(q3);
                                                    row = 0;
                                                    column = 0;
                                                    sizeProduct = 0;
                                                    error = 0;
                                                } else{
                                                    error = 1;
                                                }
                                            } else {
                                                if(row == 3)
                                                    row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{ 
	                                        if(row == ROW_1){
                                                if (column > 0){
                                                    column--;
                                                }
                                            }else if(row == ROW_2){
                                                if(option == 1){
                                                    option = 0;
                                                }
                                            }else if(row == ROW_3){
                                                if(month > 0){
                                                    month--;
                                                }
                                            }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if(row == ROW_1){
                                                if (column < sizeProduct){
                                                    column++;
                                                }
                                            }else if(row == ROW_2){
                                                if(option == 0){
                                                    option = 1;
                                                }
                                            }else if(row == ROW_3){
                                                if(month < 11){
                                                    month++;
                                                }
                                            }
                                            break;
                                        }
                                        case CLEAN: {
                                            if(row == ROW_1){
                                                if(column>0){
                                                    if(sizeProduct > 0){
                                                            for(i=column-1;i<SIZEIDPRODUCT;i++)
                                                                product[i]=product[i+1];
                                                            --sizeProduct;
                                                            --column;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row != ROW_1)
                                                row--;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row != 3)
                                                row++;
                                            break;
                                        }
                                        default:{
                                            if(row == ROW_1){
                                                if(sizeProduct < SIZEIDPRODUCT){
                                                    bool valid = isValidChar(buffer);
                                                    if(valid){
                                                        printf("%i -> ",buffer);
                                                        buffer = shift(buffer);
                                                        printf("%i",buffer);
                                                        editForm(product,buffer,++sizeProduct,column);
                                                        column++;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_1;
                            column = COLUMN_3;
                            break;
                        }
                        case COLUMN_4: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column = 0;
                                sizeProduct = 0;
                                option = 0;
                                count = 0;
                                branch = 0;
                                while (buffer != ENTER) {
                                    printMenuQuery4(row,branch);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row != ROW_2){
                                                buffer = '\0';
                                                if(branch == 3) option = 0;
                                                else option = branch + 1;
                                                start4 = clock();
                                                Q4Output q4 = getProductsNeverBought(sgv, option);
                                                end4 = clock();
                                                double time4 = ((double)(end4 - start4)) / CLOCKS_PER_SEC;
                                                int noNotBough = getQuery4OutputLength(q4);
                                                GPtrArray *query4Answer = getQuery4OutputProductsNotBought(q4);
                                                while(buffer != ENTER){
                                                    printQuery4(query4Answer,count,9,11,noNotBough,branch,time4);
                                                    system("/bin/stty raw");
                                                    buffer = getchar();
                                                    system("/bin/stty cooked");
                                                    if(buffer == DOWN && count < noNotBough){
                                                        if(count+9*11 < noNotBough){
                                                            count+=9*11;
                                                        }
                                                    }
                                                    if(buffer == UP && count > 0){
                                                        if(count-9*11 < 0){
                                                            count=0;
                                                        }else{
                                                            count-=9*11;
                                                        }
                                                    }
                                                }
                                                freeQuery4Output(q4);
                                                row = 0;
                                                column = 0;
                                            } else {
                                                if(row == ROW_2)
                                                    row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{ 
	                                        if(row == ROW_1){
                                                if(branch > 0){
                                                    branch--;
                                                }
                                            }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if(row == ROW_1){
                                                if(branch < 3){
                                                    branch++;
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row != ROW_1)
                                                row--;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row != ROW_2)
                                                row++;
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_1;
                            column = COLUMN_4;
                            break;
                        }
                        case COLUMN_5: {
                            buffer = '\0';
                            count = 0;
                            start5 = clock();
                            Q5Output q5 = getClientsOfALLBranches(sgv);
                            end5 = clock();
                            double time5 = ((double)(end5 - start5)) / CLOCKS_PER_SEC;
                            int length5 = getQuery5OutputLength(q5);
                            GPtrArray *clientsList5 = getQuery5OutputClientsList(q5);
                            while(buffer != ENTER){
                                printQuery5(clientsList5,count,9,14,length5,time5);
                                system("/bin/stty raw");
                                buffer = getchar();
                                system("/bin/stty cooked");
                                if(buffer == DOWN && count < length5){
                                    if(count+9*14 < length5){
                                        count+=9*14;
                                    }
                                }
                                if(buffer == UP && count > 0){
                                    if(count-9*14 < 0){
                                        count=0;
                                    }else{
                                        count-=9*14;
                                    }
                                }
                            }
                            freeQuery5Output(q5);
                            row = ROW_1;
                            column = COLUMN_5;
                            break;
                        }
                    }
                    break;
                }
                case ROW_2: {
                    switch(column){
                        case COLUMN_1: {
                            buffer = '\0';
                            start6 = clock();
                            Q6Output q6 = getClientsAndProductsNeverBoughtCount(sgv);
                            end6 = clock();
                            double time6 = ((double)(end6 - start6)) / CLOCKS_PER_SEC;
                            while(buffer != ENTER){
                                printQuery6(getQuery6OutputClientsDidntBuy(q6),getQuery6OutputProductsNotBought(q6),time6);
                                system("/bin/stty raw");
                                buffer = getchar();
                                system("/bin/stty cooked");
                            }
                            freeQuery6Output(q6);
                            row = ROW_2;
                            column = COLUMN_1;
                            break;
                        }
                        case COLUMN_2: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column = 0;
                                sizeClient = 0;
                                while (buffer != ENTER) {
                                    printMenuQuery7(client,row,column,sizeClient,error);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row == ROW_1){
                                                if(sizeClient == SIZEIDCLIENT && validateClient(client)){
                                                    buffer = '\0';
                                                    start7 = clock();
                                                    Q7Output q7 = getProductsBoughtByClient(sgv, client);
                                                    end7 = clock();
                                                    double time7 = ((double)(end7 - start7)) / CLOCKS_PER_SEC;                
                                                    while (buffer != ENTER) {
                                                        printQuery7(getQuery7OutputClientQuantities(q7),
                                                                    getQuery7OutputClientTotalQuantityBranches(q7),
                                                                    getQuery7OutputClientTotalQuantityMonths(q7),
                                                                    getQuery7OutputClientTotalQuantity(q7), client,time7);
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                    }
                                                    freeQuery7Output(q7);
                                                    row = 0;
                                                    column = 0;
                                                    sizeClient = 0;
                                                    error = 0;
                                                } else{
                                                    error = 1;
                                                }
                                            } else {
                                                row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{ 
	                                        if (column > 0){
                                                column--;
	    	                                }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if (column < sizeClient){
                                                    column++;
                                            }
                                            break;
                                        }
                                        case CLEAN: {
                                            if(row == ROW_1){
                                                if(column>0){
                                                    if(sizeClient > 0){
                                                            for(i=column-1;i<SIZEIDCLIENT;i++)
                                                                client[i]=client[i+1];
                                                            --sizeClient;
                                                            --column;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row == ROW_2)
                                                row = ROW_1;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row == ROW_1)
                                                row = ROW_2;
                                            break;
                                        }
                                        default:{
                                            if(row == ROW_1){
                                                if(sizeClient < SIZEIDCLIENT){
                                                    bool valid = isValidChar(buffer);
                                                    if(valid){
                                                        buffer = shift(buffer);
                                                        editForm(client,buffer,++sizeClient,column);
                                                        column++;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_2;
                            column = COLUMN_2;
                            break;
                        }
                        case COLUMN_3: {
                            buffer = '\0';
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column = 0;
                                month = 0;
                                month2 = 0;
                                while (row != ESC) {
                                    printMenuQuery8(row,month,month2);;
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row != ROW_3){
                                                if(month <= month2){
                                                    buffer = '\0';
                                                    start8 = clock();
                                                    Q8Output q8 = getSalesAndProfits(sgv, month+1, month2+1);
                                                    end8 = clock();
                                                    double time8 = ((double)(end8 - start8)) / CLOCKS_PER_SEC;
                                                    int numSales = getQuery8OutputNumSales(q8);
                                                    double valueSales = getQuery8OutputValueSales(q8);
                                                    while (buffer != ENTER) {
                                                        printQuery8(numSales,valueSales,time8);
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                    }
                                                    buffer = '\0';
                                                    freeQuery8Output(q8);
                                                    row = 0;
                                                    column = 0;
                                                }
                                            } else {
                                                row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{
                                            if(row == ROW_1){
                                                if (month != 0){
                                                    month--;
                                                }
                                            }else if(row == ROW_2){
                                                if (month2 != 0){
                                                    if(month == month2){
                                                        month--;
                                                    }
                                                    month2--;
                                                }
                                            }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if(row == ROW_1){
                                                if (month != 11){
                                                    if(month == month2){
                                                        month2++;
                                                    }
                                                    month++;
                                                }
                                            }else if(row == ROW_2){
                                                if(month2 != 11){
                                                    month2++;
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row != ROW_1)
                                                row--;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row != ROW_3)
                                                row++;
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_2;
                            column = COLUMN_3;
                            break;
                        }
                        case COLUMN_4: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column = 0;
                                sizeProduct = 0;
                                month = 0;
                                type = 0;
                                while (buffer != ENTER) {
                                    printMenuQuery9(product,row,column,sizeProduct,branch,type);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row != 3){
                                                if(sizeProduct == SIZEIDPRODUCT && validateProduct(product)){
                                                    count = 0;
                                                    buffer = '\0';
                                                    start9 = clock();
                                                    Q9Output q9 = getProductBuyers(sgv, product, branch+1);
                                                    end9 = clock();
                                                    double time9 = ((double)(end9 - start9)) / CLOCKS_PER_SEC;
                                                    int totalN = getQuery9OutputTotalN(q9);
                                                    int totalP = getQuery9OutputTotalP(q9);
                                                    while(buffer != ENTER){
                                                        if(type == 0){
                                                            GPtrArray *arrayN = getQuery9OutputArrayN(q9);
                                                            printQuery9(arrayN,product,count,9,14,totalN,branch,'N',time9);
                                                            system("/bin/stty raw");
                                                            buffer = getchar();
                                                            system("/bin/stty cooked");
                                                            if(buffer == DOWN && count < totalN){
                                                            if(count+9*14 < totalN){
                                                                count+=9*14;
                                                            }
                                                            }
                                                            if(buffer == UP && count > 0){
                                                                if(count-9*14 < 0){
                                                                    count=0;
                                                                }else{
                                                                    count-=9*14;
                                                                }
                                                            }
                                                        }else{
                                                            GPtrArray *arrayP = getQuery9OutputArrayP(q9);
                                                            printQuery9(arrayP,product,count,9,14,totalP,branch,'P',time9);
                                                            system("/bin/stty raw");
                                                            buffer = getchar();
                                                            system("/bin/stty cooked");
                                                            if(buffer == DOWN && count < totalP){
                                                                if(count+9*14 < totalP){
                                                                    count+=9*14;
                                                                }
                                                                }
                                                                if(buffer == UP && count > 0){
                                                                    if(count-9*14 < 0){
                                                                        count=0;
                                                                    }else{
                                                                        count-=9*14;
                                                                    }
                                                            }
                                                        }
                                                    }
                                                    freeQuery9Output(q9);
                                                    row = 0;
                                                    column = 0;
                                                    sizeProduct = 0;
                                                    error = 0;
                                                } else{
                                                    error = 1;
                                                }
                                            } else {
                                                if(row == 3)
                                                    row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{ 
	                                        if(row == ROW_1){
                                                if (column > 0){
                                                    column--;
                                                }
                                            }else if(row == ROW_2){
                                                if(branch != 0){
                                                    branch--;
                                                }
                                            }else if(row == ROW_3){
                                                if(type == 1){
                                                    type = 0;
                                                }
                                            }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if(row == ROW_1){
                                                if (column < sizeProduct){
                                                    column++;
                                                }
                                            }else if(row == ROW_2){
                                                if(branch != 2){
                                                    branch++;
                                                }
                                            }else if(row == ROW_3){
                                                if(type == 0){
                                                    type = 1;
                                                }
                                            }
                                            break;
                                        }
                                        case CLEAN: {
                                            if(row == ROW_1){
                                                if(column>0){
                                                    if(sizeProduct > 0){
                                                            for(i=column-1;i<SIZEIDPRODUCT;i++)
                                                                product[i]=product[i+1];
                                                            --sizeProduct;
                                                            --column;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row != ROW_1)
                                                row--;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row != 3)
                                                row++;
                                            break;
                                        }
                                        default:{
                                            if(row == ROW_1){
                                                if(sizeProduct < SIZEIDPRODUCT){
                                                    bool valid = isValidChar(buffer);
                                                    if(valid){
                                                        buffer = shift(buffer);
                                                        editForm(product,buffer,++sizeProduct,column);
                                                        column++;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_2;
                            column = COLUMN_4;
                            break;
                        }
                        case COLUMN_5: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column = 0;
                                sizeClient = 0;
                                month = 0;
                                count = 0;
                                while (buffer != ENTER) {
                                    printMenuQuery10(client,row,column,sizeClient,month);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row != ROW_3){
                                                if(sizeClient == SIZEIDCLIENT && validateClient(client)){
                                                    buffer = '\0';
                                                    count = 0;
                                                    start10 = clock();
                                                    Q10Output q10 = getClientFavoriteProducts(sgv, client, month+1);
                                                    end10 = clock();
                                                    double time10 = ((double)(end10 - start10)) / CLOCKS_PER_SEC;
                                                    GPtrArray *arrayProducts = getQuery10OutputProductsArray(q10);
                                                    int total10 = getQuery10OutputLength(q10);
                                                    while (buffer != ENTER) {
                                                        printQuery10(arrayProducts,client,count,9,11,total10,month+1,time10);
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                        if(buffer == DOWN && count < total10){
                                                            if(count+9*11 < total10){
                                                                count+=9*11;
                                                            }
                                                        }
                                                        if(buffer == UP && count > 0){
                                                            if(count-9*11 < 0){
                                                                count=0;
                                                            }else{
                                                                count-=9*11;
                                                            }
                                                        }
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                    }
                                                    freeQuery10Output(q10);
                                                    row = 0;
                                                    column = 0;
                                                    sizeClient = 0;
                                                    error = 0;
                                                } else{
                                                    error = 1;
                                                }
                                            } else {
                                                row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{
                                            if(row == ROW_1){ 
	                                            if (column > 0){
                                                    column--;
	    	                                    }
                                            } else if(row == ROW_2){
                                                if (month != 0){
                                                    month--;
	    	                                    }
                                            }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if(row == ROW_1){
                                                if (column < sizeClient){
                                                    column++;
                                                }
                                            }else if(row == ROW_2){
                                                if (month < 11){
                                                    month++;
                                                }
                                            }
                                            break;
                                        }
                                        case CLEAN: {
                                            if(row == ROW_1){
                                                if(column>0){
                                                    if(sizeClient > 0){
                                                            for(i=column-1;i<SIZEIDCLIENT;i++)
                                                                client[i]=client[i+1];
                                                            --sizeClient;
                                                            --column;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row != ROW_1)
                                                row--;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row != ROW_3)
                                                row++;
                                            break;
                                        }
                                        default:{
                                            if(row == ROW_1){
                                                if(sizeClient < SIZEIDCLIENT){
                                                    bool valid = isValidChar(buffer);
                                                    if(valid){
                                                        buffer = shift(buffer);
                                                        editForm(client,buffer,++sizeClient,column);
                                                        column++;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_2;
                            column = COLUMN_5;
                            break;
                        }
                    }
                    break;
                }
                case ROW_3: {
                    switch(column){
                        case COLUMN_1: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column2 = 0;
                                sizeN = 0;
                                count = 0;
                                while (row != ESC) {
                                    printMenuQuery11(N,row,column2,sizeN);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row != ROW_2){
                                                if(sizeN > 0){
                                                    buffer = '\0';
                                                    count = 0;
                                                    N[sizeN] = '\0';
                                                    int size11 = (int) strtol(N,NULL,10);
                                                    start11 = clock();
                                                    Q11Output q11 = getTopSelledProducts(sgv, size11);
                                                    end11 = clock();
                                                    double time11 = ((double)(end11 - start11)) / CLOCKS_PER_SEC;
                                                    GPtrArray *productInfoArray = getQuery11OutputProductInfoArray(q11);
                                                    int length11 = getQuery11OutputLength(q11);
                                                    printf("%d",length11);
                                                    int lines11 = 8;
                                                    while (buffer != ENTER) {
                                                        printQuery11(productInfoArray,count,lines11,length11,time11);
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                        if(buffer == DOWN && count < length11){
                                                            if(count+lines11 < length11){
                                                                count+=lines11;
                                                            }
                                                        }
                                                        if(buffer == UP && count > 0){
                                                            if(count-lines11 < 0){
                                                                count=0;
                                                            }else{
                                                                count-=lines11;
                                                            }
                                                        }
                                                    }
                                                    freeQuery11Output(q11);
                                                    row = 0;
                                                    column2 = 0;
                                                    sizeN = 0;
                                                }
                                            } else {
                                                row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{
                                            if(row == ROW_1){
                                                if (column2 > 0){
                                                    column2--;
	    	                                    }
                                            }else{
                                                row = ROW_1;
                                            }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if(row == ROW_1){
                                                if (column2 < sizeN){
                                                    column2++;
                                                }else{
                                                    row = ROW_2;
                                                }
                                            }
                                            break;
                                        }
                                        case CLEAN: {
                                            if(row == ROW_1){
                                                if(column2>0){
                                                    if(sizeN > 0){
                                                            for(i=column2-1;i<8;i++)
                                                                N[i]=N[i+1];
                                                            --sizeN;
                                                            --column2;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                        default:{
                                            if(row == ROW_1){
                                                if(sizeN < 8){
                                                    int valid = isValidNumber(buffer);
                                                    if(valid){
                                                        buffer = shift(buffer);
                                                        editForm(N,buffer,++sizeN,column2);
                                                        column2++;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_3;
                            column = COLUMN_1;
                            break;
                        }
                        case COLUMN_2: {
                            buffer = '\0';
                            error = 0;
                            while (row != ESC) {
                                buffer = '\0';
                                row = 0;
                                column = 0;
                                column2 = 0;
                                sizeClient = 0;
                                sizeN = 0;
                                count = 0;
                                while (row != ESC) {
                                    printMenuQuery12(client,N,row,column,column2,sizeClient,sizeN,error);
                                    system("/bin/stty raw");
                                    buffer = getchar();
                                    system("/bin/stty cooked");
                                    switch (buffer){
                                        case ENTER:{
                                            if(row != ROW_3){
                                                if(sizeN > 0 && sizeClient == SIZEIDCLIENT && validateClient(client)){
                                                    buffer = '\0';
                                                    count = 0;
                                                    N[sizeN] = '\0';
                                                    int size12 = (int) strtol(N,NULL,10);
                                                    start12 = clock();
                                                    Q12Output q12 = getClientTopProfitProducts(sgv,client,size12);
                                                    end12 = clock();
                                                    double time12 = ((double)(end12 - start12)) / CLOCKS_PER_SEC;
                                                    GPtrArray *topProfitProducts = getQuery12OutputTopProfitProducts(q12);
                                                    int length12 = getQuery12OutputLength(q12);
                                                    while (buffer != ENTER) {
                                                        printQuery12(topProfitProducts,client,count,9,11,length12,time12);
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                        if(buffer == DOWN && count < length12){
                                                            if(count+9*11 < length12){
                                                                count+=9*11;
                                                            }
                                                        }
                                                        if(buffer == UP && count > 0){
                                                            if(count-9*11 < 0){
                                                                count=0;
                                                            }else{
                                                                count-=9*11;
                                                            }
                                                        }
                                                        system("/bin/stty raw");
                                                        buffer = getchar();
                                                        system("/bin/stty cooked");
                                                    }
                                                    freeQuery12Output(q12);
                                                    row = 0;
                                                    column = 0;
                                                    sizeClient = 0;
                                                    error = 0;
                                                } else{
                                                    error = 1;
                                                }
                                            } else {
                                                row = ESC;
                                            }
                                            break;
                                        }
                                        case LEFT:{
                                            if(row == ROW_1){ 
	                                            if (column > 0){
                                                    column--;
	    	                                    }
                                            } else if(row == ROW_2){
                                                if (column2 > 0){
                                                    column2--;
	    	                                    }
                                            }
                                            break;
                                        }
                                        case RIGHT:{ 
                                            if(row == ROW_1){
                                                if (column < sizeClient){
                                                    column++;
                                                }
                                            }else if(row == ROW_2){
                                                if (column2 < sizeN){
                                                    column2++;
                                                }
                                            }
                                            break;
                                        }
                                        case CLEAN: {
                                            if(row == ROW_1){
                                                if(column>0){
                                                    if(sizeClient > 0){
                                                            for(i=column-1;i<SIZEIDCLIENT;i++)
                                                                client[i]=client[i+1];
                                                            --sizeClient;
                                                            --column;
                                                    }
                                                }
                                            }
                                            if(row == ROW_2){
                                                if(column2>0){
                                                    if(sizeN > 0){
                                                            for(i=column2-1;i<8;i++)
                                                                N[i]=N[i+1];
                                                            --sizeN;
                                                            --column2;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                        case UP:{
                                            if(row != ROW_1)
                                                row--;
                                            break;
                                        }
                                        case DOWN:{
                                            if(row != ROW_3)
                                                row++;
                                            break;
                                        }
                                        default:{
                                            if(row == ROW_1){
                                                if(sizeClient < SIZEIDCLIENT){
                                                    bool valid = isValidChar(buffer);
                                                    if(valid){
                                                        buffer = shift(buffer);
                                                        editForm(client,buffer,++sizeClient,column);
                                                        column++;
                                                    }
                                                }
                                            }
                                            if(row == ROW_2){
                                                if(sizeN < 8){
                                                    int valid = isValidNumber(buffer);
                                                    if(valid){
                                                        buffer = shift(buffer);
                                                        editForm(N,buffer,++sizeN,column2);
                                                        column2++;
                                                    }
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            row = ROW_3;
                            column = COLUMN_2;
                            break;
                        }   
                        case COLUMN_3: {
                            out = 0;
                            break;
                        } 
                    }
                    break;
                }
            }
        }
    }
   if (sgv_is_initialized || sgv_is_loaded){
   	destroySGV(sgv);
	sgv_is_initialized = 0 ;
	sgv_is_loaded = 0;
    }
    system("/bin/stty cooked");
    printf(SHOW_CURSOR);
    system("clear");
}
