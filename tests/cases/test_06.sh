#!/bin/sh
# Non-readable file check.

touch tests/inputs/1ggf.pdb
chmod 000 tests/inputs/1ggf.pdb
./pdbCAparameters tests/inputs/1ggf.pdb
chmod 777 tests/inputs/1ggf.pdb
rm -f tests/inputs/1ggf.pdb
