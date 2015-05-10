#!/bin/bash

ghc -O2 ExprPPP.hs
ghc -O2 ASTPPP.hs
rm *.hi
rm *.o
mv ExprPPP ../exe
mv ASTPPP ../exe
