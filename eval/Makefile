
CC=cc
CFLAGS=-fast

allfive: allfive.c pokerlib.o fast_eval.o
	${CC} ${CFLAGS} allfive.c pokerlib.o fast_eval.o -s -o allfive

pokerlib.o: pokerlib.c arrays.h
	${CC} -c ${CFLAGS} pokerlib.c -o pokerlib.o

fast_eval.o: fast_eval.c
	${CC} -c ${CFLAGS} fast_eval.c -o fast_eval.o
