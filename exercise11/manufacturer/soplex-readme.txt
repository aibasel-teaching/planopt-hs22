Installation
============

To install SoPlex you have to download its source code from

  https://soplex.zib.de/download.php?fname=soplex-4.0.2.tgz

We could not distribute this file in the course repository because you
have to confirm that you are using it only for non-commercial purposes.
Once you downloaded the file, save it next to this file and call

  sudo ./install-soplex.sh

to compile the code and install SoPlex.



File Format
===========

SoPlex accepts input files in the format described here:

  http://lpsolve.sourceforge.net/5.1/CPLEX-format.htm

Note that all variables are non-negative (>= 0) by default. To use
unrestricted variables, you have to declare them as "free" in the
section "Bounds".

You can find an example in the file example.lp. Please use the optional
constraint names and use readable variable names in your solution.


Calling SoPlex
==============

After installing SoPlex and creating an LP file, you can solve the LP
and print an optimal solution by calling

  soplex -x example.lp

The output should contain lines like this

  SoPlex status       : problem is solved [optimal]
  Solving time (sec)  : 0.00
  Iterations          : 2
  Objective value     : 1.10000000e+01

  Primal solution (name, value):
  x	    1.0333333333333332e+01
  y	   -6.6666666666666696e-01
  All other variables are zero (within 1.0e-16). Solution has 2 nonzero entries.

In this case, the problem was solved optimally, has an objective value
of 11 and an optimal solution is x = 10 + 1/3 and y = -2/3.

You can also print the dual solution of an LP with the option -y.
