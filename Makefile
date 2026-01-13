all:

	gcc -E src/test.c -o obj/test.i
	gcc -S obj/test.i -o obj/test.s
	gcc -c obj/test.s -o obj/test.o
	gcc obj/test.o -o build/test

clean:
	rm -f obj/test.*
	rm -f build/test.*