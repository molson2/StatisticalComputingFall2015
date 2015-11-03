#!/bin/bash
NSIM=25 # number of grid nodes to use
qsub -pe openmpi $NSIM -N matt -j y -cwd job.sh
