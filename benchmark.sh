#!/bin/bash
# Top-level executable for "Are We Fast Yet" benchmarks
#   Originally developed by Stefan Marr
#   https://gitlab.soft.vub.ac.be/stefan.marr/awfy-runs
#
# Adapted by Richard Roberts
#
# PARAMS=("--commit-id=$CI_BUILD_REF" "--environment=yuria" "--branch=$CI_BUILD_REF_NAME")
# rebench --invocation=1 -f "${PARAMS[@]}" codespeed.conf all e:MothTyped
# rebench --invocation=1 -f "${PARAMS[@]}" codespeed.conf steady
# rebench --invocation=1 -f "${PARAMS[@]}" codespeed.conf typing
# rebench --in 30 --it 100 -f "${PARAMS[@]}" codespeed.conf type-cost
rebench -f --in 9 --it 5000 codespeed.conf typing-startup
# rebench codespeed.conf stats

# rebench --invocation=1 -f -c "${PARAMS[@]}" codespeed.conf interp


## Archive results

DATA_ROOT=~/benchmark-results/moth-benchmarks

REV=`git rev-parse HEAD | cut -c1-8`

NUM_PREV=`ls -l $DATA_ROOT | grep ^d | wc -l`
NUM_PREV=`printf "%03d" $NUM_PREV`

TARGET_PATH=$DATA_ROOT/$NUM_PREV-$REV
LATEST=$DATA_ROOT/latest

mkdir -p $TARGET_PATH
bzip2 benchmark.data
mv benchmark.data.bz2 $TARGET_PATH/
rm $LATEST
ln -s $TARGET_PATH $LATEST
echo Data archived to $TARGET_PATH
