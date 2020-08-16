############################# Makefile ##########################
CFLAGS= -W -Wall -Wextra -O3 -D_GNU_SOURCE -ansi `pkg-config --cflags --libs glib-2.0`
GDBFLAGS=  -W -Wall -Wextra -O3 -ggdb3 -D_GNU_SOURCE -ansi 
VGFLAGS = --leak-check=full -s --show-reachable=no --track-origins=yes --keep-stacktraces=alloc-and-free --error-limit=no --num-callers=40 --show-leak-kinds=all

CC = gcc

COBJECTS:=$(patsubst %.c,%.o,$(wildcard *.c))
GDBOBJECTS:= $(shell find -name '*.c')

EXECUTABLE=program

DOCSPATH = ../docs/
BENCHMARKSPATH = ../bench
IMAGE = $$(date +%F-%T)_memusage.png

$(EXECUTABLE): $(COBJECTS)
	$(CC) -o $(EXECUTABLE) $(COBJECTS) $(CFLAGS)

#@- hide command
docs:
	cd ../docs && doxygen doxygen_config

run:
	@./$(EXECUTABLE) 

rm:
	rm -rf *.o $(EXECUTABLE)

grind:
	valgrind $(VGFLAGS) ./$(EXECUTABLE) 1 
	
gdb:
	gcc -o  SGVGDB $(GDBFLAGS)  $(GDBOBJECTS) -W -Wall -Wextra -O2 -D_GNU_SOURCE `pkg-config --cflags --libs glib-2.0`

fmt:
	@-clang-format -style="{BasedOnStyle: Google, IndentWidth: 4}" -verbose -i *.c 

mem:
	memusage -T -p $(BENCHMARKSPATH)/$(IMAGE) ./$(EXECUTABLE) 
