## Makefile for UWYO COSC 4780/5010 Homework 5 - Java side
## Author: Finley McIlwaine

.PHONY : bnfc parse test test_grad build

bnfc/cpp/*.java: CPP.cf
	bnfc --java --makefile=bnfc.mk -p bnfc $^
	make -f bnfc.mk
bnfc: bnfc/cpp/*.java

*.class: *.java bnfc/cpp/*.java
	javac $^

install: *.class

test: bnfc install
	cp runtime.class test/good/
	cp runtime.class test/bad/
	cd test && cabal -v0 run tester java

test_grad: bnfc install
	cp runtime.class test/good/
	cp runtime.class test/bad/
	cp runtime.class test/grad/good/
	cp runtime.class test/grad/bad/
	cd test && cabal -v0 run tester java grad

