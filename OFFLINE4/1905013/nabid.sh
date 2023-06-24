#!/bin/bash

yacc -d -y 1905013.y
echo 'Generated the parser C file as well the header file'
g++ -w -c -o y.o y.tab.c
echo 'Generated the parser object file'
flex 1905013.l
echo 'Generated the scanner C file'

 g++ -fpermissive -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'
g++ y.o l.o -lfl 
./a.out mytest5.c

# yacc -d parser.y
# flex scanner.l
# g++ -fsanitize=address -g lex.yy.c y.tab.c -o a.out
# echo 'All ready, running'
# ./a.out noerror.txt
