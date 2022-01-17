## Makefile for UWYO COSC 4780/5010 Homework 4 - Java side
## Author: Finley McIlwaine

.PHONY : bnfc parse test test_grad build

bnfc/cpp/*.java: CPP.cf
	bnfc --java --makefile=bnfc.mk -p bnfc $^
	make -f bnfc.mk

*.class: *.java bnfc/cpp/*.java
	javac $^

bnfc: bnfc/cpp/*.java

install: *.class

parse: build bnfc
	@java bnfc.cpp.Test

test: bnfc build
	@cd ../test && cabal -v0 run tester java

test_grad: bnfc build
	@cd ../test && cabal -v0 run tester java grad
