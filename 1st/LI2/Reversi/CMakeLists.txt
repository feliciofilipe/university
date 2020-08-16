cmake_minimum_required(VERSION 3.13)
project(proj C)

set(CMAKE_C_STANDARD 99)



add_executable(proj main.c estado.h functions.h menu.c jogar.c jogar.h valid.c bot.c bot.h menu_options.c menu_options.h stack.c stack.h print_functions.c load_save.c)