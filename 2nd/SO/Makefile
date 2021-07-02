all: server client

server: bin/aurrasd

client: bin/aurras

bin/aurrasd: obj/aurrasd.o
	gcc -g obj/aurrasd.o -o bin/aurrasd

obj/aurrasd.o: src/aurrasd.c
	gcc -Wall -g -c src/aurrasd.c -o obj/aurrasd.o

bin/aurras: obj/aurras.o
	gcc -g obj/aurras.o -o bin/aurras

obj/aurras.o: src/aurras.c
	gcc -Wall -g -c src/aurras.c -o obj/aurras.o

clean:
	@cat .art/maid.ascii
	@rm obj/* bin/{aurras,aurrasd} tmp/*

script_server:
	python3 scripts/server.py

unlimited_server:
	python3 scripts/unlimited_server.py

test:
	python3 scripts/tests.py

format:
	@-clang-format -style="{BasedOnStyle: Google, IndentWidth: 4}" -verbose -i src/*.c includes/*.h

yapf:
	yapf --in-place --recursive --style="{based_on_style = Google, indent_width: 4}" scripts/*.py

terry:
	python3 scripts/im_the_smartest_programmer_that_has_ever_lived.py
