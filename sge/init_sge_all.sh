#!/bin/bash


qconf -dq all.q

# Parallel Environments
qconf -dp mpich
qconf -Mp conf/orte.pe
qconf -Mp conf/mpi.pe
qconf -Ap conf/threaded.pe
qconf -Ap conf/ddi.pe

qconf -Aq conf/all.q

qconf -Mrqs conf/limit_slots_to_cores.rqs 

qconf -Mc conf/complexes.txt
./config_mem_free.sh
./config_scratch_free.sh

./init_global_config.sh
