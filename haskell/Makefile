## Makefile for UWYO COSC 4780/5010 Homework 4 - Haskell side
## Author: Finley McIlwaine

.PHONY : bnfc parse test test_grad install

bnfc/*.hs: CPP.cf
	bnfc -m -o bnfc $^
	cd bnfc && make

bnfc: bnfc/*.hs

parse: bnfc
	@./bnfc/TestCPP

icpp: *.hs
	cabal install exe:icpp --installdir . --overwrite-policy=always icpp

install: icpp bnfc

test: install bnfc
	@cd ../test && cabal -v0 run tester haskell

test_grad: install bnfc
	@cd ../test && cabal -v0 run tester haskell grad
