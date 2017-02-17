CC=clang
CFLAGS=-O0 -g -Wall -Wpointer-arith -ftrapv -fsanitize=undefined-trap -fsanitize-undefined-trap-on-error

# or, for gcc...
#CC=gcc
#CFLAGS=-O0 -g -Wall

LD=$(CC)
LDFLAGS=-g

test:	ringbuf-test
	./ringbuf-test

coverage: ringbuf-test-gcov
	  ./ringbuf-test-gcov
	  gcov -o ringbuf-gcov.o ringbuf.c

valgrind: ringbuf-test
	  valgrind ./ringbuf-test

help:
	@echo "Targets:"
	@echo
	@echo "test  - build and run ringbuf unit tests."
	@echo "coverage - use gcov to check test coverage of ringbuf.c."
	@echo "valgrind - use valgrind to check for memory leaks."
	@echo "clean - remove all targets."
	@echo "help  - this message."

ringbuf-test-gcov: ringbuf-test-gcov.o ringbuf-gcov.o
	gcc -o ringbuf-test-gcov --coverage $^

ringbuf-test-gcov.o: ringbuf-test.c ringbuf.h
	gcc -c $< -o $@

ringbuf-gcov.o: ringbuf.c ringbuf.h
	gcc --coverage -c $< -o $@

ringbuf-test: ringbuf-test.o libringbuf.so
	$(LD) -o ringbuf-test $(LDFLAGS) $^ -L$(MY_LIBS_PATH) -lringbuf

ringbuf-test.o: ringbuf-test.c ringbuf.h
	$(CC) $(CFLAGS) -c $< -o $@ 

libringbuf.so: ringbuf.o
	$(CC) -shared -o libringbuf.so ringbuf.o
	cp ./libringbuf.so $(MY_LIBS_PATH)/

ringbuf.o: ringbuf.c ringbuf.h
	$(CC) $(CFLAGS) -fPIC -c $< -o $@
	cp ./ringbuf.h $(MY_INCLUDES_PATH)/

clean:
	rm -f ringbuf-test ringbuf-test-gcov *.o *.so *.gcov *.gcda *.gcno

.PHONY:	clean
