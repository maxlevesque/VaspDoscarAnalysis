VaspDoscarAnalysis
==================

Extract projected or total electronic density of states as calculated and written by VASP in DOSCAR file.


What for
========

depending on user answers, it may compute the total density of states, or projected density of states of any atom labeled as in the POSCAR file.
the program askes the user what it needs during execution. no input file is needed. for simplicity.
The energies may be translated so that Fermi energy is the reference (abscissa is E-Efermi) if user wants.

Author
======

It has been written by Maximilien Levesque, while in postdoc @ Ecole Normale Superieure, Paris
in the group of theoretical physical-chemistry of Daniel Borgis

Citation
========

Citation to some work where I used this script would be really appreciated and would help keep traces.
For instance:
LEVESQUE, GUPTA AND GUPTA, PHYSICAL REVIEW B 85, 064111 (2012)

Licence
=======

It is free of any copyright. just send me an email at maximilien.levesque@gmail.com for thanks :) or bug reports. See also Citation just below.

Versioning
==========

It is based on VASP 4.6 documentation written found at http://cms.mpi.univie.ac.at/vasp/vasp/DOSCAR_file.html
I recommand the use of the GNU fortran compiler (gfortran)

Compilation
===========

You may simply compile the fortran 90 file as usual, or better use SCONS.
The POSCAR file should be in the directory from which you call doscar_analysis.

