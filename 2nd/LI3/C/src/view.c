#include <glib.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <limits.h>
#include <math.h>
#include "../include/clients.h"
#include "../libs/config.h"
#include "../include/products.h"
#include "../include/interface.h"
#include "../libs/productInfo.h"

void printClientPath(){
	printf("\x1b[1;35mClient Path:\x1b[0m\n"); 
}

void printProductsPath(){
	printf("\x1b[1;35mProducts Path:\x1b[0m\n"); 
}

void printSalesPath(){
	printf("\x1b[1;35mSales path:\x1b[0m\n");
}


static void printFrameTop(){
    system("clear"); 
    puts(COLOR_B_CYAN);
    printf("                     ╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
    printf("                     ║\x1b[1;35m    /$$$$$$   /$$$$$$  /$$    /$$           \x1b[1;36m                                                ║\n");
    printf("                     ║\x1b[1;35m   /$$__  $$ /$$__  $$| $$   | $$           \x1b[1;36m                                                ║\n");
    printf("                     ║\x1b[1;35m  | $$  \\__/| $$  \\__/| $$   | $$         \x1b[1;36m                                                  ║\n");
    printf("                     ║\x1b[1;35m  |  $$$$$$ | $$ /$$$$|  $$ / $$/           \x1b[1;36m                                                ║\n");
    printf("                     ║\x1b[1;35m   \\____  $$| $$|_  $$ \\  $$ $$/          \x1b[1;36m                                                  ║\n");
    printf("                     ║\x1b[1;35m   /$$  \\ $$| $$  \\ $$  \\  $$$/          \x1b[1;36m                                                   ║\n");
    printf("                     ║\x1b[1;35m  |  $$$$$$/|  $$$$$$/   \\  $/             \x1b[1;36m                                                 ║\n");
    printf("                     ║\x1b[1;35m   \\______/  \\______/     \\_/            \x1b[1;36m                                                   ║\n");
    printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
    puts(COLOR_RESET);
}
static void printFrameBottom(){
   puts(COLOR_B_CYAN);
    printf("                     ╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
    puts(COLOR_RESET);
}

static void printPressEnterToContinue(char* color){
        printf(BLINK);
        printf("%s",color);
        printf("press ENTER to continue");
        printf(RESET);
        printf(COLOR_RESET);
}


static void printLoadProducts(){
    int i,j,k;
    int rows = 20;
    int loadTime  = 5000;
    for(i = 0; i < 49; i++){
        system("clear");
        printFrameTop();
        printf("                     \x1b[1;36m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 1/4) loading products           [");
        for(j = 0; j < i; j++)
            printf("#");
        while(j < 50){
            printf("-");
            j++;
        }
        printf("] %i",i*2);
        if(i < 5) printf(" ");
        printf("%% \x1b[1;36m║\n");
        printf(COLOR_B_CYAN);
        for(k = 0; k < rows; k++){
            printf("                     ║                                                                                            ║\n");
        }
        printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
        printFrameBottom();
        usleep(loadTime);
    }
}

static void printLoadClients(){
    int i,j,k;
    int rows = 20;
    int loadTime  = 5000;
    for(i = 0; i < 49; i++){
        system("clear");
        printFrameTop();
        printf("                     \x1b[1;36m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 1/4) loading products           [##################################################] 100%%\x1b[1;36m║\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 2/4) loading clients            [");
        for(j = 0; j < 50; j++){
            if(j < i){
                printf("#");
            }else{
                printf("-");
            }
        }
        printf("] %i",i*2);
        if(i < 5) printf(" ");
        printf("%% \x1b[1;36m║\n");
        printf(COLOR_B_CYAN);
        for(k = 0; k < rows-1; k++){
            printf("                     ║                                                                                            ║\n");
        }
        printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
        printFrameBottom();
        usleep(loadTime);
    }
}

static void printLoadSales(){
    int i,j,k;
    int rows = 20;
    int loadTime  = 5000;
    for(i = 0; i < 49; i++){
        system("clear");
        printFrameTop();
        printf("                     \x1b[1;36m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 1/4) loading products           [##################################################] 100%%\x1b[1;36m║\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 2/4) loading clients            [##################################################] 100%%\x1b[1;36m║\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 3/4) loading sales              [");
        for(j = 0; j < 50; j++){
            if(j < i){
                printf("#");
            }else{
                printf("-");
            }
        }
        printf("] %i",i*2);
        if(i < 5) printf(" ");
        printf("%% \x1b[1;36m║\n");
        for(k = 0; k < rows-2; k++){
            printf("                     ║                                                                                            ║\n");
        }
        printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
        printFrameBottom();
        usleep(loadTime);
    }
}

static void printLoadInterface(){
    int i,j,k;
    int rows = 20;
    int loadTime  = 5000;
    for(i = 0; i < 49; i++){
        system("clear");
        printFrameTop();
        printf("                     \x1b[1;36m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 1/4) loading products           [##################################################] 100%%\x1b[1;36m║\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 2/4) loading clients            [##################################################] 100%%\x1b[1;36m║\n");;
        printf("                     \x1b[1;36m║\x1b[0m ( 3/4) loading sales              [##################################################] 100%%\x1b[1;36m║\n");
        printf("                     \x1b[1;36m║\x1b[0m ( 4/4) loading interface          [");
        for(j = 0; j < 50; j++){
            if(j < i){
                printf("#");
            }else{
                printf("-");
            }
        }
        printf("] %i",i*2);
        if(i < 5) printf(" ");
        printf("%% \x1b[1;36m║\n");
        printf(COLOR_B_CYAN);
        for(k = 0; k < rows-3; k++){
            printf("                     ║                                                                                            ║\n");
        }
        printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
        printFrameBottom();
        usleep(loadTime);
    }
}

static void printBuildingApp(){
    int i;
    int rows = 20;
    system("clear");
    printFrameTop();
    printf("                     \x1b[1;36m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
    printf("                     \x1b[1;36m║\x1b[0m ( 1/4) loading products           [##################################################] 100%%\x1b[1;36m║\n");
    printf("                     \x1b[1;36m║\x1b[0m ( 2/4) loading clients            [##################################################] 100%%\x1b[1;36m║\n");;
    printf("                     \x1b[1;36m║\x1b[0m ( 3/4) loading sales              [##################################################] 100%%\x1b[1;36m║\n");
    printf("                     \x1b[1;36m║\x1b[0m ( 4/4) loading interface          [##################################################] 100%%\x1b[1;36m║\n");
    printf("                     \x1b[1;36m║\x1b[0m \x1b[0m\033[5mBuilding App...\033[0m\x1b[1;35m                                                                            \x1b[1;36m║\n");
    printf(COLOR_B_CYAN);
    for(i = 0; i < rows-4; i++){
        printf("                     ║                                                                                            ║\n");
    }
    printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
    printFrameBottom();
}

void printLoad(){
    printLoadProducts();
    printLoadClients();
    printLoadSales();
    printLoadInterface();
    printBuildingApp();
}

static int numPlaces (int n) {
    if (n < 0) return numPlaces (n*(-1));
    if (n < 10) return 1;
    return 1 + numPlaces (n / 10);
}

static int numPlacesD (double n) {
    if (n < 0) return numPlacesD (n*(-1));
    if (n < 10) return 1;
    return 1 + numPlacesD (n / 10);
}

static void printRowOne(int row,int column){
    printf(COLOR_RESET);
    printf(COLOR_B_CYAN);
    if(row != ROW_1){
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ ║     \x1b[0mSales\x1b[1;36m      ║ ║     \x1b[0mNever\x1b[1;36m      ║ ║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ ║   \x1b[0mAnd Profit\x1b[1;36m   ║ ║    \x1b[0mBought\x1b[1;36m      ║ ║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    }else{
    switch(column){
    case COLUMN_1:{
    printf("                     \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║  \x1b[0m\033[5mGet Current\033[0m\x1b[1;35m   ║\x1b[1;36m ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     \x1b[1;35m║     \x1b[0m\033[5mFiles\033[0m\x1b[1;35m      ║\x1b[1;36m ║    \x1b[0mStarted\x1b[1;36m     ║ ║     \x1b[0mSales\x1b[1;36m      ║ ║     \x1b[0mNever\x1b[1;36m      ║ ║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     \x1b[1;35m║      \x1b[0m\033[5mInfo\033[0m\x1b[1;35m      ║\x1b[1;36m ║   \x1b[0mBy Letter\x1b[1;36m    ║ ║   \x1b[0mAnd Profit\x1b[1;36m   ║ ║    \x1b[0mBought\x1b[1;36m      ║ ║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    break;
    }
    case COLUMN_2:{
    printf("                     ╔════════════════╗ \x1b[1;35m╔════════════════╗ \x1b[1;36m╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ \x1b[1;35m║                ║ \x1b[1;36m║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ \x1b[1;35m║                ║ \x1b[1;36m║                ║ ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ \x1b[1;35m║  \x1b[0m\033[5mGet Products\033[0m\x1b[1;35m  ║ \x1b[1;36m║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ \x1b[1;35m║    \x1b[0m\033[5mStarted\033[0m\x1b[1;35m     ║ \x1b[1;36m║     \x1b[0mSales\x1b[1;36m      ║ ║     \x1b[0mNever\x1b[1;36m      ║ ║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ \x1b[1;35m║   \x1b[0m\033[5mBy Letter\033[0m\x1b[1;35m    ║ \x1b[1;36m║   \x1b[0mAnd Profit\x1b[1;36m   ║ ║    \x1b[0mBought\x1b[1;36m      ║ ║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     ║                ║ \x1b[1;35m║                ║ \x1b[1;36m║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ \x1b[1;35m║                ║ \x1b[1;36m║                ║ ║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ \x1b[1;35m╚════════════════╝ \x1b[1;36m╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    break;
    }
    case COLUMN_3:{
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║  \x1b[0m\033[5mGet Products\033[0m\x1b[1;35m  ║\x1b[1;36m ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ \x1b[1;35m║     \x1b[0m\033[5mSales\033[0m\x1b[1;35m      ║\x1b[1;36m ║     \x1b[0mNever\x1b[1;36m      ║ ║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ \x1b[1;35m║   \x1b[0m\033[5mAnd Profit\033[0m\x1b[1;35m   ║\x1b[1;36m ║    \x1b[0mBought\x1b[1;36m      ║ ║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝\n");
    break;
    }
    case COLUMN_4:{
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║  \x1b[0m\033[5mGet Products\033[0m\x1b[1;35m  ║ \x1b[1;36m║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ ║     \x1b[0mSales\x1b[1;36m      ║ \x1b[1;35m║     \x1b[0m\033[5mNever\033[0m\x1b[1;35m      ║ \x1b[1;36m║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ ║   \x1b[0mAnd Profit\x1b[1;36m   ║ \x1b[1;35m║    \x1b[0m\033[5mBought\033[0m\x1b[1;35m      ║ \x1b[1;36m║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝\n");
    break;
    }
    case COLUMN_5:{
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m \n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║  \x1b[0m\033[5mGet Clients\033[0m\x1b[1;35m   ║\x1b[1;36m \n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ ║     \x1b[0mSales\x1b[1;36m      ║ ║     \x1b[0mNever\x1b[1;36m      ║ \x1b[1;35m║     \x1b[0m\033[5mOf All\033[0m\x1b[1;35m     ║\x1b[1;36m \n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ ║   \x1b[0mAnd Profit\x1b[1;36m   ║ ║    \x1b[0mBought\x1b[1;36m      ║ \x1b[1;35m║    \x1b[0m\033[5mBranches\033[0m\x1b[1;35m    ║\x1b[1;36m \n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m \n");
    break;
    }
    }    
    }
}

static void printRowTwo(int row,int column){
    printf(COLOR_B_CYAN);
    if(row != ROW_2){
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║   \x1b[0mGet Sales\x1b[1;36m    ║ ║      \x1b[0mGet\x1b[1;36m       ║ ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ ║      \x1b[0mAnd\x1b[1;36m       ║ ║    \x1b[0mProduct\x1b[1;36m     ║ ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ ║     \x1b[0mProfit\x1b[1;36m     ║ ║    \x1b[0mBuyers\x1b[1;36m      ║ ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    }else{
    switch(column){
    case COLUMN_1:{
    printf("                     \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║  \x1b[0m\033[5mGet Clients\033[0m\x1b[1;35m   ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║      \x1b[0m\033[5mAnd\033[0m\x1b[1;35m       ║\x1b[1;36m ║  \x1b[0mGet Products\x1b[1;36m  ║ ║   \x1b[0mGet Sales\x1b[1;36m    ║ ║      \x1b[0mGet\x1b[1;36m       ║ ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     \x1b[1;35m║    \x1b[0m\033[5mProducts\033[0m\x1b[1;35m    ║\x1b[1;36m ║     \x1b[0mBought\x1b[1;36m     ║ ║      \x1b[0mAnd\x1b[1;36m       ║ ║    \x1b[0mProduct\x1b[1;36m     ║ ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     \x1b[1;35m║     \x1b[0m\033[5mNever\033[0m\x1b[1;35m      ║\x1b[1;36m ║   \x1b[0mBy Client\x1b[1;36m    ║ ║     \x1b[0mProfit\x1b[1;36m     ║ ║    \x1b[0mBuyers\x1b[1;36m      ║ ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     \x1b[1;35m║  \x1b[0m\033[5mBought Count\033[0m\x1b[1;35m  ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    break;
    }
    case COLUMN_2:{
    printf("                     ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ \x1b[1;35m║  \x1b[0m\033[5mGet Products\033[0m\x1b[1;35m  ║\x1b[1;36m ║   \x1b[0mGet Sales\x1b[1;36m    ║ ║      \x1b[0mGet\x1b[1;36m       ║ ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ \x1b[1;35m║     \x1b[0m\033[5mBought\033[0m\x1b[1;35m     ║\x1b[1;36m ║      \x1b[0mAnd\x1b[1;36m       ║ ║    \x1b[0mProduct\x1b[1;36m     ║ ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ \x1b[1;35m║   \x1b[0m\033[5mBy Client\033[0m\x1b[1;35m    ║\x1b[1;36m ║     \x1b[0mProfit\x1b[1;36m     ║ ║    \x1b[0mBuyers\x1b[1;36m      ║ ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    break;
    }
    case COLUMN_3:{
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║   \x1b[0m\033[5mGet Sales\033[0m\x1b[1;35m    ║\x1b[1;36m ║      \x1b[0mGet\x1b[1;36m       ║ ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ \x1b[1;35m║      \x1b[0m\033[5mAnd\033[0m\x1b[1;35m       ║\x1b[1;36m ║    \x1b[0mProduct\x1b[1;36m     ║ ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ \x1b[1;35m║     \x1b[0m\033[5mProfit\033[0m\x1b[1;35m     ║\x1b[1;36m ║    \x1b[0mBuyers\x1b[1;36m      ║ ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝\n");
    break;
    }
    case COLUMN_4:{
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║   \x1b[0mGet Sales\x1b[1;36m    ║ \x1b[1;35m║      \x1b[0m\033[5mGet\033[0m\x1b[1;35m       ║\x1b[1;36m ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ ║      \x1b[0mAnd\x1b[1;36m       ║ \x1b[1;35m║    \x1b[0m\033[5mProduct\033[0m\x1b[1;35m     ║\x1b[1;36m ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ ║     \x1b[0mProfit\x1b[1;36m     ║ \x1b[1;35m║    \x1b[0m\033[5mBuyers\033[0m\x1b[1;35m      ║\x1b[1;36m ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝\n");
    break;
    }
    case COLUMN_5:{
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m \n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m \n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m \n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║   \x1b[0mGet Sales\x1b[1;36m    ║ ║      \x1b[0mGet\x1b[1;36m       ║ \x1b[1;35m║   \x1b[0m\033[5mGet Client\033[0m\x1b[1;35m   ║\x1b[1;36m \n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ ║      \x1b[0mAnd\x1b[1;36m       ║ ║    \x1b[0mProduct\x1b[1;36m     ║ \x1b[1;35m║    \x1b[0m\033[5mFavorite\033[0m\x1b[1;35m    ║\x1b[1;36m \n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ ║     \x1b[0mProfit\x1b[1;36m     ║ ║    \x1b[0mBuyers\x1b[1;36m      ║ \x1b[1;35m║    \x1b[0m\033[5mProducts\033[0m\x1b[1;35m    ║\x1b[1;36m \n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m \n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m \n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m \n");
    break;
    }
    }
    }
}

static void printRowThree(int row,int column){ 
    printf(COLOR_B_CYAN);
    if(row != ROW_3){
    printf("                     ╔═══════════════════════════════════╗ ╔═══════════════════════════════════╗ ╔════════════════╗\n");
    printf("                     ║                                   ║ ║                                   ║ ║                ║\n");
    printf("                     ║      \x1b[0mGet Top Selled Products\x1b[1;36m      ║ ║  \x1b[0mGet Client Top Profit Products\x1b[1;36m   ║ ║      \x1b[0mQUIT\x1b[1;36m      ║\n");
    printf("                     ║                                   ║ ║                                   ║ ║                ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚═══════════════════════════════════╝ ╚════════════════╝");
    }else{
    switch(column){
    case COLUMN_1:{
    printf("                     \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔═══════════════════════════════════╗ ╔════════════════╗\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║                                   ║ ║                ║\n");
    printf("                     \x1b[1;35m║      \x1b[0m\033[5mGet Top Selled Products\033[0m\x1b[1;35m      ║\x1b[1;36m ║  \x1b[0mGet Client Top Profit Products\x1b[1;36m   ║ ║      \x1b[0mQUIT\x1b[1;36m      ║\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║                                   ║ ║                ║\n");
    printf("                     \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚═══════════════════════════════════╝ ╚════════════════╝");
    break;
    }
    case COLUMN_2:{
    printf("                     ╔═══════════════════════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                                   ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║      \x1b[0mGet Top Selled Products\x1b[1;36m      ║ \x1b[1;35m║  \x1b[0m\033[5mGet Client Top Profit Products\033[0m\x1b[1;35m   ║\x1b[1;36m ║      \x1b[0mQUIT\x1b[1;36m      ║\n");
    printf("                     ║                                   ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ╚═══════════════════════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝");
    break;
    }
    case COLUMN_3:{
    printf("                     ╔═══════════════════════════════════╗ ╔═══════════════════════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m \n");
    printf("                     ║                                   ║ ║                                   ║ \x1b[1;35m║                ║\x1b[1;36m \n");
    printf("                     ║      \x1b[0mGet Top Selled Products\x1b[1;36m      ║ ║  \x1b[0mGet Client Top Profit Products\x1b[1;36m   ║ \x1b[1;35m║      \x1b[0m\033[5mQUIT\033[0m\x1b[1;35m      ║\x1b[1;36m \n");
    printf("                     ║                                   ║ ║                                   ║ \x1b[1;35m║                ║\x1b[1;36m \n");
    printf("                     ╚═══════════════════════════════════╝ ╚═══════════════════════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m ");
    break;
    } 
    }
    }
}

static void printTypeBar(){
    printf(BLINK);
    printf("|");
    printf(RESET);
}

static void printDisplay(int option,int row,int order){
    printf(COLOR_RESET);
    if(row == order){
        if(option == 0){
            printf(" GLOBAL >");
        }else{
            printf(" < BRANCH");
        }
    }else{
        if(option == 0){
            printf(" GLOBAL  ");
        }else{
            printf(" BRANCH  ");
        }    
    }
}

static void printType(int type,int row,int order){
    printf(COLOR_RESET);
    if(row == order){
        if(type == 1){
            printf("< P  ");
        }else{
            printf("  N >");
        }
    }else{
        if(type == 1){
            printf("  P  ");
        }else{
            printf("  N  ");
        }    
    }
}

static void printBranch(int branch,int row,int order){
    printf(COLOR_RESET);
    if(row == order){
        if(branch == 0){
            printf("  1 >");
        }else if(branch == 1){
            printf("< 2 >");
        }else if(branch == 2){
            printf("< 3 >");
        }else{
            printf("< TOTAL");
        }
    }else{
        if(branch < 3){
            printf("  %i  ",branch+1);
        } else{
            printf("  TOTAL");
        }    
    }
}

static void printBranch2(int branch,int row,int order){
    printf(COLOR_RESET);
    if(row == order){
        if(branch == 0){
            printf("  1 >");
        }else if(branch == 1){
            printf("< 2 >");
        }else if(branch == 2){
            printf("< 3  ");
        }
    }else{
        printf("  %i  ",branch+1);   
    }
}

static void printMonth(int month,int row,int order){
    printf(COLOR_RESET);
    if(row == order){
        if(month == 0){
            printf("  1 >");
        }else if(month == 11){
            printf("< 12  ");
        }else{
            printf("< %i >",month+1);
        }
    }else{
        printf("  %i  ",month+1);    
    }
}

static void printClientForm(char* client,int sizeClient,int row,int column,int order){
        printf(COLOR_RESET);
        int i = 0;
        int flag = 0;
        if(row == order){
            while(i < sizeClient){
                if(column == SIZEIDCLIENT || i != column || flag){
                    printf("%c",client[i]);
                    i++;
                }else{
                    printTypeBar();
                    flag++;
                }
            }
            if(sizeClient == 0 || column == sizeClient){
                printTypeBar();
            }
        }
        else{
            for(i = 0; i < sizeClient;i++)
                printf("%c",client[i]);
        }
}

static void printNForm(char* N,int sizeN,int row,int column,int order){
        printf(COLOR_RESET);
        int i = 0;
        int flag = 0;
        if(row == order){
            while(i < sizeN){
                if(column == 8 || i != column || flag){
                    printf("%c",N[i]);
                    i++;
                }else{
                    printTypeBar();
                    flag++;
                }
            }
            if(sizeN == 0 || column == sizeN){
                printTypeBar();
            }
        }
        else{
            for(i = 0; i < sizeN;i++)
                printf("%c",N[i]);
        }
}

static void printProductForm(char* product,int sizeProduct,int row,int column,int order){
        printf(COLOR_RESET);
        int i = 0;
        int flag = 0;
        if(row == order){
            while(i < sizeProduct){
                if(column == SIZEIDPRODUCT || i != column || flag){
                    printf("%c",product[i]);
                    i++;
                }else{
                    printTypeBar();
                    flag++;
                }
            }
            if(sizeProduct == 0 || column == sizeProduct){
                printTypeBar();
            }
        }
        else{
            for(i = 0; i < sizeProduct;i++)
                printf("%c",product[i]);
        }
}

static void printLetterForm(char letter,int sizeLetter,int row,int column,int order){
        printf(COLOR_RESET);
        if(row == order){
            if(column == 0){
                printTypeBar();
                if(sizeLetter == 1){
                    printf("%c",letter);
                }
            }else{
                if(sizeLetter == 1){
                    printf("%c",letter);
                }
                printTypeBar();
            }
        }else{
            if(sizeLetter == 1){
                printf("%c",letter);
            }
        }
}

static void printProductFirstLine(char **products,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 3; i++){
        printf("                     ");
        if(i == 0){  
            printf("╔══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╗╔══════════════╗");
        }else if(i == 1){
            for(j=0;j<columns;j++){
                if(from+j < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",products[from+j]);
                }
                else{
                    printf("║      ");
                }
            }
            printf("║║              ║");
        }else{
            printf("╠══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╣║              ║");
        }
    printf("\n");
    }
}

static void printProductLine(char **products,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 2; i++){
        printf("                     ");
        if(i == 0){
            for(j=0;j<columns;j++){
                if(from+columns < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",products[from+j]);
                }
                else{
                    printf("║      ");
                }
            }
            printf("║║              ║");
        }else{
            printf("╠══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╣║              ║");
        }
    printf("\n");
    }
}

static void printProductLastLine(char **products,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 2; i++){
        printf("                     ");
        if(i == 0){ 
            for(j=0;j<columns;j++){
                if(from+columns < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",products[from+j]);
                }
                else{
                    printf("║      ");
                }
            }
            printf("║║              ║");
        }else{
            printf("╚══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╝║              ║");
        }
    printf("\n");
    }
}

static void printProductFirstLineGPtr(GPtrArray *products,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 3; i++){
        printf("                     ");
        if(i == 0){  
            printf("╔══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╦══════╗╔══════════════╗");
        }else if(i == 1){
            for(j=0;j<columns;j++){
                if(from+j < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",(char *)g_ptr_array_index(products, from+j));
                }
                else{
                    printf("║      ");
                }
            }
            printf("║║              ║");
        }else{
            printf("╠══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╣║              ║");
        }
    printf("\n");
    }
}

static void printProductLineGPtr(GPtrArray* products,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 2; i++){
        printf("                     ");
        if(i == 0){
            for(j=0;j<columns;j++){
                if(from+j < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",(char *)g_ptr_array_index(products, from+j));
                }
                else{
                    printf("║      ");
                }
            }
            printf("║║              ║");
        }else{
            printf("╠══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════╣║              ║");
        }
    printf("\n");
    }
}

static void printProductLastLineGPtr(GPtrArray* products,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 2; i++){
        printf("                     ");
        if(i == 0){ 
            for(j=0;j<columns;j++){
                if(from+columns < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",(char *)g_ptr_array_index(products, from+j));
                }
                else{
                    printf("║      ");
                }
            }
            printf("║║              ║");
        }else{
            printf("╚══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╩══════╝║              ║");
        }
    printf("\n");
    }
}

static void printProductTable(char **products, int from, int rows, int columns,int qLength){
    int row;
    int count = from;
    for(row = 0; row < rows; row++){
        if(row == 0){
            printProductFirstLine(products,count,qLength,columns);
        }else if(row == rows-1){
            printProductLastLine(products,count,qLength,columns);
        }else{
            printProductLine(products,count,qLength,columns);
        }
        count+=columns;
    }
}

static void printClientFirstLineGPtr(GPtrArray *clients,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 3; i++){
        printf("                     ");
        if(i == 0){  
            printf("╔═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╗╔═══════╗");
        }else if(i == 1){
            for(j=0;j<columns;j++){
                if(from+j < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",(char *)g_ptr_array_index(clients, from+j));
                }
                else{
                    printf("║     ");
                }
            }
            printf("║║       ║");
        }else{
            printf("╠═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╣║       ║");
        }
    printf("\n");
    }
}

static void printClientLineGPtr(GPtrArray* clients,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 2; i++){
        printf("                     ");
        if(i == 0){
            for(j=0;j<columns;j++){
                if(from+columns < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",(char *)g_ptr_array_index(clients, from+j));
                }
                else{
                    printf("║     ");
                }
            }
            printf("║║       ║");
        }else{
            printf("╠═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╣║       ║");
        }
    printf("\n");
    }
}

static void printClientLastLineGPtr(GPtrArray* clients,int from, int qLength, int columns){
    int i,j;
    printf(COLOR_B_CYAN);
    for(i = 0; i < 2; i++){
        printf("                     ");
        if(i == 0){ 
            for(j=0;j<columns;j++){
                if(from+columns < qLength){
                    printf("║\x1b[0m%s\x1b[1;36m",(char *)g_ptr_array_index(clients, from+j));
                }
                else{
                    printf("║     ");
                }
            }
            printf("║║       ║");
        }else{
            printf("╚═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╝║       ║");
        }
    printf("\n");
    }
}

static void printProductTableGPtr(GPtrArray* products, int from, int rows, int columns,int qLength){
    int row;
    int count = from;
    for(row = 0; row < rows; row++){
        if(row == 0){
            printProductFirstLineGPtr(products,count,qLength,columns);
        }else if(row == rows-1){
            printProductLastLineGPtr(products,count,qLength,columns);
        }else{
            printProductLineGPtr(products,count,qLength,columns);
        }
        count+=columns;
    }
}

static void printProductFirstLineGPtr2(GPtrArray *products,int row, int qLength){
    int i,j;
    printf(COLOR_B_CYAN);
    char *id;
    int idNeedsFree = 0;
    if(row < qLength){
        ProductInfo info = (ProductInfo)g_ptr_array_index(products, row);
        id = getProductInfoProductId(info);
        idNeedsFree = 1;
        int unitsSold0 = getProductInfoUnitsSold(info, 1);
        int numberOfClients0 = getProductInfoNumberOfClients(info, 1);
        int unitsSold1 = getProductInfoUnitsSold(info, 2);
        int numberOfClients1 = getProductInfoNumberOfClients(info, 2);
        int unitsSold2 = getProductInfoUnitsSold(info, 3);
        int numberOfClients2 = getProductInfoNumberOfClients(info, 3);
        for(i = 0; i < 3; i++){
        printf("                     ");
        if(i == 0){  
            printf("╔════════╦══════════════╦════════════╦══════════════╦════════════╦══════════════╦════════════╗\n");
            printf("                     ");
            printf("║PRODUCT ║ CLIENTS - B1 ║ UNITS - B1 ║ CLIENTS - B2 ║ UNITS - B2 ║ CLIENTS - B3 ║ UNITS - B3 ║\n");
            printf("                     ");
            printf("╠════════╬══════════════╬════════════╬══════════════╬════════════╬══════════════╬════════════╣");
        }else if(i == 1){ 
            printf("║ \x1b[0m%s\x1b[1;36m ",id);
            printf("║\x1b[0m");
            for(j=0;j<14-numPlaces(numberOfClients0);j++)
                printf("0");
            printf("%d\x1b[1;36m",numberOfClients0);
            printf("║\x1b[0m");
            for(j=0;j<12-numPlaces(unitsSold0);j++)
                printf("0");
            printf("%d\x1b[1;36m",unitsSold0);
            printf("║\x1b[0m");
            for(j=0;j<14-numPlaces(numberOfClients1);j++)
                printf("0");
            printf("%d\x1b[1;36m",numberOfClients1);
            printf("║\x1b[0m");
            for(j=0;j<12-numPlaces(unitsSold1);j++)
                printf("0");
            printf("%d\x1b[1;36m",unitsSold1);
            printf("║\x1b[0m");
            for(j=0;j<14-numPlaces(numberOfClients2);j++)
                printf("0");
            printf("%d\x1b[1;36m",numberOfClients2);
            printf("║\x1b[0m");
            for(j=0;j<12-numPlaces(unitsSold2);j++)
                printf("0");
            printf("%d\x1b[1;36m",unitsSold2);
            printf("║");
        }else{
            printf("╠════════╬══════════════╬════════════╬══════════════╬════════════╬══════════════╬════════════╣");
        }
        printf("\n");
        }
    } else{
        for(i = 0; i < 3; i++){
        printf("                     ");
        if(i == 0){  
            printf("╔════════╦══════════════╦════════════╦══════════════╦════════════╦══════════════╦════════════╗\n");
            printf("                     ");
            printf("║PRODUCT ║ CLIENTS - B1 ║ UNITS - B1 ║ CLIENTS - B2 ║ UNITS - B2 ║ CLIENTS - B3 ║ UNITS - B3 ║\n");
            printf("                     ");
            printf("╠════════╬══════════════╬════════════╬══════════════╬════════════╬══════════════╬════════════╣");
        }else if(i == 1){
            printf("║        ║              ║            ║              ║            ║              ║            ║");
        }else{
            printf("╠════════╬══════════════╬════════════╬══════════════╬════════════╬══════════════╬════════════╣");
        }
        printf("\n");
        }
    }
	if (idNeedsFree) free(id);
}

static void printProductLineGPtr2(GPtrArray* products,int row, int qLength){
    int i,j;
    char *id;
    int idNeedsFree = 0;
    printf(COLOR_B_CYAN);
    if(row < qLength){ 
        ProductInfo info = (ProductInfo)g_ptr_array_index(products, row);
        id = getProductInfoProductId(info);
	idNeedsFree = 1;
        int unitsSold0 = getProductInfoUnitsSold(info, 1);
        int numberOfClients0 = getProductInfoNumberOfClients(info, 1);
        int unitsSold1 = getProductInfoUnitsSold(info, 2);
        int numberOfClients1 = getProductInfoNumberOfClients(info, 2);
        int unitsSold2 = getProductInfoUnitsSold(info, 3);
        int numberOfClients2 = getProductInfoNumberOfClients(info, 3);
        for(i = 0; i < 2; i++){
            printf("                     ");
            if(i == 0){ 
                printf("║ \x1b[0m%s\x1b[1;36m ",id);
                printf("║\x1b[0m");
                for(j=0;j<14-numPlaces(numberOfClients0);j++)
                    printf("0");
                printf("%d\x1b[1;36m",numberOfClients0);
                printf("║\x1b[0m");
                for(j=0;j<12-numPlaces(unitsSold0);j++)
                    printf("0");
                printf("%d\x1b[1;36m",unitsSold0);
                printf("║\x1b[0m");
                for(j=0;j<14-numPlaces(numberOfClients1);j++)
                    printf("0");
                printf("%d\x1b[1;36m",numberOfClients1);
                printf("║\x1b[0m");
                for(j=0;j<12-numPlaces(unitsSold1);j++)
                    printf("0");
                printf("%d\x1b[1;36m",unitsSold1);
                printf("║\x1b[0m");
                for(j=0;j<14-numPlaces(numberOfClients2);j++)
                    printf("0");
                printf("%d\x1b[1;36m",numberOfClients2);
                printf("║\x1b[0m");
                for(j=0;j<12-numPlaces(unitsSold2);j++)
                    printf("0");
                printf("%d\x1b[1;36m",unitsSold2);
                printf("║");
            }else{
                printf("╠════════╬══════════════╬════════════╬══════════════╬════════════╬══════════════╬════════════╣");
            }
        printf("\n");
        }
    }else{
        for(i = 0; i < 2; i++){
            printf("                     ");
            if(i == 0){ 
                printf("║        ║              ║            ║              ║            ║              ║            ║");    
            }else{
                printf("╠════════╬══════════════╬════════════╬══════════════╬════════════╬══════════════╬════════════╣");
            }
        printf("\n");
        }
    }
   if(idNeedsFree) free(id);
}

static void printProductLastLineGPtr2(GPtrArray* products,int row, int qLength){
    int i,j;
    printf(COLOR_B_CYAN);
    char *id;
    int idNeedsFree = 0;
    if(row < qLength){
        ProductInfo info = (ProductInfo)g_ptr_array_index(products, row);
        id = getProductInfoProductId(info);
	idNeedsFree = 1;
        int unitsSold0 = getProductInfoUnitsSold(info, 1);
        int numberOfClients0 = getProductInfoNumberOfClients(info, 1);
        int unitsSold1 = getProductInfoUnitsSold(info, 2);
        int numberOfClients1 = getProductInfoNumberOfClients(info, 2);
        int unitsSold2 = getProductInfoUnitsSold(info, 3);
        int numberOfClients2 = getProductInfoNumberOfClients(info, 3);
        for(i = 0; i < 2; i++){
            printf("                     ");
            if(i == 0){
                printf("║ \x1b[0m%s\x1b[1;36m ",id);
                printf("║\x1b[0m");
                for(j=0;j<14-numPlaces(numberOfClients0);j++)
                    printf("0");
                printf("%d\x1b[1;36m",numberOfClients0);
                printf("║\x1b[0m");
                for(j=0;j<12-numPlaces(unitsSold0);j++)
                    printf("0");
                printf("%d\x1b[1;36m",unitsSold0);
                printf("║\x1b[0m");
                for(j=0;j<14-numPlaces(numberOfClients1);j++)
                    printf("0");
                printf("%d\x1b[1;36m",numberOfClients1);
                printf("║\x1b[0m");
                for(j=0;j<12-numPlaces(unitsSold1);j++)
                    printf("0");
                printf("%d\x1b[1;36m",unitsSold1);
                printf("║\x1b[0m");
                for(j=0;j<14-numPlaces(numberOfClients2);j++)
                    printf("0");
                printf("%d\x1b[1;36m",numberOfClients2);
                printf("║\x1b[0m");
                for(j=0;j<12-numPlaces(unitsSold2);j++)
                    printf("0");
                printf("%d\x1b[1;36m",unitsSold2);
                printf("║");
            }else{
                printf("╚════════╩══════════════╩════════════╩══════════════╩════════════╩══════════════╩════════════╝");
            }
        printf("\n");
        }
    }else{
        for(i = 0; i < 2; i++){
            printf("                     ");
            if(i == 0){
                printf("║        ║              ║            ║              ║            ║              ║            ║");    
            }else{
                printf("╚════════╩══════════════╩════════════╩══════════════╩════════════╩══════════════╩════════════╝");
            }
        printf("\n");
        }
    }
	if (idNeedsFree) free(id);
}


static void printProductTableGPtr2(GPtrArray* productInfoArray, int from, int rows, int qLength){
    int row;
    int count = 0;
    for(row = from; row < rows+from; row++){
        if(row == from){
            printProductFirstLineGPtr2(productInfoArray,row,qLength);
        }else if(row == from+rows-1){
            printProductLastLineGPtr2(productInfoArray,row,qLength);
        }else{
            printProductLineGPtr2(productInfoArray,row,qLength);
        }
        count++;
    }
}

static void printClientTableGPtr(GPtrArray* clients, int from, int rows, int columns,int qLength){
    int row;
    int count = from;
    for(row = 0; row < rows; row++){
        if(row == 0){
            printClientFirstLineGPtr(clients,count,qLength,columns);
        }else if(row == rows-1){
            printClientLastLineGPtr(clients,count,qLength,columns);
        }else{
            printClientLineGPtr(clients,count,qLength,columns);
        }
        count+=columns;
    }
}

static void printLastRowQuery2(int fromIndex,int to,int qLength,char letter,double time){
    int from = fromIndex+1;
    printf("                     ╔═══════════════════════════════════╗ ╔══════════════════════════════════════╗║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║                                   ║ ║        \x1b[1;35mLETTER:\x1b[0m %c\x1b[1;36m                     ║║              ║\n",letter);
    printf("                     ║   \x1b[1;35mLESS:\x1b[0m KEY-UP\x1b[1;35m   MORE:\x1b[0m KEY-DOWN\x1b[1;36m   ║ ║                                      ║║              ║\n");
    printf("                     ║                                   ║ ║        \x1b[1;35mQuery2 Time:\x1b[0m %lf\x1b[1;36m         ║║              ║\n",time);
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║         \x1b[0m%i \x1b[1;35m- \x1b[0m%i \x1b[1;35m/ %i\x1b[1;36m",from,to,qLength);
    int nDigits = 0;
    nDigits += numPlaces(from);
    nDigits += numPlaces(to);
    nDigits += numPlaces(qLength);
    int i;
    for(i = 0;i<20-nDigits;i++){
        printf(" ");
    }
    printf("║ ║       ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("        \x1b[1;36m║║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚══════════════════════════════════════╝╚══════════════╝");
}

static void printLastRowQuery4(int from,int to,int qLength,int branch,double time){
    printf("                     ╔═══════════════════════════════════╗ ╔══════════════════════════════════════╗║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    if(branch == 3){
    printf("                     ║                                   ║ ║        \x1b[1;35mBRANCH: \x1b[0mTOTAL\x1b[1;36m                 ║║              ║\n");    
    }else{
    printf("                     ║                                   ║ ║        \x1b[1;35mBRANCH: \x1b[0m%i\x1b[1;36m                     ║║              ║\n",branch+1);
    }
    printf("                     ║   \x1b[1;35mLESS:\x1b[0m KEY-UP   \x1b[1;35mMORE:\x1b[0m KEY-DOWN\x1b[1;36m   ║ ║                                      ║║              ║\n");
    printf("                     ║                                   ║ ║        \x1b[1;35mQuery4 Time:\x1b[0m %lf\x1b[1;36m         ║║              ║\n",time);
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║         \x1b[0m%i \x1b[1;35m- \x1b[0m%i \x1b[1;35m/ %i\x1b[1;36m",from,to,qLength);
    int nDigits = 0;
    nDigits += numPlaces(from);
    nDigits += numPlaces(to);
    nDigits += numPlaces(qLength);
    int i;
    for(i = 0;i<20-nDigits;i++){
        printf(" ");
    }
    printf("║ ║       ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("        \x1b[1;36m║║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚══════════════════════════════════════╝╚══════════════╝");
}

static void printLastRowQuery5(int from,int to,int qLength,double time){
   printf("                     ╔═══════════════════════════════════╗ ╔═════════════════════════════════════════════╗║       ║\n");
    printf("                     ║                                   ║ ║                                             ║║       ║\n");
    printf("                     ║                                   ║ ║        \x1b[1;35mCLIENTS OF ALL BRANCHES  \x1b[1;36m            ║║       ║\n");
    printf("                     ║   \x1b[1;35mLESS:\x1b[0m KEY-UP   \x1b[1;35mMORE:\x1b[0m KEY-DOWN\x1b[1;36m   ║ ║                                             ║║       ║\n");
    printf("                     ║                                   ║ ║        \x1b[1;35mQuery5 Time:\x1b[0m %lf \x1b[1;36m               ║║       ║\n",time);
    printf("                     ║                                   ║ ║                                             ║║       ║\n");
    printf("                     ║         \x1b[0m%i \x1b[1;35m- \x1b[0m%i \x1b[1;35m/ %i\x1b[1;36m",from,to,qLength);
    int nDigits = 0;
    nDigits += numPlaces(from);
    nDigits += numPlaces(to);
    nDigits += numPlaces(qLength);
    int i;
    for(i = 0;i<20-nDigits;i++){
        printf(" ");
    }
    printf("║ ║       ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("               \x1b[1;36m║║       ║\n");
    printf("                     ║                                   ║ ║                                             ║║       ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚═════════════════════════════════════════════╝╚═══════╝");
}


static void printTitleQuery7(){
    printf(COLOR_B_CYAN);
    printf("                     ╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
    printf("                     ║                                 \x1b[1;35mGET PRODUCTS BOUGHT BY CLIENT\x1b[1;36m                              ║\n");
    printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝\n");
}

static void printLastRowQuery9(char* product,int from,int to,int qLength,int branch,char type,double time){
    printf("                     ╔═══════════════════════════════════╗ ╔═════════════════════════════════════════════╗║       ║\n");
    printf("                     ║                                   ║ ║                                             ║║       ║\n");
    printf("                     ║   \x1b[1;35mPRODUCT:\x1b[0m %s\x1b[1;36m                 ║ ║        \x1b[1;35mBRANCH:\x1b[0m %i     TYPE:\x1b[0m %c\x1b[1;36m                ║║       ║\n",product,branch+1,type);
    printf("                     ║                                   ║ ║                                             ║║       ║\n");
    printf("                     ║   \x1b[1;35mLESS:\x1b[0m KEY-UP    \x1b[1;35mMORE:\x1b[0m KEY-DOWN\x1b[1;36m  ║ ║        \x1b[1;35mQuery9 Time:\x1b[0m %lf\x1b[1;36m                ║║       ║\n",time);
    printf("                     ║                                   ║ ║                                             ║║       ║\n");
    printf("                     ║         \x1b[0m%i \x1b[1;35m- \x1b[0m%i \x1b[1;35m/ %i\x1b[1;36m",from,to,qLength);
    int nDigits = 0;
    nDigits += numPlaces(from);
    nDigits += numPlaces(to);
    nDigits += numPlaces(qLength);
    int i;
    for(i = 0;i<20-nDigits;i++){
        printf(" ");
    }
    printf("║ ║       ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("               \x1b[1;36m║║       ║\n");
    printf("                     ║                                   ║ ║                                             ║║       ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚═════════════════════════════════════════════╝╚═══════╝");
}

static void printLastRowQuery10(char* client,int from,int to,int qLength,int month,double time){
    printf("                     ╔═══════════════════════════════════╗ ╔══════════════════════════════════════╗║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║   \x1b[1;35mCLIENT:\x1b[0m %s\x1b[1;36m                   ║ ║        \x1b[1;35mMONTH:\x1b[0m %i\x1b[1;36m                      ║║              ║\n",client,month);
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║   \x1b[1;35mLESS:\x1b[0m KEY-UP   MORE:\x1b[0m KEY-DOWN\x1b[1;36m   ║ ║        \x1b[1;35mQuery10 Time:\x1b[0m %lf\x1b[1;36m        ║║              ║\n",time);
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║         \x1b[0m%i \x1b[1;35m- \x1b[0m%i \x1b[1;35m/ %i\x1b[1;36m",from,to,qLength);
    int nDigits = 0;
    nDigits += numPlaces(from);
    nDigits += numPlaces(to);
    nDigits += numPlaces(qLength);
    int i;
    for(i = 0;i<20-nDigits;i++){
        printf(" ");
    }
    printf("║ ║       ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("        \x1b[1;36m║║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚══════════════════════════════════════╝╚══════════════╝");
}

static void printLastRowQuery11(int from,int to,int qLength,double time){
    printf("                     ╔═══════════════════════════════════╗ ╔══════════════════════════════════════════════════════╗\n");
    printf("                     ║                                   ║ ║                                                      ║\n");
    printf("                     ║                                   ║ ║        \x1b[1;35mGET TOP SELLED PRODUCTS\x1b[1;36m                       ║\n");
    printf("                     ║   \x1b[1;35mLESS:\x1b[0m KEY-UP\x1b[1;35m   MORE:\x1b[0m KEY-DOWN\x1b[1;36m   ║ ║                                                      ║\n");
    printf("                     ║                                   ║ ║        \x1b[1;35mQuery11 Time:\x1b[0m %lf\x1b[1;36m                        ║\n",time);
    printf("                     ║                                   ║ ║                                                      ║\n");
    printf("                     ║         \x1b[0m%i \x1b[1;35m- \x1b[0m%i \x1b[1;35m/ %i\x1b[1;36m",from,to,qLength);
    int nDigits = 0;
    nDigits += numPlaces(from);
    nDigits += numPlaces(to);
    nDigits += numPlaces(qLength);
    int i;
    for(i = 0;i<20-nDigits;i++){
        printf(" ");
    }
    printf("║ ║       ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("        \x1b[1;36m                ║\n");
    printf("                     ║                                   ║ ║                                                      ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚══════════════════════════════════════════════════════╝");
}

static void printLastRowQuery12(char* clients, int from,int to,int qLength,double time){
    printf("                     ╔═══════════════════════════════════╗ ╔══════════════════════════════════════╗║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║   \x1b[1;35mCLIENT:\x1b[0m %s\x1b[1;36m                   ║ ║    \x1b[1;35mGET CLIENT TOP PROFIT PRODUCTS\x1b[1;36m    ║║              ║\n",clients);
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║   \x1b[1;35mLESS:\x1b[0m KEY-UP   \x1b[1;35mMORE:\x1b[0m KEY-DOWN\x1b[1;36m   ║ ║        \x1b[1;35mQuery12 Time:\x1b[0m %lf\x1b[1;36m        ║║              ║\n",time);
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ║         \x1b[0m%i \x1b[1;35m- \x1b[0m%i \x1b[1;35m/ %i\x1b[1;36m",from,to,qLength);
    int nDigits = 0;
    nDigits += numPlaces(from);
    nDigits += numPlaces(to);
    nDigits += numPlaces(qLength);
    int i;
    for(i = 0;i<20-nDigits;i++){
        printf(" ");
    }
    printf("║ ║       ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("        \x1b[1;36m║║              ║\n");
    printf("                     ║                                   ║ ║                                      ║║              ║\n");
    printf("                     ╚═══════════════════════════════════╝ ╚══════════════════════════════════════╝╚══════════════╝");
}

static void printIntQ3(int n){
    char buf[12];
    int nDigits;
    nDigits = sprintf(buf,"%d", n);
    int i;
    printf(COLOR_RESET);
    for(i = 0; i < 12-nDigits;i++){
        printf("0");
    }
    printf("%s\x1b[1;35m║",buf);
    printf(COLOR_B_PINK);
}

static void printFloatQ3(float n){
    int nDigits = numPlaces(floor(n));
    int i;
    printf(COLOR_RESET);
    printf("%.2f",n);
    for(i = 0; i < 11-(nDigits+2);i++){
        printf("0");
    }
    printf(COLOR_B_PINK);
    printf("║");
}

void printQuery1(double time){
    int i;
    int rows = 20;
    system("clear");
    printFrameTop();
    printf("                     \x1b[1;36m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
    printf("                     \x1b[1;36m║\x1b[0m ( 1/4) loading products           [##################################################] 100%%\x1b[1;36m║\n");
    printf("                     \x1b[1;36m║\x1b[0m ( 2/4) loading clients            [##################################################] 100%%\x1b[1;36m║\n");
    printf("                     \x1b[1;36m║\x1b[0m ( 3/4) loading sales              [##################################################] 100%%\x1b[1;36m║\n");
    printf("                     \x1b[1;36m║\x1b[0m ( 4/4) loading interface          [##################################################] 100%%\x1b[1;36m║\n");
    printf("                     \x1b[1;36m║\x1b[0m Building App...                                                                            \x1b[1;36m║\n");
    printf(COLOR_B_CYAN);
    for(i = 0; i < rows-13; i++){
            printf("                     ║                                                                                            ║\n");
    }
    printf("                     ║                                   ");
    printPressEnterToContinue(COLOR_B_PINK);
    printf("                                  \x1b[1;36m║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ║  \x1b[1;35mQuery1 Time:\x1b[0m %lf\x1b[1;36m",time);
    printf("                                                                     ║\n");
    printf("                     ║                                                                                            ║\n");
    printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
    printFrameBottom();
    char buffer = '\0';
    while(buffer != ENTER){
        system("/bin/stty raw");
        buffer = getchar();
        system("/bin/stty cooked");
    }
}

void printQuery2(char **products, int from, int rows, int columns,int qLength,char letter,double time) {
    printFrameTop();
    printProductTable(products,from,rows,columns,qLength);
    if(from+99 < qLength){
        printLastRowQuery2(from,from+99,qLength,letter,time);
    }else{
        printLastRowQuery2(from,qLength,qLength,letter,time);
    }
}

void printQuery3(int *numSalesArray, float *valueSalesArray ,char *id, int option,double time) {
    printFrameTop();
    printf(COLOR_B_CYAN);
    if(option == 0){
        printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗ ╔════════════════╗\x1b[1;36m\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m║              %s               ║ ║                ║\x1b[1;36m\n",id);
        printf("                     ║                ║ ║                ║ \x1b[1;35m╠═════════╦════════════╦════════════╣ ║                ║\x1b[1;36m\n");
        printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║ GLOBAL  ║   TYPE N   ║   TYPE P   ║ ║  Query3 Time:  ║\x1b[1;36m\n");
        printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ \x1b[1;35m╠═════════╬════════════╬════════════╣ ║    \x1b[0m%lf    \x1b[1;35m║\x1b[1;36m\n",time);
        printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ \x1b[1;35m║ SALES   ║");
        printIntQ3(numSalesArray[BRANCH_1]+numSalesArray[BRANCH_2]+numSalesArray[BRANCH_3]);
        printIntQ3(numSalesArray[BRANCH_1+NUMBEROFBRANCHES]+numSalesArray[BRANCH_2+NUMBEROFBRANCHES]+numSalesArray[BRANCH_3+NUMBEROFBRANCHES]);
        printf(" ║                ║\x1b[1;36m\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m╠═════════╬════════════╬════════════╣ ║     \x1b[1;35m\033[5mENTER\033[0m\x1b[1;35m      ║\x1b[1;36m\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m║ REVENUE ║");
        printFloatQ3(valueSalesArray[BRANCH_1]+valueSalesArray[BRANCH_2]+valueSalesArray[BRANCH_3]);
        printFloatQ3(valueSalesArray[BRANCH_1+NUMBEROFBRANCHES]+valueSalesArray[BRANCH_2+NUMBEROFBRANCHES]+valueSalesArray[BRANCH_3+NUMBEROFBRANCHES]);
        printf(" ║                ║\x1b[1;36m\n");
        printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚═════════╩════════════╩════════════╝ ╚════════════════╝\x1b[1;36m \n");
        printRowTwo(ROW_1,COLUMN_3);
        printRowThree(ROW_1,COLUMN_3);
    }else{
        printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m║              %s               ║\x1b[1;36m ║                ║\n",id);
        printf("                     ║                ║ ║                ║ \x1b[1;35m╠═════════╦════════════╦════════════╣\x1b[1;36m ║                ║\n");
        printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║ BRANCH 1║   TYPE N   ║   TYPE P   ║\x1b[1;36m ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
        printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ║     \x1b[0mOf All\x1b[1;36m     ║\n");
        printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ \x1b[1;35m║ SALES   ║");
        printIntQ3(numSalesArray[BRANCH_1]);
        printIntQ3(numSalesArray[BRANCH_1+NUMBEROFBRANCHES]);
        printf("\x1b[1;36m ║    \x1b[0mBranches\x1b[1;36m    ║\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ║                ║\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m║ REVENUE ║");
        printFloatQ3(valueSalesArray[BRANCH_1]);
        printFloatQ3(valueSalesArray[BRANCH_1+NUMBEROFBRANCHES]);
        printf("\x1b[1;36m ║                ║\n");
        printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ╚════════════════╝\n");
        printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m║ BRANCH 2║   TYPE N   ║   TYPE P   ║\x1b[1;36m ╔════════════════╗\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ║                ║\n");
        printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ \x1b[1;35m║ SALES   ║");
        printIntQ3(numSalesArray[BRANCH_2]);
        printIntQ3(numSalesArray[BRANCH_2+NUMBEROFBRANCHES]);
        printf("\x1b[1;36m ║                ║\n");
        printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
        printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ \x1b[1;35m║ REVENUE ║");
        printFloatQ3(valueSalesArray[BRANCH_2]);
        printFloatQ3(valueSalesArray[BRANCH_2+NUMBEROFBRANCHES]);
        printf("\x1b[1;36m ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
        printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ║    \x1b[0mProducts\x1b[1;36m    ║\n");
        printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ \x1b[1;35m║ BRANCH 3║   TYPE N   ║   TYPE P   ║\x1b[1;36m ║                ║\n");
        printf("                     ║                ║ ║                ║ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ║                ║\n");
        printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m║ SALES   ║");
        printIntQ3(numSalesArray[BRANCH_3]);
        printIntQ3(numSalesArray[BRANCH_3+NUMBEROFBRANCHES]);
        printf("\x1b[1;36m ╚════════════════╝\n");
        printf("                     ╔═══════════════════════════════════╗ \x1b[1;35m╠═════════╬════════════╬════════════╣\x1b[1;36m ╔════════════════╗\n");
        printf("                     ║                                   ║ \x1b[1;35m║ REVENUE ║");
        printFloatQ3(valueSalesArray[BRANCH_3]);
        printFloatQ3(valueSalesArray[BRANCH_3+NUMBEROFBRANCHES]);
        printf("\x1b[1;36m ║                ║\n");
        printf("                     ║      \x1b[0mGet Top Selled Products\x1b[1;36m      ║ \x1b[1;35m╠═════════╩════════════╩════════════╣\x1b[1;36m ║      \x1b[0mQUIT\x1b[1;36m      ║\n");
        printf("                     ║                                   ║ \x1b[1;35m║ Query3 Time: \x1b[0m%lf       \x1b[1;35m\033[5mENTER\033[0m\x1b[1;35m ║\x1b[1;36m ║                ║\n",time);
        printf("                     ╚═══════════════════════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝");
    }
    printFrameBottom();
}

void printQuery4(GPtrArray *products, int from, int rows, int columns,int qLength,int branch,double time) {
    printFrameTop();
    printProductTableGPtr(products,from,rows,columns,qLength);
    if(from+99 < qLength){
        printLastRowQuery4(from,from+99,qLength,branch,time);
    }else{
        printLastRowQuery4(from,qLength,qLength,branch,time);
    }
}

void printQuery5(GPtrArray *clients, int from, int rows, int columns,int qLength,double time) {
    printFrameTop();
    printClientTableGPtr(clients,from,rows,columns,qLength);
    if(from+(9*14) < qLength){
        printLastRowQuery5(from,from+(9*14),qLength,time);
    }else{
        printLastRowQuery5(from,qLength,qLength,time);
    }
}

void printQuery6(int clients, int products,double time) {
    printFrameTop();
    printRowOne(ROW_2,COLUMN_1);
    int digitsP, digitsC;
    int i;
    digitsC = numPlaces(clients);
    digitsP = numPlaces(products);
    printf("                     \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║ Clients: \x1b[0m%d\x1b[1;35m",clients);
    for(i = 0; i < 25-digitsC; i++)
        printf(" ");
    printf("║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║   \x1b[0mGet Sales\x1b[1;36m    ║ ║      \x1b[0mGet\x1b[1;36m       ║ ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     \x1b[1;35m║ Products: \x1b[0m%d\x1b[1;35m",products);
    for(i = 0; i < 24-digitsP; i++)
        printf(" ");
    printf("║\x1b[1;36m ║      \x1b[0mAnd\x1b[1;36m       ║ ║    \x1b[0mProduct\x1b[1;36m     ║ ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║     \x1b[0mProfit\x1b[1;36m     ║ ║    \x1b[0mBuyers\x1b[1;36m      ║ ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     \x1b[1;35m║ Query6 Time:\x1b[0m %lf",time);
    printf("     \x1b[1;35m\033[5mENTER\033[0m\x1b[1;35m   \x1b[1;35m║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    printRowThree(ROW_2,COLUMN_1);
    printFrameBottom();
}

void printQuery7(int **clientQuantities, int *totalQuantityBranches,
                int *totalQuantityMonths, int totalQuantity, char *id,double time) {
    printFrameTop();
    int branch,month;
    char buf[10];
    int i,ndigits;
    printTitleQuery7();
    printf(COLOR_B_PINK);
    printf("                     ╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
    printf("                     ║                                           %s                                            ║\n",id);
    puts("                     ╠══════════════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╦═════╣");
    puts("                     ║ BRANCHES     ║ JAN ║ FEV ║ MAR ║ APR ║ MAY ║ JUN ║ JUL ║ AUG ║ SEP ║ OCT ║ NOV ║ DEZ ║TOTAL║");
    puts("                     ╠══════════════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╣");
    for(branch = 0; branch <= NUMBEROFBRANCHES; branch++){
        if(branch != NUMBEROFBRANCHES){
            printf("                     ");
            printf("║ BRANCH %d     ║", branch+1);
            for(month = 0; month <= NMONTHS; month++){
                printf(COLOR_RESET);
                if (month != NMONTHS)
                    ndigits =
                        sprintf(buf,"%d", clientQuantities[branch][month]);
                else
                    ndigits = sprintf(buf,"%d", totalQuantityBranches[branch]);
                for (i = 0; i < 5 - ndigits; i++) printf("0");
                printf("%s", buf);
                printf(COLOR_B_PINK);
                printf("║");
            }
            printf("\n                     ");
            printf("╠══════════════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╣\n");
        }else{
            printf("                     ");
            printf("║ TOTAL        ║");
            for(month = 0; month <= NMONTHS; month++){
                printf(COLOR_RESET);
                if (month != NMONTHS)
                    ndigits = sprintf(buf,"%d", totalQuantityMonths[month]);
                else
                    ndigits = sprintf(buf,"%d", totalQuantity);
                for (i = 0; i < 5 - ndigits; i++) printf("0");
                printf("%s", buf);
                printf(COLOR_B_PINK);
                printf("║");
            }
            printf("\n");
        }
    }
    puts("                     ╠══════════════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╣");
    printf("                     ║ Query7 Time:\x1b[0m %lf \x1b[1;35m                                                               \x1b[1;35m\033[5mENTER\033[0m\x1b[1;35m ║\n",time);
    puts("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
    printRowThree(ROW_2,COLUMN_2);
    printFrameBottom();
}

void printQuery8(int numSales, double valueSales, double time) {
    int i;
    int nDigits,nDigits2;
    nDigits = numPlaces(numSales);
    nDigits2 = numPlacesD(valueSales);
    printFrameTop();
    printRowOne(ROW_2,COLUMN_3);
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ \x1b[1;35m║ Sales:\x1b[0m %d",numSales);
    for(i=0;i < 27-nDigits;i++)
        printf(" ");
    printf("\x1b[1;35m║ \x1b[1;36m║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║                                   ║\x1b[1;36m ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ \x1b[1;35m║ Profits:\x1b[0m %.2lf",valueSales);
    for(i=0;i < 22-nDigits2;i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ \x1b[1;35m║                                   ║\x1b[1;36m ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ \x1b[1;35m║ Query Time8:\x1b[0m %lf",time);
    printf("     \x1b[1;35m\033[5mENTER\033[0m\x1b[1;35m   \x1b[1;35m║ \x1b[1;36m║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝\x1b[1;36m\n");
    printRowThree(ROW_2,COLUMN_3);
    printFrameBottom();
}

void printQuery9(GPtrArray *clients,char *product, int from, int rows, int columns,int qLength,int branch,char type,double time) {
    printFrameTop();
    printClientTableGPtr(clients,from,rows,columns,qLength);
    if(from+(9*14) < qLength){
        printLastRowQuery9(product,from,from+(9*14),qLength,branch,type,time);
    }else{
        printLastRowQuery9(product,from,qLength,qLength,branch,type,time);
    }
}

void printQuery10(GPtrArray *products, char* client,int from, int rows, int columns,int qLength,int month,double time) {
    printFrameTop();
    printProductTableGPtr(products,from,rows,columns,qLength);
    if(from+99 < qLength){
        printLastRowQuery10(client,from,from+99,qLength,month,time);
    }else{
        printLastRowQuery10(client,from,qLength,qLength,month,time);
    }
}

void printQuery11(GPtrArray *products, int from, int rows,int qLength,double time) {
    printFrameTop();
    printProductTableGPtr2(products,from,rows,qLength);
    if(from+8 < qLength){
        printLastRowQuery11(from,from+8,qLength,time);
    }else{
        printLastRowQuery11(from,qLength,qLength,time);
    }
}

void printQuery12(GPtrArray *products, char* clients, int from, int rows, int columns,int qLength,double time) {
    printFrameTop();
    printProductTableGPtr(products,from,rows,columns,qLength);
    if(from+99 < qLength){
        printLastRowQuery12(clients,from,from+99,qLength,time);
    }else{
        printLastRowQuery12(clients,from,qLength,qLength,time);
    }
}

void printQuery13(char* clientsPath,char* productsPath,char* salesPath,int clientsRead,int clientsValidated,int productsRead,int productsValidated,int salesRead,int salesValidated,double time){
    int i;
    printFrameTop();
    printf("                     \x1b[1;36m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║  ");
    printf("\x1b[1;35mClients path:\x1b[0m %s\x1b[1;36m", clientsPath);
    for(i = 0; i < 76-((int) strlen(clientsPath)); i++)
        printf(" ");
    printf("║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║  ");
    printf("\x1b[0m%d clients read, %d clients validated\x1b[1;36m",
    clientsRead,
    clientsValidated);
    for(i = 0; i < 57-(numPlaces(clientsRead)+numPlaces(clientsValidated)); i++)
        printf(" ");              
    printf("║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║  ");
    printf("\x1b[1;35mProducts path:\x1b[0m %s\x1b[1;36m", productsPath);
    for(i = 0; i < 75-((int) strlen(productsPath)); i++)
        printf(" ");
    printf("║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║  ");
    printf("\x1b[0m%d products read, %d products validated\x1b[1;36m",
    productsRead,
    productsValidated);
    for(i = 0; i < 55-(numPlaces(productsRead)+numPlaces(productsValidated)); i++)
        printf(" ");
    printf("║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║  ");
    printf("\x1b[1;35mSales path:\x1b[0m %s\x1b[1;36m", salesPath);
    for(i = 0; i < 76-((int) strlen(salesPath)); i++)
        printf(" ");
    printf("  ");
    printf("║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║  ");
    printf("\x1b[0m%d sales read, %d sales validated\x1b[1;36m",
    salesRead, salesValidated);
    for(i = 0; i < 61-(numPlaces(salesRead)+numPlaces(salesValidated)); i++)
        printf(" ");
    printf("║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║  \x1b[1;35mQuery13 Time:\x1b[0m %lf                                            ",time);
    printPressEnterToContinue(COLOR_B_PINK);
    printf(" \x1b[1;36m║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m║                                                                                            ║\n");
    printf("                     \x1b[1;36m╚════════════════════════════════════════════════════════════════════════════════════════════╝");
    printFrameBottom();
}

void printOption(int option, int code){
    if(option == code){
        printf(BLINK);
        printf(COLOR_B_PINK);
    }else if(option == code-1 && option != MENU_KILLER){
        printf(RESET);
        printf(COLOR_RESET);
    }
}

void printMenu(int row,int column) {
    printFrameTop();
    printRowOne(row,column);
    printRowTwo(row,column);
    printRowThree(row,column);
    printFrameBottom();
}

void printQuitSingle(int row,int order){
    if(row == order){
        printf(BLINK);
        printf(COLOR_B_PINK);
        printf("QUIT");
        printf(COLOR_RESET);
        printf(RESET);
    }else{
        printf("\x1b[0mQUIT");
    }
}

void printGreeter(int row,int column){
    printFrameTop();
    if(row == ROW_1){
        if(column == COLUMN_1){
            printf("                     \x1b[1;35m╔═════════════════════════════════════════════╗\x1b[1;36m╔═════════════════════════════════════════════╗\n");
            printf("                     \x1b[1;35m║                                             ║\x1b[1;36m║                                             ║\n");
            printf("                     \x1b[1;35m║                     /$$                     ║\x1b[1;36m║                   /$$$$$$                   ║\n");      
            printf("                     \x1b[1;35m║                   /$$$$                     ║\x1b[1;36m║                  /$$__  $$                  ║\n");      
            printf("                     \x1b[1;35m║                  |_  $$                     ║\x1b[1;36m║                 |__/  \\ $$                  ║\n");      
            printf("                     \x1b[1;35m║                    | $$                     ║\x1b[1;36m║                   /$$$$$$/                  ║\n");      
            printf("                     \x1b[1;35m║                    | $$                     ║\x1b[1;36m║                  /$$____/                   ║\n");      
            printf("                     \x1b[1;35m║                    | $$                     ║\x1b[1;36m║                 | $$                        ║\n");      
            printf("                     \x1b[1;35m║                   /$$$$$$                   ║\x1b[1;36m║                 | $$$$$$$$                  ║\n");      
            printf("                     \x1b[1;35m║                  |______/                   ║\x1b[1;36m║                 |________/                  ║\n");      
            printf("                     \x1b[1;35m║                                             ║\x1b[1;36m║                                             ║\n");
            printf("                     \x1b[1;35m║              \x1b[1;35m\033[5mLoad Default Files\033[0m\x1b[1;35m             ║\x1b[1;36m║            \x1b[0mLoad From Custom Path\x1b[1;36m            ║\n");
            printf("                     \x1b[1;35m║                                             ║\x1b[1;36m║                                             ║\n");
            printf("                     \x1b[1;35m╚═════════════════════════════════════════════╝\x1b[1;36m╚═════════════════════════════════════════════╝\n");
            printf(COLOR_B_CYAN);
            printf("                     ╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                           \x1b[0mEXIT\033[0m\x1b[1;36m                                             ║\n");
            printf("                     ║                                        \x1b[0mAPLICATION\033[0m\x1b[1;36m                                          ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝"); 
        }else{
            printf("                     \x1b[1;36m╔═════════════════════════════════════════════╗\x1b[1;35m╔═════════════════════════════════════════════╗\n");
            printf("                     \x1b[1;36m║                                             ║\x1b[1;35m║                                             ║\n");
            printf("                     \x1b[1;36m║                     /$$                     ║\x1b[1;35m║                   /$$$$$$                   ║\n");      
            printf("                     \x1b[1;36m║                   /$$$$                     ║\x1b[1;35m║                  /$$__  $$                  ║\n");      
            printf("                     \x1b[1;36m║                  |_  $$                     ║\x1b[1;35m║                 |__/  \\ $$                  ║\n");      
            printf("                     \x1b[1;36m║                    | $$                     ║\x1b[1;35m║                   /$$$$$$/                  ║\n");      
            printf("                     \x1b[1;36m║                    | $$                     ║\x1b[1;35m║                  /$$____/                   ║\n");      
            printf("                     \x1b[1;36m║                    | $$                     ║\x1b[1;35m║                 | $$                        ║\n");      
            printf("                     \x1b[1;36m║                   /$$$$$$                   ║\x1b[1;35m║                 | $$$$$$$$                  ║\n");      
            printf("                     \x1b[1;36m║                  |______/                   ║\x1b[1;35m║                 |________/                  ║\n");      
            printf("                     \x1b[1;36m║                                             ║\x1b[1;35m║                                             ║\n");
            printf("                     \x1b[1;36m║              \x1b[0mLoad Default Files\x1b[1;36m             ║\x1b[1;35m║            \x1b[1;35m\033[5mLoad From Custom Path\033[0m\x1b[1;35m            ║\n");
            printf("                     \x1b[1;36m║                                             ║\x1b[1;35m║                                             ║\n");
            printf("                     \x1b[1;36m╚═════════════════════════════════════════════╝\x1b[1;35m╚═════════════════════════════════════════════╝\n");
            printf(COLOR_B_CYAN);
            printf("                     ╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                           \x1b[0mEXIT\033[0m\x1b[1;36m                                             ║\n");
            printf("                     ║                                        \x1b[0mAPLICATION\033[0m\x1b[1;36m                                          ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ║                                                                                            ║\n");
            printf("                     ╚════════════════════════════════════════════════════════════════════════════════════════════╝");
        }
    } else{
        printf(COLOR_B_CYAN);
        printf("                     ╔═════════════════════════════════════════════╗╔═════════════════════════════════════════════╗\n");
        printf("                     ║                                             ║║                                             ║\n");
        printf("                     ║                     /$$                     ║║                   /$$$$$$                   ║\n");      
        printf("                     ║                   /$$$$                     ║║                  /$$__  $$                  ║\n");      
        printf("                     ║                  |_  $$                     ║║                 |__/  \\ $$                  ║\n");      
        printf("                     ║                    | $$                     ║║                   /$$$$$$/                  ║\n");      
        printf("                     ║                    | $$                     ║║                  /$$____/                   ║\n");      
        printf("                     ║                    | $$                     ║║                 | $$                        ║\n");      
        printf("                     ║                   /$$$$$$                   ║║                 | $$$$$$$$                  ║\n");      
        printf("                     ║                  |______/                   ║║                 |________/                  ║\n");      
        printf("                     ║                                             ║║                                             ║\n");
        printf("                     ║              \x1b[0mLoad Default Files\x1b[1;36m             ║║            \x1b[0mLoad From Custom Path\x1b[1;36m            ║\n");
        printf("                     ║                                             ║║                                             ║\n");
        printf("                     ╚═════════════════════════════════════════════╝╚═════════════════════════════════════════════╝\n");
        printf("                     \x1b[1;35m╔════════════════════════════════════════════════════════════════════════════════════════════╗\n");
        printf("                     \x1b[1;35m║                                                                                            ║\n");
        printf("                     \x1b[1;35m║                                                                                            ║\n");
        printf("                     \x1b[1;35m║                                           \x1b[1;35m\033[5mEXIT\033[0m\x1b[1;35m                                             ║\n");
        printf("                     \x1b[1;35m║                                        \x1b[1;35m\033[5mAPLICATION\033[0m\x1b[1;35m                                          ║\n");
        printf("                     \x1b[1;35m║                                                                                            ║\n");
        printf("                     \x1b[1;35m║                                                                                            ║\n");
        printf("                     \x1b[1;35m║                                                                                            ║\n");
        printf("                     \x1b[1;35m╚════════════════════════════════════════════════════════════════════════════════════════════╝"); 
    }
    printFrameBottom();   
}

void printMenuQuery2(char letter,int row,int column,int sizeLetter){
    printFrameTop();
    printf(COLOR_B_CYAN);
    printf("                     ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ \x1b[1;35m║   \x1b[1;35mLETTER:");
    printLetterForm(letter,sizeLetter,row,column,ROW_1);
    int i;
    for(i=0;i<3+(1*(row != ROW_1))-sizeLetter;i++)
        printf(" ");
    printf("\x1b[1;35m  ║\x1b[1;36m ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ \x1b[1;35m║                ║\x1b[1;36m ║     \x1b[0mSales\x1b[1;36m      ║ ║     \x1b[0mNever\x1b[1;36m      ║ ║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ \x1b[1;35m║      \x1b[0m");
    printQuitSingle(row,ROW_2);
    printf("      \x1b[1;35m║\x1b[1;36m ║   \x1b[0mAnd Profit\x1b[1;36m   ║ ║    \x1b[0mBought\x1b[1;36m      ║ ║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ║                ║ \x1b[1;35m║                ║\x1b[1;36m ║                ║ ║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝ ╚════════════════╝\n");
    printRowTwo(ROW_1,COLUMN_2);
    printRowThree(ROW_1,COLUMN_2);
    printFrameBottom();
}

void printMenuQuery3(char* product,int row,int column,int sizeProduct,int option,int month,int error){
    printFrameTop();
    printf(COLOR_B_CYAN);
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║                                   ║\x1b[1;36m ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ \x1b[1;35m║                                   ║\x1b[1;36m ║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ \x1b[1;35m║          PRODUCT:");
    printProductForm(product,sizeProduct,row,column,ROW_1);
    int i;
    for(i=0;i<16+(1*(row != ROW_1))-sizeProduct;i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m ║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║          DISPLAY:");
    printDisplay(option,row,ROW_2);
    for(i=0;i<8;i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m║                                   ║\x1b[1;36m ╚════════════════╝\n");
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m║          MONTH:");
    printMonth(month,row,ROW_3);
    for(i=0;i<14-(1*(month > 8));i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ \x1b[1;35m║          \x1b[0m");
    printQuitSingle(row,3);
    printf("\x1b[1;35m                     ║\x1b[1;36m ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║                                   ║\x1b[1;36m ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ \x1b[1;35m║          \x1b[0m");
    if(error){
        printf("Invalid Input");
    }else{
        printf("             ");
    }
    printf("\x1b[1;35m            ║\x1b[1;36m ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ \x1b[1;35m║                                   ║\x1b[1;36m ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝\n");
    printRowThree(ROW_1,COLUMN_3);
    printFrameBottom();
}

void printMenuQuery4(int row,int branch){
    printFrameTop();
    printf(COLOR_B_CYAN);
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║                                   ║\x1b[1;36m ║  \x1b[0mGet Clients\x1b[1;36m   ║\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ \x1b[1;35m║                                   ║\x1b[1;36m ║     \x1b[0mOf All\x1b[1;36m     ║\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ \x1b[1;35m║          BRANCH:");
    printBranch(branch,row,ROW_1);
    int i;
    for(i=0;i<13-(2*(branch == 3));i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m ║    \x1b[0mBranches\x1b[1;36m    ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║          ");
    printQuitSingle(row,ROW_2);
    printf("                     \x1b[1;35m║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m║                                   ║\x1b[1;36m ╚════════════════╝\n");
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m║          ");
    printf("                     ");
    printf("    \x1b[1;35m║\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ \x1b[1;35m║          \x1b[0m");
    printf("\x1b[1;35m                         ║\x1b[1;36m ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║                                   ║\x1b[1;36m ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ \x1b[1;35m║          \x1b[0m");
    printf("\x1b[1;35m                         ║\x1b[1;36m ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ \x1b[1;35m║                                   ║\x1b[1;36m ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝\n");
    printRowThree(ROW_1,COLUMN_3);
    printFrameBottom();
}


void printMenuQuery7(char* client,int row,int column,int sizeClient,int error) {
    int i;
    printFrameTop();
    printf(COLOR_RESET);
    printRowOne(ROW_2,ROW_2);
    printf("                     ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗ ╔════════════════╗\n");
    printf("                     ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║ ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ \x1b[1;35m║  \x1b[1;35mCLIENT:\x1b[0m");
    printClientForm(client,sizeClient,row,column,ROW_1);
    for(i=0;i<6+(1*(row != ROW_1))-sizeClient;i++)
        printf(" ");
    if(error)
        printf("   Invalid Input");
    else printf("                ");
    printf("   \x1b[1;35m║ \x1b[1;36m║      \x1b[0mGet\x1b[1;36m       ║ ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ \x1b[1;35m║                                   ║ \x1b[1;36m║    \x1b[0mProduct\x1b[1;36m     ║ ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ \x1b[1;35m║ ");
    printf("\x1b[0m              ");
    printQuitSingle(row,ROW_2);
    printf("               \x1b[1;35m ║ \x1b[1;36m║    \x1b[0mBuyers\x1b[1;36m      ║ ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ \x1b[1;35m║                                   ║ \x1b[1;36m║                ║ ║                ║\n");
    printf("                     ║                ║ \x1b[1;35m║                                   ║ \x1b[1;36m║                ║ ║                ║\n");
    printf("                     ╚════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝ ╚════════════════╝\n");
    printRowThree(ROW_2,ROW_2);
    printFrameBottom();
}

void printMenuQuery8(int row, int minMonth,int maxMonth){
    int i;
    printFrameTop();
    printRowOne(ROW_2,COLUMN_3);
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ \x1b[1;35m║    FROM:");
    printMonth(minMonth,row,ROW_1);
    for(i=0;i<14-(1*(minMonth > 8));i++)
        printf(" ");
    printf("       \x1b[1;35m║ \x1b[1;36m║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║                                   ║\x1b[1;36m ║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ \x1b[1;35m║      TO:");
    printMonth(maxMonth,row,ROW_2);
    for(i=0;i<14-(1*(maxMonth > 8));i++)
        printf(" ");
    printf("       \x1b[1;35m║\x1b[1;36m ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ \x1b[1;35m║                                   ║\x1b[1;36m ║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ \x1b[1;35m║       ");
    printQuitSingle(row,ROW_3);
    printf("                        \x1b[1;35m║ \x1b[1;36m║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝\x1b[1;36m\n");
    printRowThree(ROW_2,COLUMN_3);
    printFrameBottom();
}

void printMenuQuery9(char* product,int row,int column,int sizeProduct,int branch,int type){
    printFrameTop();
    printf(COLOR_B_CYAN);
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║  \x1b[0mGet Current\x1b[1;36m   ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║     \x1b[0mFiles\x1b[1;36m      ║ ║    \x1b[0mStarted\x1b[1;36m     ║ ║     \x1b[0mSales\x1b[1;36m      ║ \x1b[1;35m║          PRODUCT:");
    printProductForm(product,sizeProduct,row,column,ROW_1);
    int i;
    for(i=0;i<16+(1*(row != ROW_1))-sizeProduct;i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m\n");
    printf("                     ║      \x1b[0mInfo\x1b[1;36m      ║ ║   \x1b[0mBy Letter\x1b[1;36m    ║ ║   \x1b[0mAnd Profit\x1b[1;36m   ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║          BRANCH:");
    printBranch2(branch,row,ROW_2);
    for(i=0;i<13;i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ \x1b[1;35m║          TYPE:");
    printType(type,row,ROW_3);
    printf("               \x1b[1;35m║\x1b[1;36m\n");
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║          ");
    printQuitSingle(row,3);
    printf("                     \x1b[1;35m║\x1b[1;36m\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║   \x1b[0mGet Sales\x1b[1;36m    ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ ║      \x1b[0mAnd\x1b[1;36m       ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ ║     \x1b[0mProfit\x1b[1;36m     ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m\n");
    printRowThree(ROW_2,COLUMN_4);
    printFrameBottom();
}

void printMenuQuery10(char* client,int row,int column,int sizeClient,int month){
    int i;
    printFrameTop();
    printf(COLOR_B_CYAN);
    printRowOne(ROW_2,COLUMN_5);
    printf("                     ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔════════════════╗\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║ CLIENT:");
    printClientForm(client,sizeClient,row,column,ROW_1);
    for(i=0;i<7+(1*(row != ROW_1))-sizeClient;i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ ║   \x1b[0mGet Sales\x1b[1;36m    ║ ║      \x1b[0mGet\x1b[1;36m       ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ ║      \x1b[0mAnd\x1b[1;36m       ║ ║    \x1b[0mProduct\x1b[1;36m     ║ \x1b[1;35m║ MONTH:");
    printMonth(month,row,ROW_2);
    for(i=0;i<4-(1*(month > 8));i++)
        printf(" ");
    printf("\x1b[1;35m║\x1b[1;36m\n");    
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ ║     \x1b[0mProfit\x1b[1;36m     ║ ║    \x1b[0mBuyers\x1b[1;36m      ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║ ");
    printQuitSingle(row,ROW_3);
    printf("           \x1b[1;35m║\x1b[1;36m\n");
    printf("                     ║                ║ ║                ║ ║                ║ ║                ║ \x1b[1;35m║                ║\x1b[1;36m\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ ╚════════════════╝ \x1b[1;35m╚════════════════╝\x1b[1;36m\n");
    printRowThree(ROW_2,COLUMN_5);
    printFrameBottom();
}

void printMenuQuery11(char* N,int row,int column,int sizeN){
    int i;
    printFrameTop();
    printf(COLOR_B_CYAN);
    printRowOne(ROW_3,COLUMN_1);
    printRowTwo(ROW_3,COLUMN_1);
    printf("                     \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔═══════════════════════════════════╗ ╔════════════════╗\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║                                   ║ ║                ║\n");
    printf("                     \x1b[1;35m║ N:");
    printNForm(N,sizeN,row,column,ROW_1);
     for(i=0;i<9+(1*(row != ROW_1))-sizeN;i++)
        printf(" ");
    printf("              ");
    printQuitSingle(row,ROW_2);
    printf("    \x1b[1;35m║\x1b[1;36m ║  \x1b[0mGet Client Top Profit Products\x1b[1;36m   ║ ║      \x1b[0mQUIT\x1b[1;36m      ║\n");
    printf("                     \x1b[1;35m║                                   ║\x1b[1;36m ║                                   ║ ║                ║\n");
    printf("                     \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚═══════════════════════════════════╝ ╚════════════════╝");
    printFrameBottom();
}

void printMenuQuery12(char* client,char* N,int row,int column,int column2,int sizeClient,int sizeN,int error){
    int i;
    printFrameTop();
    printf(COLOR_B_CYAN);
    printRowOne(ROW_3,COLUMN_2);
    printf("                     ╔════════════════╗ ╔════════════════╗ \x1b[1;35m╔═══════════════════════════════════╗\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║  \x1b[0mGet Clients\x1b[1;36m   ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║      \x1b[0mAnd\x1b[1;36m       ║ ║  \x1b[0mGet Products\x1b[1;36m  ║ \x1b[1;35m║          CLIENT:");
    printClientForm(client,sizeClient,row,column,ROW_1);
    for(i=0;i<17+(1*(row != ROW_1))-sizeClient;i++)
        printf(" ");
    printf("\x1b[1;35m║ \x1b[1;36m║   \x1b[0mGet Client\x1b[1;36m   ║\n");
    printf("                     ║    \x1b[0mProducts\x1b[1;36m    ║ ║     \x1b[0mBought\x1b[1;36m     ║ \x1b[1;35m║                                   ║\x1b[1;36m ║    \x1b[0mFavorite\x1b[1;36m    ║\n");
    printf("                     ║     \x1b[0mNever\x1b[1;36m      ║ ║   \x1b[0mBy Client\x1b[1;36m    ║ \x1b[1;35m║          N:");
    printNForm(N,sizeN,row,column2,ROW_2);
     for(i=0;i<22+(1*(row != ROW_2))-sizeN;i++)
        printf(" ");
    printf("\x1b[1;35m║ \x1b[1;36m║    \x1b[0mProducts\x1b[1;36m    ║\n");
    printf("                     ║  \x1b[0mBought Count\x1b[1;36m  ║ ║                ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║                ║ ║                ║ \x1b[1;35m║          ");
    printQuitSingle(row,ROW_3);
    printf("                     \x1b[1;35m║ \x1b[1;36m║                ║\n");
    printf("                     ╚════════════════╝ ╚════════════════╝ \x1b[1;35m║                                   ║\x1b[1;36m ╚════════════════╝\n");
    printf("                     ╔═══════════════════════════════════╗ \x1b[1;35m║          \x1b[0m");
    if(error){
        printf("Invalid Input");
    }else{
        printf("             ");
    }
    printf("            \x1b[1;35m║\x1b[1;36m ╔════════════════╗\n");
    printf("                     ║                                   ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ║      \x1b[0mGet Top Selled Products\x1b[1;36m      ║ \x1b[1;35m║                                   ║\x1b[1;36m ║      \x1b[0mQUIT\x1b[1;36m      ║\n");
    printf("                     ║                                   ║ \x1b[1;35m║                                   ║\x1b[1;36m ║                ║\n");
    printf("                     ╚═══════════════════════════════════╝ \x1b[1;35m╚═══════════════════════════════════╝\x1b[1;36m ╚════════════════╝");
    printFrameBottom();
}
